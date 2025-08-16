import 'dart:math' as math;

import '../../index.dart';

extension NumOperators on num? {
  /// Safely divides two numbers with custom handling for division by zero and zero values.
  ///
  /// - Returns [whenBothZero] if both `this` and `b` are zero.
  /// - Returns [whenDivByZero] if dividing by zero unless [returnNaNOnDivByZero] is `true`.
  /// - Otherwise, returns `this / b`.
  double safeDivide(
    num b, {
    num whenBothZero = 0,
    num whenDivByZero = double.infinity,
    bool returnNaNOnDivByZero = false,
  }) => NumbersHelper.safeDivide(
    getOr(),
    b,
    whenDivByZero: whenDivByZero,
    whenBothZero: whenBothZero,
    returnNaNOnDivByZero: returnNaNOnDivByZero,
  );

  /// Rounds this double to the nearest multiple of [multiple].
  num roundToNearestMultiple(double multiple) =>
      (getOr() / multiple).round() * multiple;

  /// Rounds this double up to the nearest multiple of [multiple].
  num roundUpToMultiple(double multiple) =>
      (getOr() / multiple).ceil() * multiple;

  /// Rounds this double down to the nearest multiple of [multiple].
  num roundDownToMultiple(double multiple) =>
      (getOr() / multiple).floor() * multiple;

  /// Returns the prime factors of this integer.
  List<int> primeFactors() {
    var n = getOr().toInt();
    final factors = <int>[];
    for (var i = 2; i <= math.sqrt(n).toInt(); i++) {
      while (n % i == 0) {
        factors.add(i);
        n ~/= i;
      }
    }
    if (n > 1) factors.add(n);
    return factors;
  }

  /// Returns the factorial of this integer.
  int factorial() {
    final value = getOr().toInt();

    if (value < 0) throw ArgumentError('Negative numbers are not allowed.');
    var result = 1;
    for (var i = 2; i <= value; i++) {
      result *= i;
    }
    return result;
  }

  /// Returns the greatest common divisor of this integer and [other].
  int gcd(int other) => NumbersHelper.gcd(getOr().toInt(), other);

  /// Returns the least common multiple of this integer and [other].
  int lcm(int other) => (getOr().toInt() * other).abs() ~/ gcd(other);

  /// Normalizes this number to a range between [min] and [max].
  num scaleBetween(num min, num max) {
    if (min == max) throw ArgumentError('Min and max cannot be the same.');
    return (getOr() - min) / (max - min);
  }
}

/// A utility class for numerical helper methods.
class NumbersHelper {
  NumbersHelper._();

  /// Safely divides two numbers with custom handling for division by zero and zero values.
  ///
  /// - Returns [whenBothZero] if both `a` and `b` are zero.
  /// - Returns [whenDivByZero] if dividing by zero unless [returnNaNOnDivByZero] is `true`.
  /// - Otherwise, returns `a / b`.
  ///
  /// [a] is the numerator, [b] is the denominator.
  /// [whenBothZero] specifies the return value when both are zero (default: 0).
  /// [whenDivByZero] specifies the return value when dividing by zero (default: infinity).
  /// [returnNaNOnDivByZero] sets whether to return NaN on division by zero (default: false).
  ///
  /// Example:
  /// ```dart
  /// print(NumHelpers.safeDivide(0, 0)); // Output: 0
  /// print(NumHelpers.safeDivide(10, 0)); // Output: Infinity
  /// print(NumHelpers.safeDivide(10, 0, whenDivByZero: -1)); // Output: -1
  /// print(NumHelpers.safeDivide(10, 0, returnNaNOnDivByZero: true)); // Output: NaN
  /// print(NumHelpers.safeDivide(10, 2)); // Output: 5
  /// ```
  static double safeDivide(
    num a,
    num b, {
    num whenBothZero = 0,
    num whenDivByZero = double.infinity,
    bool returnNaNOnDivByZero = false,
  }) {
    if (a == 0 && b == 0) return whenBothZero.toDouble();
    if (b == 0) {
      return (returnNaNOnDivByZero ? double.nan : whenDivByZero).toDouble();
    }
    return a / b;
  }

  /// Calculates the greatest common divisor (GCD) of two integers [a] and [b].
  static int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);

  /// Checks if a number [n] is a perfect square.
  static bool isPerfectSquare(int n) {
    final sqrtN = math.sqrt(n).toInt();
    return sqrtN * sqrtN == n;
  }

  /// A map of integers to Roman numeral representations.
  ///
  /// This map is used to convert integers into their corresponding Roman numeral forms.
  static final _romanNumerals = <int, String>{
    1: 'I', // One
    2: 'II', // Two
    3: 'III', // Three
    4: 'IV', // Four
    5: 'V', // Five
    6: 'VI', // Six
    7: 'VII', // Seven
    8: 'VIII', // Eight
    9: 'IX', // Nine
    10: 'X', // Ten
    11: 'XI', // Eleven
    12: 'XII', // Twelve
    13: 'XIII', // Thirteen
    14: 'XIV', // Fourteen
    15: 'XV', // Fifteen
    20: 'XX', // Twenty
    30: 'XXX', // Thirty
    40: 'XL', // Forty
    50: 'L', // Fifty
    60: 'LX', // Sixty
    70: 'LXX', // Seventy
    90: 'XC', // Ninety
    99: 'IC', // Ninety-Nine (rarely used; common alternative is XCIX)
    100: 'C', // One Hundred
    200: 'CC', // Two Hundred
    400: 'CD', // Four Hundred
    500: 'D', // Five Hundred
    600: 'DC', // Six Hundred
    900: 'CM', // Nine Hundred
    990: 'XM', // Nine Hundred Ninety (non-standard; commonly use CMXC)
    1000: 'M', // One Thousand
  };

  /// Converts a Roman numeral string [romanNumeral] to an integer.
  static int fromRomanNumeral(String romanNumeral) {
    final romanMap = _romanNumerals.flip();
    var i = 0;
    var result = 0;
    while (i < romanNumeral.length) {
      if (i + 1 < romanNumeral.length &&
          romanMap.containsKey(romanNumeral.substring(i, i + 2))) {
        result += romanMap[romanNumeral.substring(i, i + 2)]!;
        i += 2;
      } else {
        result += romanMap[romanNumeral[i]]!;
        i += 1;
      }
    }
    return result;
  }
}
