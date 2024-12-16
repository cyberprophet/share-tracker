part of '../share_tracker.dart';

mixin ErrorHandlerMixin on BaseController {
  void handleError(Object e, StackTrace s) {
    String errorMessage;

    if (e is PlatformException) {
      errorMessage = '${e.code}: ${e.message}';
    } else {
      errorMessage = e.toString();
    }
    final State? state = this.state;

    if (state != null && state.mounted) {
      ScaffoldMessenger.of(state.context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
