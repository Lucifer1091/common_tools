import 'package:flutter/material.dart';

import 'my_color_scheme.dart';
import 'my_typography.dart';

extension MyTypographyMaterialExtension on MyTypography {
  TextTheme toMaterialTextTheme({Color? color}) {
    TextStyle applyColor(TextStyle style) =>
        color == null ? style : style.copyWith(color: color);

    return TextTheme(
      displayLarge: applyColor(displayLarge),
      displayMedium: applyColor(displayMedium),
      displaySmall: applyColor(displaySmall),
      headlineLarge: applyColor(headlineLarge),
      headlineMedium: applyColor(headlineMedium),
      headlineSmall: applyColor(headlineSmall),
      titleLarge: applyColor(titleLarge),
      titleMedium: applyColor(titleMedium),
      titleSmall: applyColor(titleSmall),
      bodyLarge: applyColor(bodyLarge),
      bodyMedium: applyColor(bodyMedium),
      bodySmall: applyColor(bodySmall),
      labelLarge: applyColor(labelLarge),
      labelMedium: applyColor(labelMedium),
      labelSmall: applyColor(labelSmall),
    );
  }
}

extension MyColorSchemeMaterialExtension on MyColorScheme {
  ColorScheme toMaterialColorScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    );

    return base.copyWith(
      primary: primary,
      onPrimary: primaryForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      tertiary: accent,
      onTertiary: accentForeground,
      error: destructive,
      onError: destructiveForeground,
      surface: background,
      onSurface: foreground,
      outline: border,
      onSurfaceVariant: mutedForeground,
      surfaceContainerHighest: card,
      inversePrimary: accent,
      scrim: ring,
    );
  }

  ThemeData toMaterialTheme({
    MyTypography typography = const MyTypography.geist(),
  }) {
    final colorScheme = toMaterialColorScheme();
    final textTheme = typography.toMaterialTextTheme(color: foreground);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: card,
      dividerColor: border,
      splashColor: selection.withValues(alpha: 0.16),
      highlightColor: selection.withValues(alpha: 0.08),
      textTheme: textTheme,
      primaryTextTheme: typography.toMaterialTextTheme(
        color: primaryForeground,
      ),
      iconTheme: IconThemeData(color: foreground),
      primaryIconTheme: IconThemeData(color: primaryForeground),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: foreground),
        titleTextStyle: typography.titleLarge.copyWith(color: foreground),
      ),
      fontFamily: typography.bodyMedium.fontFamily,
    );
  }
}
