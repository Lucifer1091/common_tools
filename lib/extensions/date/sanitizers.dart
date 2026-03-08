import 'package:flutter/material.dart';

import 'operators.dart';

/// Read-only derived values for [DateTime], such as period boundaries
/// and next/previous units.
extension DateTimeGetters on DateTime {
  /// Creates a new [DateTime] instance that is a copy of this instance.
  ///
  /// Returns a new [DateTime] instance.
  DateTime get clone =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: isUtc);

  /// Returns the starting [DateTime] of the current year.
  ///
  /// Returns a new [DateTime] instance set to the start of the year (January 1st, 00:00:00).
  DateTime get startOfYear => (isUtc ? DateTime.utc : DateTime.new)(year);

  /// Returns the starting [DateTime] of the current month.
  ///
  /// Returns a new [DateTime] instance set to the start of the month (first day, 00:00:00).
  DateTime get startOfMonth =>
      (isUtc ? DateTime.utc : DateTime.new)(year, month);

  /// Returns the starting [DateTime] of the current week.
  ///
  /// Returns a new [DateTime] instance set to the start of the week (Monday, 00:00:00).
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  /// Returns the starting [DateTime] of the previous week.
  ///
  /// Returns a new [DateTime] instance set to the start of the previous week (Monday, 00:00:00).
  DateTime get startOfLastWeek => startOfDay.subtractDays(7).startOfWeek;

  /// Returns the starting [DateTime] of the current day.
  ///
  /// Returns a new [DateTime] instance set to the start of the day (00:00:00).
  DateTime get startOfDay => clone.setHour(0, 0, 0, 0, 0);

  /// Returns the starting [DateTime] of the current hour.
  ///
  /// Returns a new [DateTime] instance set to the start of the hour (HH:00:00).
  DateTime get startOfHour => clone.setMinute(0, 0, 0, 0);

  /// Returns the end of the year for this date.
  DateTime get endOfYear => clone.setYear(year, DateTime.december).endOfMonth;

  /// Returns the ending [DateTime] of the current month.
  ///
  /// Returns a new [DateTime] instance set to the end of the month.
  DateTime get endOfMonth =>
      (isUtc ? DateTime.utc : DateTime.new)(year, month + 1, 0).endOfDay;

  /// Returns the ending [DateTime] of the current week.
  ///
  /// Returns a new [DateTime] instance set to the end of the week.
  DateTime get endOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday)).endOfDay;

  /// Returns the end of the next week from the current date.
  DateTime get endOfNextWeek => startOfWeek.addDays(7).endOfWeek;

  /// Returns the end of this day (`23:59:59.999999`).
  DateTime get endOfDay => clone.setHour(23, 59, 59, 999, 999);

  /// Returns the end of this hour (`mm:ss.SSSuuu = 59:59.999999`).
  DateTime get endOfHour => clone.setMinute(59, 59, 999, 999);

  /// One calendar year after this [DateTime].
  DateTime get nextYear => clone.setYear(year + 1);

  /// One calendar year before this [DateTime].
  DateTime get previousYear => clone.setYear(year - 1);

  /// One calendar month after this [DateTime].
  DateTime get nextMonth => clone.setMonth(month + 1);

  /// One calendar month before this [DateTime].
  DateTime get previousMonth => clone.setMonth(month - 1);

  /// Seven days after this [DateTime].
  DateTime get nextWeek => addDays(7);

  /// Seven days before this [DateTime].
  DateTime get previousWeek => subtractDays(7);

  /// The next calendar day preserving local/UTC mode.
  DateTime get nextDay => addDays(1);

  /// The previous calendar day.
  DateTime get previousDay => addDays(-1);

  /// Returns this moment represented as a UTC [DateTime].
  DateTime get utc =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: true);

  /// Returns this moment represented as a local [DateTime].
  DateTime get local =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
}

/// Mutation-like setters that return new [DateTime] instances.
///
/// Each method is immutable and preserves the UTC/local mode of the source.
extension DateTimeSetters on DateTime {
  /// Creates a new [DateTime] instance with the provided fields replaced.
  ///
  /// Returns a new [DateTime] with the updated values.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      isUtc
          ? DateTime.utc(
            year ?? this.year,
            month ?? this.month,
            day ?? this.day,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          )
          : DateTime(
            year ?? this.year,
            month ?? this.month,
            day ?? this.day,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          );

  /// Returns a copy using [time] for hour/minute while preserving the date.
  ///
  /// If [time] is omitted, the original time is preserved.
  DateTime copyTime([TimeOfDay? time]) {
    return (isUtc ? DateTime.utc : DateTime.new)(
      year,
      month,
      day,
      time?.hour ?? hour,
      time?.minute ?? minute,
    );
  }

