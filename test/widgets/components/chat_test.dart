import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChatGroup.textStyle applies to plain Text bubbles', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: ChatGroup(
          textStyle: TextStyle(color: Colors.white, fontSize: 18),
          children: [ChatBubble(child: Text('Plain message'))],
        ),
      ),
    );

    final style = _renderedTextStyle(tester, 'Plain message');

    expect(style.color, Colors.white);
    expect(style.fontSize, 18);
  });

  testWidgets('ChatGroup.textStyle applies to MyText bubbles', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: ChatGroup(
          textStyle: TextStyle(color: Colors.yellow, fontSize: 17),
          children: [ChatBubble(child: MyText('Design-system message'))],
        ),
      ),
    );

    final style = _renderedTextStyle(tester, 'Design-system message');

    expect(style.color, Colors.yellow);
    expect(style.fontSize, 17);
  });

  testWidgets('ChatBubble.textStyle overrides group text style', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: ChatGroup(
          textStyle: TextStyle(color: Colors.white, fontSize: 18),
          children: [
            ChatBubble(
              textStyle: TextStyle(color: Colors.black, fontSize: 14),
              child: Text('Override message'),
            ),
          ],
        ),
      ),
    );

    final style = _renderedTextStyle(tester, 'Override message');

    expect(style.color, Colors.black);
    expect(style.fontSize, 14);
  });

  testWidgets('explicit Text style wins over chat text style fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: ChatGroup(
          textStyle: TextStyle(color: Colors.white, fontSize: 18),
          children: [
            ChatBubble(
              child: Text(
                'Explicit message',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );

    final style = _renderedTextStyle(tester, 'Explicit message');

    expect(style.color, Colors.green);
    expect(style.fontSize, 18);
  });

  testWidgets('ChatReaction preserves inherited bubble text style', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: ChatGroup(
          textStyle: TextStyle(color: Colors.purple, fontSize: 16),
          children: [
            ChatReaction(
              reaction: ChatReactionContainer(child: Text('!')),
              child: ChatBubble(child: Text('Reacted message')),
            ),
          ],
        ),
      ),
    );

    final style = _renderedTextStyle(tester, 'Reacted message');

    expect(style.color, Colors.purple);
    expect(style.fontSize, 16);
  });

  testWidgets('standalone self ChatReaction uses explicit end alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _reactionScenario(
          alignment: AxisAlignmentDirectional.end,
          bubbleAlignment: AxisAlignmentDirectional.end,
        ),
      ),
    );

    _expectReactionLeftOfBubble(tester);
  });

  testWidgets('standalone self reaction sits opposite the end-side tail', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: ChatReaction(
          alignment: AxisAlignmentDirectional.end,
          reaction: const SizedBox(key: _reactionKey, width: 24, height: 16),
          child: ChatBubble(
            alignment: AxisAlignmentDirectional.end,
            type: ChatBubbleType.tail.copyWith(
              position: () => AxisDirectional.end,
            ),
            child: const SizedBox(
              key: _bubbleContentKey,
              width: 80,
              height: 20,
            ),
          ),
        ),
      ),
    );

    _expectReactionLeftOfBubble(tester);
  });

  testWidgets('standalone other ChatReaction uses explicit start alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _reactionScenario(
          alignment: AxisAlignmentDirectional.start,
          bubbleAlignment: AxisAlignmentDirectional.start,
        ),
      ),
    );

    _expectReactionRightOfBubble(tester);
  });

  testWidgets('ChatReaction.corner overrides inferred alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _reactionScenario(
          alignment: AxisAlignmentDirectional.end,
          bubbleAlignment: AxisAlignmentDirectional.end,
          corner: ChatBubbleCornerDirectional.bottomEnd,
        ),
      ),
    );

    _expectReactionRightOfBubble(tester);
  });

  testWidgets('ChatReaction still uses inherited ChatGroup alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: ChatGroup(
          alignment: AxisAlignmentDirectional.start,
          children: [_reactionScenario()],
        ),
      ),
    );

    _expectReactionRightOfBubble(tester);
  });
}

const _bubbleContentKey = Key('bubble-content');
const _reactionKey = Key('reaction');

Widget _reactionScenario({
  AxisAlignmentGeometry? alignment,
  AxisAlignmentGeometry? bubbleAlignment,
  ChatBubbleCornerDirectional? corner,
}) {
  return ChatReaction(
    alignment: alignment,
    corner: corner,
    reaction: const SizedBox(key: _reactionKey, width: 24, height: 16),
    child: ChatBubble(
      alignment: bubbleAlignment,
      child: const SizedBox(key: _bubbleContentKey, width: 80, height: 20),
    ),
  );
}

void _expectReactionLeftOfBubble(WidgetTester tester) {
  expect(
    tester.getCenter(find.byKey(_reactionKey)).dx,
    lessThan(tester.getCenter(find.byKey(_bubbleContentKey)).dx),
  );
}

void _expectReactionRightOfBubble(WidgetTester tester) {
  expect(
    tester.getCenter(find.byKey(_reactionKey)).dx,
    greaterThan(tester.getCenter(find.byKey(_bubbleContentKey)).dx),
  );
}

TextStyle _renderedTextStyle(WidgetTester tester, String text) {
  final richTextFinder = find.byWidgetPredicate(
    (widget) => widget is RichText && widget.text.toPlainText() == text,
  );
  final paragraph = tester.renderObject<RenderParagraph>(richTextFinder);
  final style = paragraph.text.style;
  expect(style, isNotNull);
  return style!;
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
        child: Scaffold(
          body: SizedBox(width: 400, child: Center(child: child)),
        ),
      ),
    );
  }
}
