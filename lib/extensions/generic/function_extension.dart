import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Scheduling and error-handling helpers for zero-argument functions.
///
/// These APIs are primarily useful in widget code where callbacks must run
/// after a frame or at the end of the current frame.
///
/// Example:
/// ```dart
/// (() {
///   debugPrint('Executed after current frame');
/// }).schedulerBinding;
/// ```
extension FunctionExtension on void Function() {
  /// Schedules this callback using [SchedulerBinding.addPostFrameCallback].
  ///
  /// The callback runs once after the current frame is rendered.
  void get schedulerBinding =>
      SchedulerBinding.instance.addPostFrameCallback((_) => this());

  /// Schedules this callback after the current frame plus [duration].
  ///
  /// This first posts a frame callback, then delays execution by [duration].
  ///
  /// Example:
  /// ```dart
  /// final callback = () => debugPrint('ran later');
  /// callback.widgetBindingWithDelay(const Duration(milliseconds: 300));
  /// ```
  void widgetBindingWithDelay(Duration duration) => WidgetsBinding.instance
      .addPostFrameCallback((_) => Future.delayed(duration, this));

  /// Runs this callback when [WidgetsBinding.endOfFrame] completes.
  ///
  /// Useful when work must happen after frame finalization.
  void get endOfFrame => WidgetsBinding.instance.endOfFrame.then((_) => this());

  /// Executes this callback and forwards any thrown error to [onError].
  ///
  /// This catches synchronous throws and asynchronous failures.
  ///
  /// Example:
  /// ```dart
  /// await (() => throw Exception('fail')).catchAll((error, stackTrace) {
  ///   debugPrint('handled: $error');
  /// });
  /// ```
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
