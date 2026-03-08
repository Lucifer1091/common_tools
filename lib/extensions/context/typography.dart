import 'package:flutter/material.dart';

import '../../index.dart';

extension ContextTypographyExtension on BuildContext {
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  MyTypography get textTheme => MyTheme.of(this).typography;

  TextStyle get displayLarge => textTheme.displayLarge;

  TextStyle get displayMedium => textTheme.displayMedium;

  TextStyle get displaySmall => textTheme.displaySmall;

  TextStyle get headlineLarge => textTheme.headlineLarge;

  TextStyle get headlineMedium => textTheme.headlineMedium;

  TextStyle get headlineSmall => textTheme.headlineSmall;

  TextStyle get titleLarge => textTheme.titleLarge;

  TextStyle get titleMedium => textTheme.titleMedium;

  TextStyle get titleSmall => textTheme.titleSmall;

  TextStyle get bodyLarge => textTheme.bodyLarge;

  TextStyle get bodyMedium => textTheme.bodyMedium;

  TextStyle get bodySmall => textTheme.bodySmall;

  TextStyle get labelLarge => textTheme.labelLarge;

  TextStyle get labelMedium => textTheme.labelMedium;

  TextStyle get labelSmall => textTheme.labelSmall;
}
