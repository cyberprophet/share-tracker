part of '../../share_tracker.dart';

typedef TrackerChanged = void Function(Tracker tracker);

class TrackerService {
  TrackerService._();

  void _onReceiveTaskData(Object json) {
    if (json is Map<String, dynamic>) {
      for (final callback in _callbacks) {
        callback(Tracker.fromJson(json));
      }
    }
  }

  void addTrackerChangedCallback(TrackerChanged callback) {
    if (!_callbacks.contains(callback)) _callbacks.add(callback);
  }

  void removeTrackerChangedCallback(TrackerChanged callback) {
    _callbacks.remove(callback);
  }

  void init() {
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'tracker_service',
        channelName: 'Tracker Service',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions:
          const IOSNotificationOptions(showNotification: false),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction:
            ForegroundTaskEventAction.repeat((kDebugMode ? 1 : 10) * 1000),
        autoRunOnBoot: true,
      ),
    );
  }

  Future<bool> start(int id, String title) async {
    bool responsePermission = true;

    responsePermission = await _requestPlatformPermissions();
    responsePermission = await _requestTrackerPermission();

    if (responsePermission) {
      final result = await FlutterForegroundTask.startService(
        serviceId: id,
        notificationTitle: title,
        notificationText: '',
        callback: startTracker,
      );

      if (result is ServiceRequestFailure) throw result.error;
    }
    return responsePermission;
  }

  Future<void> stop() async {
    final result = await FlutterForegroundTask.stopService();

    if (result is ServiceRequestFailure) throw result.error;
  }

  Future<bool> _requestPlatformPermissions() async {
    bool responsePermission = true;

    if (NotificationPermission.granted !=
        await FlutterForegroundTask.checkNotificationPermission()) {
      final _ = await FlutterForegroundTask.requestNotificationPermission();

      responsePermission = NotificationPermission.granted ==
          await FlutterForegroundTask.checkNotificationPermission();
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        responsePermission =
            await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      if (!await FlutterForegroundTask.canDrawOverlays) {
        responsePermission =
            await FlutterForegroundTask.openSystemAlertWindowSettings();
      }
    }

    if (!await Permission.activityRecognition.isGranted) {
      responsePermission =
          (await Permission.activityRecognition.request()).isGranted;
    }
    return responsePermission;
  }

  Future<bool> _requestTrackerPermission() async {
    if (LocationPermission.always != await Geolocator.checkPermission()) {
      return await _requestGeolocatorPermission();
    }
    return LocationPermission.always == await Geolocator.checkPermission();
  }

  Future<bool> _requestGeolocatorPermission() async {
    if (LocationPermission.always != await Geolocator.checkPermission()) {
      final requestGeoPermission = await Geolocator.requestPermission();

      if (LocationPermission.deniedForever == requestGeoPermission ||
          LocationPermission.denied == requestGeoPermission) {
        return await openAppSettings();
      }
      return LocationPermission.always == await Geolocator.requestPermission();
    }
    return LocationPermission.always == await Geolocator.checkPermission();
  }

  Future<bool> get isRunningService => FlutterForegroundTask.isRunningService;

  final _callbacks = <TrackerChanged>[];

  static final instance = TrackerService._();
}
