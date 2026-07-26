import './converters.dart';

/// Sign and digit-slicing helpers for nullable numbers.
extension NumSanitizers on num? {
  /// Swap the sign of the number.
  num swapSign() => -getOr();

  /// Returns half of this value.
  num get half => getOr() / 2;

  /// Returns one-third of this value.
  num get third => getOr() / 3;

  /// Returns one-quarter of this value.
  num get quarter => getOr() / 4;

  /// Returns one-fifth of this value.
  num get fifth => getOr() / 5;

  /// Returns one-tenth of this value.
  double get tenth => getOr() / 10;

  /// Returns absolute value.
  double get absolute => toDouble().abs();

  /// Returns this value multiplied by 2.
  num get doubled => getOr() * 2;

  /// Returns this value multiplied by 3.
  num get tripled => getOr() * 3;

  /// Returns this value multiplied by 4.
  num get quadrupled => getOr() * 4;

  /// Returns this value squared.
  num get squared => getOr() * getOr();

  /// Returns the sum of numeric digits in this value.
  ///
  /// Non-digit characters (including sign and decimal separator) are ignored.
  num sumOfDigits() {
    final raw = toString().replaceAll(RegExp('[^0-9]'), '');
    if (raw.isEmpty) return 0;

    return raw.split('').fold<int>(0, (sum, digit) => sum + int.parse(digit));
  }

  /// Returns the numeric substring between first [start] and next [end].
  ///
  /// Matching is performed on this value's string representation.
  /// Returns `0` when boundaries are not found.
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

  /// Returns numeric content before first [substring] match.
  ///
  /// Matching is performed on this value's string representation.
  /// Returns `0` when [substring] is not found.
  num digitsBeforeFirst(num substring) {
    final source = toString();
    final index = source.indexOf(substring.toString());
    if (index == -1) return 0;

    final result = source.substring(0, index);
    return _parseNumberOrZero(result);
  }

  /// Returns numeric content after first [substring] match.
  ///
  /// Matching is performed on this value's string representation.
  /// Returns `0` when [substring] is not found.
  num digitsAfterFirst(num substring) {
    final source = toString();
    final target = substring.toString();
    final index = source.indexOf(target);
    if (index == -1) return 0;

    final result = source.substring(index + target.length);
    return _parseNumberOrZero(result);
  }

  /// Returns numeric content before last [substring] match.
  ///
  /// Matching is performed on this value's string representation.
  /// Returns `0` when [substring] is not found.
  num digitsBeforeLast(num substring) {
    final source = toString();
    final index = source.lastIndexOf(substring.toString());
    if (index == -1) return 0;

    final result = source.substring(0, index);
    return _parseNumberOrZero(result);
  }

  /// Returns numeric content after last [substring] match.
  ///
  /// Matching is performed on this value's string representation.
  /// Returns `0` when [substring] is not found.
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
