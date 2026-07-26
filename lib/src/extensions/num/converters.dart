import 'dart:math';

import 'package:intl/intl.dart';

import '../date/converters.dart';
import '../date/operators.dart';
import './operators.dart';
import './validators.dart';

/// Conversion and formatting helpers for nullable numbers.
extension NumConverters on num? {
  /// Returns this value, or [value] when `null`.
  ///
  /// Example:
  /// ```dart
  /// final num? input = null;
  /// final resolved = input.getOr(10); // 10
  /// ```
  num getOr([num value = 0]) => this ?? value;

  /// Returns this value as [double], or `0` when `null`.
  double toDouble() => toDoubleOr(0);

  /// Returns this value as [double], or `null` when `null`.
  double? toDoubleOrNull() => this?.toDouble();

  /// Returns this value as [double], or [value] when `null`.
  double toDoubleOr(double value) => toDoubleOrNull() ?? value;

  /// Returns this value as [int], or `0` when `null`.
  int toInt() => toIntOr(0);

  /// Returns this value as [int], or `null` when `null`.
  int? toIntOrNull() => this?.toInt();

  /// Returns this value as [int], or [value] when `null`.
  int toIntOr(int value) => toIntOrNull() ?? value;

  /// Converts this number to [bool], or `false` when `null`.
  ///
  /// Uses [toBoolOrNull] semantics: only numeric value `1` maps to `true`.
  bool toBool() => toBoolOr(false);

  /// Converts this number to [bool] using `1 => true`, all other non-null values => `false`.
  ///
  /// Returns `null` when this value is `null`.
  bool? toBoolOrNull() => isNotNull ? this == 1 : null;

  /// Converts this number to [bool], or [value] when `null`.
  ///
  /// Uses [toBoolOrNull] semantics: only numeric value `1` maps to `true`.
  bool toBoolOr(bool value) => toBoolOrNull() ?? value;

  /// Converts degrees to radians.
  double? degreesToRadians() => isNotNull ? this! * (pi / 180.0) : null;

  /// Converts radians to degrees.
  double? radiansToDegrees() => isNotNull ? this! * (180.0 / pi) : null;

  /// Converts this number to a simplified mixed-fraction string.
  ///
  /// Fraction precision is based on a fixed denominator of `1,000,000`.
  ///
  /// Example:
  /// ```dart
  /// print(2.5.asFraction()); // 2 1/2
  /// print(0.75.asFraction()); // 3/4
  /// ```
  String asFraction() {
    final intPart = getOr().truncate();
    final fraction = getOr() - intPart;
    if (fraction == 0) return intPart.toString();
    final gcd = NumbersHelper.gcd((fraction * 1000000).round(), 1000000);
    return '${intPart != 0 ? '$intPart ' : ''}${(fraction * 1000000 / gcd).round()}/${1000000 ~/ gcd}';
  }

  /// Converts this integer to a binary string.
  String toBinaryString() => toInt().toRadixString(2);

  /// Converts this integer to a hexadecimal string.
  String toHexString() => toInt().toRadixString(16).toUpperCase();

  /// Returns the count of `'1'` digits in [toBinaryString] output.
  int bitCount() => toInt().toBinaryString().replaceAll('0', '').length;

  /// Converts `50` to `0.5`.
  double asPercentage() => getOr() / 100.0;

  /// Returns `[percentage]%` of this number.
  ///
  /// Example:
  /// ```dart
  /// final tax = 200.percentageOf(15); // 30
  /// ```
  double percentageOf(double percentage) => (getOr() * percentage) / 100.0;

  /// Returns this value as a percentage of [total].
  ///
  /// Example:
  /// ```dart
  /// final a = 25.percentage(200); // 12.5
  /// final b = 25.percentage(200, allowDecimals: false); // 12
  /// ```
  num percentage(num total, {bool allowDecimals = true, int dp = 2}) {
    if (isNull) return 0;
    if (total == 0) {
      throw ArgumentError.value(total, 'total', 'cannot be zero');
    }

    final result = (this! / total) * 100;
    if (allowDecimals) {
      return double.parse(result.toStringAsFixed(dp));
    }

    return result.toInt();
  }

