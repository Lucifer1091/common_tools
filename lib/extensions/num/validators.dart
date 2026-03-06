import 'dart:math' as math;

import 'converters.dart';
import 'operators.dart';

extension NumValidators on num? {
  /// Returns `true` if this nullable number is `null`.
  bool get isNull => this == null;

  bool get isNotNull => !isNull;

  /// Returns `true` if the number is even, `false` otherwise.
  bool get isEven => isNotNull && this! % 2 == 0;

  /// Returns `true` if the number is odd, `false` otherwise.
  bool get isOdd => isNotNull && this! % 2 != 0;

  /// Returns `true` if the number is positive, `false` otherwise.
  bool get isPositive => isNotNull && this! > 0;

  /// Returns `true` if the number is negative, `false` otherwise.
  bool get isNegative => isNotNull && this! < 0;

  /// Returns to if [num] has .00000 fraction points
  bool get isWhole =>
      isNotNull &&
      this != double.infinity &&
      this != double.negativeInfinity &&
      !this!.isNaN &&
      this!.truncate() == this;

  /// Returns `true` if the number is zero, `false` otherwise.
  bool get isZero => isNotNull && this! == 0;

  /// Returns `true` if the number is an integer, `false` otherwise.
  bool get isInteger => this == toInt();

  /// Returns `true` if the number is a double, `false` otherwise.
  bool get isDouble => this is double;

  /// Determines if `this` is between [min] and [max].
  /// If [inclusive] is `true`, both bounds are inclusive; otherwise, the upper bound is exclusive.
  bool between(num min, num max, {bool inclusive = true}) {
    assert(
      min <= max,
      'Invalid bounds: $min and $max, min cannot be greater than max',
    );

    if (isNull) return false;
    final value = this!;
    return inclusive
        ? (min <= value && value <= max)
        : (min <= value && value < max);
  }

  /// Returns `true` if this number is outside the given range of [min] and [max].
  bool outside(num min, num max, {bool inclusive = true}) {
    assert(
      min <= max,
      'Invalid bounds: $min and $max, min cannot be greater than max',
    );

    if (isNull) return false;
    final value = this!;
    return inclusive
        ? (value < min || value > max)
        : (value <= min || value >= max);
  }

  /// Check if the number starts with [prefix].
  /// Returns `true` if the number starts with [prefix], `false` otherwise.
  bool startsWith(num prefix) =>
      isNotNull && toString().startsWith(prefix.toString());

  /// Check if the number ends with [suffix].
  /// Returns `true` if the number ends with [suffix], `false` otherwise.
  bool endsWith(num suffix) =>
      isNotNull && toString().endsWith(suffix.toString());

  /// Check if the number contains [substring].
  /// Returns `true` if the number contains [substring], `false` otherwise.
  bool contains(num substring) =>
      isNotNull && toString().contains(substring.toString());

  /// Returns true if [num] is close to [other] within [precision].
  /// By default, [precision] is set to 1.0e-8 which is 0.00000001 which makes
  /// it suitable for most of the cases.
  bool isCloseTo(double other, {double precision = 1.0e-8}) =>
      isNotNull && (this! - other).abs() <= precision;

  /// Returns true if [num] represents a leap year
  bool get isLeapYear {
    if (isNull) return false;
    final int year = toInt();
    if (year <= 0) return false;

    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// Returns true if [num] can be completely divisible by [divider]
  bool isDivisibleBy(int divider) {
    if (divider == 0) {
      throw ArgumentError.value(divider, 'divider', 'cannot be zero');
    }
    if (isNull) return false;

    return this! % divider == 0;
  }

  /// Returns true if [num] can be completely divisible
  /// by all of the [dividers].
  bool isDivisibleByAll(List<int> dividers) {
    if (dividers.contains(0)) {
      throw ArgumentError.value(dividers, 'dividers', 'cannot contain zero');
    }
    if (isNull) return false;

    return dividers.every((divider) => this! % divider == 0);
  }

  /// Checks if this integer is a prime number.
  bool isPrime() {
    if (isNull) return false;
    final value = getOr().toInt();
    if (value <= 1) return false;

    for (var i = 2; i <= math.sqrt(value).toInt(); i++) {
      if (value % i == 0) return false;
    }
    return true;
  }

  /// Checks if this integer is a perfect square.
  bool isPerfectSquare() {
    if (isNull) return false;
    final value = getOr().toInt();
    return value >= 0 && NumbersHelper.isPerfectSquare(value);
  }

  /// Checks if this integer is a perfect cube.
  bool isPerfectCube() {
    if (isNull) return false;
    final n = getOr().abs();
    var cubeRoot = 0;
    while (cubeRoot * cubeRoot * cubeRoot < n) {
      cubeRoot++;
    }
    return cubeRoot * cubeRoot * cubeRoot == n;
  }

  /// Checks if this integer is a Fibonacci number.
  bool isFibonacci() {
    if (isNull) return false;
    final value = getOr().toInt();

    final n1 = 5 * value * value + 4;
    final n2 = 5 * value * value - 4;

    return NumbersHelper.isPerfectSquare(n1) ||
        NumbersHelper.isPerfectSquare(n2);
  }

  /// Checks if this integer is a power of [base].
  bool isPowerOf(int base) {
    if (base <= 1) {
      throw ArgumentError.value(base, 'base', 'must be greater than 1');
    }
    if (isNull) return false;

    var n = getOr().toInt();
    if (n <= 0) return false;

    while (n % base == 0) {
      n ~/= base;
    }
    return n == 1;
  }
}
