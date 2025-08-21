import 'package:flutter/widgets.dart';

class MyTypography {
  const MyTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// Default Geist typography
  const MyTypography.geist({
    this.displayLarge = const TextStyle(
      fontSize: 57,
      height: 64 / 57,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.displayMedium = const TextStyle(
      fontSize: 45,
      height: 52 / 45,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.displaySmall = const TextStyle(
      fontSize: 36,
      height: 44 / 36,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.headlineLarge = const TextStyle(
      fontSize: 32,
      height: 40 / 32,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.headlineMedium = const TextStyle(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.headlineSmall = const TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.titleLarge = const TextStyle(
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w500,
      fontFamily: kDefaultFontFamily,
    ),
    this.titleMedium = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w500,
      fontFamily: kDefaultFontFamily,
    ),
    this.titleSmall = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      fontFamily: kDefaultFontFamily,
    ),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      fontFamily: kDefaultFontFamily,
    ),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      fontFamily: kDefaultFontFamily,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      fontFamily: kDefaultFontFamily,
    ),
    this.labelSmall = const TextStyle(
      fontSize: 11,
      height: 16 / 11,
      fontWeight: FontWeight.w500,
      fontFamily: kDefaultFontFamily,
    ),
  });

  /// Custom font family constructor
  factory MyTypography.custom(String fontFamily) {
    final base = MyTypography.geist();
    return base.copyWith(
      displayLarge: base.displayLarge.copyWith(fontFamily: fontFamily),
      displayMedium: base.displayMedium.copyWith(fontFamily: fontFamily),
      displaySmall: base.displaySmall.copyWith(fontFamily: fontFamily),
      headlineLarge: base.headlineLarge.copyWith(fontFamily: fontFamily),
      headlineMedium: base.headlineMedium.copyWith(fontFamily: fontFamily),
      headlineSmall: base.headlineSmall.copyWith(fontFamily: fontFamily),
      titleLarge: base.titleLarge.copyWith(fontFamily: fontFamily),
      titleMedium: base.titleMedium.copyWith(fontFamily: fontFamily),
      titleSmall: base.titleSmall.copyWith(fontFamily: fontFamily),
      bodyLarge: base.bodyLarge.copyWith(fontFamily: fontFamily),
      bodyMedium: base.bodyMedium.copyWith(fontFamily: fontFamily),
      bodySmall: base.bodySmall.copyWith(fontFamily: fontFamily),
      labelLarge: base.labelLarge.copyWith(fontFamily: fontFamily),
      labelMedium: base.labelMedium.copyWith(fontFamily: fontFamily),
      labelSmall: base.labelSmall.copyWith(fontFamily: fontFamily),
    );
  }

  /// Internal scaling helper
  MyTypography scale(double factor) {
    return MyTypography(
      displayLarge: displayLarge.scale(factor),
      displayMedium: displayMedium.scale(factor),
      displaySmall: displaySmall.scale(factor),
      headlineLarge: headlineLarge.scale(factor),
      headlineMedium: headlineMedium.scale(factor),
      headlineSmall: headlineSmall.scale(factor),
      titleLarge: titleLarge.scale(factor),
      titleMedium: titleMedium.scale(factor),
      titleSmall: titleSmall.scale(factor),
      bodyLarge: bodyLarge.scale(factor),
      bodyMedium: bodyMedium.scale(factor),
      bodySmall: bodySmall.scale(factor),
      labelLarge: labelLarge.scale(factor),
      labelMedium: labelMedium.scale(factor),
      labelSmall: labelSmall.scale(factor),
    );
  }

  MyTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return MyTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  static const _sans = 'Geist';
  static const _mono = 'GeistMono';

  static const kDefaultFontFamily = _sans;
  static const kDefaultFontFamilyMono = _mono;

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  static MyTypography lerp(MyTypography a, MyTypography b, double t) {
    return MyTypography(
      displayLarge: TextStyle.lerp(a.displayLarge, b.displayLarge, t)!,
      displayMedium: TextStyle.lerp(a.displayMedium, b.displayMedium, t)!,
      displaySmall: TextStyle.lerp(a.displaySmall, b.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(a.headlineLarge, b.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(a.headlineMedium, b.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(a.headlineSmall, b.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(a.titleLarge, b.titleLarge, t)!,
      titleMedium: TextStyle.lerp(a.titleMedium, b.titleMedium, t)!,
      titleSmall: TextStyle.lerp(a.titleSmall, b.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(a.bodyLarge, b.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(a.bodyMedium, b.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(a.bodySmall, b.bodySmall, t)!,
      labelLarge: TextStyle.lerp(a.labelLarge, b.labelLarge, t)!,
      labelMedium: TextStyle.lerp(a.labelMedium, b.labelMedium, t)!,
      labelSmall: TextStyle.lerp(a.labelSmall, b.labelSmall, t)!,
    );
  }
}

extension on TextStyle {
  TextStyle scale(double factor) {
    return copyWith(fontSize: fontSize != null ? fontSize! * factor : null);
  }
}
