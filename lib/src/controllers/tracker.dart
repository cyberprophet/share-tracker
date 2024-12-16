part of "../../share_tracker.dart";

class TrackerController extends BaseController with ErrorHandlerMixin {
  TrackerController({required this.id, required this.title});

  @protected
  void startService() async {
    try {
      if (!await TrackerService.instance.isRunningService) {
        final _ = await TrackerService.instance.start(id, title);
      }
    } catch (e, s) {
      handleError(e, s);
    }
  }

  void _onTrackerChanged(Tracker tracker) => listenable.value = tracker;

  @override
  void attach(State state) {
    WidgetsBinding.instance.addPostFrameCallback((_) => startService());

    TrackerService.instance.addTrackerChangedCallback(_onTrackerChanged);

    super.attach(state);
  }

  @override
  void dispose() {
    TrackerService.instance.removeTrackerChangedCallback(_onTrackerChanged);

    listenable.dispose();

    super.dispose();
  }

  final int id;
  final String title;

  final ValueNotifier<Tracker?> listenable = ValueNotifier(null);
}
