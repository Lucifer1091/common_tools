import 'dart:math' as math show min, max;

/// Utility extension methods for the [Comparable] class.
extension ComparableBasics<T> on Comparable<T> {
  /// Returns true if this should be ordered strictly before [other].
  ///
  /// Example:
  /// ```dart
  /// int a = 5;
  /// int b = 10;
  /// print(a < b); // true
  /// ```
  ///
  /// Throws an [ArgumentError] if [other] is `null`.
  bool operator <(T other) {
    if (other == null) {
      throw ArgumentError('other must not be null');
    }
    return compareTo(other) < 0;
  }

  /// Returns true if this should be ordered strictly after [other].
  ///
  /// Example:
  /// ```dart
  /// int a = 15;
  /// int b = 10;
  /// print(a > b); // true
  /// ```
  ///
  /// Throws an [ArgumentError] if [other] is `null`.
  bool operator >(T other) {
    if (other == null) {
      throw ArgumentError('other must not be null');
    }
    return compareTo(other) > 0;
  }

  /// Returns true if this should be ordered before or equal to [other].
  ///
  /// Example:
  /// ```dart
  /// int a = 5;
  /// int b = 10;
  /// print(a <= b); // true
  /// print(a <= 5); // true
  /// ```
  ///
  /// Throws an [ArgumentError] if [other] is `null`.
  bool operator <=(T other) {
    if (other == null) {
      throw ArgumentError('other must not be null');
    }
    return compareTo(other) <= 0;
  }

  /// Returns true if this should be ordered after or equal to [other].
  ///
  /// Example:
  /// ```dart
  /// int a = 15;
  /// int b = 10;
  /// print(a >= b); // true
  /// print(a >= 15); // true
  /// ```
  ///
  /// Throws an [ArgumentError] if [other] is `null`.
  bool operator >=(T other) {
    if (other == null) {
      throw ArgumentError('other must not be null');
    }
    return compareTo(other) >= 0;
  }
}

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


// /// provides extensions for [Comparable]
// extension ComparableScrewdriver<E extends Comparable<dynamic>> on E {
//   /// Returns true if [other] object is less than [this].
//   bool operator <(E other) => compareTo(other) < 0;

//   /// Returns true if [other] object is less than or equal to [this].
//   bool operator <=(E other) => compareTo(other) <= 0;

//   /// Returns true if [other] object is greater than [this].
//   bool operator >(E other) => compareTo(other) > 0;

//   /// Returns true if [other] object is greater than or equal to [this].
//   bool operator >=(E other) => compareTo(other) >= 0;

//   /// Ensures that this value is not less than the specified [minimum] value.
//   /// returns this value if it's greater than or equal to the [minimum] value
//   /// or the [minimum] value otherwise.
//   E coerceAtLeast(E minimum) => this < minimum ? minimum : this;

//   /// Ensures that this value is not greater than the specified [maximum] value.
//   /// Returns this value if it's less than or equal to the [maximum] value
//   /// or the [maximum] value otherwise.
//   E coerceAtMost(E maximum) => this > maximum ? maximum : this;

//   /// Ensures that this value lies in the specified range [min] <--> [max].
//   /// Return this value if it's in the range, or [min] value if this value
//   /// is less than [min] value, or [max] value if this value is
//   /// greater than [max] value.
//   E coerceIn(E min, E max) {
//     if (min > max) {
//       throw IllegalArgumentException(
//           'Cannot coerce value to an empty range: maximum $max is '
//           'less than minimum $min.');
//     }
//     if (this < min) return min;
//     if (this > max) return max;
//     return this;
//   }
// }

// /// Provides comparison operators for [Comparable] types.
// extension ComparableSmallerExtension<T extends Comparable<T>> on T {
//   bool operator <(T other) => compareTo(other) < 0;
// }

// extension ComparableSmallerEqualsExtension<T extends Comparable<T>> on T {
//   bool operator <=(T other) => compareTo(other) <= 0;
// }

// extension ComparableBiggerExtension<T extends Comparable<T>> on T {
//   bool operator >(T other) => compareTo(other) > 0;
// }

// extension ComparableBiggerEqualsExtension<T extends Comparable<T>> on T {
//   bool operator >=(T other) => compareTo(other) >= 0;
// }

// extension ComparableCoerceInExtension<T extends Comparable<T>> on T {
//   /// Ensures that this value lies in the specified range
//   /// [minimumValue]..[maximumValue].
//   ///
//   /// @return this value if it's in the range, or [minimumValue]
//   /// if this value is less than [minimumValue],
//   /// or [maximumValue] if this value is greater than [maximumValue].
//   T coerceIn(T minimumValue, [T? maximumValue]) {
//     if (maximumValue != null && minimumValue > maximumValue) {
//       throw ArgumentError(
//         'Cannot coerce value to an empty range: '
//         'maximum $maximumValue is less than minimum $minimumValue.',
//       );
//     }
//     if (this < minimumValue) return minimumValue;
//     if (maximumValue != null && this > maximumValue) return maximumValue;
//     return this;
//   }
// }

// extension ComparableCoerceAtLeastExtension<T extends Comparable<T>> on T {
//   /// Ensures that this value is not less than the specified [minimumValue].
//   ///
//   /// @return this value if it's greater than or equal to the [minimumValue]
//   /// or the [minimumValue] otherwise.
//   T coerceAtLeast(T minimumValue) => this < minimumValue ? minimumValue : this;
// }

// extension ComparableCoerceAtMostExtension<T extends Comparable<T>> on T {
//   /// Ensures that this value is not greater than the specified [maximumValue].
//   ///
//   /// @return this value if it's less than or equal to the [maximumValue]
//   /// or the [maximumValue] otherwise.
//   T coerceAtMost(T maximumValue) => this > maximumValue ? maximumValue : this;
// }

// extension ComparableBetweenExtension<T extends Comparable<T>> on T {
//   /// Returns true when between [first] and [endInclusive]. The order of the
//   /// arguments doesn't matter.
//   ///
//   /// Alias for `first.rangeTo(endInclusive).contains(this)`
//   bool between(T first, T endInclusive) =>
//       first.rangeTo(endInclusive).contains(this);
// }

// extension ComparableInRangeExtension<T extends Comparable<T>> on T {
//   /// Returns true if in the [range].
//   bool inRange(Range<T> range) => range.contains(this);
// }