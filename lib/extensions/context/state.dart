import 'package:flutter/material.dart';

extension ContextStateExtension on BuildContext {
  /// check whether keyboard has focus or not
  bool get hasFocus =>
      FocusScope.of(this).hasFocus || FocusScope.of(this).hasPrimaryFocus;

  /// Request focus to given FocusNode
  void requestFocus(FocusNode focus) => FocusScope.of(this).requestFocus(focus);

  /// Request focus to given FocusNode
  void unFocus(FocusNode focus) => focus.unfocus();

  /// remove keyboard focus
  void removeFocus() {
    if (hasFocus) FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Hide Keyboard
  void unFocusKeyboard() => FocusScope.of(this).unfocus();

  /// Hide soft keyboard
  void hideKeyboard() => FocusScope.of(this).requestFocus(FocusNode());

  /// Returns Form.of(context)
  FormState? get formState => Form.of(this);

  /// Returns Scaffold.of(context)
  ScaffoldState get scaffoldState => Scaffold.of(this);

  /// Returns Overlay.of(context)
  OverlayState? get overlayState => Overlay.of(this);

  /// Open Drawer
  void openDrawer() => Scaffold.of(this).openDrawer();

  void closeDrawer() => Scaffold.of(this).closeDrawer();

  /// Hide Drawer
  void openEndDrawer() => Scaffold.of(this).openEndDrawer();

  void closeEndDrawer() => Scaffold.of(this).closeEndDrawer();
}
