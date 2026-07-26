import 'dart:math';

/// Convenience helpers for nullable booleans.
///
/// Methods preserve `null` where appropriate to support tri-state logic.
extension BooleanExtensions on bool? {
  /// Returns this value, or [value] when `null`.
  ///
  /// Example:
  /// ```dart
  /// final bool? remoteFlag = null;
  /// final enabled = remoteFlag.getOr(true); // true
  /// ```
  bool getOr([bool value = false]) => this ?? value;

  /// Returns `true` only when this value is `true`.
  bool get isTrue => this ?? false;

  /// Returns `true` only when this value is `false`.
  bool get isFalse => this == false;

  /// Converts this value to an integer bit.
  ///
  /// Returns `1` for `true`; otherwise `0` (`false` and `null`).
  int get toInt => this != null && this! ? 1 : 0;

  /// Converts this value to a binary string bit.
  ///
  /// Returns `'1'` for `true`; otherwise `'0'` (`false` and `null`).
  String get binary => (this ?? false) ? '1' : '0';

  /// Toggles the value.
  ///
  /// `true` becomes `false`, and `false`/`null` become `true`.
  bool get toggle => !(this ?? false);

  /// Returns the logical inverse of this value.
  ///
  /// Returns `null` when this value is `null`.
  ///
  /// Example:
  /// ```dart
  /// true.not(); // false
  /// false.not(); // true
  /// (null as bool?).not(); // null
  /// ```
  bool? not() {
    if (this == null) return null;
    return !this!;
  }

  /// Performs logical `AND` with [other].
  ///
  /// Returns `null` when either operand is `null`.
  ///
  /// Example:
  /// ```dart
  /// true.and(true); // true
  /// true.and(false); // false
  /// (null as bool?).and(true); // null
  /// ```
  bool? and(bool? other) {
    if (this == null || other == null) return null;
    return this! && other;
  }

  /// Performs logical `OR` with [other].
  ///
  /// Returns `null` when either operand is `null`.
  ///
  /// Example:
  /// ```dart
  /// true.or(false); // true
  /// false.or(false); // false
  /// (null as bool?).or(false); // null
  /// ```
  bool? or(bool? other) {
    if (this == null || other == null) return null;
    return this! || other;
  }

  /// Performs logical `XOR` with [other].
  ///
  /// Returns `null` when either operand is `null`.
  ///
  /// Example:
  /// ```dart
  /// true.xor(false); // true
  /// true.xor(true); // false
  /// (null as bool?).xor(true); // null
  /// ```
  bool? xor(bool? other) {
    if (this == null || other == null) return null;
    return this != other;
  }
}

/// Generates a random boolean value (`true` or `false`).
bool randomBool() => Random().nextBool();