  /// Converts a byte value to the requested [unit].
  ///
  /// Returns `0` for `null` or non-positive values.
  ///
  /// Example:
  /// ```dart
  /// final mb = 1048576.fileSize(unit: SizeUnit.MB); // 1.0
  /// ```
  double fileSize({SizeUnit unit = SizeUnit.MB}) {
    if (isNull || getOr() <= 0) return 0;
    return this! / pow(1024, unit.id);
  }

  /// Converts a byte value to a human-readable size string.
  ///
  /// Returns `'0 bytes'` for `null` or non-positive values.
  ///
  /// Example:
  /// ```dart
  /// final label = 1048576.fileSizeWithSuffix(dp: 2); // 1.00 MB
  /// ```
  String fileSizeWithSuffix({int dp = 0}) {
    if (isNull || getOr() <= 0) return '0 bytes';

    const suffixes = ['bytes', 'KB', 'MB', 'GB', 'TB'];
    final i = min((log(this!) / log(1024)).floor(), suffixes.length - 1);
    return '${(this! / pow(1024, i)).toStringAsFixed(dp)} ${suffixes[i]}';
  }

  /// Formats this value using compact notation (for example `1.2M`).
  String get compact => NumberFormat.compact().format(this);

  /// Formats this value with locale-aware grouping separators.
  String get formatComma => NumberFormat().format(this);

