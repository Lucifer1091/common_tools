import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('built-in color schemes', () {
    test('registers brown, gold, and black without legacy AAGSA aliases', () {
      expect(MyColorScheme.schemes, containsAll(['brown', 'gold', 'black']));
      expect(MyColorScheme.schemes, isNot(contains('aagsa-red')));
      expect(MyColorScheme.schemes, isNot(contains('aagsa-gold')));
      expect(MyColorScheme.schemes, isNot(contains('aagsa-neutral')));

      for (final legacyName in const [
        'aagsa-red',
        'aagsa-gold',
        'aagsa-neutral',
      ]) {
        expect(
          () => MyColorScheme.fromName(legacyName),
          throwsA(isA<Exception>()),
        );
      }
    });

    test('resolves new names case-insensitively in both brightness modes', () {
      for (final name in const ['brown', 'gold', 'black']) {
        for (final brightness in Brightness.values) {
          final scheme = MyColorScheme.fromName(
            name.toUpperCase(),
            brightness: brightness,
          );

          expect(scheme.brightness, brightness);
          expect(scheme.toColorMap(), hasLength(29));
          expect(scheme.toJson(), hasLength(30));
        }
      }
    });

    test('round trips every built-in scheme through json and color maps', () {
      for (final name in MyColorScheme.schemes) {
        for (final brightness in Brightness.values) {
          final scheme = MyColorScheme.fromName(name, brightness: brightness);

          final jsonRoundTrip = MyColorScheme.fromJson(scheme.toJson());
          final colorMapRoundTrip = MyColorScheme.fromColors(
            colors: scheme.toColorMap(),
            brightness: brightness,
          );

          expect(jsonRoundTrip.brightness, scheme.brightness);
          expect(jsonRoundTrip.toColorMap(), scheme.toColorMap());
          expect(colorMapRoundTrip.brightness, scheme.brightness);
          expect(colorMapRoundTrip.toColorMap(), scheme.toColorMap());
        }
      }
    });

    test('preserves AAGSA-derived anchors and chart ordering', () {
      final brownLight = MyColorScheme.fromName('brown');
      final brownDark = MyColorScheme.fromName(
        'brown',
        brightness: Brightness.dark,
      );
      final goldLight = MyColorScheme.fromName('gold');
      final goldDark = MyColorScheme.fromName(
        'gold',
        brightness: Brightness.dark,
      );
      final blackLight = MyColorScheme.fromName('black');
      final blackDark = MyColorScheme.fromName(
        'black',
        brightness: Brightness.dark,
      );

      expect(brownLight.primary, const Color(0xff983127));
      expect(brownLight.primaryForeground, const Color(0xfffafaf9));
      expect(brownLight.ring, const Color(0xff983127));
      expect(brownLight.selection, const Color(0x47983127));
      expect(brownLight.chart1, const Color(0xff983127));
      expect(brownDark.ring, const Color(0xffc8675d));
      expect(brownDark.chart1, const Color(0xffc8675d));

      expect(goldLight.primary, const Color(0xffb0a06c));
      expect(goldLight.primaryForeground, const Color(0xff000000));
      expect(goldLight.ring, const Color(0xff746738));
      expect(goldLight.selection, const Color(0x47b0a06c));
      expect(goldLight.chart1, const Color(0xffb0a06c));
      expect(goldDark.ring, const Color(0xffb0a06c));
      expect(goldDark.chart1, const Color(0xffb0a06c));

      expect(blackLight.primary, const Color(0xff000000));
      expect(blackLight.primaryForeground, const Color(0xfffafaf9));
      expect(blackLight.selection, const Color(0x47983127));
      expect(blackLight.chart1, const Color(0xff000000));
      expect(blackDark.primary, const Color(0xfffafaf9));
      expect(blackDark.primaryForeground, const Color(0xff000000));
      expect(blackDark.chart1, const Color(0xfffafaf9));
    });

    test('keeps semantic foreground pairs readable in new schemes', () {
      for (final name in const ['brown', 'gold', 'black']) {
        for (final brightness in Brightness.values) {
          final scheme = MyColorScheme.fromName(name, brightness: brightness);

          _expectContrast(scheme.background, scheme.foreground);
          _expectContrast(scheme.card, scheme.cardForeground);
          _expectContrast(scheme.popover, scheme.popoverForeground);
          _expectContrast(scheme.primary, scheme.primaryForeground);
          _expectContrast(scheme.secondary, scheme.secondaryForeground);
          _expectContrast(scheme.muted, scheme.mutedForeground);
          _expectContrast(scheme.accent, scheme.accentForeground);
          _expectContrast(scheme.destructive, scheme.destructiveForeground);
          _expectContrast(scheme.warning, scheme.warningForeground);
          _expectContrast(scheme.success, scheme.successForeground);
        }
      }
    });
  });
}

void _expectContrast(Color background, Color foreground) {
  expect(
    _contrastRatio(background, foreground),
    greaterThanOrEqualTo(4.5),
    reason: '$foreground on $background should meet 4.5:1 contrast',
  );
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}
