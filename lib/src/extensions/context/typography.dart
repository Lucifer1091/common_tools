import 'package:flutter/material.dart';

import '../../themes/my_theme.dart';
import '../../themes/my_typography.dart';

/// Typography shortcuts for [BuildContext].
///
/// Exposes [MyTypography] tokens directly from the active [MyTheme].
///
/// Example:
/// ```dart
/// Text(
///   'Section Title',
///   style: context.titleLarge,
/// );
/// ```
extension ContextTypographyExtension on BuildContext {
  /// Returns the nearest [DefaultTextStyle] widget.
  ///
  /// Use `defaultTextStyle.style` to access the inherited [TextStyle].
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  /// Returns the package typography from the active theme.
  MyTypography get textTheme => MyTheme.of(this).typography;

  /// Shortcut for [MyTypography.displayLarge].
  TextStyle get displayLarge => textTheme.displayLarge;

  /// Shortcut for [MyTypography.displayMedium].
  TextStyle get displayMedium => textTheme.displayMedium;

  /// Shortcut for [MyTypography.displaySmall].
  TextStyle get displaySmall => textTheme.displaySmall;

  /// Shortcut for [MyTypography.headlineLarge].
  TextStyle get headlineLarge => textTheme.headlineLarge;

  /// Shortcut for [MyTypography.headlineMedium].
  TextStyle get headlineMedium => textTheme.headlineMedium;

  /// Shortcut for [MyTypography.headlineSmall].
  TextStyle get headlineSmall => textTheme.headlineSmall;

  /// Shortcut for [MyTypography.titleLarge].
  TextStyle get titleLarge => textTheme.titleLarge;

  /// Shortcut for [MyTypography.titleMedium].
  TextStyle get titleMedium => textTheme.titleMedium;

  /// Shortcut for [MyTypography.titleSmall].
  TextStyle get titleSmall => textTheme.titleSmall;

  /// Shortcut for [MyTypography.bodyLarge].
  TextStyle get bodyLarge => textTheme.bodyLarge;

  /// Shortcut for [MyTypography.bodyMedium].
  TextStyle get bodyMedium => textTheme.bodyMedium;

  /// Shortcut for [MyTypography.bodySmall].
  TextStyle get bodySmall => textTheme.bodySmall;

  /// Shortcut for [MyTypography.labelLarge].
  TextStyle get labelLarge => textTheme.labelLarge;

  /// Shortcut for [MyTypography.labelMedium].
  TextStyle get labelMedium => textTheme.labelMedium;

  /// Shortcut for [MyTypography.labelSmall].
  TextStyle get labelSmall => textTheme.labelSmall;
}
