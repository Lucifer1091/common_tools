import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('built-in color schemes', () {
    test('exposes shadcn-style base and accent color options', () {
      expect(
        MyColorScheme.baseColors,
        containsAll([
          MyBaseColor.slate,
          MyBaseColor.gray,
          MyBaseColor.neutral,
          MyBaseColor.stone,
          MyBaseColor.zinc,
          MyBaseColor.mauve,
          MyBaseColor.olive,
          MyBaseColor.mist,
          MyBaseColor.taupe,
        ]),
      );
      expect(
        MyColorScheme.accentColors,
        containsAll([
          MyAccentColor.slate,
          MyAccentColor.gray,
          MyAccentColor.neutral,
          MyAccentColor.mauve,
          MyAccentColor.taupe,
          MyAccentColor.blue,
          MyAccentColor.gold,
          MyAccentColor.black,
        ]),
      );
    });

    test(
      'matches official shadcn theme tokens excluding sidebar and radius',
      () {
        for (final entry in _officialShadcnTokens.entries) {
          for (final modeEntry in entry.value.entries) {
            final scheme = MyColorScheme.fromName(
              entry.key,
              brightness: modeEntry.key,
            );
            final colors = scheme.toColorMap();

            for (final token in _officialThemeTokenNames) {
              expect(
                colors[token],
                modeEntry.value[token],
                reason: '${entry.key} ${modeEntry.key.name} $token',
              );
            }
          }
        }
      },
    );

    test('matches official new base palette constants', () {
      expect(MyColors.mauve[50], const Color(0xfffafafb));
      expect(MyColors.mauve[500], const Color(0xff81758b));
      expect(MyColors.mauve[950], const Color(0xff161218));

      expect(MyColors.olive[50], const Color(0xfff9faf9));
      expect(MyColors.olive[500], const Color(0xff6c8072));
      expect(MyColors.olive[950], const Color(0xff101512));

      expect(MyColors.mist[50], const Color(0xfff9fafb));
      expect(MyColors.mist[500], const Color(0xff648085));
      expect(MyColors.mist[950], const Color(0xff0e1517));

      expect(MyColors.taupe[50], const Color(0xfffbfaf9));
      expect(MyColors.taupe[500], const Color(0xff867865));
      expect(MyColors.taupe[950], const Color(0xff17130e));
    });

    test('resolves base-only schemes with the base as the accent', () {
      for (final base in MyColorScheme.baseColors) {
        for (final brightness in Brightness.values) {
          final scheme = MyColorScheme.fromParts(
            base: base,
            brightness: brightness,
          );

          expect(scheme.brightness, brightness);
          expect(scheme.toColorMap(), hasLength(29));
          expect(scheme.toJson(), hasLength(30));
          expect(
            scheme.toColorMap().keys,
            isNot(contains(startsWith('sidebar'))),
          );
        }
      }

      final taupeLight = MyColorScheme.fromParts(base: MyBaseColor.taupe);
      final taupeDark = MyColorScheme.fromParts(
        base: MyBaseColor.taupe,
        brightness: Brightness.dark,
      );

      expect(
        taupeLight.secondary,
        _officialShadcnTokens['taupe']![Brightness.light]!['secondary'],
      );
      expect(
        taupeLight.border,
        _officialShadcnTokens['taupe']![Brightness.light]!['border'],
      );
      expect(
        taupeLight.primary,
        _officialShadcnTokens['taupe']![Brightness.light]!['primary'],
      );
      expect(
        taupeLight.primaryForeground,
        _officialShadcnTokens['taupe']![Brightness.light]!['primaryForeground'],
      );
      expect(
        taupeDark.background,
        _officialShadcnTokens['taupe']![Brightness.dark]!['background'],
      );
      expect(
        taupeDark.primary,
        _officialShadcnTokens['taupe']![Brightness.dark]!['primary'],
      );
      expect(
        taupeDark.primaryForeground,
        _officialShadcnTokens['taupe']![Brightness.dark]!['primaryForeground'],
      );
    });

    test('combines every base with every accent', () {
      for (final base in MyColorScheme.baseColors) {
        for (final accent in MyColorScheme.accentColors) {
          for (final brightness in Brightness.values) {
            final scheme = MyColorScheme.fromParts(
              base: base,
              accent: accent,
              brightness: brightness,
            );

            expect(scheme.brightness, brightness);
            expect(scheme.toColorMap(), hasLength(29));
          }
        }
      }
    });

    test('uses base surfaces with accent brand tokens', () {
      final generated = MyColorScheme.fromParts(
        base: MyBaseColor.mauve,
        accent: MyAccentColor.blue,
      );
      final blue = MyColorScheme.fromName('blue');

      expect(
        generated.foreground,
        _officialShadcnTokens['mauve']![Brightness.light]!['foreground'],
      );
      expect(
        generated.secondary,
        _officialShadcnTokens['mauve']![Brightness.light]!['secondary'],
      );
      expect(
        generated.border,
        _officialShadcnTokens['mauve']![Brightness.light]!['border'],
      );
      expect(generated.primary, blue.primary);
      expect(generated.primaryForeground, blue.primaryForeground);
      expect(
        generated.ring,
        _officialShadcnTokens['mauve']![Brightness.light]!['ring'],
      );
      expect(generated.chart1, blue.chart1);
    });

    test('new base presets resolve by name', () {
      final expectedTypes = <String, Type>{
        'mauve': MyMauveColorScheme,
        'olive': MyOliveColorScheme,
        'mist': MyMistColorScheme,
        'taupe': MyTaupeColorScheme,
      };

      for (final name in expectedTypes.keys) {
        for (final brightness in Brightness.values) {
          final scheme = MyColorScheme.fromName(name, brightness: brightness);

          expect(scheme.runtimeType, expectedTypes[name]);
          expect(
            scheme,
            MyColorScheme.fromParts(
              base: MyBaseColor.values.firstWhere((base) => base.name == name),
              brightness: brightness,
            ),
          );
        }
      }
    });

    test('registers brown, gold, and black without legacy AAGSA aliases', () {
      expect(
        MyColorScheme.schemes,
        containsAll([
          'brown',
          'gold',
          'black',
          'mauve',
          'olive',
          'mist',
          'taupe',
        ]),
      );
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
          _expectContrast(scheme.muted, scheme.mutedForeground, minimum: 3);
          _expectContrast(scheme.accent, scheme.accentForeground);
          _expectContrast(scheme.destructive, scheme.destructiveForeground);
          _expectContrast(scheme.warning, scheme.warningForeground);
          _expectContrast(scheme.success, scheme.successForeground);
        }
      }
    });

    test('keeps generated semantic foreground pairs readable', () {
      for (final base in MyColorScheme.baseColors) {
        for (final accent in MyColorScheme.accentColors) {
          for (final brightness in Brightness.values) {
            final scheme = MyColorScheme.fromParts(
              base: base,
              accent: accent,
              brightness: brightness,
            );

            _expectContrast(scheme.background, scheme.foreground);
            _expectContrast(scheme.card, scheme.cardForeground);
            _expectContrast(scheme.popover, scheme.popoverForeground);
            _expectContrast(scheme.primary, scheme.primaryForeground);
            _expectContrast(scheme.secondary, scheme.secondaryForeground);
            _expectContrast(scheme.muted, scheme.mutedForeground, minimum: 3);
            _expectContrast(scheme.accent, scheme.accentForeground);
            _expectContrast(scheme.destructive, scheme.destructiveForeground);
            _expectContrast(scheme.warning, scheme.warningForeground);
            _expectContrast(scheme.success, scheme.successForeground);
          }
        }
      }
    });
  });
}

