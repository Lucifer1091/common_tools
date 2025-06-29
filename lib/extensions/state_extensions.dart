import 'package:flutter/material.dart';

/// Extensions for [State] classes to provide safe widget operations.
extension StateExtensions<T extends StatefulWidget> on State<T> {
  /// Safely calls [setState] only if the widget is still mounted.
  ///
  /// This prevents the common error of calling setState on a disposed widget.
  /// Returns `true` if setState was called,
  /// `false` if the widget is not mounted.
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

    try {
      // ignore: invalid_use_of_protected_member
      setState(callback);
      return true;
    } on Exception catch (e) {
      // In case setState throws an exception, we don't want to crash the app
      debugPrint('safeSetState error: $e');
      return false;
    }
  }
}
