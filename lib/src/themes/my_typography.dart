import 'package:flutter/widgets.dart';

class MyTypography {
  /// The package that owns the bundled Geist font assets.
  static const String fontPackage = 'common_tools';

  static const String _sans = 'Geist';
  static const String _mono = 'GeistMono';

  /// The resolved family name for the bundled Geist Sans font.
  ///
  /// Use this value in APIs that only accept a font-family string. Prefer
  /// [geistSansStyle] when an API accepts a [TextStyle].
  static const String kDefaultFontFamily = 'packages/$fontPackage/$_sans';

  /// The resolved family name for the bundled Geist Mono font.
  ///
  /// Use this value in APIs that only accept a font-family string. Prefer
  /// [geistMonoStyle] when an API accepts a [TextStyle].
  static const String kDefaultFontFamilyMono = 'packages/$fontPackage/$_mono';

  /// A package-qualified base style for the bundled Geist Sans font.
  static const TextStyle geistSansStyle = TextStyle(
    fontFamily: _sans,
    package: fontPackage,
  );

  /// A package-qualified base style for the bundled Geist Mono font.
  static const TextStyle geistMonoStyle = TextStyle(
    fontFamily: _mono,
    package: fontPackage,
  );

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
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.displayMedium = const TextStyle(
      fontSize: 45,
      height: 52 / 45,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.displaySmall = const TextStyle(
      fontSize: 36,
      height: 44 / 36,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.headlineLarge = const TextStyle(
      fontSize: 32,
      height: 40 / 32,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.headlineMedium = const TextStyle(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.headlineSmall = const TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.titleLarge = const TextStyle(
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w500,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.titleMedium = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w500,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.titleSmall = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      fontFamily: _sans,
      package: fontPackage,
    ),
    this.labelSmall = const TextStyle(
      fontSize: 11,
      height: 16 / 11,
      fontWeight: FontWeight.w500,
      fontFamily: _sans,
      package: fontPackage,
    ),
  });

  /// Creates typography using a host or third-party font family.
  ///
  /// Leave [package] null for a font declared by the consuming application.
  /// Supply the owning package name when the font comes from another package.
  factory MyTypography.custom(String fontFamily, {String? package}) {
    const base = MyTypography.geist();
    TextStyle withCustomFont(TextStyle style) =>
        style._withFontFamily(fontFamily, package: package);

    return base.copyWith(
      displayLarge: withCustomFont(base.displayLarge),
      displayMedium: withCustomFont(base.displayMedium),
      displaySmall: withCustomFont(base.displaySmall),
      headlineLarge: withCustomFont(base.headlineLarge),
      headlineMedium: withCustomFont(base.headlineMedium),
      headlineSmall: withCustomFont(base.headlineSmall),
      titleLarge: withCustomFont(base.titleLarge),
      titleMedium: withCustomFont(base.titleMedium),
      titleSmall: withCustomFont(base.titleSmall),
      bodyLarge: withCustomFont(base.bodyLarge),
      bodyMedium: withCustomFont(base.bodyMedium),
      bodySmall: withCustomFont(base.bodySmall),
      labelLarge: withCustomFont(base.labelLarge),
      labelMedium: withCustomFont(base.labelMedium),
      labelSmall: withCustomFont(base.labelSmall),
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
  TextStyle _withFontFamily(String fontFamily, {String? package}) {
    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
  }

  TextStyle scale(double factor) {
    return copyWith(fontSize: fontSize != null ? fontSize! * factor : null);
  }
}
