import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';
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
          children: [
            ExampleItem(desc: 'Top of Card', builder: _cardNoticeBar),
            ExampleItem(desc: 'Clickable Notice Bar', builder: _tapNoticeBar),
            ExampleItem(
              desc: 'Vertical Scrolling Notice Bar',
              builder: _stepNoticeBar,
            ),
          ],
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
    marquee: true,
    content:
        'Informational message description informational message description informational message description informational message description informational message',
  );
}

Widget _scrollIconNoticeBar(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: MyNoticeBar(
      prefixIcon: LucideIcons.megaphone,
      marquee: true,
      content:
          'Informational message description informational message description informational message description informational message description informational message',
    ),
  );
}

Widget _iconNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
  );
}

Widget _closeNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
    suffixIcon: Icons.close,
  );
}

Widget _entranceNoticeBar1(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
    right: MyButton(
      text: 'Text Button',
      height: 22,
      type: MyButtonType.text,
      size: MyButtonSize.extraSmall,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    ),
  );
}

Widget _entranceNoticeBar2(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: MyNoticeBar(
      content: 'This is a regular notification message',
      prefixIcon: Icons.info_rounded,
      suffixIcon: LucideIcons.chevronRight,
    ),
  );
}

Widget _customNoticeBar(BuildContext context) {
  return MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: LucideIcons.bell,
    suffixIcon: LucideIcons.chevronRight,
    style: MyNoticeBarStyle(
      context: context,
      backgroundColor: context.colorScheme.secondary,
    ),
  );
}

Widget _normalNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
    theme: MyNoticeBarTheme.info,
  );
}

Widget _successNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
    theme: MyNoticeBarTheme.success,
  );
}

Widget _warningNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
    theme: MyNoticeBarTheme.warning,
  );
}

Widget _errorNoticeBar(BuildContext context) {
  return const MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
    theme: MyNoticeBarTheme.error,
  );
}

Widget _cardNoticeBar(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: MyNoticeBarStyle.generateTheme(context: context).backgroundColor,
      borderRadius: MyBorderRadius.extraLarge,
      boxShadow: MyBoxShadows.all,
    ),
    child: Column(
      children: [
        Container(
          width: size.width - 32,
          decoration: const BoxDecoration(borderRadius: MyBorderRadius.large),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: const MyNoticeBar(
            content: 'This is a regular notification message',
            prefixIcon: Icons.info_rounded,
            suffixIcon: LucideIcons.chevronRight,
          ),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: MyBorderRadius.large,
          ),
        ),
      ],
    ),
  );
}

Widget _tapNoticeBar(BuildContext context) {
  return MyNoticeBar(
    content: 'This is a regular notification message',
    prefixIcon: Icons.info_rounded,
    suffixIcon: LucideIcons.chevronRight,
    onTap: () {
      MyToast.info(context: context, title: 'tap:trigger');
    },
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
    prefixIcon: LucideIcons.volume2,
    marquee: true,
  );
}
