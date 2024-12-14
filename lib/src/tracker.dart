part of '../share_tracker.dart';

abstract class Tracker {
  void initializeEvent() {
    DangplePedometer.stepCountStream.listen(stepCount);
  }

  @protected
  void stepCount(DangpleStepCount stepCount);
}
