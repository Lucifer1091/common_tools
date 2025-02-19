import 'sanitizers.dart';
import 'validators.dart';

extension DateTimeOperators on DateTime {
  /// Returns true if this occurs strictly before [other], accounting for time
  /// zones.
  ///
  /// Alias for [DateTime.isBefore].
  ///
  /// Note that attempting to use this operator with [DateTime.==] will likely
  /// give undesirable results. This operator compares moments (i.e. with time
  /// zone taken into account), while [DateTime.==] compares field values (i.e.
  /// two [DateTime]s representing the same moment in different time zones will
  /// be treated as not equal). To check moment equality with time zone taken
  /// into account, use [DateTime.isAtSameMomentAs] rather than [DateTime.==].
  bool operator <(DateTime other) => isBefore(other);

  /// Returns true if this occurs strictly after [other], accounting for time
  /// zones.
  ///
  /// Alias for [DateTime.isAfter].
  ///
  /// Note that attempting to use this operator with [DateTime.==] will likely
  /// give undesirable results. This operator compares moments (i.e. with time
  /// zone taken into account), while [DateTime.==] compares field values (i.e.
  /// two [DateTime]s representing the same moment in different time zones will
  /// be treated as not equal). To check moment equality with time zone taken
  /// into account, use [DateTime.isAtSameMomentAs] rather than [DateTime.==].
  bool operator >(DateTime other) => isAfter(other);

  /// Returns true if this occurs at or before [other], accounting for time
  /// zones.
  ///
  /// Alias for [isBeforeOrEqualTo].
  ///
  /// Note that attempting to use this operator with [DateTime.==] will likely
  /// give undesirable results. This operator compares moments (i.e. with time
  /// zone taken into account), while [DateTime.==] compares field values (i.e.
  /// two [DateTime]s representing the same moment in different time zones will
  /// be treated as not equal). To check moment equality with time zone taken
  /// into account, use [DateTime.isAtSameMomentAs] rather than [DateTime.==].
  bool operator <=(DateTime other) => isBeforeOrEqualTo(other);

  /// Returns true if this occurs at or after [other], accounting for time
  /// zones.
  ///
  /// Alias for [isAfterOrEqualTo].
  ///
  /// Note that attempting to use this operator with [DateTime.==] will likely
  /// give undesirable results. This operator compares moments (i.e. with time
  /// zone taken into account), while [DateTime.==] compares field values (i.e.
  /// two [DateTime]s representing the same moment in different time zones will
  /// be treated as not equal). To check moment equality with time zone taken
  /// into account, use [DateTime.isAtSameMomentAs] rather than [DateTime.==].
  bool operator >=(DateTime other) => isAfterOrEqualTo(other);

  /// Returns a new [DateTime] instance with [duration] added to this.
  ///
  /// Alias for [DateTime.add].
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts a [Duration] from this [DateTime] and returns the resulting [DateTime].
  ///
  /// This operator allows for concise subtraction of durations from dates.
  DateTime operator -(Duration duration) => subtract(duration);
}

extension DateTimeOperations on DateTime {
  /// Returns the [DateTime] resulting from adding the given number
  /// of years to this [DateTime].
  ///
  /// The result is computed by incrementing the year part of this
  /// [DateTime] by [years] years, and, if required, adjusting the day part
  /// of the resulting date downwards to the last day of the month
  /// in resulting year.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 2 years -> (2022, 12, 31).
  /// (2020, 02, 29) -> add 1 year -> (2021, 02, 28).
  DateTime addYears(int years) => clone.setYear(year + years);

  /// Returns the [DateTime] resulting from adding the given number
  /// of months to this [DateTime].
  ///
  /// The result is computed by incrementing the month parts of this
  /// [DateTime] by [months] months, and, if required, adjusting the day part
  /// of the resulting date downwards to the last day of the resulting month.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 2 months -> (2021, 2, 28).
  /// (2020, 12, 31) -> add 1 month -> (2021, 1, 31).
  DateTime addMonths(int months) => clone.setMonth(month + months);

  /// Add a certain amount of quarters to this date.
  ///
  /// Each quarter is equivalent to 3 months.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 1 quarter -> (2021, 3, 31).
  /// (2020, 12, 31) -> add 2 quarters -> (2021, 6, 30).
  DateTime addQuarters(int quarters) => addMonths(quarters * 3);

