import 'package:flutter/material.dart';

import '../index.dart';

class TimeRange {
  const TimeRange({required this.start, required this.end});

  final TimeOfDay start;
  final TimeOfDay end;

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
  /// final nightRange = nightRange.toDateRange(monday);
  /// // Returns: 2023-06-12 22:00 to 2023-06-13 06:00
  /// ```
  DateTimeRange toDateRange(DateTime date) {
    final startDateTime = date.copyTime(start);
    final endDateTime = date.copyTime(end);

    if (end.isBefore(start)) {
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
  /// final workHours = ClockTimeRange(
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
  /// final nightShift = ClockTimeRange(
  ///   start: TimeOfDay(hour: 22, min: 0),
  ///   end: TimeOfDay(hour: 6, min: 0),
  /// );
  /// final midnight = DateTime(2023, 6, 15, 2, 0);  // 2:00 AM
  /// nightShift.includes(midnight);  // true
  /// ```
  bool includes(DateTime date) {
    var startDate = date.copyTime(start);
    var endDate = date.copyTime(end);

    if (end.isBefore(start)) {
      if (start.isAfter(date.timeOfDay)) {
        startDate = startDate - const Duration(days: 1);
      } else {
        endDate = endDate + const Duration(days: 1);
      }
    }

    return startDate <= date && date <= endDate;
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
}
