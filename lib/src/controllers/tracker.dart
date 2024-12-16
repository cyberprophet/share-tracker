part of "../../share_tracker.dart";

class TrackerController extends BaseController with ErrorHandlerMixin {
  void _startService() async {
    try {
      if (!await TrackerService.instance.isRunningService) {
        final _ = await TrackerService.instance.start(977, '추적자');
      }
    } catch (e, s) {
      handleError(e, s);
    }
  }

  void _onTrackerChanged(Tracker tracker) => listenable.value = tracker;

  @override
  void attach(State state) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _startService());

    TrackerService.instance.addTrackerChangedCallback(_onTrackerChanged);

    super.attach(state);
  }

  @override
  void dispose() {
    TrackerService.instance.removeTrackerChangedCallback(_onTrackerChanged);

    listenable.dispose();

    super.dispose();
  }

  final ValueNotifier<Tracker?> listenable = ValueNotifier(null);
}
