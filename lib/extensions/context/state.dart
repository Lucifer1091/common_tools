import 'package:flutter/material.dart';

extension ContextStateExtension on BuildContext {
  /// check whether keyboard has focus or not
  bool get hasFocus {
    final scope = FocusScope.of(this);
    return scope.hasFocus || scope.hasPrimaryFocus;
  }

  /// Request focus to given FocusNode
  void requestFocus(FocusNode focus) => FocusScope.of(this).requestFocus(focus);

  /// Unfocus given [FocusNode].
  void unFocus(FocusNode focus) => focus.unfocus();

  /// Hide soft keyboard
  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  /// Returns the closest [FormState] or `null` if not found.
  FormState? get formState => Form.maybeOf(this);

  /// Returns Scaffold.of(context)
  ScaffoldState? get scaffoldState => Scaffold.maybeOf(this);

  /// Returns the closest [OverlayState] or `null` if not found.
  OverlayState? get overlayState => Overlay.maybeOf(this);

  /// Open Drawer
  void openDrawer() => scaffoldState?.openDrawer();

  void closeDrawer() => scaffoldState?.closeDrawer();

  /// Hide Drawer
  void openEndDrawer() => scaffoldState?.openEndDrawer();

  void closeEndDrawer() => scaffoldState?.closeEndDrawer();
}