  /// Returns the [DateTime] resulting from adding the given number
  /// of weeks to this [DateTime].
  ///
  /// The result is computed by incrementing the day parts of this
  /// [DateTime] by [weeks] weeks.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 1 week -> (2021, 1, 7).
  /// (2020, 12, 31) -> add 14 weeks -> (2021, 4, 8).
  DateTime addWeeks(int weeks) => addDays(DateTime.daysPerWeek * weeks);

  /// Returns the [DateTime] resulting from adding the given number
  /// of days to this [DateTime].
  ///
  /// The result is computed by incrementing the day parts of this
  /// [DateTime] by [days] days.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 2 days -> (2021, 1, 2).
  /// (2020, 12, 31) -> add 14 days -> (2021, 1, 14).
  DateTime addDays(int days) => copyWith(day: day + days);

  /// Adds a specified number of business days to this [DateTime].
  ///
  /// Business days are considered as Monday to Friday.
  ///
  /// For example:
  /// (2024-05-01) -> add 10 business days -> (2024-05-15).
  DateTime addWorkingDays(int days) {
    int totalDays = days;
    DateTime result = this;
    while (totalDays > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        totalDays--;
      }
    }
    return result;
  }

  /// Returns the [DateTime] resulting from adding the given number
  /// of hours to this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 12:00:00) -> add 2 hours -> (2020-12-31 14:00:00).
  /// (2020-12-31 23:00:00) -> add 5 hours -> (2021-01-01 04:00:00).
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Returns the [DateTime] resulting from adding the given number
  /// of minutes to this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 12:00:00) -> add 30 minutes -> (2020-12-31 12:30:00).
  /// (2020-12-31 23:45:00) -> add 15 minutes -> (2020-12-31 23:59:00).
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Returns the [DateTime] resulting from subtracting the given number
  /// of years from this [DateTime].
  ///
  /// The result is computed by decrementing the year part of this
  /// [DateTime] by [years] years, and, if required, adjusting the day part
  /// of the resulting date upwards to the last day of the month
  /// in the resulting year.
  ///
  /// For example:
  /// (2022, 12, 31) -> subtract 2 years -> (2020, 12, 31).
  /// (2021, 02, 28) -> subtract 1 year -> (2020, 02, 28).
  DateTime subtractYears(int years) => clone.setYear(year - years);

  /// Returns the [DateTime] resulting from subtracting the given number
  /// of months from this [DateTime].
  ///
  /// The result is computed by decrementing the month parts of this
  /// [DateTime] by [months] months, and, if required, adjusting the day part
  /// of the resulting date upwards to the last day of the resulting month.
  ///
  /// For example:
  /// (2021, 2, 28) -> subtract 2 months -> (2020, 12, 28).
  /// (2021, 1, 31) -> subtract 1 month -> (2020, 12, 31).
  DateTime subtractMonths(int months) => clone.setMonth(month - months);

  /// Subtracts a specified number of quarters from this [DateTime].
  ///
  /// Each quarter is equivalent to 3 months.
  ///
  /// For example:
  /// (2021-03-31) -> subtract 1 quarter -> (2020-12-31).
  /// (2021-06-30) -> subtract 2 quarters -> (2020-12-31).
  DateTime subtractQuarters(int quarters) => addMonths(-quarters * 3);

  /// Subtracts a specified number of days from this [DateTime].
  ///
  /// For example:
  /// (2021-01-02) -> subtract 2 days -> (2020-12-31).
  /// (2021-01-15) -> subtract 14 days -> (2020-12-31).
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Subtracts a specified number of business days from this [DateTime].
  ///
  /// Business days are considered as Monday to Friday.
  ///
  /// For example:
  /// (2024-05-31) -> subtract 10 business days -> (2024-05-15).
  DateTime subtractWorkingDays(int days) {
    int totalDays = days;
    DateTime result = this;

    while (totalDays > 0) {
      result = result.subtract(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        totalDays--;
      }
    }

    return result;
  }

  /// Subtracts a specified number of hours from this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 14:00:00) -> subtract 2 hours -> (2020-12-31 12:00:00).
  /// (2021-01-01 04:00:00) -> subtract 5 hours -> (2020-12-31 23:00:00).
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));

  /// Subtracts a specified number of minutes from this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 12:30:00) -> subtract 30 minutes -> (2020-12-31 12:00:00).
  /// (2020-12-31 23:59:00) -> subtract 15 minutes -> (2020-12-31 23:45:00).
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));
}