  /// Formats this number with [digit] significant digits.
  ///
  /// Trailing decimal zeros are removed for non-exponent output.
  ///
  /// Example:
  /// ```dart
  /// print(3.14159.toSignificantDigits(digit: 3)); // 3.14
  /// print(1.toSignificantDigits(digit: 2)); // 1
  /// ```
  String toSignificantDigits({int digit = 2}) {
    if (digit < 1) {
      throw ArgumentError.value(digit, 'digit', 'must be greater than zero');
    }
    if (isNull) return '0';

    final value = this!.toDouble();
    if (value == 0) return '0';

    final result = value.toStringAsPrecision(digit);
    if (result.contains('e') || result.contains('E')) return result;
    return result.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  /// Returns this number as an English ordinal string.
  ///
  /// Example: `1st`, `2nd`, `3rd`, `4th`.
  String get ordinal {
    if (isNull) return '0';

    if ([11, 12, 13].contains(this! % 100)) return '${this}th';

    switch (this! % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Returns the Roman numeral representation for integers in `1..3999`.
  ///
  /// ```dart
  /// print(12.roman);   // XII
  /// print(455.roman);  // CDLV
  /// print(1.roman);    // I
  /// print(3999.roman); // MMMCMXCIX
  /// ```
  String get roman {
    if (isNull) return '';

    final int value = toIntOr(0);

    if (value < 1 || value > 3999) {
      throw ArgumentError('Number out of range (1 to 3999)');
    }

    final romanMap = {
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };

    var num = value;
    final buffer = StringBuffer();

    for (final entry in romanMap.entries) {
      while (num >= entry.key) {
        buffer.write(entry.value);
        num -= entry.key;
      }
    }

    return buffer.toString();
  }

  /// Rounds this number to [digit] decimal places.
  double roundWithDigit(int digit) {
    final digitValue = pow(10, digit);
    return (getOr() * digitValue).roundToDouble() / digitValue;
  }

  /// Rounds this number to [nthPosition] fractional digits.
  ///
  /// Example:
  /// ```dart
  /// 2.123456789.roundToPrecision(0); // 2.0
  /// 2.123456789.roundToPrecision(1); // 2.1
  /// 2.123456789.roundToPrecision(2); // 2.12
  /// 2.123456789.roundToPrecision(3); // 2.123
  /// ```
  double roundToPrecision(int nthPosition) {
    if (nthPosition < 0) {
      throw ArgumentError.value(
        nthPosition,
        'nthPosition',
        'cannot be negative',
      );
    }

    if (isNull) return 0;

    if (this!.isNaN || this!.isInfinite || this == double.negativeInfinity) {
      return toDouble();
    }

    final factor = pow(10, nthPosition).toDouble();
    return (this! * factor).roundToDouble() / factor;
  }

  /// Floors this number to [digit] decimal places.
  double floorWithDigit(int digit) {
    final digitValue = pow(10, digit);
    return (getOr() * digitValue).floorToDouble() / digitValue;
  }

  /// Returns this integer as a 2-character string with leading zero if needed.
  String twoDigits() {
    final value = toInt();
    return value.abs() < 10 ? '0$value' : value.toString();
  }

  /// Returns the last [n] digits from this integer value.
  ///
  /// Example:
  /// ```dart
  /// 123456.lastDigits(3); // 456
  /// ```
  int lastDigits(int n) {
    if (n <= 0) {
      throw ArgumentError.value(n, 'n', 'must be greater than zero');
    }
    if (isNull) return 0;

    final value = toInt().abs();
    return value % pow(10, n).toInt();
  }

  /// Returns a fixed-decimal string using [precision] digits after the decimal.
  ///
  /// A trailing `.00` is removed.
  String toPrecision([int precision = 2]) {
    var result = getOr().toStringAsFixed(precision);
    if (result.endsWith('.00')) {
      result = result.substring(0, result.length - 3);
    }
    return result;
  }

  /// Returns how many times [substring] appears in this number's string form.
  int count(num substring) {
    var count = 0;
    var index = 0;
    while (true) {
      index = toString().indexOf(substring.toString(), index);
      if (index == -1) break;
      count++;
      index++;
    }
    return count;
  }

  /// Returns indexes of all occurrences of [substring] in this number's string form.
  List<int> indexesOf(num substring) {
    final indexes = <int>[];
    var index = 0;
    while (true) {
      index = toString().indexOf(substring.toString(), index);
      if (index == -1) break;
      indexes.add(index);
      index++;
    }
    return indexes;
  }

  /// Get the index of the first occurrence of [substring] in the number.
  int indexOfFirst(num substring) => toString().indexOf(substring.toString());

  /// Get the index of the last occurrence of [substring] in the number.
  /// Returns the index of the last occurrence of [substring] in the number.
  int indexOfLast(num substring) =>
      toString().lastIndexOf(substring.toString());

  /// Transforms `this` into a `String` and pads it on the left if it is shorter
  /// than the given [width].
  String padLeft(int width, [String padding = '0']) =>
      toString().padLeft(width, padding);

  /// Transforms `this` into a `String` and pads it on the right if it is shorter
  /// than the given [width].
  String padRight(int width, [String padding = '0']) =>
      toString().padRight(width, padding);

  /// Returns all numeric digits from this number as a list.
  ///
  /// Non-digit characters (including sign and decimal separator) are ignored.
  List<int> get digits {
    if (isNull) return const <int>[];

    final raw = toString().replaceAll(RegExp('[^0-9]'), '');
    if (raw.isEmpty) return const <int>[];
    return raw.split('').map(int.parse).toList();
  }

  /// Returns [digits].length.
  int get numberOfDigits => digits.length;

  /// Clamps this value to the inclusive range `[min, max]`.
  ///
  /// Returns:
  /// - this value when inside range
  /// - [min] when below range
  /// - [max] when above range
  ///
  /// ```dart
  /// print(10.coerceIn(1, 100)); // 10
  /// print(0.coerceIn(1, 100)); // 1
  /// print(500.coerceIn(1, 100)); // 100
  /// 10.coerceIn(100, 0) // will fail with ArgumentError
  /// ```
  num coerceIn(num min, num max) {
    if (min > max) throw ArgumentError('min must be smaller the max');

    final value = getOr();
    if (value < min) return min;
    if (value > max) return max;

    return value;
  }

  /// Returns this value if it is at least [min], otherwise [min].
  ///
  /// ```dart
  /// print(10.coerceAtLeast(5)) // 10
  /// print(10.coerceAtLeast(20)) // 20
  /// ```
  num coerceAtLeast(num min) {
    final value = getOr();

    return value < min ? min : value;
  }

  /// Returns this value if it is at most [max], otherwise [max].
  ///
  /// ```dart
  /// print(10.coerceAtMost(5)) // 5
  /// print(10.coerceAtMost(20)) // 10
  /// ```
  num coerceAtMost(num max) {
    final value = getOr();

    return value > max ? max : value;
  }
}

/// Time and duration helpers for nullable numeric values.
///
/// Values are interpreted in seconds for [timeAgo] and [toClockFormat].
extension NumTimeConverters on num? {
  /// Returns a relative-duration label from a seconds value.
  ///
  /// Example:
  /// ```dart
  /// 90.timeAgo(); // 1 minute ago
  /// 90.timeAgo(addAgo: false); // 1 minute
  /// ```
  String timeAgo({bool addAgo = true}) {
    if (isNull) return '';

    final String ago = addAgo ? 'ago' : '';

    final diff = Duration(seconds: toInt());
    final sec = diff.inSeconds;

    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"}${' $ago'}";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"}${' $ago'}";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"}${' $ago'}";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"}${' $ago'}";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}${' $ago'}";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}${' $ago'}";
    } else {
      return "$sec ${sec == 1 ? "second" : "seconds"}${' $ago'}";
    }
  }

  /// Converts month number (`1..12`) to a month name.
  ///
  /// - [Abbreviation.none] => full month (`January`)
  /// - [Abbreviation.semi]/[Abbreviation.full] => short month (`Jan`)
  String toMonth({Abbreviation style = Abbreviation.none}) {
    if (isNull) return '';
    final month = toInt();
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be between 1 and 12');
    }

    return style == Abbreviation.full || style == Abbreviation.semi
        ? MyDateFormats.shortMonths[month - 1]
        : MyDateFormats.months[month - 1];
  }

