import 'package:flutter/material.dart';

import 'converters.dart';
import 'operators.dart';
import 'range.dart';
import 'sanitizers.dart';

extension DateValidators on DateTime? {
  /// Checks if the [DateTime] value is null.
  bool get isNull => this == null;

  /// Checks if the [DateTime] value is not null.
  bool get isNotNull => !isNull;

  DateTime? _utcDateOnly(DateTime? value) {
    if (value == null) return null;
    final DateTime utc = value.toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day);
  }

  /// Whether the time of the date is zero/empty.
  bool get IsTimeZero =>
      this != null &&
      this!.hour == 0 &&
      this!.minute == 0 &&
      this!.second == 0 &&
      this!.millisecond == 0 &&
      this!.microsecond == 0;

  /// Checks if the year of this [DateTime] is a leap year.
  ///
  /// Returns `false` if the [DateTime] is `null`.
  bool get isLeapYear {
    if (this == null) return false;
    final int year = this!.year;
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// Returns `true` if this [DateTime] is a Saturday or a Sunday.
  ///
  /// This getter checks if the day of the week of the [DateTime] is either
  /// Saturday or Sunday. Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? saturday = DateTime(2023, 1, 7); // A Saturday
  /// print(saturday.isWeekend); // Outputs: true
  ///
  /// DateTime? monday = DateTime(2023, 1, 9); // A Monday
  /// print(monday.isWeekend); // Outputs: false
  /// ```
  bool get isWeekend =>
      this != null &&
      (this!.weekday == DateTime.saturday || this!.weekday == DateTime.sunday);

  /// Returns `true` if this [DateTime] is not a Saturday or Sunday.
  ///
  /// This getter checks if the day of the week of the [DateTime] is a
  /// workday (Monday through Friday). Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? friday = DateTime(2023, 1, 6); // A Friday
  /// print(friday.isWorkday); // Outputs: true
  ///
  /// DateTime? sunday = DateTime(2023, 1, 8); // A Sunday
  /// print(sunday.isWorkday); // Outputs: false
  /// ```
  bool get isWorkday => !isWeekend;

  /// Returns whether the [hour] is before noon (ante meridiem) in the current timezone.
  ///
  /// This getter checks if the hour of the [DateTime] is less than 12, indicating AM.
  /// Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? morningTime = DateTime(2023, 1, 1, 9, 0); // 9:00 AM
  /// print(morningTime.isAm); // Outputs: true
  /// ```
  bool get isAm => this != null && this!.hour < 12;

  /// Returns whether the [hour] is after noon (post meridiem) in the current timezone.
  ///
  /// This getter checks if the hour of the [DateTime] is 12 or greater, indicating PM.
  /// Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? afternoonTime = DateTime(2023, 1, 1, 15, 0); // 3:00 PM
  /// print(afternoonTime.isPm); // Outputs: true
  /// ```
  bool get isPm => this != null && this!.hour >= 12;

  /// Return `true` if is morning, `false` otherwise.
  /// Morning is defined as between 5am and 12pm.
  bool get isMorning => this != null && this!.hour >= 5 && this!.hour < 12;

  /// Return `true` if is afternoon, `false` otherwise.
  /// Afternoon is defined as 12:00 to 17:59.
  bool get isAfternoon => this != null && this!.hour >= 12 && this!.hour < 17;

  /// Return `true` if is evening, `false` otherwise.
  /// Evening is between 18 and 22.
  bool get isEvening => this != null && this!.hour >= 17 && this!.hour < 21;

  /// Return `true` if is night, `false` otherwise.
  /// Night is between 23 and 5.
  bool get isNight => this != null && (this!.hour >= 21 || this!.hour < 6);

  /// Checks if this [DateTime] is greater than [other].
  ///
  /// Returns `true` if this [DateTime] is later than [other], `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isAfter(DateTime? other) {
    if (this == null || other == null) return false;

    return this!.isAfter(other);
  }

  bool isBefore(DateTime? other) {
    if (this == null || other == null) return false;

    return this!.isBefore(other);
  }

  /// Checks if this [DateTime] is after or equal to [other].
  ///
  /// Returns `true` if this [DateTime] is the same moment or later than [other],
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isAfterOrEqualTo(DateTime? other) {
    return isAfter(other) || equals(other);
  }

  /// Checks if this [DateTime] is before or equal to [other].
  ///
  /// Returns `true` if this [DateTime] is the same moment or earlier than [other],
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isBeforeOrEqualTo(DateTime? other) {
    if (this == null || other == null) return false;

    return isBefore(other) || equals(other);
  }

  /// Checks if this [DateTime] falls between [date1] and [date2],
  /// regardless of their order in the calendar.
  ///
  /// If [inclusive] is `true`, the boundaries ([date1] and [date2]) are included.
  /// If [inclusive] is `false`, the check is strictly between the two.
  ///
  /// Returns `false` if this [DateTime] is null.
  bool isBetween(DateTime? date1, DateTime? date2, {bool inclusive = true}) {
    if (this == null || date1 == null || date2 == null) return false;

    final start = date1.isBefore(date2) ? date1 : date2;
    final end = date1.isBefore(date2) ? date2 : date1;

    return inclusive
        ? (isAfterOrEqualTo(start) && isBeforeOrEqualTo(end))
        : (isAfter(start) && isBefore(end));
  }

  /// Returns true if the date of [DateTime] occurs before the date of [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool isBeforeDate(DateTime? other) {
    final DateTime? a = _utcDateOnly(this);
    final DateTime? b = _utcDateOnly(other);
    if (a == null || b == null) return false;

    return a.isBefore(b);
  }

  /// Returns true if the date of [DateTime] occurs after the date of [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool isAfterDate(DateTime? other) {
    final DateTime? a = _utcDateOnly(this);
    final DateTime? b = _utcDateOnly(other);
    if (a == null || b == null) return false;

    return a.isAfter(b);
  }

  /// Checks if this [DateTime] represents the same date as [other].
  ///
  /// Returns `true` if both [DateTime] instances have the same year, month, and day,
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isSameDate(DateTime? other) {
    final DateTime? a = _utcDateOnly(this);
    final DateTime? b = _utcDateOnly(other);
    if (a == null || b == null) return false;

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Checks if this [DateTime] represents the same time as [other].
  ///
  /// Returns `true` if both [DateTime] instances have the same hour, and minute
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isSameTime(DateTime? other) {
    if (this == null || other == null) return false;

    final date = this!;
    return date.hour == other.hour && date.minute == other.minute;
  }

  /// Checks if this [DateTime] represents the same date and time as [other].
  ///
  /// Returns `true` if both [DateTime] instances have the same year, month, day, hour,
  /// and minute, `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isSameDateAndTime(DateTime? other) {
    return isSameDate(other) && isSameTime(other);
  }

  /// Determines if this date falls within the same ISO week as [other].
  ///
  /// Dates are considered to be in the same ISO week if they have the same ISO week
  /// number within their respective years. This method handles daylight savings
  /// by comparing dates based on their UTC representation.
  ///
  /// Returns `true` if this date and [other] are in the same ISO week; otherwise, returns `false`.
  bool isSameWeek(DateTime? other) {
    if (this == null || other == null) return false;

    final DateTime a = DateTime.utc(this!.year, this!.month, this!.day);
    final DateTime b = DateTime.utc(other.year, other.month, other.day);

    return a.weekNumber == b.weekNumber && a.isoWeekYear == b.isoWeekYear;
  }

  /// Check if this date is in the same month than other
  bool isSameMonth(DateTime? other) =>
      this != null && this!.startOfMonth == other?.startOfMonth;

  /// Check if this date is in the same year than other
  bool isSameYear(DateTime? other) =>
      this != null && other != null && this!.year == other.year;

  /// Check if two dates are [equals]
  bool equals(DateTime? other) {
    if (this == null || other == null) return false;

    return this!.isAtSameMomentAs(other);
  }

  /// Return true if this date day is monday
  bool get isMonday => this != null && this!.weekday == DateTime.monday;

  /// Return true if this date day is tuesday
  bool get isTuesday => this != null && this!.weekday == DateTime.tuesday;

  /// Return true if this date day is wednesday
  bool get isWednesday => this != null && this!.weekday == DateTime.wednesday;

  /// Return true if this date day is thursday
  bool get isThursday => this != null && this!.weekday == DateTime.thursday;

  /// Return true if this date day is friday
  bool get isFriday => this != null && this!.weekday == DateTime.friday;

  /// Return true if this date day is saturday
  bool get isSaturday => this != null && this!.weekday == DateTime.saturday;

  /// Return true if this date day is sunday
  bool get isSunday => this != null && this!.weekday == DateTime.sunday;

  /// Is the given date the first day of a month?
  bool get isFirstDayOfMonth => this != null && isSameDate(this!.startOfMonth);

  /// Is the given date the last day of a month?
  bool get isLastDayOfMonth => this != null && isSameDate(this!.endOfMonth);

  /// Return true if this [DateTime] is set as UTC.
  bool get isUTC => this != null && this!.isUtc;

  /// Checks if the DateTime instance represents today's date.
  ///
  /// This function compares the year, month, and day of the DateTime instance
  /// with the current date. If all these components match, it returns true.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime.now();
  /// bool result = date.isToday; // result will be true
  /// ```
  ///
  /// Returns `true` if the date is today, otherwise `false`.
  bool get isToday => isSameDate(DateTime.now());

  /// Checks if the DateTime instance represents yesterday's date.
  ///
  /// This function subtracts one day from the current date and compares
  /// the year, month, and day of the DateTime instance with the resulting date.
  /// If all these components match, it returns true.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime.now().subtract(Duration(days: 1));
  /// bool result = date.isYesterday; // result will be true
  /// ```
  ///
  /// Returns `true` if the date is yesterday, otherwise `false`.
  bool get isYesterday =>
      isSameDate(DateTime.now().subtract(const Duration(days: 1)));

  /// Checks if the DateTime instance represents tomorrow's date.
  ///
  /// This function adds one day to the current date and compares
  /// the year, month, and day of the DateTime instance with the resulting date.
  /// If all these components match, it returns true.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime.now().add(Duration(days: 1));
  /// bool result = date.isTomorrow; // result will be true
  /// ```
  ///
  /// Returns `true` if the date is tomorrow, otherwise `false`.
  bool get isTomorrow =>
      isSameDate(DateTime.now().add(const Duration(days: 1)));

  /// Boolean check to see if the current date is in the next week.
  ///
  /// Returns `true` if this [DateTime] falls within the next week (starting from
  /// the end of today until the end of the next week). Returns `false` if the
  /// [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? nextMonday = DateTime.now().add(Duration(days: 7));
  /// print(nextMonday.isNextWeek); // Outputs: true if today is not Monday
  /// ```
  bool get isNextWeek {
    if (this == null) return false;

    final DateTime now = DateTime.now();
    final DateTime startOfNextWeek = now.startOfWeek.addDays(7);
    final DateTime endOfNextWeek = startOfNextWeek.endOfWeek;

    return isBetween(startOfNextWeek.startOfDay, endOfNextWeek.endOfDay);
  }

  /// Boolean check to see if the current date is in the last week.
  ///
  /// Returns `true` if this [DateTime] falls within the last week (from the start
  /// of last week until the end of the previous day). Returns `false` if the
  /// [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? lastWednesday = DateTime.now().subtract(Duration(days: 7 + DateTime.now().weekday - 3));
  /// print(lastWednesday.isLastWeek); // Outputs: true if today is Wednesday
  /// ```
  bool get isLastWeek {
    if (this == null) return false;

    final DateTime now = DateTime.now();
    final DateTime startOfLastWeek = now.startOfWeek.subtractDays(7);
    final DateTime endOfLastWeek = startOfLastWeek.endOfWeek;

    return isBetween(startOfLastWeek.startOfDay, endOfLastWeek.endOfDay);
  }

  /// Checks if the current DateTime instance is in the past.
  ///
  /// Returns `true` if the current DateTime instance represents a moment
  /// before the current date and time as returned by [DateTime.now],
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2000);
  /// final bool result = dateTime.isInPast();
  /// print(result); // true, since 2000 is in the past
  /// ```
  bool get isPast => isBefore(DateTime.now());

  /// Checks if the current DateTime instance is in the future.
  ///
  /// Returns `true` if the current DateTime instance represents a moment
  /// after the current date and time as returned by [DateTime.now],
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(3000);
  /// final bool result = dateTime.isInFuture();
  /// print(result); // true, since 3000 is in the future
  /// ```
  bool get isFuture => isAfter(DateTime.now());

  /// Returns true if [DateTime] occurs in previous month
  bool get isInPreviousMonth {
    if (this == null) return false;

    final now = DateTime.now();
    final previousMonth = now.startOfMonth.addMonths(-1);

    return this!.month == previousMonth.month &&
        this!.year == previousMonth.year;
  }

  /// Returns true if [DateTime] occurs in previous month
  bool get isInNextMonth {
    if (this == null) return false;

    final now = DateTime.now();
    final nextMonth = now.startOfMonth.addMonths(1);

    return this!.month == nextMonth.month && this!.year == nextMonth.year;
  }

  /// Returns true if [DateTime] occurs in previous year
  bool get isInPreviousYear =>
      this != null && this!.year == DateTime.now().year - 1;

  /// Returns true if [DateTime] occurs in next year
  bool get isInNextYear =>
      this != null && this!.year == DateTime.now().year + 1;

  /// Returns true if [DateTime] falls in january
  bool get isInJanuary => this != null && this!.month == DateTime.january;

  /// Returns true if [DateTime] falls in february
  bool get isInFebruary => this != null && this!.month == DateTime.february;

  /// Returns true if [DateTime] falls in march
  bool get isInMarch => this != null && this!.month == DateTime.march;

  /// Returns true if [DateTime] falls in april
  bool get isInApril => this != null && this!.month == DateTime.april;

  /// Returns true if [DateTime] falls in may
  bool get isInMay => this != null && this!.month == DateTime.may;

  /// Returns true if [DateTime] falls in june
  bool get isInJune => this != null && this!.month == DateTime.june;

  /// Returns true if [DateTime] falls in july
  bool get isInJuly => this != null && this!.month == DateTime.july;

  /// Returns true if [DateTime] falls in august
  bool get isInAugust => this != null && this!.month == DateTime.august;

  /// Returns true if [DateTime] falls in september
  bool get isInSeptember => this != null && this!.month == DateTime.september;

  /// Returns true if [DateTime] falls in october
  bool get isInOctober => this != null && this!.month == DateTime.october;

  /// Returns true if [DateTime] falls in november
  bool get isInNovember => this != null && this!.month == DateTime.november;

  /// Returns true if [DateTime] falls in december
  bool get isInDecember => this != null && this!.month == DateTime.december;

  /// Checks if a [DateTime] is within a given [DateTimeRange].
  ///
  /// Returns `true` if this [DateTime] is not null and falls within the provided
  /// [range], inclusive of the start and end dates. Returns `false` if the
  /// [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime.now();
  /// DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(Duration(days: 1)), end: DateTime.now().add(Duration(days: 1)));
  /// print(date.isWithinRange(range)); // Outputs: true
  /// ```
  bool isWithinRange(DateTimeRange range) =>
      this != null && range.includes(this!);

  /// Checks if the datetime has passed a specified duration.
  ///
  /// Returns `true` if the current datetime is later than the given duration.
  /// Otherwise, returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime.parse('2024-05-27T14:31:57.505Z');
  /// final bool result = date.hasDurationPassed(Duration(hours: 5, minutes: 30));
  /// print(result); // Returns true if the current time is past 20:01:57.505Z on 2024-05-27
  /// ```
  bool hasDurationPassed(Duration duration) {
    if (this == null) return false;

    return DateTime.now().isAfter(this!.add(duration));
  }
}
