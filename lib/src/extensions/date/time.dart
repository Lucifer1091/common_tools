import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Nullable-safe conversions for [TimeOfDay].
extension TimeConversions on TimeOfDay? {
  /// Checks if the [TimeOfDay] value is null.
  bool get isNull => this == null;

  /// Checks if the [TimeOfDay] value is not null.
  bool get isNotNull => !isNull;

  /// Converts this time to a [DateTime] using today's date.
  ///
  /// Returns `null` when this time is `null`.
  DateTime? toDateTime() {
    if (isNull) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, this!.hour, this!.minute);
  }

  /// Formats this time using locale-aware `DateFormat.jm()` (e.g. `2:30 PM`).
  ///
  /// Returns `null` when this time is `null`.
  String? timeToString() {
    if (isNull) return null;

    final timeFormat = DateFormat.jm();
    return timeFormat.format(this!.toDateTime()!);
  }
}

/// Comparison and convenience helpers for non-null [TimeOfDay].
extension RTimeOfDay on TimeOfDay {
  /// Returns `true` when this time is before `12:00`.
  bool get isAm => hour < 12;

  /// Returns `true` when this time is `12:00` or later.
  bool get isPm => hour >= 12;

  /// Returns `true` when this time is strictly after [other].
  bool isAfter(TimeOfDay other) =>
      hour > other.hour || (hour == other.hour && minute > other.minute);

  /// Returns `true` when this time is strictly before [other].
  bool isBefore(TimeOfDay other) =>
      hour < other.hour || (hour == other.hour && minute < other.minute);

  /// Returns `true` when this time is strictly between [start] and [end].
  bool isBetween(TimeOfDay start, TimeOfDay end) =>
      isAfter(start) && isBefore(end);

  /// Returns a copy of this time overriding [hour] and/or [minute].
  ///
  /// Example:
  /// ```dart
  /// const t = TimeOfDay(hour: 9, minute: 30);
  /// final changed = t.copyWith(minute: 45); // 09:45
  /// ```
  TimeOfDay copyWith({int? hour, int? minute}) =>
      TimeOfDay(hour: hour ?? this.hour, minute: minute ?? this.minute);
}
