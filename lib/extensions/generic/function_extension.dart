import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: inference_failure_on_function_return_type
extension FunctionExtension on Function() {
  void get widgetBinding =>
      WidgetsBinding.instance.addPostFrameCallback((_) => this());

  void get schedularBinding =>
      SchedulerBinding.instance.addPostFrameCallback((_) => this());

  void widgetBindingWithDelay(Duration duration) => WidgetsBinding.instance
      .addPostFrameCallback((_) => Future.delayed(duration, this));

  void get endOfFrame => WidgetsBinding.instance.endOfFrame.then((_) => this());

  void catchAll(void Function(Object error) onError) {
    try {
      this();
    } catch (e) {
      onError(e);
    }
  }
}
