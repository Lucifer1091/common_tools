import './validators.dart';

/// Aggregate and utility helpers for [Iterable<DateTime>].
extension IterableDateTimeHelper on Iterable<DateTime> {
  /// Get the maximum date in the iterable.
  ///
  /// Throws [StateError] if the iterable is empty.
  DateTime max() => reduce((a, b) => a.isAfter(b) ? a : b);

  /// Get the minimum date in the iterable.
  ///
  /// Throws [StateError] if the iterable is empty.
  DateTime min() => reduce((a, b) => a.isBefore(b) ? a : b);

  /// Get the span between the earliest and latest dates.
  ///
  /// Throws [StateError] if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 5),
  /// ];
  /// print(dates.span); // Duration(days: 9)
  /// ```
  Duration get span => max().difference(min());

  /// Calculate the total span in days between the earliest and latest dates.
  ///
  /// Throws [StateError] if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 5),
  /// ];
  /// print(dates.spanInDays); // 9 (10 - 1 = 9 days difference)
  /// ```
  int get spanInDays => span.inDays;

  /// Find the date in the iterable that is closest to the given [target] date.
  ///
  /// Throws [StateError] if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 20),
  /// ];
  /// final target = DateTime(2023, 1, 12);
  /// print(dates.closestTo(target)); // 2023-01-10 (closest to target)
  /// ```
  DateTime closestTo(DateTime target) {
    return reduce((a, b) {
      final diffA = a.difference(target).abs();
      final diffB = b.difference(target).abs();
      return diffA < diffB ? a : b;
    });
  }

  /// Filter dates to only include weekdays (Monday to Friday).
  /// More info about weekdays in [DateValidators.isWorkday].
  ///
  /// Example:
  /// ```dart
  /// final week = [
  ///   DateTime(2023, 6, 12), // Monday
  ///   DateTime(2023, 6, 13), // Tuesday
  ///   DateTime(2023, 6, 17), // Saturday
  ///   DateTime(2023, 6, 18), // Sunday
  /// ];
  /// final weekdays = week.weekdaysOnly.toList();
  /// print(weekdays.length); // 2 (Monday and Tuesday)
  /// ```
  Iterable<DateTime> get weekdaysOnly => where((date) => date.isWorkday);

  /// Filter dates to only include weekends (Saturday and Sunday).
  ///
  /// More info about weekends in [DateValidators.isWeekend].
  ///
  /// Example:
  /// ```dart
  /// final week = [
  ///   DateTime(2023, 6, 12), // Monday
  ///   DateTime(2023, 6, 13), // Tuesday
  ///   DateTime(2023, 6, 17), // Saturday
  ///   DateTime(2023, 6, 18), // Sunday
  /// ];
  /// final weekends = week.weekendsOnly.toList();
  /// print(weekends.length); // 2 (Saturday and Sunday)
  /// ```
  Iterable<DateTime> get weekendsOnly => where((date) => date.isWeekend);

  /// Sort dates in ascending order (earliest first).
  ///
  /// Example:
  /// ```dart
  /// final unsorted = [
  ///   DateTime(2023, 6, 15),
  ///   DateTime(2023, 6, 10),
  ///   DateTime(2023, 6, 20),
  /// ];
  /// final sorted = unsorted.sortAscending();
  /// // [2023-06-10, 2023-06-15, 2023-06-20]
  /// ```
  List<DateTime> sortAscending() {
    return List<DateTime>.from(this)..sort((a, b) => a.compareTo(b));
  }

  /// Sort dates in descending order (latest first).
  ///
  /// Example:
  /// ```dart
  /// final unsorted = [
  ///   DateTime(2023, 6, 15),
  ///   DateTime(2023, 6, 10),
  ///   DateTime(2023, 6, 20),
  /// ];
  /// final sorted = unsorted.sortDescending();
  /// // [2023-06-20, 2023-06-15, 2023-06-10]
  /// ```
  List<DateTime> sortDescending() {
    return List<DateTime>.from(this)..sort((a, b) => b.compareTo(a));
  }

  /// Get the median date in the iterable.
  ///
  /// For an odd number of dates, returns the middle date.
  /// For an even number of dates, returns the earlier of the two middle dates.
  ///
  /// Throws [StateError] if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 5),
  ///   DateTime(2023, 1, 10),
  /// ];
  /// print(dates.median()); // 2023-01-05 (middle date)
  ///
  /// final evenDates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 5),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 15),
  /// ];
  /// print(evenDates.median()); // 2023-01-05 (earlier of two middle dates)
  /// ```
  DateTime median() {
    if (isEmpty) {
      throw StateError('Cannot find median of empty iterable');
    }

    final sorted = sortAscending();
    final middle = sorted.length ~/ 2;

    // For even number of elements,
    // return the earlier of the two middle elements
    if (sorted.length.isEven) return sorted[middle - 1];

    // For odd number of elements,
    // return the middle element
    return sorted[middle];
  }

  /// Get the mode (most frequently occurring date) in the iterable.
  ///
  /// If multiple dates have the same highest frequency,
  /// returns the earliest one.
  ///
  /// If all dates occur with the same frequency,
  /// returns the earliest date.
  ///
  /// Throws [StateError] if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 5),
  ///   DateTime(2023, 1, 1), // appears twice
  ///   DateTime(2023, 1, 10),
  /// ];
  /// print(dates.mode()); // 2023-01-01 (appears most frequently)
  /// ```
  DateTime mode() {
    if (isEmpty) {
      throw StateError('Cannot find mode of empty iterable');
    }

    // Count occurrences of each date
    final counts = <DateTime, int>{};
    for (final date in this) {
      counts[date] = (counts[date] ?? 0) + 1;
    }

    // Find the maximum count
    final sortedCountsAscending = counts.entries.toList()
      ..sort((a, b) {
        if (a.value > b.value) {
          return -1;
        } else if (a.value < b.value) {
          return 1;
        }
        return a.key.compareTo(b.key);
      });

    return sortedCountsAscending.first.key;
  }
}
