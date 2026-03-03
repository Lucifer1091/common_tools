import 'package:flutter/material.dart';

import '../index.dart';

class TimeRange {
  const TimeRange({required this.start, required this.end});

  final TimeOfDay start;
  final TimeOfDay end;

  /// Returns `true` when the range crosses midnight (e.g. 22:00-06:00).
  bool get spansMidnight => end.isBefore(start);

  /// Returns `true` when start and end represent the same clock time.
  ///
  /// In this case, [includes] behaves as a single-minute point-in-time match.
  bool get isSingleMoment => start == end;

  /// Returns the effective date range for this time range on the given [date].
  ///
  /// For time range within the same day returns the same day.
  /// For overnight shifts (e.g., 22:00-06:00), the end time is moved
  /// to the next day.
  ///
  /// Example:
  /// ```dart
  /// final timeRange = TimeRange(
  ///   start: TimeOfDay(hour: 9, min: 0),
  ///   end: TimeOfDay(hour: 17, min: 0),
  /// );
  /// final nightRange = TimeRange(
  ///   start: TimeOfDay(hour: 22, min: 0),
  ///   end: TimeOfDay(hour: 6, min: 0),
  /// );
  ///
  /// final monday = DateTime(2023, 6, 12);
  ///
  /// // Day shift: same day
  /// final dayRange = timeRange.toDateRange(monday);
  /// // Returns: 2023-06-12 09:00 to 2023-06-12 17:00
  ///
  /// // Night shift: crosses midnight
  /// final nightDateRange = nightRange.toDateRange(monday);
  /// // Returns: 2023-06-12 22:00 to 2023-06-13 06:00
  ///
  /// // Same start/end: single-moment range on the same day
  /// final pointRange = TimeRange(
  ///   start: TimeOfDay(hour: 9, minute: 0),
  ///   end: TimeOfDay(hour: 9, minute: 0),
  /// ).toDateRange(monday);
  /// // Returns: 2023-06-12 09:00 to 2023-06-12 09:00
  /// ```
  DateTimeRange toDateRange(DateTime date) {
    final startDateTime = date.copyTime(start);
    final endDateTime = date.copyTime(end);

    if (spansMidnight) {
      // Overnight shift: end time is next day
      return DateTimeRange(start: startDateTime, end: endDateTime.addDays(1));
    } else {
      // Regular shift: same day
      return DateTimeRange(start: startDateTime, end: endDateTime);
    }
  }

  /// check if [date] is within the range
  ///
  /// Example:
  /// ```dart
  /// final workHours = TimeRange(
  ///   start: TimeOfDay(hour: 9, min: 0),
  ///   end: TimeOfDay(hour: 17, min: 0),
  /// );
  ///
  /// final morning = DateTime(2023, 6, 15, 10, 30);  // 10:30 AM
  /// final evening = DateTime(2023, 6, 15, 20, 30);  // 8:30 PM
  ///
  /// workHours.includes(morning);  // true
  /// workHours.includes(evening);  // false
  ///
  /// // Works with midnight-crossing ranges
  /// final nightShift = TimeRange(
  ///   start: TimeOfDay(hour: 22, min: 0),
  ///   end: TimeOfDay(hour: 6, min: 0),
  /// );
  /// final midnight = DateTime(2023, 6, 15, 2, 0);  // 2:00 AM
  /// nightShift.includes(midnight);  // true
  /// ```
  bool includes(DateTime date) {
    final startMinutes = _toMinutes(start);
    final endMinutes = _toMinutes(end);
    final currentMinutes = _toMinutes(date.timeOfDay);

    if (isSingleMoment) {
      return currentMinutes == startMinutes;
    }

    if (spansMidnight) {
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  @override
  String toString() {
    return 'start: $start --- end: $end';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TimeRange && start == other.start && end == other.end);
  }

  @override
  int get hashCode => Object.hashAll([start, end]);

  int _toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
}
