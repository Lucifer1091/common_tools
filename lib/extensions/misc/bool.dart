import 'dart:math';

extension BooleanExtensions on bool? {
  /// getOrDefault
  /// returns default value if blank
  bool getOr([bool value = false]) => this ?? value;

  /// Checks if the boolean value is true.
  bool get isTrue => this != null && this!;

  /// Checks if the boolean value is false.
  bool get isFalse => this != null && !this!;

  /// Converts the boolean value to an integer.
  ///
  /// Returns 1 if the value is true, otherwise returns 0.
  int get toInt => this != null && this! ? 1 : 0;

  /// Converts the nullable boolean to its binary representation as a string.
  ///
  /// Returns `'1'` if the value is non-null and true, otherwise returns `'0'`.
  String get binary => (this ?? false) ? '1' : '0';

  /// Toggles the boolean value.
  ///
  /// If the value is true, it returns false.
  /// If the value is false or null, it returns true.
  bool? get toggle => this != null ? !this! : null;

  /// Returns the inverse of this boolean.
  bool? not() {
    if (this == null) return null;
    return !this!;
  }

  /// Performs a logical `and` operation between this Boolean and the [other] one. Unlike the `&&` operator,
  /// this function does not perform short-circuit evaluation. Both `this` and [other] will always be evaluated.
  bool? and(bool? other) {
    if (this == null || other == null) return null;
    return this! && other;
  }

  /// Performs a logical `or` operation between this Boolean and the [other] one. Unlike the `||` operator,
  /// this function does not perform short-circuit evaluation. Both `this` and [other] will always be evaluated.
  bool? or(bool? other) {
    if (this == null || other == null) return null;
    return this! || other;
  }

  /// Performs a logical `xor` operation between this Boolean and the [other] one.
  bool? xor(bool? other) {
    if (this == null || other == null) return null;
    return this != other;
  }
}

/// Generates a random boolean value.
bool randomBool() => Random().nextBool();
