import 'package:flutter/cupertino.dart';

enum TDTimeCounterStatus { start, pause, resume, reset, idle }

/// Countdown component controller, can control start (`start()`)/pause (`pause()`)/continue (`resume()`)/reset (`reset([int? time])`)
class TDTimeCounterController extends ValueNotifier<TDTimeCounterStatus> {
  TDTimeCounterController() : super(TDTimeCounterStatus.idle);

  int? _time;

  int? get time => _time;

  void start() {
    value = TDTimeCounterStatus.start;
  }

  void pause() {
    value = TDTimeCounterStatus.pause;
  }

  void resume() {
    value = TDTimeCounterStatus.resume;
  }

  void reset([int? time]) {
    if (value == TDTimeCounterStatus.reset) {
      _time = time;
      notifyListeners();
    } else {
      _time = time;
      value = TDTimeCounterStatus.reset;
    }
  }
}
