import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: inference_failure_on_function_return_type
extension FunctionExtension on Function() {
  void get schedulerBinding =>
      SchedulerBinding.instance.addPostFrameCallback((_) => this());

  void widgetBindingWithDelay(Duration duration) => WidgetsBinding.instance
      .addPostFrameCallback((_) => Future.delayed(duration, this));

  void get endOfFrame => WidgetsBinding.instance.endOfFrame.then((_) => this());

  Future<void> catchAll(
    FutureOr<void> Function(Object error, StackTrace stackTrace) onError,
  ) async {
    try {
      await Future<void>.sync(() => this());
    } catch (error, stackTrace) {
      await onError(error, stackTrace);
    }
  }
}
