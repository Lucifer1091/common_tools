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
  Color get primaryColor => colorScheme.primary;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get primaryContainerColor => colorScheme.primaryContainer;
  Color get onPrimaryContainerColor => colorScheme.onPrimaryContainer;

  /// secondary colors
  Color get secondaryColor => colorScheme.secondary;
  Color get onSecondaryColor => colorScheme.onSecondary;
  Color get secondaryContainerColor => colorScheme.secondaryContainer;
  Color get onSecondaryContainerColor => colorScheme.onSecondaryContainer;

  /// tertiary color
  Color get tertiaryColor => colorScheme.tertiary;
  Color get onTertiaryColor => colorScheme.onTertiary;
  Color get tertiaryContainerColor => colorScheme.tertiaryContainer;
  Color get onTertiaryContainerColor => colorScheme.onTertiaryContainer;

  /// surface color
  Color get surfaceColor => colorScheme.surface;
  Color get onSurfaceColor => colorScheme.onSurface;

  /// surface variant color
  Color get surfaceVariantColor => colorScheme.surfaceContainerHighest;
  Color get onSurfaceVariantColor => colorScheme.onSurfaceVariant;

  /// inverse colors
  Color get inverseSurfaceColor => colorScheme.inverseSurface;
  Color get onInverseSurfaceColor => colorScheme.onInverseSurface;

  /// background color
  Color get backgroundColor => colorScheme.surface;
  Color get onBackgroundContainerColor => colorScheme.onSurface;

  /// outline color
  Color get outlineColor => colorScheme.outline;
  Color get outlineVariantColor => colorScheme.outlineVariant;

  /// error colors
  Color get errorColor => colorScheme.error;
  Color get onErrorColor => colorScheme.onError;
  Color get errorContainerColor => colorScheme.errorContainer;
  Color get onErrorContainerColor => colorScheme.onErrorContainer;

  /// input decoration theme
  InputDecorationTheme get inputDecoration => theme.inputDecorationTheme;

  InputBorder get enabledBorder => inputDecoration.enabledBorder!;
  InputBorder get focusedBorder => inputDecoration.focusedBorder!;
  InputBorder get errorBorder => inputDecoration.errorBorder!;
  InputBorder get focusedErrorBorder => inputDecoration.focusedErrorBorder!;
  InputBorder get disableBorder => inputDecoration.disabledBorder!;

  Color? get fillColor => inputDecoration.fillColor;
  Color? get progressIndicatorColor => theme.progressIndicatorTheme.color;
}
