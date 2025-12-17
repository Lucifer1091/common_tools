import 'package:flutter/cupertino.dart';

enum MyTimeCounterStatus { start, pause, resume, reset, idle }

/// Countdown controller, can control [start], [pause], [reset] & [resume]
class MyTimeCounterController extends ValueNotifier<MyTimeCounterStatus> {
  MyTimeCounterController() : super(MyTimeCounterStatus.idle);

  int? _time;

  int? get time => _time;

  void start() {
    value = MyTimeCounterStatus.start;
  }

  void pause() {
    value = MyTimeCounterStatus.pause;
  }

  void resume() {
    value = MyTimeCounterStatus.resume;
  }

  void reset([int? time]) {
    if (value == MyTimeCounterStatus.reset) {
      _time = time;
      notifyListeners();
    } else {
      _time = time;
      value = MyTimeCounterStatus.reset;
    }
  }
}
