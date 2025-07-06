import 'dart:math' as math;

import 'converters.dart';
import 'operators.dart';

extension NumValidators on num? {
  /// Returns `true` if this nullable iterable is either `null` or empty.
  bool get isNull => this == null;

  bool get isNotNull => !isNull;

  /// Returns `true` if the number is even, `false` otherwise.
  bool get isEven => getOr() % 2 == 0;

  /// Returns `true` if the number is odd, `false` otherwise.
  bool get isOdd => getOr() % 2 != 0;

  /// Returns `true` if the number is positive, `false` otherwise.
  bool get isPositive => getOr() > 0;

  /// Returns `true` if the number is negative, `false` otherwise.
  bool get isNegative => getOr() < 0;

  /// Returns to if [num] has .00000 fraction points
  bool get isWhole =>
      isNotNull &&
      this != double.infinity &&
      this != double.negativeInfinity &&
      !this!.isNaN &&
      this!.truncate() == this;

  /// Returns `true` if the number is zero, `false` otherwise.
  bool get isZero => getOr() == 0;

  /// Returns `true` if the number is an integer, `false` otherwise.
  bool get isInteger => this == toInt();

  /// Returns `true` if the number is a double, `false` otherwise.
  bool get isDouble => this == toDouble();

  /// Determines if `this` is between [min] and [max].
  /// If [inclusive] is `true`, both bounds are inclusive; otherwise, the upper bound is exclusive.
  bool between(num min, num max, {bool inclusive = true}) {
    assert(
      min <= max,
      'Invalid bounds: $min and $max, min cannot be greater than max',
    );

    final value = getOr();
    return inclusive
        ? (min <= value && value <= max)
        : (min <= value && value < max);
  }

  /// Returns `true` if this number is outside the given range of [min] (exclusive) and
  /// [max] (exclusive).
  bool outside(num min, num max) {
    assert(
      min <= max,
      'Invalid bounds: $min and $max, min cannot be greater than max',
    );

    final value = getOr();
    return value < min || value > max;
  }

  /// Check if the number starts with [prefix].
  /// Returns `true` if the number starts with [prefix], `false` otherwise.
  bool startsWith(num prefix) => toString().startsWith(prefix.toString());

  /// Check if the number ends with [suffix].
  /// Returns `true` if the number ends with [suffix], `false` otherwise.
  bool endsWith(num suffix) => toString().endsWith(suffix.toString());

  /// Check if the number contains [substring].
  /// Returns `true` if the number contains [substring], `false` otherwise.
  bool contains(num substring) => toString().contains(substring.toString());

  /// Returns true if [num] is close to [other] within [precision].
  /// By default, [precision] is set to 1.0e-8 which is 0.00000001 which makes
  /// it suitable for most of the cases.
  bool isCloseTo(double other, {double precision = 1.0e-8}) =>
      (getOr() - other).abs() <= precision;

  /// Returns true if [num] represents a leap year
  bool get isLeapYear {
    final int year = toInt();
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// Returns true if [num] can be completely divisible by [divider]
  bool isDivisibleBy(int divider) => getOr() % divider == 0;

  /// Returns true if [num] can be completely divisible
  /// by all of the [dividers].
  bool isDivisibleByAll(List<int> dividers) =>
      dividers.every((divider) => getOr() % divider == 0);

  /// Checks if this number is approximately equal to [other] within a [tolerance].
  bool isApproximatelyEqual(num other, {double tolerance = 0.01}) {
    return this != null && (this! - other).abs() <= tolerance;
  }

  /// Checks if this integer is a prime number.
  bool isPrime() {
    final value = getOr().toInt();
    if (value <= 1) return false;

    for (var i = 2; i <= math.sqrt(value).toInt(); i++) {
      if (value % i == 0) return false;
    }
    return true;
  }

  /// Checks if this integer is a perfect square.
  bool isPerfectSquare() {
    final value = getOr().toInt();
    if (value < 0) return false;

    final root = math.sqrt(value).toInt();
    return root * root == value;
  }

  /// Checks if this integer is a perfect cube.
  bool isPerfectCube() {
    final n = getOr().abs();
    var cubeRoot = 0;
    while (cubeRoot * cubeRoot * cubeRoot < n) {
      cubeRoot++;
    }
    return cubeRoot * cubeRoot * cubeRoot == n;
  }

  /// Checks if this integer is a Fibonacci number.
  bool isFibonacci() {
    final value = getOr().toInt();

    final n1 = 5 * value * value + 4;
    final n2 = 5 * value * value - 4;

    return NumbersHelper.isPerfectSquare(n1) ||
        NumbersHelper.isPerfectSquare(n2);
  }

  /// Checks if this integer is a power of [base].
  bool isPowerOf(int base) {
    if (base <= 1) return this == base;
    var n = getOr().toInt();
    while (n % base == 0) {
      n ~/= base;
    }
    return n == 1;
  }
}