  /// Converts weekday number (`1..7`, Monday..Sunday) to a day name.
  ///
  /// - [Abbreviation.none] => full day (`Monday`)
  /// - [Abbreviation.semi] => short day (`Mon`)
  /// - [Abbreviation.full] => very short day (`M`)
  ///
  /// Example:
  /// ```dart
  /// print(1.toDay()); // Output: Monday
  /// print(1.toDay(style: Abbreviation.semi)); // Output: Mon
  /// print(1.toDay(style: Abbreviation.full)); // Output: M
  /// ```
  String toDay({Abbreviation style = Abbreviation.none}) {
    if (isNull) return '';
    final day = toInt();
    if (day < 1 || day > 7) {
      throw ArgumentError.value(day, 'day', 'must be between 1 and 7');
    }

    if (style == Abbreviation.full) {
      return MyDateFormats.veryShortDays[day - 1];
    } else {
      return style == Abbreviation.semi
          ? MyDateFormats.shortDays[day - 1]
          : MyDateFormats.days[day - 1];
    }
  }

  /// Formats a seconds value as `HH:mm` or `HH:mm:ss`.
  ///
  /// Example:
  /// ```dart
  /// 3661.toClockFormat(); // 01:01
  /// 3661.toClockFormat(showSeconds: true); // 01:01:01
  /// ```
  String toClockFormat({bool showSeconds = false}) {
    if (isNull) return '00:00';
    if (this! < 0) {
      throw ArgumentError.value(this, 'seconds', 'cannot be negative');
    }

    int h, m, s;

    h = this! ~/ 3600;

    m = (this! - h * 3600) ~/ 60;

    s = this!.toInt() - (h * 3600) - (m * 60);

    final String hourLeft = h.toString().length < 2 ? '0$h' : h.toString();

    final String minuteLeft = m.toString().length < 2 ? '0$m' : m.toString();

    final String secondsLeft = s.toString().length < 2 ? '0$s' : s.toString();

    String result;
    if (showSeconds) {
      result = '$hourLeft:$minuteLeft:$secondsLeft';
    } else {
      result = '$hourLeft:$minuteLeft';
    }

    return result;
  }

  /// Returns a [Duration] in microseconds.
  Duration get microseconds => Duration(microseconds: toInt());

