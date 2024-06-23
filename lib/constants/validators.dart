part of 'constants.dart';

/// A utility class for validating common input fields such as email and password.
///
/// The `Validators` class provides static methods and pre-defined validators for
/// validating email addresses, passwords, and other input fields based on length
/// and pattern constraints.
class Validators {
  Validators._(); // Private constructor to prevent instantiation

  /// Validates email addresses.
  ///
  /// This validator checks that the input:
  /// - Has a minimum length of 4 characters.
  /// - Has a maximum length of 100 characters.
  /// - Is a valid email address format.
  ///
  /// Example usage:
  /// ```dart
  /// String email = "example@example.com";
  /// var result = Validators.email(email);
  /// if (result != null) {
  ///   print(result); // Prints error message if invalid
  /// }
  /// ```
  static final email = MultiValidator(
    [
      minMax(title: 'Email / User Name', min: 4, max: 100),
      EmailValidator(errorText: "Enter a valid email address."),
    ],
  );

  /// Validates passwords.
  ///
  /// This validator checks that the input:
  /// - Has a minimum length of 8 characters.
  /// - Has a maximum length of 25 characters.
  /// - Contains at least one special character.
  ///
  /// Example usage:
  /// ```dart
  /// String password = "password123!";
  /// var result = Validators.password(password);
  /// if (result != null) {
  ///   print(result); // Prints error message if invalid
  /// }
  /// ```
  static final password = MultiValidator(
    [
      minMax(title: 'Password', min: 8, max: 25),
      PatternValidator(
        r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must have at least one special character.',
      )
    ],
  );

  /// Validates that the input length is within the specified range.
  ///
  /// - [title]: The name of the input field being validated.
  /// - [min]: The minimum length allowed (default is 0).
  /// - [max]: The maximum length allowed (default is 100).
  ///
  /// Example usage:
  /// ```dart
  /// var validator = Validators.range(title: "Username", min: 3, max: 15);
  /// String username = "user123";
  /// var result = validator(username);
  /// if (result != null) {
  ///   print(result); // Prints error message if invalid
  /// }
  /// ```
  static MultiValidator range({
    required String title,
    int min = 0,
    int max = 100,
  }) {
    return MultiValidator([
      RangeValidator(
        min: min,
        max: max,
        errorText: '$title must be between $min to $max.',
      )
    ]);
  }

  /// Validates that the input length is within the specified minimum and maximum.
  ///
  /// - [title]: The name of the input field being validated.
  /// - [min]: The minimum length allowed (default is 0).
  /// - [max]: The maximum length allowed (default is 100).
  ///
  /// Example usage:
  /// ```dart
  /// var validator = Validators.minMax(title: "Name", min: 2, max: 50);
  /// String name = "John";
  /// var result = validator(name);
  /// if (result != null) {
  ///   print(result); // Prints error message if invalid
  /// }
  /// ```
  static MultiValidator minMax({
    required String title,
    int min = 0,
    int max = 100,
  }) {
    return MultiValidator([
      Validators.min(title: title, min: min),
      Validators.max(title: title, max: max),
    ]);
  }

  /// Validates that the input length does not exceed the specified maximum.
  ///
  /// - [title]: The name of the input field being validated.
  /// - [max]: The maximum length allowed (default is 100).
  ///
  /// Example usage:
  /// ```dart
  /// var validator = Validators.max(title: "Description", max: 200);
  /// String description = "This is a description.";
  /// var result = validator(description);
  /// if (result != null) {
  ///   print(result); // Prints error message if invalid
  /// }
  /// ```
  static MultiValidator max({required String title, int max = 100}) {
    return MultiValidator([
      MaxLengthValidator(
        max,
        errorText: '$title should not be greater than $max characters.',
      )
    ]);
  }

  /// Validates that the input length is at least the specified minimum.
  ///
  /// - [title]: The name of the input field being validated.
  /// - [min]: The minimum length required.
  ///
  /// Example usage:
  /// ```dart
  /// var validator = Validators.min(title: "Comment", min: 10);
  /// String comment = "Nice post!";
  /// var result = validator(comment);
  /// if (result != null) {
  ///   print(result); // Prints error message if invalid
  /// }
  /// ```
  static MultiValidator min({required String title, required int min}) {
    return MultiValidator([
      MinLengthValidator(
        min,
        errorText: '$title must be at least $min characters long.',
      )
    ]);
  }
}

/// A validator class for ensuring two values are not the same.
class UnMatchValidator {
  final String errorText;

  UnMatchValidator({required this.errorText});

  /// Validates that two string values are not the same.
  ///
  /// Returns an error message if the values match, otherwise null.
  ///
  /// Example usage:
  /// ```dart
  /// String? result = UnMatchValidator(errorText: "Values must not match")
  ///     .validateMatch("123", "123");
  /// print(result); // Prints: Values must not match
  /// ```
  String? validateMatch(String? value, String? value2) {
    if ((value?.isEmpty ?? false) || (value2?.isEmpty ?? false)) return null;

    return value != value2 ? null : errorText;
  }
}

/// A validator class for validating dates and date ranges.
class DateValidatorX {
  final String errorText;

  DateValidatorX({required this.errorText});

