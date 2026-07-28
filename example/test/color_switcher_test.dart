import 'package:example/common_tools_catalog.dart';
import 'package:example/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('theme picker selects mode, base, and accent options', (
    tester,
  ) async {
    var value = const ThemeState().pickerValue;

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1200);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: MyTheme(
          data: MyThemeData(
            colorScheme: MyColorScheme.fromParts(
              base: MyBaseColor.neutral,
              accent: MyAccentColor.blue,
            ),
            typography: const MyTypography.geist(),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: MyThemePicker(
                    selectedMode: value.mode,
                    selectedBaseColor: value.baseColor,
                    selectedAccentColor: value.accentColor,
                    onModeChanged: (mode) {
                      setState(() => value = value.copyWith(mode: mode));
                    },
                    onBaseColorChanged: (baseColor) {
                      setState(
                        () => value = value.copyWith(baseColor: baseColor),
                      );
                    },
                    onAccentColorChanged: (accentColor) {
                      setState(
                        () => value = value.copyWith(
                          accentColor: accentColor,
                          clearAccentColor: accentColor == null,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Slate'), findsNothing);
    expect(find.text('Gray'), findsNothing);
    expect(
      find.byKey(const ValueKey('my_theme_picker.accent.same_as_base')),
      findsOneWidget,
    );
    expect(find.text('Base'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('my_theme_picker.accent.neutral')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('my_theme_picker.accent.blue')),
      findsOneWidget,
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('my_theme_picker.base.taupe')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('my_theme_picker.accent.gold')));
    await tester.pumpAndSettle();

    expect(value.mode, ThemeMode.dark);
    expect(value.baseColor, MyBaseColor.taupe);
    expect(value.accentColor, MyAccentColor.gold);
  });

  test(
    'example app keeps neutral base with blue accent as fresh-launch default',
    () {
      const state = ThemeState();

      expect(state.mode, ThemeMode.light);
      expect(state.baseColor, MyBaseColor.neutral);
      expect(state.accentColor, MyAccentColor.blue);
      expect(
        state.colorScheme().primary,
        MyColorScheme.fromName('blue').primary,
      );
    },
  );
}
