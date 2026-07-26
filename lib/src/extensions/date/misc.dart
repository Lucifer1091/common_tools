import 'operators.dart';
import 'sanitizers.dart';

/// Sequence and comparison helpers for [DateTime].
extension DateTimeIterables on DateTime {
  /// Generates an iterable sequence of dates between `this` date and `end` date,
  /// optionally including or excluding both start and end dates based on [inclusive],
  /// with a specified [by] step.
  ///
  /// If [forceIncludeLast] is `true` and stepping overshoots, [end] is yielded
  /// as the final value.
  ///
  /// Dates are yielded in ascending order, adjusting for changes in timezone
  /// offset during iteration.
  ///
  /// Example:
  /// ```dart
  /// final startDate = DateTime(2024, 6, 1);
  /// final endDate = startDate.endOfMonth;
  ///
  /// final dates = startDate.to(
  ///   endDate,
  ///   inclusive: false,
  ///   by: const Duration(days: 5),
  /// );
  ///
  /// for (final date in dates) {
  ///   print(date.toIso8601String());
  /// }
  /// ```
  Iterable<DateTime> to(
    DateTime end, {
    Duration by = const Duration(days: 1),
    bool inclusive = true,
    bool forceIncludeLast = false,
  }) sync* {
    if (by <= Duration.zero) {
      throw ArgumentError.value(by, 'by', 'Step duration must be positive');
    }

    DateTime current = this;

    if (current.isAtSameMomentAs(end) && !inclusive) return;
    final bool ascending =
        current.isBefore(end) || current.isAtSameMomentAs(end);

    if (ascending) {
      while (current.isBefore(end) ||
          (inclusive && current.isAtSameMomentAs(end))) {
        yield current;
        current = current.add(by);
      }
    } else {
      while (current.isAfter(end) ||
          (inclusive && current.isAtSameMomentAs(end))) {
        yield current;
        current = current.subtract(by);
      }
    }

    final bool overshot = ascending
        ? current.isAfter(end)
        : current.isBefore(end);

    if (forceIncludeLast && overshot && !current.isAtSameMomentAs(end)) {
      yield end;
    }
  }

  /// Returns this [DateTime] clamped to be in the range [min]-[max].
  ///
  /// The comparison is done using [compareTo].
  ///
  /// The arguments [min] and [max] must form a valid range where
  /// `min.compareTo(max) <= 0`.
  ///
  /// Example:
  /// ```dart
  /// var result = DateTime(2022, DateTime.october, 15).clamp(
  ///   min: DateTime(2022, DateTime.september, 1),
  ///   max: DateTime(2022, DateTime.september, 30),
  /// ); // DateTime(2022, DateTime.september, 30);
  /// result = DateTime(2022, DateTime.august, 21).clamp(
  ///   min: DateTime(2022, DateTime.september, 15),
  ///   max: DateTime(2022, DateTime.september, 30),
  /// ); // DateTime(2022, DateTime.september, 15);
  /// result = DateTime(2022, DateTime.september, 1).clamp(
  ///   min: DateTime(2022, DateTime.august, 1),
  ///   max: DateTime(2022, DateTime.september, 30),
  /// ); // DateTime(2022, DateTime.september, 1);
  /// ```
  DateTime clamp({DateTime? min, DateTime? max}) {
    assert(
      min == null ||
          max == null ||
          min.isBefore(max) ||
          min.isAtSameMomentAs(max),
      'DateTime min has to be before or equal to max\n(min: $min - max: $max)',
    );
    if ((min != null) && isBefore(min)) {
      return min;
    } else if ((max != null) && isAfter(max)) {
      return max;
    }
    return this;
  }

  /// Returns the index of the closest date to the current [DateTime]
  /// from the given [Iterable] of dates. Returns `null` if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// final dates = [DateTime(2024, 1, 1), DateTime(2024, 6, 15)];
  /// final closestIndex = today.closestIndexTo(dates);
  /// ```
  int? closestIndexTo(Iterable<DateTime> datesArray) {
    if (datesArray.isEmpty) return null;

    var index = 0;
    var minDifference = datesArray.first.difference(this).abs();

    for (var i = 1; i < datesArray.length; i++) {
      final difference = datesArray.elementAt(i).difference(this).abs();
      if (difference < minDifference) {
        minDifference = difference;
        index = i;
      }
    }

    return index;
  }

  /// Returns the closest date to the current [DateTime] from the given
  /// [Iterable] of dates. Returns `null` if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// final dates = [DateTime(2024, 1, 1), DateTime(2024, 6, 15)];
  /// final closestDate = today.closestTo(dates);
  /// ```
  DateTime? closestTo(Iterable<DateTime> datesArray) {
    if (datesArray.isEmpty) return null;

    final index = closestIndexTo(datesArray);
    return index != null ? datesArray.elementAt(index) : null;
  }
}

/// Static helpers for constructing and comparing [DateTime] values.
extension MyDate on DateTime {
  /// Current date/time (same as [DateTime.now]).
  static DateTime now() => DateTime.now();

  /// Tomorrow at the same hour/minute/second as now.
  static DateTime tomorrow() => now().nextDay;

  /// Yesterday at the same hour/minute/second as now.
  static DateTime yesterday() => now().previousDay;

  /// Returns the current time in UTC when [isUtc] is `true`,
  /// otherwise returns local time.
  static DateTime nowWithTimezone(bool isUtc) {
    if (isUtc) return now().toUtc();

    return now();
  }

  /// Creates a [DateTime] with explicit timezone mode.
  ///
  /// Uses [DateTime.utc] when [isUtc] is `true`, otherwise [DateTime.new].
  ///
  /// Example:
  /// ```dart
  /// final local = Date.withTimezone(false, 2026, 3, 8, 12);
  /// final utc = Date.withTimezone(true, 2026, 3, 8, 12);
  /// ```
  static DateTime withTimezone(
    bool isUtc,
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    if (isUtc) {
      return DateTime.utc(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Creates a date-only [DateTime] with explicit timezone mode.
  ///
  /// Example:
  /// ```dart
  /// final d = Date.dateWithTimezone(2026, 3, 8, true);
  /// ```
  static DateTime dateWithTimezone(
    int year, [
    int month = 1,
    int day = 1,
    bool isUtc = false,
  ]) {
    if (isUtc) return DateTime.utc(year, month, day);

    return DateTime(year, month, day);
  }

  /// Returns the earlier of [left] and [right].
  static DateTime min(DateTime left, DateTime right) =>
      (left < right) ? left : right;

  /// Returns the later of [left] and [right].
  static DateTime max(DateTime left, DateTime right) =>
      (left < right) ? right : left;

  /// Compares [left] with [right] in ascending order.
  ///
  /// Returns:
  /// - `1` if [left] is after [right]
  /// - `-1` if [left] is before [right]
  /// - `0` if both represent the same moment
  static int compareAsc(DateTime left, DateTime right) {
    if (left.isAfter(right)) {
      return 1;
    } else if (left.isBefore(right)) {
      return -1;
    } else {
      return 0;
    }
  }

  /// Compares [left] with [right] in descending order.
  static int compareDesc(DateTime left, DateTime right) =>
      (-1) * compareAsc(left, right);
}
