import 'package:flutter/material.dart';

extension ContextTextThemeExtension on BuildContext {
  /// Returns DefaultTextStyle.of(context)
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  /// get textTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// display large style
  TextStyle? get displayLarge => textTheme.displayLarge;

  /// display medium style
  TextStyle? get displayMedium => textTheme.displayMedium;

  /// display small style
  TextStyle? get displaySmall => textTheme.displaySmall;

  /// headline large style
  TextStyle? get headlineLarge => textTheme.headlineLarge;

  /// headline medium style
  TextStyle? get headlineMedium => textTheme.headlineMedium;

  /// headline small style
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  /// title large style
  TextStyle? get titleLarge => textTheme.titleLarge;

  /// title medium style
  TextStyle? get titleMedium => textTheme.titleMedium;

  /// title small style
  TextStyle? get titleSmall => textTheme.titleSmall;

  /// label large style
  TextStyle? get labelLarge => textTheme.labelLarge;

  /// label medium style
  TextStyle? get labelMedium => textTheme.labelMedium;

  /// label small style
  TextStyle? get labelSmall => textTheme.labelSmall;

  /// body large style
  TextStyle? get bodyLarge => textTheme.bodyLarge;

  /// body medium style
  TextStyle? get bodyMedium => textTheme.bodyMedium;

  /// body small style
  TextStyle? get bodySmall => textTheme.bodySmall;
}
