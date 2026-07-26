import 'package:flutter/material.dart';

/// Extensions for [State] classes to provide safe widget operations.
extension StateExtensions<T extends StatefulWidget> on State<T> {
  /// Safely calls [setState] only if the widget is still mounted.
  ///
  /// This prevents calling `setState` after disposal.
  ///
  /// Returns:
  /// - `true` if `setState` executed
  /// - `false` if this state is not mounted
  ///
  /// Example:
  /// ```dart
  /// void _updateData() {
  ///   // Safe setState call
  ///   safeSetState(() {
  ///     _isLoading = false;
  ///   });
  /// }
  /// ```
  bool safeSetState(VoidCallback callback) {
    if (!mounted) return false;

    // ignore: invalid_use_of_protected_member
    setState(callback);
    return true;
  }
}