  /// Validates that the start date is after the end date.
  ///
  /// Optionally checks if the end date is not in the past.
  ///
  /// Returns an error message if validation fails, otherwise null.
  ///
  /// Example usage:
  /// ```dart
  /// String? result = DateValidatorX(errorText: "Invalid date range")
  ///     .validateAfterMatch(DateTime.now(), DateTime.now().subtract(Duration(days: 1)));
  /// print(result); // Prints: Invalid date range
  /// ```
  String? validateAfterMatch(
    DateTime? start,
    DateTime? end, {
    bool checkEndDate = true,
  }) {
    if (start == null || end == null) return null;

    if (start.isAfter(end)) return errorText;

    if (checkEndDate && end.isBefore(DateTime.now())) {
      return "Invalid date time because time is already passed";
    }

    return null;
  }

  /// Validates that the start date is before the end date.
  ///
  /// Returns an error message if the dates are the same or if the start date is after the end date, otherwise null.
  ///
  /// Example usage:
  /// ```dart
  /// String? result = DateValidatorX(errorText: "Start date must be before end date")
  ///     .validateBeforeMatch(DateTime.now().add(Duration(days: 1)), DateTime.now());
  /// print(result); // Prints: Start date must be before end date
  /// ```
  String? validateBeforeMatch(DateTime? start, DateTime? end) {
    if (start == null || end == null) return null;

    if (start.isAtSameMomentAs(end)) {
      return "Start date and End date can't be same";
    }

    if (start.isBefore(end)) return null;

    return errorText;
  }

  /// Validates that the end date is after the start date in a date range.
  ///
  /// Optionally checks if the day count between the start and end dates is the same as in another range.
  ///
  /// Returns an error message if validation fails, otherwise null.
  ///
  /// Example usage:
  /// ```dart
  /// String? result = DateValidatorX.validateRange(
  ///     DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1))),
  ///     DateTime.now().add(Duration(days: 2)).toString());
  /// print(result); // Prints: null (no error)
  /// ```
  static String? validateRange(
    DateTimeRange? firstRange,
    String? endDate, {
    bool checkDayCount = false,
    String pattern = "MMM dd, yyyy",
  }) {
    if (firstRange == null || endDate == null) return null;

    DateTime? end = endDate.toDateTime(format: pattern);

    if (end == null) return null;

    if (end.isBefore(firstRange.end)) {
      return 'The end date must be after the date range.';
    }

    if (checkDayCount) {
      int firstDayCount = firstRange.duration.inDays;
      int endDateCount = end.difference(firstRange.start).inDays;

      if (firstDayCount != endDateCount) {
        return 'The day counts in the ranges must be the same.';
      }
    }

    return null;
  }

  /// Validates that two date ranges do not overlap and have the same day count if specified.
  ///
  /// Returns an error message if validation fails, otherwise null.
  ///
  /// Example usage:
  /// ```dart
  /// String? result = DateValidatorX.validateRangeOverlap(
  ///     DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1))),
  ///     DateTimeRange(start: DateTime.now().add(Duration(days: 2)), end: DateTime.now().add(Duration(days: 3))),
  ///     checkDayCount: true);
  /// print(result); // Prints: null (no error)
  /// ```
  static String? validateRangeOverlap(
    DateTimeRange? firstRange,
    DateTimeRange? secondRange, {
    bool checkDayCount = false,
  }) {
    if (firstRange == null || secondRange == null) return null;

    if (checkDayCount) {
      int firstDayCount = firstRange.duration.inDays;
      int secondDayCount = secondRange.duration.inDays;

      if (firstDayCount != secondDayCount) {
        return 'The day counts in the ranges must be the same.';
      }
    }

    if (firstRange.start.isBefore(secondRange.end) &&
        secondRange.start.isBefore(firstRange.end)) {
      return 'The date ranges must not overlap.';
    }

    if (firstRange.end.isAfter(secondRange.start)) {
      return 'The first date range must end before the second date range starts.';
    }

    return null;
  }
}

/// A validator class for validating threshold values.
class ThresholdValidator {
  final String errorText;

  ThresholdValidator({required this.errorText});

  /// Validates that the minimum threshold value is not greater than the maximum threshold value.
  ///
  /// Returns an error message if validation fails, otherwise null.
  ///
  /// Example usage:
  /// ```dart
  /// String? result = ThresholdValidator(errorText: "Invalid threshold")
  ///     .minValidator(min: "5", max: "3");
  /// print(result); // Prints: Threshold Min cannot be greater then Threshold Max.
  /// ```
  String? minValidator({
    String? min,
    String? max,
  }) {
    if (min == null || max == null) return null;

    if (num.parse(min) > num.parse(max)) {
      return 'Threshold Min cannot be greater then Threshold Max.';
    }

    return null;
  }

  /// Validates that the maximum threshold value is not less than the minimum threshold value.
  ///
  /// Returns an error message if validation fails, otherwise null.
  ///
  /// Example usage:
  /// ```dart
  /// String? result = ThresholdValidator(errorText: "Invalid threshold")
  ///     .maxValidator(min: "3", max: "5");
  /// print(result); // Prints: null (no error)
  /// ```
  String? maxValidator({
    String? min,
    String? max,
  }) {
    if (min == null || max == null) return null;

    if (num.parse(min) > num.parse(max)) {
      return 'Threshold Max cannot be less then Threshold Min.';
    }

    return null;
  }
}
