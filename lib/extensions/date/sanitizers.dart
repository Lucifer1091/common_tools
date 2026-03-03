import 'package:flutter/material.dart';

import 'operators.dart';

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
  /// Reference: https://stackoverflow.com/questions/62872349/dart-flutter-get-first-datetime-of-this-week
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

  /// Return the end of a day for this date.
  DateTime get endOfDay => clone.setHour(23, 59, 59, 999, 999);

  /// Return the end of the hour for this date.
  DateTime get endOfHour => clone.setMinute(59, 59, 999, 999);

  /// The year after this [DateTime]
  DateTime get nextYear => clone.setYear(year + 1);

  /// The year previous this [DateTime]
  DateTime get previousYear => clone.setYear(year - 1);

  /// The month after this [DateTime]
  DateTime get nextMonth => clone.setMonth(month + 1);

  /// The month previous this [DateTime]
  DateTime get previousMonth => clone.setMonth(month - 1);

  /// The week after this [DateTime]
  DateTime get nextWeek => addDays(7);

  /// The week previous this [DateTime]
  DateTime get previousWeek => subtractDays(7);

  DateTime get nextDay => addDays(1);

  /// The day previous this [DateTime]
  DateTime get previousDay => addDays(-1);

  /// Get UTC [DateTime] from this [DateTime]
  DateTime get utc =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: true);

  /// Get Local [DateTime] from this [DateTime]
  DateTime get local =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
}

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

  /// Change [year] of this date
  ///
  /// set [month] if you want to change it as well, to skip an change other optional field set it as null
  /// set [day] if you want to change it as well, to skip an change other optional field set it as null
  /// set [hour] if you want to change it as well, to skip an change other optional field set it as null
  /// set [minute] if you want to change it as well, to skip an change other optional field set it as null
  /// set [second] if you want to change it as well, to skip an change other optional field set it as null
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as null
  /// set [microsecond] if you want to change it as well
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

  /// Change [month] of this date
  ///
  /// set [day] if you want to change it as well, to skip an change other optional field set it as null
  /// set [hour] if you want to change it as well, to skip an change other optional field set it as null
  /// set [minute] if you want to change it as well, to skip an change other optional field set it as null
  /// set [second] if you want to change it as well, to skip an change other optional field set it as null
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as null
  /// set [microsecond] if you want to change it as well
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

  /// Change [weekday] of this date
  ///
  /// set [weekStartsOn] if you want to use any other day as the start of the week
  DateTime setWeekDay(int weekday, [int weekStartsOn = DateTime.sunday]) {
    const daysPerWeek = DateTime.daysPerWeek;
    final currentDay = this.weekday;
    final reminder = weekday % daysPerWeek;
    final dayIndex = (reminder + daysPerWeek) % daysPerWeek;
    final delta = daysPerWeek - weekStartsOn;
    final diff =
        weekday < 0 || weekday > 6
            ? weekday - ((currentDay + delta) % daysPerWeek)
            : ((dayIndex + delta) % daysPerWeek) -
                ((currentDay + delta) % daysPerWeek);

    return addDays(diff);
  }

  /// Change [day] of this date
  ///
  /// set [hour] if you want to change it as well, to skip an change other optional field set it as null
  /// set [minute] if you want to change it as well, to skip an change other optional field set it as null
  /// set [second] if you want to change it as well, to skip an change other optional field set it as null
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as null
  /// set [microsecond] if you want to change it as well
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

  /// Change [minute] of this date
  ///
  /// set [second] if you want to change it as well, to skip an change other optional field set it as null
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as null
  /// set [microsecond] if you want to change it as well
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

  /// Change [second] of this date
  ///
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as null
  /// set [microsecond] if you want to change it as well
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

  /// Change [millisecond] of this date
  ///
  /// set [microsecond] if you want to change it as well
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

  /// Change [microsecond] of this date
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

  /// Returns new [DateTime] instance of nearest `n`th weekday in the future
  ///
  /// If `n`th day is today, will return `7 days in the future`.
  DateTime nextWeekday(int weekday) {
    assert(
      weekday > -1 && weekday < 8,
      '[moment_dart] Weekday must be in range `0<=n<=7`',
    );

    final int requiredDelta = (weekday - this.weekday) % 7;

    return this + Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
  }

  /// Returns new [DateTime] instance of nearest Monday in the Future
  ///
  /// If this is Monday, will return `7 days in the future`
  DateTime nextMonday() => nextWeekday(DateTime.monday);

  /// Returns new [DateTime] instance of nearest Tuesday in the Future
  ///
  /// If this is Tuesday, will return `7 days in the future`
  DateTime nextTuesday() => nextWeekday(DateTime.tuesday);

  /// Returns new [DateTime] instance of nearest Wednesday in the Future
  ///
  /// If this is Wednesday, will return `7 days in the future`
  DateTime nextWednesday() => nextWeekday(DateTime.wednesday);

  /// Returns new [DateTime] instance of nearest Thursday in the Future
  ///
  /// If this is Thursday, will return `7 days in the future`
  DateTime nextThursday() => nextWeekday(DateTime.thursday);

  /// Returns new [DateTime] instance of nearest Friday in the Future
  ///
  /// If this is Friday, will return `7 days in the future`
  DateTime nextFriday() => nextWeekday(DateTime.friday);

  /// Returns new [DateTime] instance of nearest Saturday in the Future
  ///
  /// If this is Saturday, will return `7 days in the future`
  DateTime nextSaturday() => nextWeekday(DateTime.saturday);

  /// Returns new [DateTime] instance of nearest Sunday in the Future
  ///
  /// If this is Sunday, will return `7 days in the future`
  DateTime nextSunday() => nextWeekday(DateTime.sunday);

  /// Returns new [DateTime] instance of last `n`th weekday
  ///
  /// If today is the `n`th day, will return `7 days in the past`
  DateTime lastWeekday(int weekday) {
    assert(
      weekday > -1 && weekday < 8,
      '[Moment Dart] Weekday must be in range `0<=n<=7`',
    );

    final int requiredDelta = (this.weekday - weekday) % 7;

    return this - Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
  }

  /// Returns new [DateTime] instance of nearest Monday in the past
  ///
  /// If this is Monday, will return `7 days in the past`
  DateTime lastMonday() => lastWeekday(DateTime.monday);

  /// Returns new [DateTime] instance of nearest Tuesday in the past
  ///
  /// If this is Tuesday, will return `7 days in the past`
  DateTime lastTuesday() => lastWeekday(DateTime.tuesday);

  /// Returns new [DateTime] instance of nearest Wednesday in the past
  ///
  /// If this is Wednesday, will return `7 days in the past`
  DateTime lastWednesday() => lastWeekday(DateTime.wednesday);

  /// Returns new [DateTime] instance of nearest Thursday in the past
  ///
  /// If this is Thursday, will return `7 days in the past`
  DateTime lastThursday() => lastWeekday(DateTime.thursday);

  /// Returns new [DateTime] instance of nearest Friday in the past
  ///
  /// If this is Friday, will return `7 days in the past`
  DateTime lastFriday() => lastWeekday(DateTime.friday);

  /// Returns new [DateTime] instance of nearest Saturday in the past
  ///
  /// If this is Saturday, will return `7 days in the past`
  DateTime lastSaturday() => lastWeekday(DateTime.saturday);

  /// Returns new [DateTime] instance of nearest Sunday in the past
  ///
  /// If this is Sunday, will return `7 days in the past`
  DateTime lastSunday() => lastWeekday(DateTime.sunday);

  /// Truncates the time portion of the [DateTime] object.
  ///
  /// Returns a new [DateTime] instance with the same year, month, and day,
  /// but the time set to midnight (00:00:00).
  DateTime truncateTime() =>
      (isUtc ? DateTime.utc : DateTime.new)(year, month, day);

  /// Removes any information that is equal to or smaller than milliseconds.
  /// Returned instance will have 0 milliseconds and microseconds.
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
  /// DateTime dateTime = DateTime(2024, 6, 23, 14, 38);
  /// DateTime roundedDateTime = dateTime.nearestQuarter();
  /// print(roundedDateTime); // Output: 2024-06-23 14:45:00.000
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
  /// DateTime dateTime = DateTime(2024, 6, 23, 14, 38);
  /// DateTime roundedDateTime = dateTime.nearestHalfHour();
  /// print(roundedDateTime); // Output: 2024-06-23 14:30:00.000
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