  /// Returns [DateTime] with only information that is passed to the method.
  /// In contrast to [copyWith] method, this method does not copy
  /// unspecified fields from the original [DateTime].
  DateTime only({
    int? year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) {
    return (isUtc ? DateTime.utc : DateTime.new)(
      year ?? this.year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Returns a copy with [year] replaced.
  ///
  /// Optional parameters override corresponding date/time parts.
  DateTime setYear(
    int year, [
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month ?? this.month,
    day ?? this.day,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  /// Returns a copy with [month] replaced.
  ///
  /// Optional parameters override corresponding date/time parts.
  DateTime setMonth(
    int month, [
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month,
    day ?? this.day,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  /// Returns a copy with [day] replaced.
  ///
  /// Optional parameters override corresponding time parts.
  DateTime setDay(
    int day, [
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month,
    day,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  /// Sets the hour, minute, second, millisecond, and microsecond of this [DateTime].
  ///
  /// Returns a new [DateTime] with the updated values.
  DateTime setHour(
    int hour, [
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month,
    day,
    hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  /// Returns a copy with [minute] replaced.
  ///
  /// Optional parameters override second, millisecond, and microsecond.
  DateTime setMinute(
    int minute, [
    int? second,
    int? millisecond,
    int? microsecond,
  ]) => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month,
    day,
    hour,
    minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  /// Returns a copy with [second] replaced.
  ///
  /// Optional parameters override millisecond and microsecond.
  DateTime setSecond(int second, [int? millisecond, int? microsecond]) =>
      (isUtc ? DateTime.utc : DateTime.new)(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// Returns a copy with [millisecond] replaced.
  ///
  /// Optionally overrides [microsecond].
  DateTime setMillisecond(int millisecond, [int? microsecond]) =>
      (isUtc ? DateTime.utc : DateTime.new)(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond ?? this.microsecond,
      );

  /// Returns a copy with [microsecond] replaced.
  DateTime setMicrosecond(int microsecond) =>
      (isUtc ? DateTime.utc : DateTime.new)(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );

  /// Returns the next occurrence of [weekday] after this date.
  ///
  /// If this date already falls on [weekday], returns the same weekday in the
  /// following week.
  ///
  /// In debug mode, assertions allow `0..7`; practical weekday values are
  /// [DateTime.monday]..[DateTime.sunday] (`1..7`).
  DateTime nextWeekday(int weekday) {
    assert(
      weekday > -1 && weekday < 8,
      '[moment_dart] Weekday must be in range `0<=n<=7`',
    );

    final int requiredDelta = (weekday - this.weekday) % 7;

    return this + Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
  }

  /// Returns the previous occurrence of [weekday] before this date.
  ///
  /// If this date already falls on [weekday], returns the same weekday in the
  /// previous week.
  ///
  /// In debug mode, assertions allow `0..7`; practical weekday values are
  /// [DateTime.monday]..[DateTime.sunday] (`1..7`).
  DateTime lastWeekday(int weekday) {
    assert(
      weekday > -1 && weekday < 8,
      '[Moment Dart] Weekday must be in range `0<=n<=7`',
    );

    final int requiredDelta = (this.weekday - weekday) % 7;

    return this - Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
  }

  /// Truncates the time portion of the [DateTime] object.
  ///
  /// Returns a new [DateTime] instance with the same year, month, and day,
  /// but the time set to midnight (00:00:00).
  DateTime truncateTime() =>
      (isUtc ? DateTime.utc : DateTime.new)(year, month, day);

  /// Removes microseconds while preserving milliseconds.
  ///
  /// Returned instance has `microsecond == 0`.
  DateTime truncateMicros() => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
  );

  /// Removes any information that is equal to or smaller than milliseconds.
  /// Returned instance will have 0 milliseconds and microseconds.
  DateTime truncateMillis() => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month,
    day,
    hour,
    minute,
    second,
  );

  /// Removes any information that is equal to or smaller than seconds.
  /// Returned instance will have 0 seconds, milliseconds and microseconds.
  DateTime truncateSeconds() =>
      (isUtc ? DateTime.utc : DateTime.new)(year, month, day, hour, minute);

  /// Removes any information that is equal to or smaller than minutes.
  /// Returned instance will have 0 minutes, seconds,
  /// milliseconds and microseconds.
  DateTime truncateMinutes() =>
      (isUtc ? DateTime.utc : DateTime.new)(year, month, day, hour);

  /// Rounds this [DateTime] to the nearest quarter hour.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2024, 6, 23, 14, 38);
  /// final roundedDateTime = dateTime.nearestQuarter();
  /// print(roundedDateTime); // 2024-06-23 14:45:00.000
  /// ```
  ///
  /// Returns a new [DateTime] instance rounded to the nearest quarter hour.
  DateTime nearestQuarter() {
    final int totalMinutes = (hour * 60) + minute;
    final int roundedTotalMinutes = ((totalMinutes / 15).round()) * 15;
    return (isUtc ? DateTime.utc : DateTime.new)(year, month, day).add(
      Duration(minutes: roundedTotalMinutes),
    );
  }

  /// Rounds this [DateTime] to the nearest half hour.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2024, 6, 23, 14, 38);
  /// final roundedDateTime = dateTime.nearestHalfHour();
  /// print(roundedDateTime); // 2024-06-23 14:30:00.000
  /// ```
  ///
  /// Returns a new [DateTime] instance rounded to the nearest half hour.
  DateTime nearestHalfHour() {
    final int totalMinutes = (hour * 60) + minute;
    final int roundedTotalMinutes = ((totalMinutes / 30).round()) * 30;
    return (isUtc ? DateTime.utc : DateTime.new)(year, month, day).add(
      Duration(minutes: roundedTotalMinutes),
    );
  }
}
