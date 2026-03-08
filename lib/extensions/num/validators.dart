import 'dart:math' as math;

import 'converters.dart';
import 'operators.dart';

/// Predicate helpers for nullable numbers.
extension NumValidators on num? {
  /// Returns `true` if this nullable number is `null`.
  bool get isNull => this == null;

  /// Returns `true` when this value is not `null`.
  bool get isNotNull => !isNull;

  /// Returns `true` if the number is even, `false` otherwise.
  bool get isEven => isNotNull && this! % 2 == 0;

  /// Returns `true` if the number is odd, `false` otherwise.
  bool get isOdd => isNotNull && this! % 2 != 0;

  /// Returns `true` if the number is positive, `false` otherwise.
  bool get isPositive => isNotNull && this! > 0;

  /// Returns `true` if the number is negative, `false` otherwise.
  bool get isNegative => isNotNull && this! < 0;

  /// Returns `true` when this value has no fractional part.
  ///
  /// Returns `false` for `null`, infinities, and NaN.
  bool get isWhole =>
      isNotNull &&
      this != double.infinity &&
      this != double.negativeInfinity &&
      !this!.isNaN &&
      this!.truncate() == this;

  /// Returns `true` if the number is zero, `false` otherwise.
  bool get isZero => isNotNull && this! == 0;

  /// Returns `true` when this value equals its integer truncation.
  bool get isInteger => this == toInt();

  /// Returns `true` if the number is a double, `false` otherwise.
  bool get isDouble => this is double;

  /// Returns whether this value is inside `[min, max]`.
  ///
  /// Lower bound is always inclusive.
  /// Upper bound is inclusive when [inclusive] is `true`, exclusive otherwise.
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

  /// Returns `true` when this value is outside `[min, max]`.
  ///
  /// Boundary behavior matches [between]:
  /// - [inclusive] `true`: values equal to bounds are considered inside.
  /// - [inclusive] `false`: value equal to either bound is considered outside.
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

  /// Returns `true` if this value's string form starts with [prefix].
  bool startsWith(num prefix) =>
      isNotNull && toString().startsWith(prefix.toString());

  /// Returns `true` if this value's string form ends with [suffix].
  bool endsWith(num suffix) =>
      isNotNull && toString().endsWith(suffix.toString());

  /// Returns `true` if this value's string form contains [substring].
  bool contains(num substring) =>
      isNotNull && toString().contains(substring.toString());

  /// Returns `true` when absolute difference from [other] is within [precision].
  bool isCloseTo(double other, {double precision = 1.0e-8}) =>
      isNotNull && (this! - other).abs() <= precision;

  /// Returns `true` if this integer value represents a leap year.
  bool get isLeapYear {
    if (isNull) return false;
    final int year = toInt();
    if (year <= 0) return false;

    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// Returns `true` when divisible by [divider] with no remainder.
  ///
  /// Throws [ArgumentError] when [divider] is `0`.
  bool isDivisibleBy(int divider) {
    if (divider == 0) {
      throw ArgumentError.value(divider, 'divider', 'cannot be zero');
    }
    if (isNull) return false;

    return this! % divider == 0;
  }

  /// Returns `true` when divisible by every value in [dividers].
  ///
  /// Throws [ArgumentError] when [dividers] contains `0`.
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

  /// Checks if `abs(toInt())` is a perfect cube.
  ///
  /// Negative perfect cubes also return `true` because absolute value is used.
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
