import 'package:flutter/material.dart';

import '../../index.dart';

extension ContextThemeExtension on BuildContext {
  MyThemeData get theme => MyTheme.of(this);

  bool get isDark =>
      theme.brightness == Brightness.dark ||
      colorScheme.brightness == Brightness.dark;

  /// returns brightness
  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  /// extension to get value according to theme
  T themed<T>(T light, [T? dark]) {
    return isDark ? (dark ?? light) : light;
  }

  MyColorScheme get colorScheme => theme.colorScheme;

  bool get enableFocusOutline => theme.enableFocusOutline;
}
