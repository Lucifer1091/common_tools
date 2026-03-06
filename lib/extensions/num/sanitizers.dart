import '../../index.dart';

extension NumSanitizers on num? {
  /// Swap the sign of the number.
  num swapSign() => -getOr();

  ///
  num get half => getOr() / 2;

  ///
  num get third => getOr() / 3;

  ///
  num get quarter => getOr() / 4;

  ///
  num get fifth => getOr() / 5;

  /// Returns tenth of the number
  double get tenth => getOr() / 10;

  /// Returns the absolute value
  double get absolute => toDouble().abs();

  /// Return this number time two
  num get doubled => getOr() * 2;

  /// Return this number time three
  num get tripled => getOr() * 3;

  /// Return this number time four
  num get quadrupled => getOr() * 4;

  /// Return squared number
  num get squared => getOr() * getOr();

  /// sum of digits
  /// Returns the sum of digits in the number.
  num sumOfDigits() {
    final raw = toString().replaceAll(RegExp('[^0-9]'), '');
    if (raw.isEmpty) return 0;

    return raw.split('').fold<int>(0, (sum, digit) => sum + int.parse(digit));
  }

  /// Get the digits between [start] and [end] in the number
  /// Returns the digits between [start] and [end] in the number
  num digitsBetween(num start, num end) {
    final source = toString();
    final startText = start.toString();
    final endText = end.toString();

    final startIndex = source.indexOf(startText);
    if (startIndex == -1) return 0;

    final fromIndex = startIndex + startText.length;
    final endIndex = source.indexOf(endText, fromIndex);
    if (endIndex == -1) return 0;

    final result = source.substring(fromIndex, endIndex);
    return _parseNumberOrZero(result);
  }

  /// Get the digits before the first occurrence of [substring] in the number
  /// Returns the digits before the first occurrence of [substring] in the number
  num digitsBeforeFirst(num substring) {
    final source = toString();
    final index = source.indexOf(substring.toString());
    if (index == -1) return 0;

    final result = source.substring(0, index);
    return _parseNumberOrZero(result);
  }

  /// Get the digits after the first occurrence of [substring] in the number
  /// Returns the digits after the first occurrence of [substring] in the number
  num digitsAfterFirst(num substring) {
    final source = toString();
    final target = substring.toString();
    final index = source.indexOf(target);
    if (index == -1) return 0;

    final result = source.substring(index + target.length);
    return _parseNumberOrZero(result);
  }

  /// Get the digits before the last occurrence of [substring] in the number
  /// Returns the digits before the last occurrence of [substring] in the number
  num digitsBeforeLast(num substring) {
    final source = toString();
    final index = source.lastIndexOf(substring.toString());
    if (index == -1) return 0;

    final result = source.substring(0, index);
    return _parseNumberOrZero(result);
  }

  /// Get the digits after the last occurrence of [substring] in the number
  /// Returns the digits after the last occurrence of [substring] in the number
  num digitsAfterLast(num substring) {
    final source = toString();
    final target = substring.toString();
    final index = source.lastIndexOf(target);
    if (index == -1) return 0;

    final result = source.substring(index + target.length);
    return _parseNumberOrZero(result);
  }

  num _parseNumberOrZero(String value) => num.tryParse(value) ?? 0;
}
