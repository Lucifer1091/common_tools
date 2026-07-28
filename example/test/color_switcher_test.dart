import 'package:example/common_tools_catalog.dart';
import 'package:example/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('default picker includes and selects package built-in schemes', (
    tester,
  ) async {
    String selectedColor = 'none';

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MyTheme(
          data: MyThemeData(
            colorScheme: MyColorScheme.fromName('blue'),
            typography: const MyTypography.geist(),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return MyColorSwitcher(
                selectedColor: selectedColor,
                onChanged: (value) {
                  setState(() => selectedColor = value);
                },
                onClose: () {},
              );
            },
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Brown'), findsOneWidget);
    expect(find.text('Gold'), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);
    expect(
      MyColorSwitcherOption.defaults.map((option) => option.value),
      allOf([
        contains('brown'),
        contains('gold'),
        contains('black'),
        contains('mauve'),
        contains('olive'),
        contains('mist'),
        contains('taupe'),
        isNot(contains('aagsa-red')),
        isNot(contains('aagsa-gold')),
        isNot(contains('aagsa-neutral')),
      ]),
    );

    for (final value in const ['brown', 'gold', 'black']) {
      final option = find
          .ancestor(
            of: find.text(_labelFor(value)),
            matching: find.byWidgetPredicate(
              (widget) => widget.runtimeType.toString() == 'AnimatedOnTap',
            ),
          )
          .first;

      final optionWidget = tester.widget(option) as dynamic;
      (optionWidget.onTap as VoidCallback)();
      await tester.pump();

      expect(selectedColor, value);
    }
  });

  test('example app keeps blue as fresh-launch default', () {
    expect(const ThemeState().color, 'blue');
  });
}

String _labelFor(String value) {
  return value[0].toUpperCase() + value.substring(1);
}
