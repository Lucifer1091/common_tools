import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders compact grids without slate or gray', (tester) async {
    await _setPickerViewport(tester);

    var value = const MyThemePickerValue(
      mode: ThemeMode.system,
      baseColor: MyBaseColor.neutral,
      accentColor: null,
    );

    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            return MyThemePicker(
              selectedMode: value.mode,
              selectedBaseColor: value.baseColor,
              selectedAccentColor: value.accentColor,
              onModeChanged: (mode) {
                setState(() => value = value.copyWith(mode: mode));
              },
              onBaseColorChanged: (baseColor) {
                setState(() => value = value.copyWith(baseColor: baseColor));
              },
              onAccentColorChanged: (accentColor) {
                setState(
                  () => value = value.copyWith(
                    accentColor: accentColor,
                    clearAccentColor: accentColor == null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Slate'), findsNothing);
    expect(find.text('Gray'), findsNothing);
    expect(find.text('Base'), findsOneWidget);
    expect(find.text('Same as base'), findsOneWidget);

    for (final base in MyColorScheme.baseColors) {
      final finder = find.byKey(ValueKey('my_theme_picker.base.${base.name}'));
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(value.baseColor, base);
    }

    final sameAsBase = find.byKey(
      const ValueKey('my_theme_picker.accent.same_as_base'),
    );
    expect(sameAsBase, findsOneWidget);
    await tester.tap(sameAsBase);
    await tester.pumpAndSettle();
    expect(value.accentColor, isNull);

    for (final base in MyColorScheme.baseColors) {
      expect(
        find.byKey(ValueKey('my_theme_picker.accent.${base.name}')),
        findsNothing,
      );
    }

    for (final accent in MyThemePicker.explicitAccentColors) {
      final finder = find.byKey(
        ValueKey('my_theme_picker.accent.${accent.name}'),
      );
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(value.accentColor, accent);
    }
  });

  testWidgets('dialog returns selected grid values', (tester) async {
    await _setPickerViewport(tester);

    MyThemePickerValue? result;

    await tester.pumpWidget(
      _ThemeHarness(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                result = await MyThemePicker.showDialog(
                  context: context,
                  value: const MyThemePickerValue(
                    mode: ThemeMode.light,
                    baseColor: MyBaseColor.neutral,
                    accentColor: MyAccentColor.blue,
                  ),
                );
              },
              child: const Text('Open picker'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('my_theme_picker.base.mauve')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('my_theme_picker.accent.gold')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(
      result,
      const MyThemePickerValue(
        mode: ThemeMode.light,
        baseColor: MyBaseColor.mauve,
        accentColor: MyAccentColor.gold,
      ),
    );
  });
}

Future<void> _setPickerViewport(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(560, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTheme(
        data: MyThemeData(
          colorScheme: MyColorScheme.fromParts(
            base: MyBaseColor.neutral,
            accent: MyAccentColor.blue,
          ),
          typography: const MyTypography.geist(),
        ),
        child: Scaffold(body: child),
      ),
    );
  }
}
