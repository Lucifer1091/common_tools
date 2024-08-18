part of 'extensions.dart';

/// A collection of boolean extension methods to simplify boolean operations.
///
/// This extension provides convenient methods to perform various operations
/// on boolean values, such as validation, checking for true/false, toggling,
/// and converting to integer values.
///
/// Example usage:
/// ```dart
/// import 'package:flutter_helper_kit/flutter_helper_kit.dart';
///
/// void main() {
///   // Example usage of boolean extensions
///   bool? nullableBool = true;
///
///   // Validate a boolean value and provide a default if null
///   bool validatedValue = nullableBool.validate(value: false);
///   print(validatedValue); // Output: true
///
///   // Check if a boolean value is true
///   print(nullableBool.isTrue); // Output: true
///
///   // Check if a boolean value is false
///   print(nullableBool.isFalse); // Output: false
///
///   // Check if a boolean value is not true
///   print(nullableBool.isNotTrue); // Output: false
///
///   // Check if a boolean value is not false
///   print(nullableBool.isNotFalse); // Output: true
///
///   // Convert a boolean value to an integer (1 if true, 0 if false)
///   int intValue = nullableBool.toInt;
///   print(intValue); // Output: 1
///
///   // Toggle the boolean value
///   bool toggledValue = nullableBool.toggle;
///   print(toggledValue); // Output: false
/// }
/// ```
extension BooleanExtensions on bool? {
  /// Validates the given boolean value.
  ///
  /// If the value is not null, it returns the value itself.
  /// If the value is null, it returns the provided [value].
  bool validate({bool value = false}) => this ?? value;

  /// Checks if the boolean value is true.
  bool get isTrue => this != null && this!;

  /// Checks if the boolean value is false.
  bool get isFalse => this != null && !this!;

  /// Converts the boolean value to an integer.
  ///
  /// Returns 1 if the value is true, otherwise returns 0.
  int get toInt => this != null && this! ? 1 : 0;

  /// Toggles the boolean value.
  ///
  /// If the value is true, it returns false.
  /// If the value is false or null, it returns true.
  bool get toggle => this != null ? !this! : false;

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
  //  this function does not perform short-circuit evaluation. Both `this` and [other] will always be evaluated.
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

/// * extension for bool
extension RBool on bool {
  /// * convert bool to int if true return 1 else 0
  int toInt() => this ? 1 : 0;

  /// * return reversed bool
  bool toggle() => !this;
}

/// Provides extensions for [bool].
extension BoolScrewdriver on bool {
  /// Returns opposite of [this]
  bool get toggled => !this;

  /// Returns 1 if [this] is true and 0 if otherwise.
  int toInt() => this ? 1 : 0;
}

/// Generates a random boolean value.
bool randomBool() => Random().nextBool();
