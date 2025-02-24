import 'converters.dart';

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
    num sum = 0;
    var number = getOr();
    while (number > 0) {
      sum += number % 10;
      number = (number / 10).floor();
    }
    return sum;
  }

  /// Get the digits after a [substring] in the number
  /// Returns the digits after a [substring] in the number
  num digitsAfter(num substring) {
    final index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    final result = toString().substring(index + 1);
    return int.parse(result);
  }

  /// Get the digits before a [substring] in the number
  /// Returns the digits before a [substring] in the number
  num digitsBefore(num substring) {
    final index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    final result = toString().substring(0, index);
    return int.parse(result);
  }

  /// Get the digits between [start] and [end] in the number
  /// Returns the digits between [start] and [end] in the number
  num digitsBetween(num start, num end) {
    final startIndex = toString().indexOf(start.toString());
    if (startIndex == -1) return 0;
    final endIndex = toString().indexOf(end.toString(), startIndex + 1);
    if (endIndex == -1) return 0;
    final result = toString().substring(startIndex + 1, endIndex);
    return int.parse(result);
  }

  /// Get the digits before the first occurrence of [substring] in the number
  /// Returns the digits before the first occurrence of [substring] in the number
  num digitsBeforeFirst(num substring) {
    final index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    final result = toString().substring(0, index);
    return int.parse(result);
  }

  /// Get the digits after the first occurrence of [substring] in the number
  /// Returns the digits after the first occurrence of [substring] in the number
  num digitsAfterFirst(num substring) {
    final index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    final result = toString().substring(index + 1);
    return int.parse(result);
  }

  /// Get the digits before the last occurrence of [substring] in the number
  /// Returns the digits before the last occurrence of [substring] in the number
  num digitsBeforeLast(num substring) {
    final index = toString().lastIndexOf(substring.toString());
    if (index == -1) return 0;
    final result = toString().substring(0, index);
    return int.parse(result);
  }

  /// Get the digits after the last occurrence of [substring] in the number
  /// Returns the digits after the last occurrence of [substring] in the number
  num digitsAfterLast(num substring) {
    final index = toString().lastIndexOf(substring.toString());
    if (index == -1) return 0;
    final result = toString().substring(index + 1);
    return int.parse(result);
  }
}
