import 'package:flutter/material.dart';

/// Convenience helpers for nullable [GlobalKey] of [FormState].
extension FormStateX on GlobalKey<FormState>? {
  /// Validates the form and returns whether it is valid.
  ///
  /// Returns `false` when this key is `null` or when no [FormState] is attached.
  ///
  /// Example:
  /// ```dart
  /// final valid = formKey.isValid();
  /// ```
  bool isValid() {
    if (this == null) return false;

    return this!.currentState?.validate() ?? false;
  }

  /// Returns `true` when [isValid] is `false`.
  bool isNotValid() => !isValid();

  /// Resets all fields in the form.
  ///
  /// No-op when this key is `null` or not attached.
  void reset() {
    if (this == null) return;

    return this!.currentState?.reset();
  }

  /// Saves all fields in the form.
  ///
  /// No-op when this key is `null` or not attached.
  void save() {
    if (this == null) return;

    return this!.currentState?.save();
  }

  /// Runs granular validation and returns invalid fields.
  ///
  /// Returns:
  /// - `null` when this key is `null`
  /// - a set of invalid [FormFieldState]s when attached
  Set<FormFieldState<Object?>>? validateGranularly() {
    if (this == null) return null;

    return this!.currentState?.validateGranularly();
  }
}
