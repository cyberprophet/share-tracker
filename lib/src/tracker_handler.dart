part of '../share_tracker.dart';

@pragma('vm:entry-point')
void startTracker() => FlutterForegroundTask.setTaskHandler(TrackerHandler());

class TrackerHandler extends TaskHandler {
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    _streamUserAccelerometerSubscription?.cancel();
    _streamServiceStatusSubscription?.cancel();
    _streamAccelerometerSubscription?.cancel();
    _streamMagnetometerSubscription?.cancel();
    _streamStepCountSubscription?.cancel();
    _streamBarometerSubscription?.cancel();
    _streamGyroscopeSubscription?.cancel();
    _streamPositionSubscription?.cancel();
    _streamStatusSubscription?.cancel();

    _streamStatusSubscription = null;
    _streamPositionSubscription = null;
    _streamGyroscopeSubscription = null;
    _streamStepCountSubscription = null;
    _streamBarometerSubscription = null;
    _streamMagnetometerSubscription = null;
    _streamAccelerometerSubscription = null;
    _streamServiceStatusSubscription = null;
    _streamUserAccelerometerSubscription = null;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    final difference = timestamp.difference(_tracker.initTime.toUtc());

    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds % 60;

    final _ = FlutterForegroundTask.updateService(
      notificationText: '${_distance.toStringAsFixed(2)}㎞\n$minutes분 $seconds초',
    );
    _tracker.minutes = minutes;
    _tracker.seconds = seconds;

    FlutterForegroundTask.sendDataToMain(_tracker.toMap());
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _streamStepCountSubscription =
        DangplePedometer.stepCountStream.listen(onReceiveStepCount);

    _streamStatusSubscription =
        Pedometer.pedestrianStatusStream.listen(onReceivePedestrianStatus);

    _streamServiceStatusSubscription =
        Geolocator.getServiceStatusStream().listen((status) {
      final _ =
          FlutterForegroundTask.updateService(notificationTitle: status.name);
    });
    final locationSettings = LocationSettings(
      accuracy: Platform.isAndroid
          ? LocationAccuracy.high
          : LocationAccuracy.bestForNavigation,
    );
    _streamPositionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen(onReceivePosition);

    _streamUserAccelerometerSubscription =
        userAccelerometerEventStream().listen(onReceiveUserAccelerometer);

    _streamAccelerometerSubscription =
        accelerometerEventStream().listen(onReceiveAccelerometer);

    _streamGyroscopeSubscription =
        gyroscopeEventStream().listen(onReceiveGyroscope);

    _streamMagnetometerSubscription =
        magnetometerEventStream().listen(onReceiveMagnetometer);

    _streamBarometerSubscription =
        barometerEventStream().listen(onReceiveBarometer);
  }

  @protected
  void onReceiveBarometer(BarometerEvent e) {
    _tracker.barometer = e;
  }

  @protected
  void onReceiveMagnetometer(MagnetometerEvent e) {
    _tracker.magnetometer = e;
  }

  @protected
  void onReceiveGyroscope(GyroscopeEvent e) {
    _tracker.gyroscope = e;
  }

  @protected
  void onReceiveAccelerometer(AccelerometerEvent e) {
    _tracker.accelerometer = e;
  }

  @protected
  void onReceiveUserAccelerometer(UserAccelerometerEvent e) {
    _tracker.userAccelerometer = e;
  }

  @protected
  void onReceiveStepCount(DangpleStepCount stepCount) {
    _tracker.stepCount = stepCount;
  }

  @protected
  void onReceivePedestrianStatus(PedestrianStatus status) {
    _tracker.pedestrianStatus = status;
  }

  @protected
  void onReceivePosition(Position position) {
    if (_latitude != null && _longitude != null) {
      _distance = Geolocator.distanceBetween(
        _latitude!,
        _longitude!,
        position.latitude,
        position.longitude,
      );
      _distance = _distance / 1000;
    } else {
      _latitude = position.latitude;
      _longitude = position.longitude;
    }
    _tracker.position = position;
  }

  StreamSubscription<DangpleStepCount>? _streamStepCountSubscription;
  StreamSubscription<PedestrianStatus>? _streamStatusSubscription;
  StreamSubscription<Position>? _streamPositionSubscription;
  StreamSubscription<AccelerometerEvent>? _streamAccelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _streamGyroscopeSubscription;
  StreamSubscription<MagnetometerEvent>? _streamMagnetometerSubscription;
  StreamSubscription<BarometerEvent>? _streamBarometerSubscription;
  StreamSubscription<dynamic>? _streamServiceStatusSubscription;
  StreamSubscription<UserAccelerometerEvent>?
      _streamUserAccelerometerSubscription;

  double? _latitude, _longitude;

  double _distance = 0;

  final _tracker = Tracker(initTime: DateTime.now());
}
