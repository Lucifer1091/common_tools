import 'package:flutter/material.dart';

/// String hex parser for [Color].
extension StringToColor on String {
  /// Parses this hex string into a [Color].
  ///
  /// Accepted formats:
  /// - `RRGGBB`
  /// - `AARRGGBB`
  /// - optional leading `#`
  ///
  /// When alpha is omitted, `FF` is assumed.
  ///
  /// Throws [FormatException] when the input length is not 6 or 8 hex chars.
  ///
  /// Example:
  /// ```dart
  /// final brand = '#1565C0'.fromHex();
  /// final semiTransparent = '801565C0'.fromHex();
  /// ```
  Color fromHex() {
    final normalized = replaceFirst('#', '');
    if (normalized.length != 6 && normalized.length != 8) {
      throw FormatException('Invalid hex color: $this');
    }

    final buffer = StringBuffer();
    if (normalized.length == 6) buffer.write('ff');
    buffer.write(normalized);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Utility color transformations and serialization helpers.
extension HexColor on Color {
  int _to8Bit(double channel) => (channel * 255.0).round().clamp(0, 255);

  /// Returns the same color with alpha multiplied by [factor].
  ///
  /// [factor] is clamped to the valid alpha range (`0.0..1.0`) after scaling.
  Color scaleAlpha(double factor) =>
      withValues(alpha: (a * factor).clamp(0.0, 1.0));

  /// Converts this color to an 8-digit hex string (`AARRGGBB`).
  ///
  /// Set [leadingHashSign] to `false` to omit `#`.
  ///
  /// Example:
  /// ```dart
  /// final hex = Colors.blue.toHex(); // e.g. #FF2196F3
  /// ```
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${_to8Bit(a).toRadixString(16).padLeft(2, '0')}'
      '${_to8Bit(r).toRadixString(16).padLeft(2, '0')}'
      '${_to8Bit(g).toRadixString(16).padLeft(2, '0')}'
      '${_to8Bit(b).toRadixString(16).padLeft(2, '0')}';

  /// Returns a lighter color by increasing HSL lightness by [percentage].
  ///
  /// [percentage] must be in range `0.0..1.0`.
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

  /// Returns a darker color by decreasing HSL lightness by [percentage].
  ///
  /// [percentage] must be in range `0.0..1.0`.
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

  /// Interpolates this color toward [another] by [amount].
  ///
  /// [amount] is usually in `0.0..1.0` where:
  /// - `0.0` returns this color
  /// - `1.0` returns [another]
  Color? mix(Color another, double amount) => Color.lerp(this, another, amount);

  /// Returns `true` when [getBrightness] is below `128`.
  bool get isDark => getBrightness < 128.0;

  /// Returns `true` when this color is not [isDark].
  bool get isLight => !isDark;

  /// Returns perceived brightness using a YIQ-weighted RGB formula.
  double get getBrightness =>
      (_to8Bit(r) * 299 + _to8Bit(g) * 587 + _to8Bit(b) * 114) / 1000;

  /// Returns relative luminance in range `0.0..1.0`.
  double get getLuminance => computeLuminance();
}
