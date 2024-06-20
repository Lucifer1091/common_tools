part of 'constants.dart';

class Validators {
  Validators._();

  static final email = MultiValidator(
    [
      minMax(title: 'Email / User Name', min: 4, max: 100),
      EmailValidator(errorText: "Enter a valid email address."),
    ],
  );

  static final password = MultiValidator(
    [
      minMax(title: 'Password', min: 8, max: 25),
      PatternValidator(
        r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must have at least one special character.',
      )
    ],
  );

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

  static MultiValidator max({required String title, int max = 100}) {
    return MultiValidator([
      MaxLengthValidator(
        max,
        errorText: '$title should not be greater than $max characters.',
      )
    ]);
  }

  static MultiValidator min({required String title, required int min}) {
    return MultiValidator([
      MinLengthValidator(
        min,
        errorText: '$title must be at least $min characters long.',
      )
    ]);
  }
}

/// To check if 2 values are not same
class UnMatchValidator {
  final String errorText;

  UnMatchValidator({required this.errorText});

  String? validateMatch(String? value, String? value2) {
    if ((value?.isEmpty ?? false) || (value2?.isEmpty ?? false)) return null;

    return value != value2 ? null : errorText;
  }
}

class DateValidatorX {
  final String errorText;

  DateValidatorX({required this.errorText});

  String? afterMatch(
    DateTime? start,
    DateTime? end, {
    bool checkEndDate = true,
  }) {
    if ((start == null) || (end == null)) return null;

    return start.isAfter(end)
        ? errorText
        : checkEndDate
            ? end.isBefore(DateTime.now())
                ? "Invalid date time because time is already passed"
                : null
            : null;
  }

  String? beforeMatch(DateTime? start, DateTime? end) {
    if ((start == null) || (end == null)) return null;

    return start.isSameDateAndTime(end)
        ? "Start date and End date can't be same"
        : start.isBefore(end)
            ? null
            : errorText;
  }

  static String? rangeValidator(
    DateTimeRange? first,
    String? end, {
    bool checkDayCount = false,
    String pattern = "MMM dd, yyyy",
  }) {
    if (first == null || end == null) return null;

    if (end.toDateTime(format: pattern)?.isBefore(first.end) ?? false) {
      return 'Clone To date should be after clone from range.';
    }

    return null;
  }

  static String? rangeValidatorX(
    DateTimeRange? first,
    DateTimeRange? second, {
    bool checkDayCount = false,
  }) {
    if (first == null || second == null) return null;

    if (checkDayCount) {
      int firstDayCount = first.start.difference(first.end).inDays;
      int secondDayCount = second.start.difference(second.end).inDays;

      if (firstDayCount != secondDayCount) {
        return 'Clone From and Clone To days count must be same.';
      }
    }

    if (first.start.isBefore(second.end) && second.start.isBefore(first.end)) {
      return 'Clone From and Clone To range is overlapping.';
    }

    if (first.end.isAfter(second.start)) {
      return 'Clone From Range must be before Clone To Range.';
    }

    return null;
  }
}

class ThresholdValidator {
  final String errorText;

  ThresholdValidator({required this.errorText});

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
