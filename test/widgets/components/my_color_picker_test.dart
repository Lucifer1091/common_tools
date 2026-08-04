import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('initial swatch and label render the supplied color', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: const Color(0xFF336699),
          showLabel: true,
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.text('#336699'), findsOneWidget);
  });

  testWidgets('popover opens and RGB input emits changes', (tester) async {
    Color? changed;

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: const Color(0xFF336699),
          onChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.tap(find.byType(MyButton).first);
    await _pumpPopover(tester);
    await tester.enterText(_editableIn('my-color-picker-r-input'), '12');
    await tester.pump();

    expect(_channel(changed!.r), 12);
  });

  testWidgets('dialog mode commits its draft only after Save', (tester) async {
    Color? changed;

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: const Color(0xFF336699),
          presentation: MyColorPickerPresentation.dialog,
          dialogTitle: const Text('Select Color'),
          onChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.tap(find.byType(MyButton).first);
    await tester.pumpAndSettle();
    expect(find.text('Select Color'), findsOneWidget);
    expect(
      tester
          .widget<EditableText>(_editableIn('my-color-picker-r-input'))
          .controller
          .text,
      '51',
    );

    await tester.enterText(_editableIn('my-color-picker-g-input'), '44');
    await tester.pump();

    expect(changed, isNull);
    await tester.tap(find.byKey(const Key('my-color-picker-dialog-save')));
    await tester.pumpAndSettle();

    expect(_channel(changed!.g), 44);
  });

  testWidgets('dialog Cancel discards its draft', (tester) async {
    Color? changed;

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: const Color(0xFF336699),
          presentation: MyColorPickerPresentation.dialog,
          showLabel: true,
          onChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.tap(find.byType(MyButton).first);
    await tester.pumpAndSettle();
    await tester.enterText(_editableIn('my-color-picker-r-input'), '220');
    await tester.pump();
    await tester.tap(find.byKey(const Key('my-color-picker-dialog-cancel')));
    await tester.pumpAndSettle();

    expect(changed, isNull);
    expect(find.text('#336699'), findsOneWidget);
  });

  testWidgets('mode selection keeps the compact popover open', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: const Color(0xFFE41E78),
          showAlpha: true,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(MyButton).first);
    await _pumpPopover(tester);
    await _selectMode(tester, 'HEX');

    expect(find.byKey(const Key('my-color-picker-plane')), findsOneWidget);
    expect(find.byKey(const Key('my-color-picker-hex-input')), findsOneWidget);
  });

  testWidgets('compact plane drag commits its final pointer color', (
    tester,
  ) async {
    Color? changed;
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: const Color(0xFFE41E78),
          onChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.tap(find.byType(MyButton).first);
    await _pumpPopover(tester);
    final plane = find.byKey(const Key('my-color-picker-plane'));
    final rect = tester.getRect(plane);
    final gesture = await tester.startGesture(
      rect.topLeft + const Offset(20, 20),
    );
    await gesture.moveTo(rect.bottomRight - const Offset(20, 20));
    await gesture.up();
    await tester.pump();

    final hsv = HSVColor.fromColor(changed!);
    expect(hsv.saturation, greaterThan(0.8));
    expect(hsv.value, greaterThan(0.8));
  });

  testWidgets('screen picker samples a direct click without prior hover', (
    tester,
  ) async {
    Color? picked;
    await tester.pumpWidget(
      _ThemeHarness(
        child: Builder(
          builder: (context) {
            return MyButton(
              text: 'Pick',
              onTap: () async {
                picked = await MyColorPicker.pickColorFromScreen(context);
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Pick'));
    for (var attempt = 0; attempt < 20; attempt++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      if (find
          .byKey(const Key('my-eye-dropper-active-layer'))
          .evaluate()
          .isNotEmpty) {
        break;
      }
    }
    expect(
      find.byKey(const Key('my-eye-dropper-active-layer')),
      findsOneWidget,
    );
    await tester.tapAt(const Offset(500, 400));
    await tester.pumpAndSettle();

    expect(picked, isNotNull);
  });

  testWidgets('RGB, HSL, HSV, and HEX inputs update and clamp values', (
    tester,
  ) async {
    Color changed = const Color(0xFF336699);

    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            return MyColorPicker(
              value: changed,
              presentation: MyColorPickerPresentation.inline,
              initialMode: MyColorPickerMode.rgb,
              showAlpha: true,
              onChanged: (value) => setState(() => changed = value),
            );
          },
        ),
      ),
    );

    await tester.enterText(_editableIn('my-color-picker-r-input'), '999');
    await tester.pump();
    expect(_channel(changed.r), 255);

    await _selectMode(tester, 'HSL');
    await tester.enterText(_editableIn('my-color-picker-hsl-l-input'), '0');
    await tester.pump();
    expect(HSLColor.fromColor(changed).lightness, 0);

    await _selectMode(tester, 'HSV');
    await tester.enterText(_editableIn('my-color-picker-hsv-v-input'), '100');
    await tester.pump();
    expect(HSVColor.fromColor(changed).value, 1);

    await _selectMode(tester, 'HEX');
    await tester.enterText(_editableIn('my-color-picker-hex-input'), '#00FF00');
    await tester.pump();
    expect(_channel(changed.g), 255);
  });

  testWidgets('switching mode updates the input set and color plane behavior', (
    tester,
  ) async {
    Color changed = Colors.blue;

    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            return MyColorPicker(
              value: changed,
              presentation: MyColorPickerPresentation.inline,
              onChanged: (value) => setState(() => changed = value),
            );
          },
        ),
      ),
    );

    expect(find.byKey(const Key('my-color-picker-r-input')), findsOneWidget);
    await _selectMode(tester, 'HSL');
    expect(
      find.byKey(const Key('my-color-picker-hsl-l-input')),
      findsOneWidget,
    );

    await tester.tapAt(
      tester.getCenter(find.byKey(const Key('my-color-picker-plane'))),
    );
    await tester.pump();
    expect(HSLColor.fromColor(changed).saturation, closeTo(0.5, 0.08));
  });

  testWidgets('alpha input preserves transparency when enabled', (
    tester,
  ) async {
    Color? changed;

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: const Color(0xFF336699),
          presentation: MyColorPickerPresentation.inline,
          showAlpha: true,
          onChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.enterText(_editableIn('my-color-picker-a-input'), '128');
    await tester.pump();

    expect(_channel(changed!.a), 128);
  });

  testWidgets('disabled picker does not open', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyColorPicker(
          value: Colors.blue,
          enabled: false,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(MyButton).first);
    await _pumpPopover(tester);

    expect(find.byKey(const Key('my-color-picker-r-input')), findsNothing);
  });

  testWidgets('history records colors, deduplicates, and respects capacity', (
    tester,
  ) async {
    final history = MyColorHistoryController(capacity: 2);
    addTearDown(history.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        historyController: history,
        child: MyColorPicker(
          value: const Color(0xFF000000),
          presentation: MyColorPickerPresentation.inline,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.enterText(_editableIn('my-color-picker-r-input'), '10');
    await tester.pump();
    await tester.enterText(_editableIn('my-color-picker-g-input'), '20');
    await tester.pump();
    await tester.enterText(_editableIn('my-color-picker-r-input'), '10');
    await tester.pump();

    expect(history.recentColors.length, 2);
    expect(history.recentColors.toSet().length, 2);

    await tester.tap(find.byKey(const Key('my-color-picker-history-toggle')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('my-color-picker-history-grid')),
      findsOneWidget,
    );
  });

  testWidgets('form field integrates with MyForm values', (tester) async {
    final formKey = GlobalKey<MyFormState>();

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyForm(
          key: formKey,
          child: MyColorPickerFormField(
            id: 'brand',
            initialValue: const Color(0xFF000000),
            presentation: MyColorPickerPresentation.inline,
          ),
        ),
      ),
    );

    await tester.enterText(_editableIn('my-color-picker-r-input'), '64');
    await tester.pump();

    final value = formKey.currentState!.value['brand'] as Color;
    expect(_channel(value.r), 64);
  });
}

Finder _editableIn(String key) {
  return find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(EditableText),
  );
}

Future<void> _selectMode(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(const Key('my-color-picker-mode-select')));
  await _pumpPopover(tester);
  await tester.tap(find.text(label).last);
  await _pumpPopover(tester);
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

int _channel(double value) => (value * 255).round().clamp(0, 255);

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({required this.child, this.historyController});

  final Widget child;
  final MyColorHistoryController? historyController;

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
        child: MyRecentColorsScope(
          controller: historyController,
          child: MyEyeDropperLayer(
            child: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: 380, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
