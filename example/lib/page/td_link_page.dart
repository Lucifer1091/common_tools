import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class MyLinkViewPage extends StatelessWidget {
  const MyLinkViewPage({super.key});

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
            ExampleItem(desc: 'Different Themes', builder: _buildLinkStats),
            ExampleItem(
              desc: 'Disabled State',
              builder: _buildDisabledLinkStats,
            ),
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
      color: context.colorScheme.primaryForeground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.basic),
      ),
    );
  }

  List<Widget> _buildLinksWithType(MyLinkType type) {
    return [
      TDLink(
        label: type.name.sentenceCase ?? '',
        style: MyLinkStyle.primary,
        type: type,
        size: MyLinkSize.small,
      ),
      const SizedBox(height: 48, width: 80),
      TDLink(
        label: type.name.sentenceCase ?? '',
        style: MyLinkStyle.defaultStyle,
        type: type,
        size: MyLinkSize.small,
      ),
      const SizedBox(height: 16),
    ];
  }

  Widget _withUnderline(BuildContext context) {
    return Container(
      color: context.colorScheme.primaryForeground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.withUnderline),
      ),
    );
  }

  Widget _withSuffixIcon(BuildContext context) {
    return Container(
      color: context.colorScheme.primaryForeground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.withSuffix),
      ),
    );
  }

  Widget _withPrefixIcon(BuildContext context) {
    return Container(
      color: context.colorScheme.primaryForeground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLinksWithType(MyLinkType.withPrefix),
      ),
    );
  }

  Widget _buildLinkStats(BuildContext context) {
    return _buildLinkWithStyles(context, MyLinkState.normal);
  }

  Widget _buildDisabledLinkStats(BuildContext context) {
    return _buildLinkWithStyles(context, MyLinkState.disabled);
  }

  Column _buildLinkWithStyles(BuildContext context, MyLinkState state) {
    return Column(
      children: [
        Container(
          color: context.colorScheme.primaryForeground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLinkWithTypeAndState(MyLinkStyle.primary, state),
              const SizedBox(height: 48, width: 50),
              _buildLinkWithTypeAndState(MyLinkStyle.defaultStyle, state),
              const SizedBox(height: 48, width: 50),
              _buildLinkWithTypeAndState(MyLinkStyle.danger, state),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          color: context.colorScheme.primaryForeground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLinkWithTypeAndState(MyLinkStyle.warning, state),
              const SizedBox(height: 48, width: 50),
              _buildLinkWithTypeAndState(MyLinkStyle.success, state),
            ],
          ),
        ),
      ],
    );
  }

  TDLink _buildLinkWithTypeAndState(MyLinkStyle style, MyLinkState state) {
    return TDLink(
      label: 'Jump Link',
      style: style,
      state: state,
      type: MyLinkType.withSuffix,
      size: MyLinkSize.small,
    );
  }

  Widget _buildLinkSizes(BuildContext context) {
    return Container(
      color: context.colorScheme.primaryForeground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLinkWithSizeAndStyle(MyLinkStyle.primary, MyLinkSize.small),
          const SizedBox(height: 48, width: 40),
          _buildLinkWithSizeAndStyle(MyLinkStyle.primary, MyLinkSize.medium),
          const SizedBox(height: 48, width: 40),
          _buildLinkWithSizeAndStyle(MyLinkStyle.primary, MyLinkSize.large),
        ],
      ),
    );
  }

  TDLink _buildLinkWithSizeAndStyle(MyLinkStyle style, MyLinkSize size) {
    return TDLink(
      label: '${size.name.capitalize} link',
      style: style,
      state: MyLinkState.normal,
      type: MyLinkType.withSuffix,
      size: size,
    );
  }
}
