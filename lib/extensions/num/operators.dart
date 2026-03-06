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
  num roundToNearestMultiple(double multiple) {
    if (multiple == 0) {
      throw ArgumentError.value(multiple, 'multiple', 'cannot be zero');
    }

    return (getOr() / multiple).round() * multiple;
  }

  /// Rounds this double up to the nearest multiple of [multiple].
  num roundUpToMultiple(double multiple) {
    if (multiple == 0) {
      throw ArgumentError.value(multiple, 'multiple', 'cannot be zero');
    }

    return (getOr() / multiple).ceil() * multiple;
  }

  /// Rounds this double down to the nearest multiple of [multiple].
  num roundDownToMultiple(double multiple) {
    if (multiple == 0) {
      throw ArgumentError.value(multiple, 'multiple', 'cannot be zero');
    }

    return (getOr() / multiple).floor() * multiple;
  }

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
  int lcm(int other) {
    final a = getOr().toInt();
    if (a == 0 || other == 0) return 0;

    return (a * other).abs() ~/ NumbersHelper.gcd(a, other);
  }

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
  /// print(NumbersHelper.safeDivide(0, 0)); // Output: 0
  /// print(NumbersHelper.safeDivide(10, 0)); // Output: Infinity
  /// print(NumbersHelper.safeDivide(10, 0, whenDivByZero: -1)); // Output: -1
  /// print(NumbersHelper.safeDivide(10, 0, returnNaNOnDivByZero: true)); // Output: NaN
  /// print(NumbersHelper.safeDivide(10, 2)); // Output: 5
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
  static int gcd(int a, int b) {
    var x = a.abs();
    var y = b.abs();
    while (y != 0) {
      final temp = y;
      y = x % y;
      x = temp;
    }
    return x;
  }

  /// Checks if a number [n] is a perfect square.
  static bool isPerfectSquare(int n) {
    final sqrtN = math.sqrt(n).toInt();
    return sqrtN * sqrtN == n;
  }

  /// Standard Roman numeral symbol values.
  static const _romanValues = <String, int>{
    'I': 1,
    'V': 5,
    'X': 10,
    'L': 50,
    'C': 100,
    'D': 500,
    'M': 1000,
  };

  /// Converts a Roman numeral string [romanNumeral] to an integer.
  static int fromRomanNumeral(String romanNumeral) {
    final input = romanNumeral.trim().toUpperCase();
    if (input.isEmpty) {
      throw ArgumentError.value(
        romanNumeral,
        'romanNumeral',
        'cannot be empty',
      );
    }
    final canonicalRomanPattern = RegExp(
      r'^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$',
    );
    if (!canonicalRomanPattern.hasMatch(input)) {
      throw ArgumentError.value(
        romanNumeral,
        'romanNumeral',
        'is not a valid canonical Roman numeral (1..3999)',
      );
    }

    var result = 0;
    var previous = 0;

    for (var i = input.length - 1; i >= 0; i--) {
      final current = _romanValues[input[i]];
      if (current == null) {
        throw ArgumentError.value(
          romanNumeral,
          'romanNumeral',
          'contains invalid Roman symbols',
        );
      }

      if (current < previous) {
        result -= current;
      } else {
        result += current;
        previous = current;
      }
    }

    return result;
  }
}
