import 'package:flutter/material.dart';

import '../../themes/my_color_scheme.dart';
import '../../themes/my_theme.dart';

/// Theme-oriented shortcuts for [BuildContext].
///
/// Works with package-specific theme types ([MyThemeData], [MyColorScheme]).
///
/// Example:
/// ```dart
/// final Color bg = context.themed<Color>(
///   Colors.white,
///   Colors.black,
/// );
/// ```
extension ContextThemeExtension on BuildContext {
  /// Returns the active package theme for this context.
  MyThemeData get theme => MyTheme.of(this);

  /// Returns `true` when the active theme is dark.
  ///
  /// This checks both `theme.brightness` and `colorScheme.brightness`.
  bool get isDark =>
      theme.brightness == Brightness.dark ||
      colorScheme.brightness == Brightness.dark;

  /// Returns platform brightness from [MediaQuery].
  ///
  /// This reflects system preference and may differ from [MyThemeData.brightness].
  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  /// Resolves a value based on current brightness.
  ///
  /// Returns [dark] when [isDark] is `true`, otherwise [light].
  /// If [dark] is not provided, [light] is returned for both modes.
  ///
  /// Example:
  /// ```dart
  /// final Color iconColor = context.themed<Color>(
  ///   Colors.black,
  ///   Colors.white,
  /// );
  /// ```
  T themed<T>(T light, [T? dark]) {
    return isDark ? (dark ?? light) : light;
  }

  /// Returns the active package color scheme.
  MyColorScheme get colorScheme => theme.colorScheme;

  /// Whether focus outlines should be rendered by components.
  bool get enableFocusOutline => theme.enableFocusOutline;
}
