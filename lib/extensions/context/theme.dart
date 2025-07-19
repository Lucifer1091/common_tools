import 'package:flutter/material.dart';

extension ContextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  bool get isDark =>
      theme.brightness == Brightness.dark ||
      colorScheme.brightness == Brightness.dark;

  /// returns brightness
  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  /// extension to get value according to theme
  T themedValue<T>(T light, [T? dark]) {
    return isDark ? (dark ?? light) : light;
  }

  ColorScheme get colorScheme => theme.colorScheme;

  /// colorscheme colors
  /// primary colors
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  /// secondary colors
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  /// tertiary color
  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  /// surface color
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;

  /// surface variant color
  Color get surfaceVariant => colorScheme.surfaceContainerHighest;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  /// inverse colors
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onInverseSurface => colorScheme.onInverseSurface;

  /// background color
  Color get background => colorScheme.surface;
  Color get onBackgroundContainer => colorScheme.onSurface;

  /// outline color
  Color get outline => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;

  /// error colors
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;

  /// input decoration theme
  InputDecorationTheme get inputDecoration => theme.inputDecorationTheme;

  InputBorder get enabledBorder => inputDecoration.enabledBorder!;
  InputBorder get focusedBorder => inputDecoration.focusedBorder!;
  InputBorder get errorBorder => inputDecoration.errorBorder!;
  InputBorder get focusedErrorBorder => inputDecoration.focusedErrorBorder!;
  InputBorder get disableBorder => inputDecoration.disabledBorder!;

  Color? get fillColor => inputDecoration.fillColor;
  Color? get progressIndicator => theme.progressIndicatorTheme.color;
}
