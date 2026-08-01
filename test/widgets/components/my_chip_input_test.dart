import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  group('MyChipEditingController', () {
    test('initializes chips, duplicates, document order, and plain text', () {
      final controller = MyChipEditingController<String>(
        text: 'tail',
        initialChips: const ['one', 'one', 'two'],
      );
      addTearDown(controller.dispose);

      expect(controller.chips, ['one', 'one', 'two']);
      expect(controller.plainText, 'tail');
      expect(controller.text.length, 7);
    });

    test('textAtCursor uses chip boundaries and handles selections', () {
      final controller = MyChipEditingController<String>(
        text: 'hello world',
        initialChips: const ['left'],
      )..appendChip('right');
      addTearDown(controller.dispose);

      controller.selection = const TextSelection.collapsed(offset: 6);
      expect(controller.textAtCursor, 'hello world');

      controller.selection = const TextSelection(
        baseOffset: 1,
        extentOffset: 6,
      );
      expect(controller.textAtCursor, 'hello');

      controller.selection = const TextSelection.collapsed(offset: -1);
      expect(controller.textAtCursor, isEmpty);
    });

    test(
      'supports insert, append, replace, set, remove, and clear operations',
      () {
        final controller = MyChipEditingController<String>(text: 'draft');
        addTearDown(controller.dispose);

        controller.selection = const TextSelection.collapsed(offset: 2);
        expect(
          controller.insertChipAtCursor((text) => 'submitted:$text'),
          isTrue,
        );
        expect(controller.chips, ['submitted:draft']);
        expect(controller.plainText, isEmpty);

        controller.appendChip('last');
        controller.insertChip('first');
        controller.appendChipAtCursor('cursor');
        expect(controller.chips, [
          'first',
          'cursor',
          'submitted:draft',
          'last',
        ]);

        expect(controller.removeChip('submitted:draft'), isTrue);
        expect(controller.removeChipAt(1), isTrue);
        expect(controller.chips, ['first', 'last']);

        controller.chips = const ['reset', 'reset'];
        expect(controller.chips, ['reset', 'reset']);
        controller.value = controller.value.copyWith(
          text: '${controller.text}typing',
          selection: TextSelection.collapsed(
            offset: controller.text.length + 'typing'.length,
          ),
        );
        controller.clearTextAtCursor();
        expect(controller.plainText, isEmpty);

        controller.removeAllChips();
        expect(controller.chips, isEmpty);
        expect(controller.plainText, isEmpty);
      },
    );

    test('rejected chip conversion preserves the active text', () {
      final controller = MyChipEditingController<String>(text: 'keep me');
      addTearDown(controller.dispose);

      expect(controller.insertChipAtCursor((text) => null), isFalse);
      expect(controller.plainText, 'keep me');
      expect(controller.chips, isEmpty);
    });

    test('listeners observe the reconciled chip list', () {
      final controller = MyChipEditingController<String>(
        initialChips: const ['one'],
      );
      addTearDown(controller.dispose);
      List<String>? observed;
      controller.addListener(() => observed = controller.chips);

      controller.appendChip('two');
      expect(observed, ['one', 'two']);

      controller.selection = const TextSelection(
        baseOffset: 0,
        extentOffset: 1,
      );
      controller.replaceSelectionWithSpans(const []);
      expect(observed, ['two']);
    });

    test('selection spans can round-trip mixed text and chips', () {
      final controller = MyChipEditingController<String>(
        text: 'tail',
        initialChips: const ['one'],
      );
      addTearDown(controller.dispose);
      final spans = controller.getSelectionSpans(
        TextSelection(baseOffset: 0, extentOffset: controller.text.length),
      );

      final target = MyChipEditingController<String>();
      addTearDown(target.dispose);
      target.replaceSelectionWithSpans(spans);

      expect(target.chips, ['one']);
      expect(target.plainText, 'tail');
    });
  });

  group('chip clipboard handlers', () {
    test('default handler serializes adjacent chips and plain text', () {
      const handler = MyDefaultChipClipboardHandler<String>(
        chipSeparator: ', ',
      );
      final value = handler.serializeClipboard(const [
        MyChipSpan<String>(value: 'one', child: SizedBox()),
        MyChipSpan<String>(value: 'two', child: SizedBox()),
        TextSpan(text: ' tail'),
      ]);

      expect(value, 'one, two tail');
      expect(handler.deserializeClipboard(value).single, isA<TextSpan>());
    });

    test('decorated handler round-trips delimiters and escaping', () {
      const handler = MyDecoratedChipClipboardHandler<String>(
        prefix: '@',
        delimiter: ';',
        chipDeserializer: _identity,
      );
      const chips = ['hello world', '@inside;slash\\'];
      final serialized = handler.serializeClipboard([
        MyChipSpan<String>(value: chips[0], child: const SizedBox()),
        MyChipSpan<String>(value: chips[1], child: const SizedBox()),
      ]);
      final deserialized = handler.deserializeClipboard(serialized);

      expect(
        deserialized.whereType<MyChipSpan<String>>().map((span) => span.value),
        chips,
      );
    });

    test('decorated handler preserves mixed text with suffix tokens', () {
      const handler = MyDecoratedChipClipboardHandler<String>(
        prefix: r'${',
        suffix: '}',
        chipDeserializer: _identity,
        escapeNonChip: true,
      );
      final serialized = handler.serializeClipboard(const [
        TextSpan(text: 'before '),
        MyChipSpan<String>(value: 'name', child: SizedBox()),
        TextSpan(text: ' after'),
      ]);
      final spans = handler.deserializeClipboard(serialized);

      expect(serialized, r'before ${name} after');
      expect(spans.whereType<MyChipSpan<String>>().single.value, 'name');
    });
  });

  testWidgets('renders chips and close removes the exact occurrence once', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>(
      initialChips: const ['one', 'one'],
    );
    final changes = <List<String>>[];
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          onChipSubmitted: _identity,
          onChipsChanged: (chips) => changes.add(chips),
          chipBuilder: (context, chip) => Text('chip:$chip'),
        ),
      ),
    );

    expect(find.text('chip:one'), findsNWidgets(2));
    final closeButtons = find.byWidgetPredicate(
      (widget) => widget is MyButton && widget.icon == LucideIcons.x,
    );
    await tester.tap(closeButtons.first);
    await tester.pump();

    expect(controller.chips, ['one']);
    expect(changes, [
      ['one'],
    ]);
  });

  testWidgets('custom wrapper and useChips false are honored', (tester) async {
    final controller = MyChipEditingController<String>(
      initialChips: const ['one'],
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          onChipSubmitted: _identity,
          chipBuilder: (context, chip) => Text(chip),
          chipWrapperBuilder: (context, chip, child, onDeleted) {
            return GestureDetector(
              key: const ValueKey('custom-wrapper'),
              onTap: onDeleted,
              child: child,
            );
          },
        ),
      ),
    );
    expect(find.byKey(const ValueKey('custom-wrapper')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('custom-wrapper')));
    await tester.pump();
    expect(controller.chips, isEmpty);

    controller.appendChip('plain');
    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          useChips: false,
          onChipSubmitted: _identity,
          chipBuilder: (context, chip) => Text('plain:$chip'),
        ),
      ),
    );
    expect(find.text('plain:plain'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is MyButton && widget.icon == LucideIcons.x,
      ),
      findsNothing,
    );
  });

  testWidgets('Enter submits the active token and retains focus', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>(text: 'hello world');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          focusNode: focusNode,
          onChipSubmitted: (value) => value.toUpperCase(),
          chipBuilder: (context, chip) => Text(chip),
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(controller.chips, ['HELLO WORLD']);
    expect(controller.plainText, isEmpty);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('rejected Enter submission preserves the active token', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>(text: 'keep me');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          focusNode: focusNode,
          onChipSubmitted: (_) => null,
          chipBuilder: (context, chip) => Text(chip),
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(controller.chips, isEmpty);
    expect(controller.plainText, 'keep me');
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('Backspace removes a chip and reports the updated list', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>(
      initialChips: const ['one'],
    );
    final focusNode = FocusNode();
    List<String>? changed;
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          focusNode: focusNode,
          onChipSubmitted: _identity,
          onChipsChanged: (chips) => changed = chips,
          chipBuilder: (context, chip) => Text(chip),
        ),
      ),
    );
    controller.selection = const TextSelection.collapsed(offset: 1);
    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    expect(controller.chips, isEmpty);
    expect(changed, isEmpty);
  });

  testWidgets('autocomplete inserts a chip without intermediate text', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>(text: 'he');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _harness(
        MyAutoComplete(
          controller: controller,
          suggestions: const ['hello world'],
          child: MyChipInput<String>(
            controller: controller,
            focusNode: focusNode,
            onChipSubmitted: _identity,
            chipBuilder: (context, chip) => Text('chip:$chip'),
          ),
        ),
      ),
    );
    focusNode.requestFocus();
    await _pumpPopover(tester);
    await tester.tap(find.text('hello world'));
    await _pumpPopover(tester);

    expect(controller.chips, ['hello world']);
    expect(controller.plainText, isEmpty);
    expect(find.text('chip:hello world'), findsOneWidget);
  });

  testWidgets('keyboard autocomplete acceptance creates one chip', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>(text: 'he');
    final focusNode = FocusNode();
    final changes = <List<String>>[];
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _harness(
        MyAutoComplete(
          controller: controller,
          suggestions: const ['hello world'],
          child: MyChipInput<String>(
            controller: controller,
            focusNode: focusNode,
            onChipSubmitted: _identity,
            onChipsChanged: (chips) => changes.add(chips),
            chipBuilder: (context, chip) => Text(chip),
          ),
        ),
      ),
    );
    focusNode.requestFocus();
    await _pumpPopover(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpPopover(tester);

    expect(controller.chips, ['hello world']);
    expect(controller.plainText, isEmpty);
    expect(changes, [
      ['hello world'],
    ]);
  });

  testWidgets('autoInsertSuggestion false preserves normal autocomplete', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>(text: 'he');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _harness(
        MyAutoComplete(
          controller: controller,
          suggestions: const ['hello world'],
          child: MyChipInput<String>(
            controller: controller,
            focusNode: focusNode,
            autoInsertSuggestion: false,
            onChipSubmitted: _identity,
            chipBuilder: (context, chip) => Text(chip),
          ),
        ),
      ),
    );
    focusNode.requestFocus();
    await _pumpPopover(tester);
    await tester.tap(find.text('hello world'));
    await _pumpPopover(tester);

    expect(controller.chips, isEmpty);
    expect(controller.plainText, 'hello world');
  });

  testWidgets('clipboard shortcuts copy, cut, and paste decorated chips', (
    tester,
  ) async {
    String? clipboardText;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      switch (call.method) {
        case 'Clipboard.setData':
          clipboardText =
              (call.arguments as Map<Object?, Object?>)['text'] as String?;
          return null;
        case 'Clipboard.getData':
          return clipboardText == null ? null : {'text': clipboardText};
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
    final controller = MyChipEditingController<String>(
      initialChips: const ['one', 'two'],
    );
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          focusNode: focusNode,
          clipboardHandler: const MyDecoratedChipClipboardHandler<String>(
            prefix: '@',
            delimiter: ';',
            chipDeserializer: _identity,
          ),
          onChipSubmitted: _identity,
          chipBuilder: (context, chip) => Text(chip),
        ),
      ),
    );
    focusNode.requestFocus();
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
    await tester.pump();
    await _sendControlShortcut(tester, LogicalKeyboardKey.keyC);
    final copied = await Clipboard.getData(Clipboard.kTextPlain);
    expect(copied?.text, '@one;@two');

    await _sendControlShortcut(tester, LogicalKeyboardKey.keyX);
    await tester.pump();
    expect(controller.chips, isEmpty);

    await Clipboard.setData(const ClipboardData(text: '@three;@four'));
    await _sendControlShortcut(tester, LogicalKeyboardKey.keyV);
    await tester.pump();
    expect(controller.chips, ['three', 'four']);
  });

  testWidgets('external controller remains usable after widget disposal', (
    tester,
  ) async {
    final controller = MyChipEditingController<String>();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(
        MyChipInput<String>(
          controller: controller,
          onChipSubmitted: _identity,
          chipBuilder: (context, chip) => Text(chip),
        ),
      ),
    );
    await tester.pumpWidget(_harness(const SizedBox()));

    controller.appendChip('still alive');
    expect(controller.chips, ['still alive']);
  });

  testWidgets('replacing an external controller detaches the old one', (
    tester,
  ) async {
    final first = MyChipEditingController<String>();
    final second = MyChipEditingController<String>();
    addTearDown(first.dispose);
    addTearDown(second.dispose);

    Widget build(MyChipEditingController<String> controller) {
      return _harness(
        MyChipInput<String>(
          controller: controller,
          onChipSubmitted: _identity,
          chipBuilder: (context, chip) => Text('chip:$chip'),
        ),
      );
    }

    await tester.pumpWidget(build(first));
    first.appendChip('first');
    await tester.pump();
    expect(find.text('chip:first'), findsOneWidget);

    await tester.pumpWidget(build(second));
    first.appendChip('detached');
    second.appendChip('second');
    await tester.pump();

    expect(first.chips, ['first', 'detached']);
    expect(second.chips, ['second']);
    expect(find.text('chip:first'), findsNothing);
    expect(find.text('chip:detached'), findsNothing);
    expect(find.text('chip:second'), findsOneWidget);
  });
}

String _identity(String value) => value;

Future<void> _sendControlShortcut(
  WidgetTester tester,
  LogicalKeyboardKey key,
) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyEvent(key);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pump();
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

Widget _harness(Widget child) {
  return MaterialApp(
    home: MyTheme(
      data: MyThemeData(
        colorScheme: MyColorScheme.fromParts(
          base: MyBaseColor.neutral,
          accent: MyAccentColor.blue,
        ),
        typography: const MyTypography.geist(),
      ),
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: 420, child: child),
        ),
      ),
    ),
  );
}
