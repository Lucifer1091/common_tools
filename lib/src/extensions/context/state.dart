import 'package:flutter/material.dart';

/// Convenience accessors for focus, form, scaffold, and overlay state
/// retrieval from [BuildContext].
///
/// Example:
/// ```dart
/// final emailFocus = FocusNode();
/// context.requestFocus(emailFocus);
///
/// if (context.formState?.validate() == true) {
///   context.hideKeyboard();
/// }
/// ```
extension ContextStateExtension on BuildContext {
  /// Returns `true` if this context currently has focus.
  ///
  /// This checks both [FocusScopeNode.hasFocus] and
  /// [FocusScopeNode.hasPrimaryFocus].
  bool get hasFocus {
    final scope = FocusScope.of(this);
    return scope.hasFocus || scope.hasPrimaryFocus;
  }

  /// Requests focus for the given [focus] node.
  void requestFocus(FocusNode focus) => FocusScope.of(this).requestFocus(focus);

  /// Unfocuses the given [focus] node.
  void unFocus(FocusNode focus) => focus.unfocus();

  /// Hides the soft keyboard by unfocusing the current primary focus.
  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  /// Returns the closest [FormState], or `null` when no [Form] ancestor exists.
  FormState? get formState => Form.maybeOf(this);

  /// Returns the closest [ScaffoldState], or `null` when unavailable.
  ScaffoldState? get scaffoldState => Scaffold.maybeOf(this);

  /// Returns the closest [OverlayState], or `null` when unavailable.
  OverlayState? get overlayState => Overlay.maybeOf(this);

  /// Opens the scaffold drawer when a [ScaffoldState] is available.
  ///
  /// No-op when there is no enclosing [Scaffold].
  void openDrawer() => scaffoldState?.openDrawer();

  /// Closes the scaffold drawer when a [ScaffoldState] is available.
  ///
  /// No-op when there is no enclosing [Scaffold].
  void closeDrawer() => scaffoldState?.closeDrawer();

  /// Opens the scaffold end drawer when a [ScaffoldState] is available.
  ///
  /// No-op when there is no enclosing [Scaffold].
  void openEndDrawer() => scaffoldState?.openEndDrawer();

  /// Closes the scaffold end drawer when a [ScaffoldState] is available.
  ///
  /// No-op when there is no enclosing [Scaffold].
  void closeEndDrawer() => scaffoldState?.closeEndDrawer();
}