  /// Returns a [Duration] in milliseconds.
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Returns a [Duration] in seconds.
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: toInt());

  /// Returns a [Duration] in minutes.
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: toInt());

  /// Returns `DateTime.now() - this.minutes`.
  DateTime get minutesAgo => DateTime.now() - Duration(minutes: toInt());

  /// Returns `DateTime.now() + this.minutes`.
  DateTime get minutesAfter => DateTime.now() + Duration(minutes: toInt());

  /// Returns a [Duration] in hours.
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: toInt());

  /// Returns `DateTime.now() - this.hours`.
  DateTime get hoursAgo => DateTime.now() - Duration(hours: toInt());

  /// Returns `DateTime.now() + this.hours`.
  DateTime get hoursAfter => DateTime.now() + Duration(hours: toInt());

  /// Returns a [Duration] in days.
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: toInt());

  /// Returns `DateTime.now() - this.days`.
  DateTime get daysAgo => DateTime.now() - Duration(days: toInt());

  /// Returns `DateTime.now() + this.days`.
  DateTime get daysAfter => DateTime.now() + Duration(days: toInt());

  /// Returns a [Duration] in weeks.
  /// ```dart
  /// 5.weeks
  /// ```
  Duration get weeks => Duration(days: toInt() * 7);

  /// Returns `DateTime.now() - this.weeks`.
  DateTime get weeksAgo => DateTime.now() - Duration(days: toInt() * 7);

  /// Returns `DateTime.now() + this.weeks`.
  DateTime get weeksAfter => DateTime.now() + Duration(days: toInt() * 7);

  /// Returns an approximate month [Duration] (`30` days each).
  /// ```dart
  /// 5.month
  /// ```
  Duration get month => Duration(days: toInt() * 30);

  /// Returns an approximate year [Duration] (`365` days each).
  /// ```dart
  /// 5.years
  /// ```
  Duration get years => Duration(days: toInt() * 365);
}

/// Converts numeric values to English words.
extension HumanReadableWords on num? {
  static final List<String> _units = [
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
  ];

  static final List<String> _teens = [
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen',
  ];

  static final List<String> _tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety',
  ];

  static final List<String> _thousands = [
    '',
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
    'quintillion',
  ];

  /// Converts this value to English words.
  ///
  /// Example:
  /// ```dart
  /// print(13578921.toWords());
  /// // thirteen million five hundred seventy-eight thousand nine hundred twenty-one
  /// print(1234.56.toWords());
  /// // one thousand two hundred thirty-four point five six
  /// ```
  ///
  /// Set [useAnd] to include "and" style joining (common in British English).
  String toWords({bool useAnd = false}) {
    if (getOr() == 0) return _units[0];

    if (this! < 0) return 'minus ${(-this!).toWords(useAnd: useAnd)}';

    String words = '';
    int integerPart = this!.truncate();
    int thousandCounter = 0;

    while (integerPart > 0) {
      if (integerPart % 1000 != 0) {
        words =
            _convertLessThanThousand(
              integerPart % 1000,
              thousandCounter > 0,
              useAnd,
            ) +
            (thousandCounter > 0 ? ' ${_thousands[thousandCounter]} ' : '') +
            words;
      }
      integerPart ~/= 1000;
      thousandCounter++;
    }

    String fractionalWords = '';
    if (this is double) {
      final String fractionalPart = toString().split('.').last;
      if (int.parse(fractionalPart) > 0) {
        fractionalWords =
            ' point ${fractionalPart.split('').map((digit) => _units[int.parse(digit)]).join(' ')}';
      }
    }

    return (words.trim() + fractionalWords).trim();
  }

  String _convertLessThanThousand(
    int number,
    bool isThousandGroup,
    bool useAnd,
  ) {
    String words = '';

    if (number >= 100) {
      words += '${_units[number ~/ 100]} hundred';
      number %= 100;
      if (useAnd && number > 0) {
        words += ' and ';
      } else {
        words += ' ';
      }
    }

    if (number >= 20) {
      words += _tens[number ~/ 10];
      if (number % 10 > 0) {
        words += '-${_units[number % 10]}';
      }
    } else if (number >= 10) {
      words += _teens[number - 10];
    } else if (number > 0) {
      words += _units[number];
    } else if (useAnd && isThousandGroup && words.isNotEmpty) {
      words += ' and';
    } else {
      words += ' ';
    }

    return words;
  }
}

/// File-size unit for [NumConverters.fileSize].
enum SizeUnit {
  BYTES(0),
  KB(1),
  MB(2),
  GB(3),
  TB(4);

  const SizeUnit(this.id);

  /// Base-1024 exponent used for conversion.
  final int id;
}
