import 'dart:async';
import 'dart:math';

import 'package:flutter/scheduler.dart';

class CommonUtils {
  CommonUtils._();

  void timer({
    required Duration duration,
    required void Function(Duration time) onTick,
    VoidCallback? onDone,
  }) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration.inSeconds == 0) {
        timer.cancel();
        onDone?.call();
      } else {
        duration = duration - Duration(seconds: 1);
        onTick.call(duration);
      }
    });
  }

  /// Utility function to make a value nullable.
  ///
  /// This function is used to ensure that the provided value is nullable.
  /// In this context, it is used to handle the nullable `SchedulerBinding.instance`.
  ///
  /// - [value]: The value to make nullable.
  /// - Returns: The nullable version of the provided value.
  static T? makeNullable<T>(T? value) => value;

  /// Executes a function after the build is created.
  ///
  /// This function schedules the provided [onCreated] callback to be executed
  /// after the current frame is rendered. It uses Flutter's `SchedulerBinding`
  /// to add a post-frame callback, ensuring that the specified function runs
  /// after the widget tree has been built.
  ///
  /// Example usage:
  /// ```dart
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   afterBuildCreated(() {
  ///     // Code to execute after the build is created
  ///   });
  /// }
  /// ```
  ///
  /// If the [onCreated] callback is null, the function will not execute any code.
  ///
  /// - [onCreated]: The callback function to be executed after the build is created.
  static void afterBuildCreated(VoidCallback? onCreated) {
    makeNullable(
      SchedulerBinding.instance,
    )?.addPostFrameCallback((_) => onCreated?.call());
  }

  /// returns random bool.
  static bool randomBool([int? seed]) => Random(seed).nextBool();

  /// returns random int between [min] (inclusive, default 0) and [max] (exclusive, default 100).
  static int randomInt(int max, [int? min, int? seed]) {
    if (min != null) {
      assert(max > min, 'max must be greater than min');
    }
    final rand = Random(seed);
    return (min ?? 0) + rand.nextInt(max - (min ?? 0));
  }

  /// returns random double between [min] (inclusive, default 0) and [max] (exclusive, default 1).
  static double randomDouble([double? max, double? min, int? seed]) {
    if (min != null && max != null) {
      assert(max > min, 'max must be greater than min');
    }
    final rand = Random(seed);
    return (min ?? 0) + rand.nextDouble() * (max ?? 1 - (min ?? 0));
  }

  /// returns random string.
  static String randomString(int length, [int? seed]) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (index) => characters[randomInt(characters.length, seed)],
    ).join();
  }
}
