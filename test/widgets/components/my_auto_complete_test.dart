import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextEditingController.currentWord', () {
    test('uses the word around collapsed selections', () {
      final controller = TextEditingController(text: 'apple pie');
      addTearDown(controller.dispose);

      controller.selection = const TextSelection.collapsed(offset: 0);
      expect(controller.currentWord, 'apple');

      controller.selection = const TextSelection.collapsed(offset: 9);
      expect(controller.currentWord, 'pie');
    });

    test('handles whitespace, invalid, and ranged selections', () {
      final controller = TextEditingController(text: 'apple  pie');
      addTearDown(controller.dispose);

      controller.selection = const TextSelection.collapsed(offset: 6);
      expect(controller.currentWord, isNull);

      controller.selection = const TextSelection(
        baseOffset: 0,
        extentOffset: 5,
      );
      expect(controller.currentWord, 'apple');

      controller.selection = const TextSelection.collapsed(offset: -1);
      expect(controller.currentWord, isNull);
    });
  });

  testWidgets('external suggestions update while the input is focused', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    var suggestions = <String>[];
    late StateSetter update;
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return _field(
              child: MyAutoComplete(
                controller: controller,
                suggestions: suggestions,
                child: MyInput(controller: controller, focusNode: focusNode),
              ),
            );
          },
        ),
      ),
    );

    focusNode.requestFocus();
    await _pumpPopover(tester);
    expect(find.text('Apple'), findsNothing);

    update(() => suggestions = ['Apple', 'Apricot']);
    await _pumpPopover(tester);

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Apricot'), findsOneWidget);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('built-in filtering uses the current word and ignores case', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: _field(
          child: MyAutoComplete.filtered(
            controller: controller,
            options: const ['Apple', 'Grape', 'Banana'],
            child: MyInput(controller: controller, focusNode: focusNode),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    controller.value = const TextEditingValue(
      text: 'Choose AP',
      selection: TextSelection.collapsed(offset: 9),
    );
    await _pumpPopover(tester);

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Grape'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('empty query and empty results keep the popover closed', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: _field(
          child: MyAutoComplete.filtered(
            controller: controller,
            options: const ['Apple'],
            child: MyInput(controller: controller, focusNode: focusNode),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await _pumpPopover(tester);
    expect(find.byType(ListView).hitTestable(), findsNothing);

    controller.value = const TextEditingValue(
      text: 'zzz',
      selection: TextSelection.collapsed(offset: 3),
    );
    await _pumpPopover(tester);
    expect(find.byType(ListView).hitTestable(), findsNothing);
  });

  testWidgets(
    'pointer selection completes text and does not immediately reopen',
    (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      String? selected;
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _ThemeHarness(
          child: _field(
            child: MyAutoComplete.filtered(
              controller: controller,
              options: const ['Apple', 'Apricot'],
              onSelected: (value) => selected = value,
              child: MyInput(controller: controller, focusNode: focusNode),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      controller.value = const TextEditingValue(
        text: 'I like app',
        selection: TextSelection.collapsed(offset: 10),
      );
      await _pumpPopover(tester);
      await tester.tap(find.text('Apple'));
      await _pumpPopover(tester);

      expect(controller.text, 'I like Apple');
      expect(controller.selection, const TextSelection.collapsed(offset: 12));
      expect(controller.value.composing, TextRange.empty);
      expect(selected, 'Apple');
      expect(focusNode.hasFocus, isTrue);
      expect(find.byType(ListView).hitTestable(), findsNothing);

      controller.value = const TextEditingValue(
        text: 'I like Apple a',
        selection: TextSelection.collapsed(offset: 14),
      );
      await _pumpPopover(tester);
      expect(find.byType(ListView), findsOneWidget);
    },
  );

  for (final testCase
      in <
        ({
          MyAutoCompleteMode mode,
          TextEditingValue initial,
          String expected,
          int expectedCaret,
        })
      >[
        (
          mode: MyAutoCompleteMode.append,
          initial: const TextEditingValue(
            text: 'say ',
            selection: TextSelection.collapsed(offset: 4),
          ),
          expected: 'say Apple',
          expectedCaret: 9,
        ),
        (
          mode: MyAutoCompleteMode.replaceWord,
          initial: const TextEditingValue(
            text: 'say app now',
            selection: TextSelection.collapsed(offset: 7),
          ),
          expected: 'say Apple now',
          expectedCaret: 9,
        ),
        (
          mode: MyAutoCompleteMode.replaceAll,
          initial: const TextEditingValue(
            text: 'say app now',
            selection: TextSelection.collapsed(offset: 7),
          ),
          expected: 'Apple',
          expectedCaret: 5,
        ),
      ]) {
    testWidgets('${testCase.mode.name} applies the selected completion', (
      tester,
    ) async {
      final controller = TextEditingController.fromValue(testCase.initial);
      final focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _ThemeHarness(
          child: _field(
            child: MyAutoComplete(
              controller: controller,
              suggestions: const ['Apple'],
              mode: testCase.mode,
              child: MyInput(controller: controller, focusNode: focusNode),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await _pumpPopover(tester);
      await tester.tap(find.text('Apple'));
      await _pumpPopover(tester);

      expect(controller.text, testCase.expected);
      expect(controller.selection.extentOffset, testCase.expectedCaret);
    });
  }

  testWidgets('keyboard navigation wraps, scrolls, and accepts with Enter', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    final scrollController = ScrollController();
    final options = List.generate(20, (index) => 'Apple $index');
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    addTearDown(scrollController.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: _field(
          child: MyAutoComplete(
            controller: controller,
            suggestions: options,
            popoverConstraints: const BoxConstraints(maxHeight: 100),
            scrollController: scrollController,
            child: MyInput(controller: controller, focusNode: focusNode),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await _pumpPopover(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump(const Duration(milliseconds: 100));

    expect(scrollController.offset, greaterThan(0));

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpPopover(tester);
    expect(controller.text, 'Apple 19');
  });

  testWidgets('Tab accepts a highlighted suggestion and Escape only closes', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: _field(
          child: MyAutoComplete(
            controller: controller,
            suggestions: const ['Apple', 'Apricot'],
            child: MyInput(controller: controller, focusNode: focusNode),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await _pumpPopover(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _pumpPopover(tester);
    expect(controller.text, isEmpty);
    expect(find.byType(ListView).hitTestable(), findsNothing);

    controller.value = const TextEditingValue(
      text: 'a',
      selection: TextSelection.collapsed(offset: 1),
    );
    await _pumpPopover(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await _pumpPopover(tester);
    expect(controller.text, 'Apple');
  });

  testWidgets('custom completer and item builder are honored', (tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: _field(
          child: MyAutoComplete(
            controller: controller,
            suggestions: const ['Apple'],
            completer: (suggestion) => suggestion.toUpperCase(),
            itemBuilder: (context, suggestion, highlighted) {
              return Text('Custom $suggestion $highlighted');
            },
            child: MyInput(controller: controller, focusNode: focusNode),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await _pumpPopover(tester);
    expect(find.text('Custom Apple false'), findsOneWidget);
    await tester.tap(find.text('Custom Apple false'));
    await _pumpPopover(tester);
    expect(controller.text, 'APPLE');
  });

  testWidgets(
    'popover matches the input width and honors explicit constraints',
    (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _ThemeHarness(
          child: _field(
            width: 240,
            child: MyAutoComplete(
              controller: controller,
              suggestions: const ['Apple'],
              popoverConstraints: const BoxConstraints(maxWidth: 180),
              child: MyInput(controller: controller, focusNode: focusNode),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await _pumpPopover(tester);
      expect(
        tester
            .getSize(
              find.byKey(const ValueKey<String>('my_auto_complete.popover')),
            )
            .width,
        180,
      );
    },
  );

  testWidgets('popover matches the input width by default', (tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: _field(
          width: 240,
          child: MyAutoComplete(
            controller: controller,
            suggestions: const ['Apple'],
            child: MyInput(controller: controller, focusNode: focusNode),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await _pumpPopover(tester);
    expect(
      tester
          .getSize(
            find.byKey(const ValueKey<String>('my_auto_complete.popover')),
          )
          .width,
      240,
    );
  });

  testWidgets('outside tap and focus loss close without selecting', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    final outsideFocusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    addTearDown(outsideFocusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: Column(
          children: [
            _field(
              child: MyAutoComplete(
                controller: controller,
                suggestions: const ['Apple'],
                child: MyInput(controller: controller, focusNode: focusNode),
              ),
            ),
            const SizedBox(height: 180),
            GestureDetector(
              key: const ValueKey('outside'),
              behavior: HitTestBehavior.opaque,
              child: Focus(
                focusNode: outsideFocusNode,
                child: const SizedBox(width: 100, height: 60),
              ),
            ),
          ],
        ),
      ),
    );

    focusNode.requestFocus();
    await _pumpPopover(tester);
    outsideFocusNode.requestFocus();
    await _pumpPopover(tester);
    expect(focusNode.hasFocus, isFalse);
    expect(
      tester.widget<MyPopover>(find.byType(MyPopover)).controller!.isOpen,
      isFalse,
    );
    expect(tester.widget<MyPortal>(find.byType(MyPortal)).visible, isFalse);
    expect(find.byType(ListView).hitTestable(), findsNothing);

    focusNode.requestFocus();
    await _pumpPopover(tester);
    await tester.tap(find.byKey(const ValueKey('outside')));
    await _pumpPopover(tester);

    expect(controller.text, isEmpty);
    expect(find.byType(ListView).hitTestable(), findsNothing);
  });
}

Widget _field({required Widget child, double width = 260}) {
  return Align(
    alignment: Alignment.topCenter,
    child: SizedBox(width: width, child: child),
  );
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
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
