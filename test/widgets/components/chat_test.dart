import 'dart:math';

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
        child: MyChatGroup(
          textStyle: TextStyle(color: Colors.white, fontSize: 18),
          children: [MyChatBubble(child: Text('Plain message'))],
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
        child: MyChatGroup(
          textStyle: TextStyle(color: Colors.yellow, fontSize: 17),
          children: [MyChatBubble(child: MyText('Design-system message'))],
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
        child: MyChatGroup(
          textStyle: TextStyle(color: Colors.white, fontSize: 18),
          children: [
            MyChatBubble(
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
        child: MyChatGroup(
          textStyle: TextStyle(color: Colors.white, fontSize: 18),
          children: [
            MyChatBubble(
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
        child: MyChatGroup(
          textStyle: TextStyle(color: Colors.purple, fontSize: 16),
          children: [
            MyChatReaction(
              reaction: MyChatReactionContainer(child: Text('!')),
              child: MyChatBubble(child: Text('Reacted message')),
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
        child: _tightLane(
          _reactionScenario(
            alignment: AxisAlignmentDirectional.end,
            bubbleAlignment: AxisAlignmentDirectional.end,
            tailPosition: AxisDirectional.end,
          ),
        ),
      ),
    );

    _expectEndAlignedReaction(tester);
  });

  testWidgets('standalone self reaction sits opposite the end-side tail', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _tightLane(
          MyChatReaction(
            alignment: AxisAlignmentDirectional.end,
            reaction: const SizedBox(key: _reactionKey, width: 24, height: 16),
            child: MyChatBubble(
              key: _bubbleKey,
              alignment: AxisAlignmentDirectional.end,
              type: MyChatBubbleType.tail.copyWith(
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
      ),
    );

    _expectEndAlignedReaction(tester);
  });

  testWidgets('standalone other ChatReaction uses explicit start alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _tightLane(
          _reactionScenario(
            alignment: AxisAlignmentDirectional.start,
            bubbleAlignment: AxisAlignmentDirectional.start,
            tailPosition: AxisDirectional.start,
          ),
        ),
      ),
    );

    _expectStartAlignedReaction(tester);
  });

  testWidgets('ChatReaction.corner overrides inferred alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _tightLane(
          _reactionScenario(
            alignment: AxisAlignmentDirectional.end,
            bubbleAlignment: AxisAlignmentDirectional.end,
            corner: MyChatBubbleCornerDirectional.bottomEnd,
            tailPosition: AxisDirectional.end,
          ),
        ),
      ),
    );

    final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
    final reactionRect = tester.getRect(find.byKey(_reactionKey));
    expect(reactionRect.right, moreOrLessEquals(bubbleRect.right - 12));
  });

  testWidgets('ChatReaction still uses inherited ChatGroup alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _tightLane(
          MyChatGroup(
            alignment: AxisAlignmentDirectional.start,
            type: MyChatBubbleType.tail.copyWith(
              position: () => AxisDirectional.start,
            ),
            children: [_reactionScenario()],
          ),
        ),
      ),
    );

    _expectStartAlignedReaction(tester);
  });

  testWidgets('directional end reaction mirrors in RTL', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        textDirection: TextDirection.rtl,
        child: _tightLane(
          _reactionScenario(
            alignment: AxisAlignmentDirectional.end,
            bubbleAlignment: AxisAlignmentDirectional.end,
            tailPosition: AxisDirectional.end,
          ),
        ),
      ),
    );

    _expectStartAlignedReaction(tester);
  });

  testWidgets('wide reaction expands a short bubble by extraWidth', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _tightLane(
          _reactionScenario(
            alignment: AxisAlignmentDirectional.end,
            bubbleAlignment: AxisAlignmentDirectional.end,
            tailPosition: AxisDirectional.end,
            reactionWidth: 140,
            bubbleContentWidth: 20,
            extraWidth: 10,
          ),
        ),
      ),
    );

    final laneRect = tester.getRect(find.byKey(_laneKey));
    final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
    final reactionRect = tester.getRect(find.byKey(_reactionKey));
    expect(bubbleRect.width, moreOrLessEquals(150));
    expect(reactionRect.left, moreOrLessEquals(bubbleRect.left + 12));
    expect(
      max(bubbleRect.right, reactionRect.right),
      moreOrLessEquals(laneRect.right),
    );
  });

  testWidgets('long reacted bubble stays within the available width', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _tightLane(
          _reactionScenario(
            alignment: AxisAlignmentDirectional.end,
            bubbleAlignment: AxisAlignmentDirectional.end,
            tailPosition: AxisDirectional.end,
            bubbleContentWidth: 500,
          ),
        ),
      ),
    );

    final laneRect = tester.getRect(find.byKey(_laneKey));
    final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
    expect(bubbleRect.width, lessThanOrEqualTo(laneRect.width));
    expect(bubbleRect.left, greaterThanOrEqualTo(laneRect.left));
    expect(bubbleRect.right, lessThanOrEqualTo(laneRect.right));
  });
}

