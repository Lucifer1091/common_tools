import 'package:flutter/material.dart';

import '../extensions/date/converters.dart';
import '../extensions/date/operators.dart';
import '../extensions/date/sanitizers.dart';

/// Represents a daily time-of-day interval.
///
/// A [TimeRange] can be:
/// - same-day (for example `09:00 -> 17:00`)
/// - overnight (for example `22:00 -> 06:00`)
/// - single-moment (`start == end`)
///
/// Range boundaries are inclusive in [includes].
///
/// Example:
/// ```dart
/// final officeHours = TimeRange(
///   start: const TimeOfDay(hour: 9, minute: 0),
///   end: const TimeOfDay(hour: 17, minute: 0),
/// );
///
/// print(officeHours.includes(DateTime(2026, 3, 8, 10, 30))); // true
/// print(officeHours.includes(DateTime(2026, 3, 8, 20, 0)));  // false
/// ```
class TimeRange {
  /// Creates a [TimeRange] from [start] to [end].
  const TimeRange({required this.start, required this.end});

  /// Start time-of-day of the range.
  final TimeOfDay start;

  /// End time-of-day of the range.
  final TimeOfDay end;

  /// Returns `true` when the range crosses midnight (e.g. 22:00-06:00).
  bool get spansMidnight => end.isBefore(start);

  /// Returns `true` when start and end represent the same clock time.
  ///
  /// In this case, [includes] behaves as a single-minute point-in-time match.
  bool get isSingleMoment => start == end;

  /// Converts this daily time range into a concrete [DateTimeRange] for [date].
  ///
  /// For same-day ranges, both [start] and [end] remain on [date].
  /// For overnight ranges (for example `22:00 -> 06:00`), the end time is
  /// moved to the next day.
  ///
  /// Example:
  /// ```dart
  /// final timeRange = TimeRange(
  ///   start: TimeOfDay(hour: 9, minute: 0),
  ///   end: TimeOfDay(hour: 17, minute: 0),
  /// );
  /// final nightRange = TimeRange(
  ///   start: TimeOfDay(hour: 22, minute: 0),
  ///   end: TimeOfDay(hour: 6, minute: 0),
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

  /// Returns whether [date] falls inside this time range.
  ///
  /// Only the time-of-day component is considered; calendar date is ignored.
  ///
  /// Start and end are both treated as inclusive boundaries.
  ///
  /// Example:
  /// ```dart
  /// final workHours = TimeRange(
  ///   start: TimeOfDay(hour: 9, minute: 0),
  ///   end: TimeOfDay(hour: 17, minute: 0),
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
  ///   start: TimeOfDay(hour: 22, minute: 0),
  ///   end: TimeOfDay(hour: 6, minute: 0),
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
