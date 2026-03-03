import 'operators.dart';
import 'sanitizers.dart';
import 'validators.dart';

extension DateTimeIterables on DateTime {
  /// Generates an iterable sequence of dates between `this` date and `end` date,
  /// optionally including or excluding both start and end dates based on [inclusive],
  /// with a specified [by] step.
  ///
  /// If [forceIncludeLast] is set to true and the step (`by`) exceeds the end date,
  /// the last possible date will be included which does not exceeds [end].
  ///
  /// Dates are yielded in ascending order, adjusting for changes in timezone
  /// offset during iteration.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// DateTime startDate = DateTime(2024, 6, 1);
  /// DateTime endDate = startDate.endOfMonth;
  ///
  /// Iterable<DateTime> dates = startDate.to(endDate, inclusive: false, by: const Duration(days: 5));
  ///
  /// for (var date in dates) {
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

    final bool overshot =
        ascending ? current.isAfter(end) : current.isBefore(end);

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
  /// DateTime today = DateTime.now();
  /// List<DateTime> dates = [DateTime(2024, 1, 1), DateTime(2024, 6, 15)];
  /// int? closestIndex = today.closestIndexTo(dates);
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
  /// DateTime today = DateTime.now();
  /// List<DateTime> dates = [DateTime(2024, 1, 1), DateTime(2024, 6, 15)];
  /// DateTime? closestDate = today.closestTo(dates);
  /// ```
  DateTime? closestTo(Iterable<DateTime> datesArray) {
    if (datesArray.isEmpty) return null;

    final index = closestIndexTo(datesArray);
    return index != null ? datesArray.elementAt(index) : null;
  }
}

extension Date on DateTime {
  /// Current date (Same as [DateTime.now])
  static DateTime now() => DateTime.now();

  /// Current date (Same as [DateTime.now])
  static DateTime today() => now().startOfDay;

  /// Tomorrow at same hour / minute / second than now
  static DateTime tomorrow() => now().nextDay;

  /// Yesterday at same hour / minute / second than now
  static DateTime yesterday() => now().previousDay;

  static DateTime nowWithTimezone(bool isUtc) {
    if (isUtc) return now().toUtc();

    return now();
  }

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

  static DateTime dateWithTimezone(
    int year, [
    int month = 1,
    int day = 1,
    bool isUtc = false,
  ]) {
    if (isUtc) return DateTime.utc(year, month, day);

    return DateTime(year, month, day);
  }

  /// Returns true if left [isBefore] than right
  static DateTime min(DateTime left, DateTime right) =>
      (left < right) ? left : right;

  /// Returns true if left [isAfter] than right
  static DateTime max(DateTime left, DateTime right) =>
      (left < right) ? right : left;

  /// Compare the two dates and return 1 if the first date [isAfter] the second,
  /// -1 if the first date [isBefore] the second or 0 first date [equals] the second.
  static int compareAsc(DateTime dateLeft, DateTime dateRight) {
    if (dateLeft.isAfter(dateRight)) {
      return 1;
    } else if (dateLeft.isBefore(dateRight)) {
      return -1;
    } else {
      return 0;
    }
  }

  /// Compare the two dates and return -1 if the first date [isAfter] the second,
  /// 1 if the first date [isBefore] the second or 0 first date [equals] the second.
  static int compareDesc(DateTime dateLeft, DateTime dateRight) =>
      (-1) * compareAsc(dateLeft, dateRight);
}
