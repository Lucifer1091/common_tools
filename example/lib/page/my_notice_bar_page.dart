import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyNoticeBarPage extends StatelessWidget {
  const MyNoticeBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'noticeBar',
      desc:
          'Displayed below the navigation bar to show helpful messages to users.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Plain Text Notice Bar', builder: _textNoticeBar),
            ExampleItem(
              desc: 'Scrollable Notice Bar',
              builder: _scrollNoticeBar,
            ),
            ExampleItem(builder: _scrollIconNoticeBar),
            ExampleItem(desc: 'Notice Bar with Icon', builder: _iconNoticeBar),
            ExampleItem(
              desc: 'Notice Bar with Close Button',
              builder: _closeNoticeBar,
            ),
            ExampleItem(
              desc: 'Notice Bar with Action',
              builder: _entranceNoticeBar1,
            ),
            ExampleItem(builder: _entranceNoticeBar2),
            ExampleItem(
              desc: 'Custom Styled Notice Bar',
              builder: _customNoticeBar,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: 'Default Notice', builder: _normalNoticeBar),
            ExampleItem(desc: 'Success Notice', builder: _successNoticeBar),
            ExampleItem(desc: 'Warning Notice', builder: _warningNoticeBar),
            ExampleItem(desc: 'Error Notice', builder: _errorNoticeBar),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [ExampleItem(desc: 'Top of Card', builder: _cardNoticeBar)],
        ),
      ],
      test: [
        ExampleItem(desc: 'Clickable Notice Bar', builder: _tapNoticeBar),
        ExampleItem(
          desc: 'Notice Bar with Custom Left Content',
          builder: _leftNoticeBar,
        ),
        ExampleItem(
          desc: 'Vertical Scrolling Notice Bar',
          builder: _stepNoticeBar,
        ),
      ],
    );
  }
}

Widget _textNoticeBar(BuildContext context) {
  return const MyNoticeBar(content: 'This is a regular notification message');
}

Widget _scrollNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content:
        'Informational message description informational message description informational message description informational message description informational message',
    marquee: true,
    speed: 50,
  );
}

Widget _scrollIconNoticeBar(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: MyNoticeBar(
      content:
          'Informational message description informational message description informational message description informational message description informational message',
      speed: 50,
      prefixIcon: Icons.speaker_rounded,
      marquee: true,
    ),
  );
}

Widget _iconNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
  );
}

Widget _closeNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
    suffixIcon: Icons.close,
  );
}

Widget _entranceNoticeBar1(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
    right: MyButton(
      text: 'Text Button',
      type: MyButtonType.text,

      size: MyButtonSize.extraSmall,
      height: 22,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    ),
  );
}

Widget _entranceNoticeBar2(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: MyNoticeBar(
      content: 'This is a regular notification message',
      prefixIcon: Icons.cancel_rounded,
      suffixIcon: Icons.chevron_right,
    ),
  );
}

Widget _customNoticeBar(BuildContext context) {
  return MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: LucideIcons.bell,
    suffixIcon: Icons.chevron_right,
    style: MyNoticeBarStyle(backgroundColor: ThemeColors.neutral.shade200),
  );
}

Widget _normalNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
    theme: MyNoticeBarTheme.info,
  );
}

Widget _successNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
    theme: MyNoticeBarTheme.success,
  );
}

Widget _warningNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
    theme: MyNoticeBarTheme.warning,
  );
}

Widget _errorNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
    theme: MyNoticeBarTheme.error,
  );
}

Widget _cardNoticeBar(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: MyNoticeBarStyle.generateTheme().backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(9)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0d000000),
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
        BoxShadow(
          color: Color(0x0f000000),
          blurRadius: 10,
          spreadRadius: 1,
          offset: Offset(0, 8),
        ),
        BoxShadow(
          color: Color(0x1a000000),
          blurRadius: 5,
          spreadRadius: -3,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: size.width - 32,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          clipBehavior: Clip.hardEdge,
          child: const MyNoticeBar(
            content: 'This is a regular notification message',
            prefixIcon: Icons.cancel_rounded,
            suffixIcon: Icons.chevron_right,
          ),
        ),
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ],
    ),
  );
}

Widget _tapNoticeBar(BuildContext context) {
  return MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.cancel_rounded,
    suffixIcon: Icons.chevron_right,
    onTap: () {
      // TDToast.showText('tap:trigger', context: context);
    },
  );
}

Widget _leftNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    suffixIcon: Icons.chevron_right,
    left: MyButton(
      text: 'Text',
      type: MyButtonType.text,

      size: MyButtonSize.extraSmall,
      height: 22,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    ),
  );
}

Widget _stepNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: [
      'Have you not seen the Yellow River descending from the sky',
      'Rushing to the sea, never to return',
      'Have you not seen',
    ],
    direction: Axis.vertical,
    prefixIcon: Icons.speaker_rounded,
    marquee: true,
  );
}
