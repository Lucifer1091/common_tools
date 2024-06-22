// ignore_for_file: constant_identifier_names, non_constant_identifier_names
part of 'extensions.dart';

extension NumExtension on num {
  String get compact => NumberFormat.compact().format(this);

  String get formatComma => NumberFormat().format(this);

  String toSignificantDigits({int digit = 2}) {
    NumberFormat formatter = NumberFormat('0' * digit);
    return formatter.format(this);
  }

  String get ordinal {
    var specialValue = [11, 12, 13].contains(this % 100);
    if (specialValue) {
      return "${this}th";
    } else if (toString().length == 1) {
      switch (this) {
        case 0:
          return "0";
        case 1:
          return "${this}st";
        case 2:
          return "${this}nd";
        case 3:
          return "${this}rd";
        default:
          return "${this}th";
      }
    } else {
      switch (this % 10) {
        case 1:
          return "${this}st";
        case 2:
          return "${this}nd";
        case 3:
          return "${this}rd";
        default:
          return "${this}th";
      }
    }
  }

  String toClockFormat({bool showSeconds = false}) {
    int h, m, s;

    h = this ~/ 3600;

    m = ((this - h * 3600)) ~/ 60;

    s = toInt() - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

    String result;
    if (showSeconds) {
      result = "$hourLeft:$minuteLeft:$secondsLeft";
    } else {
      result = "$hourLeft:$minuteLeft";
    }

    return result;
  }

  String getTimeFormatFromDouble() {
    if (this < 0) return '00:00';
    int flooredValue = floor();
    num decimalValue = this - flooredValue;
    String hourValue = flooredValue.toString();
    String minuteString = _getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getTimeStringFromDouble() {
    if (this < 0) return '00:00';
    int flooredValue = floor();
    num decimalValue = this - flooredValue;
    String hourValue = _getHourString(flooredValue);
    String minuteString = _getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String _getMinuteString(num decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String _getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  /// Converts a file size (in bytes) to a human-readable string with appropriate suffix (Bytes, KB, MB, GB, TB).
  ///
  /// The function takes an optional parameter [dp] which specifies the number of decimal places to include in the output.
  ///
  /// If the file size is less than or equal to zero, the function returns "0 Bytes".
  ///
  /// - Parameter [dp]: An integer specifying the number of decimal places to include in the output (default is 0).
  ///
  /// Returns:
  /// - A string representing the file size in a human-readable format with an appropriate suffix.
  ///
  /// Example:
  /// ```dart
  /// int fileSize = 1048576;
  /// String readableSize = fileSize.fileSizeWithSuffix(dp: 2); // "1.00 MB"
  /// ```
  String fileSizeWithSuffix({int dp = 0}) {
    if (this <= 0) return "0 bytes";
    const suffixes = ["bytes", "KB", "MB", "GB", "TB"];
    var i = (math.log(this) / math.log(1024)).floor();
    return '${(this / math.pow(1024, i)).toStringAsFixed(dp)} ${suffixes[i]}';
  }

  /// Converts a file size (in bytes) to a specified unit (Bytes, KB, MB, GB, TB).
  ///
  /// The function takes an optional parameter [unit] which specifies the unit to convert the file size to.
  /// The default unit is megabytes (MB).
  ///
  /// If the file size is less than or equal to zero, the function returns 0.
  ///
  /// - Parameter [unit]: An enum value of [SizeUnit] specifying the unit to convert the file size to (default is [SizeUnit.MB]).
  ///
  /// Returns:
  /// - A double representing the file size in the specified unit.
  ///
  /// Example:
  /// ```dart
  /// int fileSizeInBytes = 1048576;
  /// double fileSizeInMB = fileSizeInBytes.fileSize(unit: SizeUnit.MB); // 1.048576
  /// ```
  double fileSize({SizeUnit unit = SizeUnit.MB}) {
    if (this <= 0) return 0;
    return (this / math.pow(1000, unit.id));
  }
}

enum SizeUnit {
  BYTES(0),
  KB(1),
  MB(2),
  GB(3),
  TB(4);

  final int id;
  const SizeUnit(this.id);
}

extension DoubleExtensions on double {
  double roundWithDigit(int digit) {
    final digitValue = math.pow(10, digit);
    return (this * digitValue).roundToDouble() / digitValue;
  }

  double floorWithDigit(int digit) {
    final digitValue = math.pow(10, digit);
    return (this * digitValue).floorToDouble() / digitValue;
  }
}

/// Extension on `num` to convert to human-readable words.
extension HumanReadableWords on num {
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
    'nine'
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
    'nineteen'
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
    'ninety'
  ];

  static final List<String> _thousands = [
    '',
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
    'quintillion'
  ];

  /// Converts the number to a human-readable form as words.
  ///
  /// Example:
  /// ```dart
  /// print(13578921.toWords()); // Output: 'thirteen million five hundred seventy-eight thousand nine hundred twenty-one'
  /// print(1234.56.toWords()); // Output: 'one thousand two hundred and thirty-four point five six'
  /// ```
  ///
  /// Returns the string representation of the number as words.
  ///
  /// set [useAnd] to true if you want proper conversion
  ///
  /// ```dart
  /// print(13578921.toWords(useAnd: true)); // Output: 'thirteen million five hundred and seventy-eight thousand nine hundred and twenty-one'
  /// ```
  ///
  String toWords({bool useAnd = false}) {
    if (this == 0) return _units[0];

    if (this < 0) return 'minus ${(-this).toWords(useAnd: useAnd)}';

    String words = '';
    int integerPart = truncate();
    int thousandCounter = 0;

    while (integerPart > 0) {
      if (integerPart % 1000 != 0) {
        words = _convertLessThanThousand(
                integerPart % 1000, thousandCounter > 0, useAnd) +
            (thousandCounter > 0 ? ' ${_thousands[thousandCounter]} ' : '') +
            words;
      }
      integerPart ~/= 1000;
      thousandCounter++;
    }

    String fractionalWords = '';
    if (this is double) {
      String fractionalPart = toString().split('.').last;
      if (int.parse(fractionalPart) > 0) {
        fractionalWords =
            ' point ${fractionalPart.split('').map((digit) => _units[int.parse(digit)]).join(' ')}';
      }
    }

    return (words.trim() + fractionalWords).trim();
  }

  String _convertLessThanThousand(
      int number, bool isThousandGroup, bool useAnd) {
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
