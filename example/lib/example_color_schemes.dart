import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';

const aagsaRedColorValue = 'aagsa-red';
const aagsaGoldColorValue = 'aagsa-gold';
const aagsaNeutralColorValue = 'aagsa-neutral';

final List<MyColorSwitcherOption> exampleColorSwitcherOptions =
    List<MyColorSwitcherOption>.unmodifiable([
      ...MyColorSwitcherOption.defaults,
      MyColorSwitcherOption(
        value: aagsaRedColorValue,
        label: 'AAGSA Red',
        schemeBuilder: aagsaRedColorScheme,
      ),
      MyColorSwitcherOption(
        value: aagsaGoldColorValue,
        label: 'AAGSA Gold',
        schemeBuilder: aagsaGoldColorScheme,
      ),
      MyColorSwitcherOption(
        value: aagsaNeutralColorValue,
        label: 'AAGSA Neutral',
        schemeBuilder: aagsaNeutralColorScheme,
      ),
    ]);

MyColorScheme resolveExampleColorScheme(
  String value, {
  required Brightness brightness,
}) {
  return switch (value.toLowerCase()) {
    aagsaRedColorValue => aagsaRedColorScheme(brightness),
    aagsaGoldColorValue => aagsaGoldColorScheme(brightness),
    aagsaNeutralColorValue => aagsaNeutralColorScheme(brightness),
    _ => MyColorScheme.fromName(value, brightness: brightness),
  };
}

MyColorScheme aagsaRedColorScheme(Brightness brightness) {
  return _aagsaColorScheme(_AagsaColorVariant.red, brightness);
}

MyColorScheme aagsaGoldColorScheme(Brightness brightness) {
  return _aagsaColorScheme(_AagsaColorVariant.gold, brightness);
}

MyColorScheme aagsaNeutralColorScheme(Brightness brightness) {
  return _aagsaColorScheme(_AagsaColorVariant.neutral, brightness);
}

MyColorScheme _aagsaColorScheme(
  _AagsaColorVariant variant,
  Brightness brightness,
) {
  final base = MyColorScheme.fromName('stone', brightness: brightness);
  final isLight = brightness == Brightness.light;

  final primary = switch (variant) {
    _AagsaColorVariant.red => _AagsaPalette.logoRed,
    _AagsaColorVariant.gold => _AagsaPalette.logoGold,
    _AagsaColorVariant.neutral =>
      isLight ? _AagsaPalette.black : _AagsaPalette.warmWhite,
  };
  final primaryForeground = switch (variant) {
    _AagsaColorVariant.red => _AagsaPalette.warmWhite,
    _AagsaColorVariant.gold => _AagsaPalette.black,
    _AagsaColorVariant.neutral =>
      isLight ? _AagsaPalette.warmWhite : _AagsaPalette.black,
  };
  final ring = switch ((variant, brightness)) {
    (_AagsaColorVariant.red, Brightness.light) => _AagsaPalette.logoRed,
    (_AagsaColorVariant.red, Brightness.dark) => _AagsaPalette.supportingRed,
    (_AagsaColorVariant.gold, Brightness.light) =>
      _AagsaPalette.supportingGoldDark,
    (_AagsaColorVariant.gold, Brightness.dark) => _AagsaPalette.logoGold,
    (_AagsaColorVariant.neutral, _) => base.ring,
  };
  final selectionColor = switch (variant) {
    _AagsaColorVariant.neutral => _AagsaPalette.logoRed,
    _ => primary,
  };
  final charts = _AagsaChartPalette.resolve(variant, brightness);

  return base.copyWith(
    primary: primary,
    primaryForeground: primaryForeground,
    mutedForeground: isLight
        ? _AagsaPalette.mutedForeground
        : base.mutedForeground,
    destructive: isLight
        ? _AagsaPalette.destructiveLight
        : _AagsaPalette.destructiveDark,
    destructiveForeground: _AagsaPalette.warmWhite,
    ring: ring,
    selection: selectionColor.withValues(alpha: .28),
    chart1: charts[0],
    chart2: charts[1],
    chart3: charts[2],
    chart4: charts[3],
    chart5: charts[4],
  );
}

enum _AagsaColorVariant { red, gold, neutral }

class _AagsaPalette {
  const _AagsaPalette._();

  static const Color logoRed = Color(0xFF983127);
  static const Color logoGold = Color(0xFFB0A06C);
  static const Color black = Color(0xFF000000);

  static const Color supportingRed = Color(0xFFC8675D);
  static const Color supportingGoldLight = Color(0xFFD2C59B);
  static const Color supportingGoldDark = Color(0xFF746738);
  static const Color warmWhite = Color(0xFFFAFAF9);

  static const Color mutedForeground = Color(0xFF736B60);
  static const Color destructiveLight = Color(0xFFB91C1C);
  static const Color destructiveDark = Color(0xFFDC2626);
}

class _AagsaChartPalette {
  const _AagsaChartPalette._();

  static List<Color> resolve(
    _AagsaColorVariant variant,
    Brightness brightness,
  ) {
    return switch ((variant, brightness)) {
      (_AagsaColorVariant.red, Brightness.light) => lightRed,
      (_AagsaColorVariant.red, Brightness.dark) => darkRed,
      (_AagsaColorVariant.gold, Brightness.light) => lightGold,
      (_AagsaColorVariant.gold, Brightness.dark) => darkGold,
      (_AagsaColorVariant.neutral, Brightness.light) => lightNeutral,
      (_AagsaColorVariant.neutral, Brightness.dark) => darkNeutral,
    };
  }

  static const List<Color> lightRed = [
    _AagsaPalette.logoRed,
    _AagsaPalette.supportingGoldDark,
    _AagsaPalette.black,
    _AagsaPalette.supportingRed,
    _AagsaPalette.logoGold,
  ];

  static const List<Color> darkRed = [
    _AagsaPalette.supportingRed,
    _AagsaPalette.logoGold,
    _AagsaPalette.warmWhite,
    _AagsaPalette.logoRed,
    _AagsaPalette.supportingGoldLight,
  ];

  static const List<Color> lightGold = [
    _AagsaPalette.logoGold,
    _AagsaPalette.logoRed,
    _AagsaPalette.black,
    _AagsaPalette.supportingGoldDark,
    _AagsaPalette.supportingRed,
  ];

  static const List<Color> darkGold = [
    _AagsaPalette.logoGold,
    _AagsaPalette.supportingRed,
    _AagsaPalette.warmWhite,
    _AagsaPalette.supportingGoldLight,
    _AagsaPalette.logoRed,
  ];

  static const List<Color> lightNeutral = [
    _AagsaPalette.black,
    _AagsaPalette.logoRed,
    _AagsaPalette.supportingGoldDark,
    _AagsaPalette.supportingRed,
    _AagsaPalette.logoGold,
  ];

  static const List<Color> darkNeutral = [
    _AagsaPalette.warmWhite,
    _AagsaPalette.supportingRed,
    _AagsaPalette.logoGold,
    _AagsaPalette.supportingGoldLight,
    _AagsaPalette.logoRed,
  ];
}
