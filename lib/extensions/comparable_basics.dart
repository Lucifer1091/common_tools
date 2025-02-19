import 'dart:math' as math show min, max;

import 'helper.dart';

/// Returns the greater of two [Comparable] objects.
///
/// For [num] values, behaves identically to [math.max].
///
/// If the arguments compare equal, then it is unspecified which of the two
/// arguments is returned.
///
/// Example:
/// ```dart
/// int a = 5;
/// int b = 10;
/// print(max(a, b)); // 10
///
/// double x = 7.2;
/// double y = 3.8;
/// print(max(x, y)); // 7.2
///
/// String str1 = "apple";
/// String str2 = "banana";
/// print(max(str1, str2)); // "banana"
/// ```
T max<T extends Comparable<Object>>(T a, T b) {
  if (a is num) {
    return math.max(a, b as num) as T;
  }
  return (a >= b) ? a : b;
}

/// Returns the lesser of two [Comparable] objects.
///
/// For [num] values, behaves identically to [math.min].
///
/// If the arguments compare equal, then it is unspecified which of the two
/// arguments is returned.
///
/// Example:
/// ```dart
/// int a = 5;
/// int b = 10;
/// print(min(a, b)); // 5
///
/// double x = 7.2;
/// double y = 3.8;
/// print(min(x, y)); // 3.8
///
/// String str1 = "apple";
/// String str2 = "banana";
/// print(min(str1, str2)); // "apple"
/// ```
T min<T extends Comparable<Object>>(T a, T b) {
  if (a is num) {
    return math.min(a, b as num) as T;
  }
  return (a <= b) ? a : b;
}

/// Provides comparison operators for [Comparable] types.
extension ComparableSmallerExtension<T extends Comparable<T>> on T {
  bool operator <(T other) => compareTo(other) < 0;

  bool operator <=(T other) => compareTo(other) <= 0;

  bool operator >(T other) => compareTo(other) > 0;

  bool operator >=(T other) => compareTo(other) >= 0;

  /// Ensures that this value lies in the specified range
  /// [min]..[max].
  ///
  /// @return this value if it's in the range, or [min]
  /// if this value is less than [min],
  /// or [max] if this value is greater than [max].
  T coerceIn(T min, [T? max]) {
    if (max != null && min > max) {
      throw ArgumentError(
        'Cannot coerce value to an empty range: '
        'maximum $max is less than minimum $min.',
      );
    }
    if (this < min) return min;
    if (max != null && this > max) return max;
    return this;
  }

  /// Ensures that this value is not less than the specified [min].
  ///
  /// @return this value if it's greater than or equal to the [min]
  /// or the [min] otherwise.
  T coerceAtLeast(T min) => this < min ? min : this;

  /// Ensures that this value is not greater than the specified [max].
  ///
  /// @return this value if it's less than or equal to the [max]
  /// or the [max] otherwise.
  T coerceAtMost(T max) => this > max ? max : this;

  /// Returns true when between [first] and [endInclusive]. The order of the
  /// arguments doesn't matter.
  ///
  /// Alias for `first.rangeTo(endInclusive).contains(this)`
  bool between(T first, T endInclusive) =>
      first.rangeTo(endInclusive).contains(this);

  /// Returns true if in the [range].
  bool inRange(Range<T> range) => range.contains(this);
}
