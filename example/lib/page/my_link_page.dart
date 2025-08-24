import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class MyLinkPage extends StatelessWidget {
  const MyLinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      desc:
          'When the function can be clearly expressed by an icon, you can use a pure icon floating button, such as: add, publish.',
      exampleCodeGroup: 'link',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Primary / Default Type',
              builder: (context) {
                return Column(
                  spacing: 8,
                  children: [
                    _basicTypeBasic(context),
                    _withUnderline(context),
                    _withPrefixIcon(context),
                    _withSuffixIcon(context),
                  ],
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              desc: 'Different Themes (Normal State)',
              builder: _buildLinkStats,
            ),
            ExampleItem(desc: 'Disabled State', builder: _buildDisabledLinks),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [ExampleItem(desc: 'Link Sizes', builder: _buildLinkSizes)],
        ),
      ],
    );
  }

  Widget _basicTypeBasic(BuildContext context) {
    return Container(
      color: context.colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.basic),
      ),
    );
  }

  List<Widget> _buildLinksWithType(MyLinkType type) {
    return [
      MyLink(
        text: type.name.sentenceCase ?? '',
        style: MyLinkStyle.primary,
        type: type,
        size: MyLinkSize.small,
      ),
      const SizedBox(height: 30, width: 80),
      MyLink(
        text: type.name.sentenceCase ?? '',
        style: MyLinkStyle.defaults,
        type: type,
        size: MyLinkSize.small,
      ),
    ];
  }

  Widget _withUnderline(BuildContext context) {
    return Container(
      color: context.colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.withUnderline),
      ),
    );
  }

  Widget _withSuffixIcon(BuildContext context) {
    return Container(
      color: context.colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.withSuffix),
      ),
    );
  }

  Widget _withPrefixIcon(BuildContext context) {
    return Container(
      color: context.colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.withPrefix),
      ),
    );
  }

  Widget _buildLinkStats(BuildContext context) {
    return _buildLinkWithStyles(context, true);
  }

  Widget _buildDisabledLinks(BuildContext context) {
    return _buildLinkWithStyles(context, false);
  }

  Column _buildLinkWithStyles(BuildContext context, bool state) {
    return Column(
      spacing: 8,
      children: [
        Container(
          color: context.colorScheme.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLinkWithTypeAndState(MyLinkStyle.primary, state),
              const SizedBox(height: 30, width: 50),
              _buildLinkWithTypeAndState(MyLinkStyle.defaults, state),
              const SizedBox(height: 30, width: 50),
              _buildLinkWithTypeAndState(MyLinkStyle.danger, state),
            ],
          ),
        ),
        Container(
          color: context.colorScheme.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLinkWithTypeAndState(MyLinkStyle.warning, state),
              const SizedBox(height: 30, width: 50),
              _buildLinkWithTypeAndState(MyLinkStyle.success, state),
            ],
          ),
        ),
      ],
    );
  }

  MyLink _buildLinkWithTypeAndState(MyLinkStyle style, bool state) {
    return MyLink(
      text: 'Jump Link',
      style: style,
      enabled: state,
      type: MyLinkType.withSuffix,
      size: MyLinkSize.small,
    );
  }

  Widget _buildLinkSizes(BuildContext context) {
    return Container(
      color: context.colorScheme.secondary,
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLinkWithSizeAndStyle(MyLinkStyle.defaults, MyLinkSize.small),
          const Gap(40),
          _buildLinkWithSizeAndStyle(MyLinkStyle.defaults, MyLinkSize.medium),
          const Gap(40),
          _buildLinkWithSizeAndStyle(MyLinkStyle.defaults, MyLinkSize.large),
        ],
      ),
    );
  }

  MyLink _buildLinkWithSizeAndStyle(MyLinkStyle style, MyLinkSize size) {
    return MyLink(
      text: '${size.name.capitalize} link',
      style: style,
      type: MyLinkType.withSuffix,
      size: size,
    );
  }
}