const _laneKey = Key('reaction-lane');
const _bubbleKey = Key('bubble');
const _bubbleContentKey = Key('bubble-content');
const _reactionKey = Key('reaction');

Widget _tightLane(Widget child) {
  return SizedBox(key: _laneKey, width: 320, child: child);
}

Widget _reactionScenario({
  AxisAlignmentGeometry? alignment,
  AxisAlignmentGeometry? bubbleAlignment,
  MyChatBubbleCornerDirectional? corner,
  AxisDirectional? tailPosition,
  double reactionWidth = 24,
  double bubbleContentWidth = 80,
  double? extraWidth,
}) {
  return MyChatReaction(
    alignment: alignment,
    corner: corner,
    extraWidth: extraWidth,
    reaction: SizedBox(key: _reactionKey, width: reactionWidth, height: 16),
    child: MyChatBubble(
      key: _bubbleKey,
      alignment: bubbleAlignment,
      type: tailPosition == null
          ? null
          : MyChatBubbleType.tail.copyWith(position: () => tailPosition),
      child: SizedBox(
        key: _bubbleContentKey,
        width: bubbleContentWidth,
        height: 20,
      ),
    ),
  );
}

void _expectEndAlignedReaction(
  WidgetTester tester, {
  double expectedInset = 12,
}) {
  final laneRect = tester.getRect(find.byKey(_laneKey));
  final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
  final contentRect = tester.getRect(find.byKey(_bubbleContentKey));
  final reactionRect = tester.getRect(find.byKey(_reactionKey));

  expect(bubbleRect.width, lessThan(laneRect.width));
  expect(bubbleRect.right, moreOrLessEquals(laneRect.right));
  expect(reactionRect.left, moreOrLessEquals(bubbleRect.left + expectedInset));
  expect(reactionRect.right, greaterThan(contentRect.left));
}

void _expectStartAlignedReaction(WidgetTester tester) {
  final laneRect = tester.getRect(find.byKey(_laneKey));
  final bubbleRect = tester.getRect(find.byKey(_bubbleKey));
  final contentRect = tester.getRect(find.byKey(_bubbleContentKey));
  final reactionRect = tester.getRect(find.byKey(_reactionKey));

  expect(bubbleRect.width, lessThan(laneRect.width));
  expect(bubbleRect.left, moreOrLessEquals(laneRect.left));
  expect(reactionRect.right, moreOrLessEquals(bubbleRect.right - 12));
  expect(reactionRect.left, lessThan(contentRect.right));
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
  const _ThemeHarness({
    required this.child,
    this.textDirection = TextDirection.ltr,
  });

  final Widget child;
  final TextDirection textDirection;

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
          body: Directionality(
            textDirection: textDirection,
            child: SizedBox(width: 400, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}
