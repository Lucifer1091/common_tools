import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

/// 圆角示例页面
class TDRadiusPage extends StatelessWidget {
  const TDRadiusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'radius',
      children: [
        ExampleModule(
          title: '数值型',
          children: [
            ExampleItem(desc: '3px 极小组件圆角', builder: _buildRadiusSmall),
            ExampleItem(desc: '6px 组件圆角', builder: _buildRadiusDefault),
            ExampleItem(desc: '9px 卡片圆角', builder: _buildRadiusLarge),
            ExampleItem(desc: '12px 面板圆角', builder: _buildRadiusExtraLarge),
          ],
        ),
        ExampleModule(
          title: '特殊',
          children: [ExampleItem(desc: '胶囊型', builder: _buildRadiusRound)],
        ),
      ],
    );
  }

  Widget _buildRadiusSmall(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: MyBorderRadius.small,
      ),
    );
  }

  Widget _buildRadiusDefault(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
    );
  }

  Widget _buildRadiusLarge(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: MyBorderRadius.large,
      ),
    );
  }

  Widget _buildRadiusExtraLarge(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: MyBorderRadius.extraLarge,
      ),
    );
  }

  Widget _buildRadiusRound(BuildContext context) {
    // 胶囊型，数值设置较大
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: MyBorderRadius.round,
      ),
    );
  }
}
