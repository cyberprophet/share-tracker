part of '../../share_tracker.dart';

class Tracker {
  DateTime initTime;
  UserAccelerometerEvent? userAccelerometer;
  AccelerometerEvent? accelerometer;
  GyroscopeEvent? gyroscope;
  MagnetometerEvent? magnetometer;
  BarometerEvent? barometer;
  DangpleStepCount? stepCount;
  PedestrianStatus? pedestrianStatus;
  Position? position;
  String? status;
  int? minutes;
  int? seconds;

  Tracker({
    required this.initTime,
    this.userAccelerometer,
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
    this.barometer,
    this.pedestrianStatus,
    this.stepCount,
    this.position,
    this.status,
    this.minutes,
    this.seconds,
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    final userAccelerometer = json['user_accelerometer'];
    final accelerometer = json['accelerometer'];
    final gyroscope = json['gyroscope'];
    final magnetometer = json['magnetometer'];
    final barometer = json['barometer'];

    return Tracker(
      barometer: BarometerEvent(
        barometer['pressure'] ?? 0,
        barometer['timestamp'] != null
            ? DateTime.tryParse(barometer['timestamp']) ?? DateTime.now()
            : DateTime.now(),
      ),
      magnetometer: MagnetometerEvent(
        magnetometer['x'] ?? 0,
        magnetometer['y'] ?? 0,
        magnetometer['z'] ?? 0,
        magnetometer['timestamp'] != null
            ? DateTime.tryParse(magnetometer['timestamp']) ?? DateTime.now()
            : DateTime.now(),
      ),
      gyroscope: GyroscopeEvent(
        gyroscope['x'] ?? 0,
        gyroscope['y'] ?? 0,
        gyroscope['z'] ?? 0,
        gyroscope['timestamp'] != null
            ? DateTime.tryParse(gyroscope['timestamp']) ?? DateTime.now()
            : DateTime.now(),
      ),
      userAccelerometer: UserAccelerometerEvent(
        userAccelerometer['x'] ?? 0,
        userAccelerometer['y'] ?? 0,
        userAccelerometer['z'] ?? 0,
        userAccelerometer['timestamp'] != null
            ? DateTime.tryParse(userAccelerometer['timestamp']) ??
                DateTime.now()
            : DateTime.now(),
      ),
      accelerometer: AccelerometerEvent(
        accelerometer['x'] ?? 0,
        accelerometer['y'] ?? 0,
        accelerometer['z'] ?? 0,
        accelerometer['timestamp'] != null
            ? DateTime.tryParse(accelerometer['timestamp']) ?? DateTime.now()
            : DateTime.now(),
      ),
      status: json['status'],
      position:
          json['position'] != null ? Position.fromMap(json['position']) : null,
      stepCount: DangpleStepCount.fromJson(json['step_count']),
      initTime: DateTime.tryParse(json['init_time']) ?? DateTime.now(),
      minutes: json['minutes'],
      seconds: json['seconds'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': pedestrianStatus?.status,
      'step_count': stepCount?.toJson(),
      'position': position?.toJson(),
      'user_accelerometer': {
        'x': userAccelerometer?.x,
        'y': userAccelerometer?.y,
        'z': userAccelerometer?.z,
        'timestamp': userAccelerometer?.timestamp.toIso8601String()
      },
      'accelerometer': {
        'x': accelerometer?.x,
        'y': accelerometer?.y,
        'z': accelerometer?.z,
        'timestamp': accelerometer?.timestamp.toIso8601String()
      },
      'gyroscope': {
        'x': gyroscope?.x,
        'y': gyroscope?.y,
        'z': gyroscope?.z,
        'timestamp': gyroscope?.timestamp.toIso8601String()
      },
      'magnetometer': {
        'x': magnetometer?.x,
        'y': magnetometer?.y,
        'z': magnetometer?.z,
        'timestamp': magnetometer?.timestamp.toIso8601String()
      },
      'barometer': {
        'pressure': barometer?.pressure,
        'timestamp': barometer?.timestamp.toIso8601String()
      },
      'init_time': initTime.toIso8601String(),
      'minutes': minutes,
      'seconds': seconds
    };
  }

  String toJson() => json.encode(toMap());
}