const List<String> _officialThemeTokenNames = <String>[
  'background',
  'foreground',
  'card',
  'cardForeground',
  'popover',
  'popoverForeground',
  'primary',
  'primaryForeground',
  'secondary',
  'secondaryForeground',
  'muted',
  'mutedForeground',
  'accent',
  'accentForeground',
  'destructive',
  'border',
  'input',
  'ring',
  'chart1',
  'chart2',
  'chart3',
  'chart4',
  'chart5',
];

const Map<String, Map<Brightness, Map<String, Color>>> _officialShadcnTokens =
    <String, Map<Brightness, Map<String, Color>>>{
      'slate': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff020618),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff020618),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff020618),
          'primary': Color(0xff0f172b),
          'primaryForeground': Color(0xfff8fafc),
          'secondary': Color(0xfff1f5f9),
          'secondaryForeground': Color(0xff0f172b),
          'muted': Color(0xfff1f5f9),
          'mutedForeground': Color(0xff62748e),
          'accent': Color(0xfff1f5f9),
          'accentForeground': Color(0xff0f172b),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe2e8f0),
          'input': Color(0xffe2e8f0),
          'ring': Color(0xff90a1b9),
          'chart1': Color(0xfff54900),
          'chart2': Color(0xff009689),
          'chart3': Color(0xff104e64),
          'chart4': Color(0xffffb900),
          'chart5': Color(0xfffe9a00),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff020618),
          'foreground': Color(0xfff8fafc),
          'card': Color(0xff0f172b),
          'cardForeground': Color(0xfff8fafc),
          'popover': Color(0xff0f172b),
          'popoverForeground': Color(0xfff8fafc),
          'primary': Color(0xffe2e8f0),
          'primaryForeground': Color(0xff0f172b),
          'secondary': Color(0xff1d293d),
          'secondaryForeground': Color(0xfff8fafc),
          'muted': Color(0xff1d293d),
          'mutedForeground': Color(0xff90a1b9),
          'accent': Color(0xff1d293d),
          'accentForeground': Color(0xfff8fafc),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff6a7282),
          'chart1': Color(0xff1447e6),
          'chart2': Color(0xff00bc7d),
          'chart3': Color(0xfffe9a00),
          'chart4': Color(0xffad46ff),
          'chart5': Color(0xffff2056),
        },
      },
      'gray': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff030712),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff030712),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff030712),
          'primary': Color(0xff101828),
          'primaryForeground': Color(0xfff9fafb),
          'secondary': Color(0xfff3f4f6),
          'secondaryForeground': Color(0xff101828),
          'muted': Color(0xfff3f4f6),
          'mutedForeground': Color(0xff6a7282),
          'accent': Color(0xfff3f4f6),
          'accentForeground': Color(0xff101828),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e7eb),
          'input': Color(0xffe5e7eb),
          'ring': Color(0xff99a1af),
          'chart1': Color(0xfff54900),
          'chart2': Color(0xff009689),
          'chart3': Color(0xff104e64),
          'chart4': Color(0xffffb900),
          'chart5': Color(0xfffe9a00),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff030712),
          'foreground': Color(0xfff9fafb),
          'card': Color(0xff101828),
          'cardForeground': Color(0xfff9fafb),
          'popover': Color(0xff101828),
          'popoverForeground': Color(0xfff9fafb),
          'primary': Color(0xffe5e7eb),
          'primaryForeground': Color(0xff101828),
          'secondary': Color(0xff1e2939),
          'secondaryForeground': Color(0xfff9fafb),
          'muted': Color(0xff1e2939),
          'mutedForeground': Color(0xff99a1af),
          'accent': Color(0xff1e2939),
          'accentForeground': Color(0xfff9fafb),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff6a7282),
          'chart1': Color(0xff1447e6),
          'chart2': Color(0xff00bc7d),
          'chart3': Color(0xfffe9a00),
          'chart4': Color(0xffad46ff),
          'chart5': Color(0xffff2056),
        },
      },
      'zinc': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff09090b),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff09090b),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff09090b),
          'primary': Color(0xff18181b),
          'primaryForeground': Color(0xfffafafa),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff4f4f5),
          'mutedForeground': Color(0xff71717b),
          'accent': Color(0xfff4f4f5),
          'accentForeground': Color(0xff18181b),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe4e4e7),
          'input': Color(0xffe4e4e7),
          'ring': Color(0xff9f9fa9),
          'chart1': Color(0xffd4d4d8),
          'chart2': Color(0xff71717b),
          'chart3': Color(0xff52525c),
          'chart4': Color(0xff3f3f46),
          'chart5': Color(0xff27272a),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff09090b),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff18181b),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff18181b),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xffe4e4e7),
          'primaryForeground': Color(0xff18181b),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff27272a),
          'mutedForeground': Color(0xff9f9fa9),
          'accent': Color(0xff27272a),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff71717b),
          'chart1': Color(0xffd4d4d8),
          'chart2': Color(0xff71717b),
          'chart3': Color(0xff52525c),
          'chart4': Color(0xff3f3f46),
          'chart5': Color(0xff27272a),
        },
      },
      'neutral': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff171717),
          'primaryForeground': Color(0xfffafafa),
          'secondary': Color(0xfff5f5f5),
          'secondaryForeground': Color(0xff171717),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffd4d4d4),
          'chart2': Color(0xff737373),
          'chart3': Color(0xff525252),
          'chart4': Color(0xff404040),
          'chart5': Color(0xff262626),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xffe5e5e5),
          'primaryForeground': Color(0xff171717),
          'secondary': Color(0xff262626),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffd4d4d4),
          'chart2': Color(0xff737373),
          'chart3': Color(0xff525252),
          'chart4': Color(0xff404040),
          'chart5': Color(0xff262626),
        },
      },
      'stone': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0c0a09),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0c0a09),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0c0a09),
          'primary': Color(0xff1c1917),
          'primaryForeground': Color(0xfffafaf9),
          'secondary': Color(0xfff5f5f4),
          'secondaryForeground': Color(0xff1c1917),
          'muted': Color(0xfff5f5f4),
          'mutedForeground': Color(0xff79716b),
          'accent': Color(0xfff5f5f4),
          'accentForeground': Color(0xff1c1917),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe7e5e4),
          'input': Color(0xffe7e5e4),
          'ring': Color(0xffa6a09b),
          'chart1': Color(0xffd6d3d1),
          'chart2': Color(0xff79716b),
          'chart3': Color(0xff57534d),
          'chart4': Color(0xff44403b),
          'chart5': Color(0xff292524),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0c0a09),
          'foreground': Color(0xfffafaf9),
          'card': Color(0xff1c1917),
          'cardForeground': Color(0xfffafaf9),
          'popover': Color(0xff1c1917),
          'popoverForeground': Color(0xfffafaf9),
          'primary': Color(0xffe7e5e4),
          'primaryForeground': Color(0xff1c1917),
          'secondary': Color(0xff292524),
          'secondaryForeground': Color(0xfffafaf9),
          'muted': Color(0xff292524),
          'mutedForeground': Color(0xffa6a09b),
          'accent': Color(0xff292524),
          'accentForeground': Color(0xfffafaf9),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff79716b),
          'chart1': Color(0xffd6d3d1),
          'chart2': Color(0xff79716b),
          'chart3': Color(0xff57534d),
          'chart4': Color(0xff44403b),
          'chart5': Color(0xff292524),
        },
      },
      'mauve': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0c090c),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0c090c),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0c090c),
          'primary': Color(0xff1d161e),
          'primaryForeground': Color(0xfffafafa),
          'secondary': Color(0xfff3f1f3),
          'secondaryForeground': Color(0xff1d161e),
          'muted': Color(0xfff3f1f3),
          'mutedForeground': Color(0xff79697b),
          'accent': Color(0xfff3f1f3),
          'accentForeground': Color(0xff1d161e),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe7e4e7),
          'input': Color(0xffe7e4e7),
          'ring': Color(0xffa89ea9),
          'chart1': Color(0xffd7d0d7),
          'chart2': Color(0xff79697b),
          'chart3': Color(0xff594c5b),
          'chart4': Color(0xff463947),
          'chart5': Color(0xff2a212c),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0c090c),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff1d161e),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff1d161e),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xffe7e4e7),
          'primaryForeground': Color(0xff1d161e),
          'secondary': Color(0xff2a212c),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff2a212c),
          'mutedForeground': Color(0xffa89ea9),
          'accent': Color(0xff2a212c),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff79697b),
          'chart1': Color(0xffd7d0d7),
          'chart2': Color(0xff79697b),
          'chart3': Color(0xff594c5b),
          'chart4': Color(0xff463947),
          'chart5': Color(0xff2a212c),
        },
      },
      'olive': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0c0c09),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0c0c09),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0c0c09),
          'primary': Color(0xff1d1d16),
          'primaryForeground': Color(0xfffbfbf9),
          'secondary': Color(0xfff4f4f0),
          'secondaryForeground': Color(0xff1d1d16),
          'muted': Color(0xfff4f4f0),
          'mutedForeground': Color(0xff7c7c67),
          'accent': Color(0xfff4f4f0),
          'accentForeground': Color(0xff1d1d16),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe8e8e3),
          'input': Color(0xffe8e8e3),
          'ring': Color(0xffabab9c),
          'chart1': Color(0xffd8d8d0),
          'chart2': Color(0xff7c7c67),
          'chart3': Color(0xff5b5b4b),
          'chart4': Color(0xff474739),
          'chart5': Color(0xff2b2b22),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0c0c09),
          'foreground': Color(0xfffbfbf9),
          'card': Color(0xff1d1d16),
          'cardForeground': Color(0xfffbfbf9),
          'popover': Color(0xff1d1d16),
          'popoverForeground': Color(0xfffbfbf9),
          'primary': Color(0xffe8e8e3),
          'primaryForeground': Color(0xff1d1d16),
          'secondary': Color(0xff2b2b22),
          'secondaryForeground': Color(0xfffbfbf9),
          'muted': Color(0xff2b2b22),
          'mutedForeground': Color(0xffabab9c),
          'accent': Color(0xff2b2b22),
          'accentForeground': Color(0xfffbfbf9),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff7c7c67),
          'chart1': Color(0xffd8d8d0),
          'chart2': Color(0xff7c7c67),
          'chart3': Color(0xff5b5b4b),
          'chart4': Color(0xff474739),
          'chart5': Color(0xff2b2b22),
        },
      },
      'mist': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff090b0c),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff090b0c),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff090b0c),
          'primary': Color(0xff161b1d),
          'primaryForeground': Color(0xfff9fbfb),
          'secondary': Color(0xfff1f3f3),
          'secondaryForeground': Color(0xff161b1d),
          'muted': Color(0xfff1f3f3),
          'mutedForeground': Color(0xff67787c),
          'accent': Color(0xfff1f3f3),
          'accentForeground': Color(0xff161b1d),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe3e7e8),
          'input': Color(0xffe3e7e8),
          'ring': Color(0xff9ca8ab),
          'chart1': Color(0xffd0d6d8),
          'chart2': Color(0xff67787c),
          'chart3': Color(0xff4b585b),
          'chart4': Color(0xff394447),
          'chart5': Color(0xff22292b),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff090b0c),
          'foreground': Color(0xfff9fbfb),
          'card': Color(0xff161b1d),
          'cardForeground': Color(0xfff9fbfb),
          'popover': Color(0xff161b1d),
          'popoverForeground': Color(0xfff9fbfb),
          'primary': Color(0xffe3e7e8),
          'primaryForeground': Color(0xff161b1d),
          'secondary': Color(0xff22292b),
          'secondaryForeground': Color(0xfff9fbfb),
          'muted': Color(0xff22292b),
          'mutedForeground': Color(0xff9ca8ab),
          'accent': Color(0xff22292b),
          'accentForeground': Color(0xfff9fbfb),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff67787c),
          'chart1': Color(0xffd0d6d8),
          'chart2': Color(0xff67787c),
          'chart3': Color(0xff4b585b),
          'chart4': Color(0xff394447),
          'chart5': Color(0xff22292b),
        },
      },
      'taupe': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0c0a09),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0c0a09),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0c0a09),
          'primary': Color(0xff1d1816),
          'primaryForeground': Color(0xfffbfaf9),
          'secondary': Color(0xfff3f1f1),
          'secondaryForeground': Color(0xff1d1816),
          'muted': Color(0xfff3f1f1),
          'mutedForeground': Color(0xff7c6d67),
          'accent': Color(0xfff3f1f1),
          'accentForeground': Color(0xff1d1816),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe8e4e3),
          'input': Color(0xffe8e4e3),
          'ring': Color(0xffaba09c),
          'chart1': Color(0xffd8d2d0),
          'chart2': Color(0xff7c6d67),
          'chart3': Color(0xff5b4f4b),
          'chart4': Color(0xff473c39),
          'chart5': Color(0xff2b2422),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0c0a09),
          'foreground': Color(0xfffbfaf9),
          'card': Color(0xff1d1816),
          'cardForeground': Color(0xfffbfaf9),
          'popover': Color(0xff1d1816),
          'popoverForeground': Color(0xfffbfaf9),
          'primary': Color(0xffe8e4e3),
          'primaryForeground': Color(0xff1d1816),
          'secondary': Color(0xff2b2422),
          'secondaryForeground': Color(0xfffbfaf9),
          'muted': Color(0xff2b2422),
          'mutedForeground': Color(0xffaba09c),
          'accent': Color(0xff2b2422),
          'accentForeground': Color(0xfffbfaf9),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff7c6d67),
          'chart1': Color(0xffd8d2d0),
          'chart2': Color(0xff7c6d67),
          'chart3': Color(0xff5b4f4b),
          'chart4': Color(0xff473c39),
          'chart5': Color(0xff2b2422),
        },
      },
      'amber': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xffbb4d00),
          'primaryForeground': Color(0xfffffbeb),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffffd230),
          'chart2': Color(0xfffe9a00),
          'chart3': Color(0xffe17100),
          'chart4': Color(0xffbb4d00),
          'chart5': Color(0xff973c00),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff973c00),
          'primaryForeground': Color(0xfffffbeb),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffffd230),
          'chart2': Color(0xfffe9a00),
          'chart3': Color(0xffe17100),
          'chart4': Color(0xffbb4d00),
          'chart5': Color(0xff973c00),
        },
      },
      'blue': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff1447e6),
          'primaryForeground': Color(0xffeff6ff),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xff8ec5ff),
          'chart2': Color(0xff2b7fff),
          'chart3': Color(0xff155dfc),
          'chart4': Color(0xff1447e6),
          'chart5': Color(0xff193cb8),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff193cb8),
          'primaryForeground': Color(0xffeff6ff),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xff8ec5ff),
          'chart2': Color(0xff2b7fff),
          'chart3': Color(0xff155dfc),
          'chart4': Color(0xff1447e6),
          'chart5': Color(0xff193cb8),
        },
      },
      'cyan': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff007595),
          'primaryForeground': Color(0xffecfeff),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xff53eafd),
          'chart2': Color(0xff00b8db),
          'chart3': Color(0xff0092b8),
          'chart4': Color(0xff007595),
          'chart5': Color(0xff005f78),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff005f78),
          'primaryForeground': Color(0xffecfeff),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xff53eafd),
          'chart2': Color(0xff00b8db),
          'chart3': Color(0xff0092b8),
          'chart4': Color(0xff007595),
          'chart5': Color(0xff005f78),
        },
      },
      'emerald': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff007a55),
          'primaryForeground': Color(0xffecfdf5),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xff5ee9b5),
          'chart2': Color(0xff00bc7d),
          'chart3': Color(0xff009966),
          'chart4': Color(0xff007a55),
          'chart5': Color(0xff006045),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff006045),
          'primaryForeground': Color(0xffecfdf5),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xff5ee9b5),
          'chart2': Color(0xff00bc7d),
          'chart3': Color(0xff009966),
          'chart4': Color(0xff007a55),
          'chart5': Color(0xff006045),
        },
      },
      'fuchsia': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xffa800b7),
          'primaryForeground': Color(0xfffdf4ff),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xfff4a8ff),
          'chart2': Color(0xffe12afb),
          'chart3': Color(0xffc800de),
          'chart4': Color(0xffa800b7),
          'chart5': Color(0xff8a0194),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff8a0194),
          'primaryForeground': Color(0xfffdf4ff),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xfff4a8ff),
          'chart2': Color(0xffe12afb),
          'chart3': Color(0xffc800de),
          'chart4': Color(0xffa800b7),
          'chart5': Color(0xff8a0194),
        },
      },
      'green': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff008236),
          'primaryForeground': Color(0xfff0fdf4),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xff7bf1a8),
          'chart2': Color(0xff00c950),
          'chart3': Color(0xff00a63e),
          'chart4': Color(0xff008236),
          'chart5': Color(0xff016630),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff016630),
          'primaryForeground': Color(0xfff0fdf4),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xff7bf1a8),
          'chart2': Color(0xff00c950),
          'chart3': Color(0xff00a63e),
          'chart4': Color(0xff008236),
          'chart5': Color(0xff016630),
        },
      },
      'indigo': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff432dd7),
          'primaryForeground': Color(0xffeef2ff),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffa3b3ff),
          'chart2': Color(0xff615fff),
          'chart3': Color(0xff4f39f6),
          'chart4': Color(0xff432dd7),
          'chart5': Color(0xff372aac),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff372aac),
          'primaryForeground': Color(0xffeef2ff),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffa3b3ff),
          'chart2': Color(0xff615fff),
          'chart3': Color(0xff4f39f6),
          'chart4': Color(0xff432dd7),
          'chart5': Color(0xff372aac),
        },
      },
      'lime': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff9ae600),
          'primaryForeground': Color(0xff35530e),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffbbf451),
          'chart2': Color(0xff7ccf00),
          'chart3': Color(0xff5ea500),
          'chart4': Color(0xff497d00),
          'chart5': Color(0xff3c6300),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff7ccf00),
          'primaryForeground': Color(0xff35530e),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffbbf451),
          'chart2': Color(0xff7ccf00),
          'chart3': Color(0xff5ea500),
          'chart4': Color(0xff497d00),
          'chart5': Color(0xff3c6300),
        },
      },
      'orange': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xffca3500),
          'primaryForeground': Color(0xfffff7ed),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffffb86a),
          'chart2': Color(0xffff6900),
          'chart3': Color(0xfff54900),
          'chart4': Color(0xffca3500),
          'chart5': Color(0xff9f2d00),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff9f2d00),
          'primaryForeground': Color(0xfffff7ed),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffffb86a),
          'chart2': Color(0xffff6900),
          'chart3': Color(0xfff54900),
          'chart4': Color(0xffca3500),
          'chart5': Color(0xff9f2d00),
        },
      },
      'pink': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xffc6005c),
          'primaryForeground': Color(0xfffdf2f8),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xfffda5d5),
          'chart2': Color(0xfff6339a),
          'chart3': Color(0xffe60076),
          'chart4': Color(0xffc6005c),
          'chart5': Color(0xffa3004c),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xffa3004c),
          'primaryForeground': Color(0xfffdf2f8),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xfffda5d5),
          'chart2': Color(0xfff6339a),
          'chart3': Color(0xffe60076),
          'chart4': Color(0xffc6005c),
          'chart5': Color(0xffa3004c),
        },
      },
      'purple': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff8200db),
          'primaryForeground': Color(0xfffaf5ff),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffdab2ff),
          'chart2': Color(0xffad46ff),
          'chart3': Color(0xff9810fa),
          'chart4': Color(0xff8200db),
          'chart5': Color(0xff6e11b0),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff6e11b0),
          'primaryForeground': Color(0xfffaf5ff),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffdab2ff),
          'chart2': Color(0xffad46ff),
          'chart3': Color(0xff9810fa),
          'chart4': Color(0xff8200db),
          'chart5': Color(0xff6e11b0),
        },
      },
      'red': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xffc10007),
          'primaryForeground': Color(0xfffef2f2),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffffa2a2),
          'chart2': Color(0xfffb2c36),
          'chart3': Color(0xffe7000b),
          'chart4': Color(0xffc10007),
          'chart5': Color(0xff9f0712),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff9f0712),
          'primaryForeground': Color(0xfffef2f2),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffffa2a2),
          'chart2': Color(0xfffb2c36),
          'chart3': Color(0xffe7000b),
          'chart4': Color(0xffc10007),
          'chart5': Color(0xff9f0712),
        },
      },
      'rose': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xffc70036),
          'primaryForeground': Color(0xfffff1f2),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffffa1ad),
          'chart2': Color(0xffff2056),
          'chart3': Color(0xffec003f),
          'chart4': Color(0xffc70036),
          'chart5': Color(0xffa50036),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xffa50036),
          'primaryForeground': Color(0xfffff1f2),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffffa1ad),
          'chart2': Color(0xffff2056),
          'chart3': Color(0xffec003f),
          'chart4': Color(0xffc70036),
          'chart5': Color(0xffa50036),
        },
      },
      'sky': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff0069a8),
          'primaryForeground': Color(0xfff0f9ff),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xff74d4ff),
          'chart2': Color(0xff00a6f4),
          'chart3': Color(0xff0084d1),
          'chart4': Color(0xff0069a8),
          'chart5': Color(0xff00598a),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff00598a),
          'primaryForeground': Color(0xfff0f9ff),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xff74d4ff),
          'chart2': Color(0xff00a6f4),
          'chart3': Color(0xff0084d1),
          'chart4': Color(0xff0069a8),
          'chart5': Color(0xff00598a),
        },
      },
      'teal': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff00786f),
          'primaryForeground': Color(0xfff0fdfa),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xff46ecd5),
          'chart2': Color(0xff00bba7),
          'chart3': Color(0xff009689),
          'chart4': Color(0xff00786f),
          'chart5': Color(0xff005f5a),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff005f5a),
          'primaryForeground': Color(0xfff0fdfa),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xff46ecd5),
          'chart2': Color(0xff00bba7),
          'chart3': Color(0xff009689),
          'chart4': Color(0xff00786f),
          'chart5': Color(0xff005f5a),
        },
      },
      'violet': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xff7008e7),
          'primaryForeground': Color(0xfff5f3ff),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffc4b4ff),
          'chart2': Color(0xff8e51ff),
          'chart3': Color(0xff7f22fe),
          'chart4': Color(0xff7008e7),
          'chart5': Color(0xff5d0ec0),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xff5d0ec0),
          'primaryForeground': Color(0xfff5f3ff),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffc4b4ff),
          'chart2': Color(0xff8e51ff),
          'chart3': Color(0xff7f22fe),
          'chart4': Color(0xff7008e7),
          'chart5': Color(0xff5d0ec0),
        },
      },
      'yellow': <Brightness, Map<String, Color>>{
        Brightness.light: <String, Color>{
          'background': Color(0xffffffff),
          'foreground': Color(0xff0a0a0a),
          'card': Color(0xffffffff),
          'cardForeground': Color(0xff0a0a0a),
          'popover': Color(0xffffffff),
          'popoverForeground': Color(0xff0a0a0a),
          'primary': Color(0xfffdc700),
          'primaryForeground': Color(0xff733e0a),
          'secondary': Color(0xfff4f4f5),
          'secondaryForeground': Color(0xff18181b),
          'muted': Color(0xfff5f5f5),
          'mutedForeground': Color(0xff737373),
          'accent': Color(0xfff5f5f5),
          'accentForeground': Color(0xff171717),
          'destructive': Color(0xffe7000b),
          'border': Color(0xffe5e5e5),
          'input': Color(0xffe5e5e5),
          'ring': Color(0xffa1a1a1),
          'chart1': Color(0xffffdf20),
          'chart2': Color(0xfff0b100),
          'chart3': Color(0xffd08700),
          'chart4': Color(0xffa65f00),
          'chart5': Color(0xff894b00),
        },
        Brightness.dark: <String, Color>{
          'background': Color(0xff0a0a0a),
          'foreground': Color(0xfffafafa),
          'card': Color(0xff171717),
          'cardForeground': Color(0xfffafafa),
          'popover': Color(0xff171717),
          'popoverForeground': Color(0xfffafafa),
          'primary': Color(0xfff0b100),
          'primaryForeground': Color(0xff733e0a),
          'secondary': Color(0xff27272a),
          'secondaryForeground': Color(0xfffafafa),
          'muted': Color(0xff262626),
          'mutedForeground': Color(0xffa1a1a1),
          'accent': Color(0xff262626),
          'accentForeground': Color(0xfffafafa),
          'destructive': Color(0xffff6467),
          'border': Color(0x1affffff),
          'input': Color(0x26ffffff),
          'ring': Color(0xff737373),
          'chart1': Color(0xffffdf20),
          'chart2': Color(0xfff0b100),
          'chart3': Color(0xffd08700),
          'chart4': Color(0xffa65f00),
          'chart5': Color(0xff894b00),
        },
      },
    };

void _expectContrast(
  Color background,
  Color foreground, {
  double minimum = 4.5,
}) {
  expect(
    _contrastRatio(background, foreground),
    greaterThanOrEqualTo(minimum),
    reason: '$foreground on $background should meet $minimum:1 contrast',
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
