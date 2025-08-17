import 'package:flutter/material.dart';

extension StringToColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color fromHex() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension HexColor on Color {
  Color scaleAlpha(double factor) {
    return withValues(alpha: a * factor);
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${a.toInt().toRadixString(16).padLeft(2, '0')}'
      '${r.toInt().toRadixString(16).padLeft(2, '0')}'
      '${g.toInt().toRadixString(16).padLeft(2, '0')}'
      '${b.toInt().toRadixString(16).padLeft(2, '0')}';

  /// Lighten the color by [percentage] (0.0 to 1.0).
  Color lighten([double percentage = .1]) {
    assert(
      percentage >= 0 && percentage <= 1,
      'Percentage must be between 0 and 1',
    );

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + percentage).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }

  /// Darken the color by [percentage] (0.0 to 1.0).
  Color darken([double percentage = .1]) {
    assert(
      percentage >= 0 && percentage <= 1,
      'Percentage must be between 0 and 1',
    );

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness(
      (hsl.lightness - percentage).clamp(0.0, 1.0),
    );

    return hslDark.toColor();
  }

  /// Mixes a color with [another]. [amount] is from 0 to 1.
  Color? mix(Color another, double amount) => Color.lerp(this, another, amount);

  /// Returns `true` if the color is dark, otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// bool isDark = color.isDark;
  /// print('Is Dark: $isDark'); // Output: false
  /// ```
  bool get isDark => getBrightness < 128.0;

  /// Returns `true` if the color is light, otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// bool isLight = color.isLight;
  /// print('Is Light: $isLight'); // Output: true
  /// ```
  bool get isLight => !isDark;

  /// Returns the brightness of the color.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// double brightness = color.getBrightness;
  /// print('Brightness: $brightness'); // Output: 110.622
  /// ```
  double get getBrightness => (r * 299 + g * 587 + b * 114) / 1000;

  /// Returns the luminance of the color.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// double luminance = color.getLuminance;
  /// print('Luminance: $luminance'); // Output: 0.2126
  /// ```
  double get getLuminance => computeLuminance();
}
