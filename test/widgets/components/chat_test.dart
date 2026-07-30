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
