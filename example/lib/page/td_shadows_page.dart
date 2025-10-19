import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

/// 圆角示例页面
class TDShadowsPage extends StatelessWidget {
  const TDShadowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.primaryForeground,
      title: myTitle(context),
      exampleCodeGroup: 'shadows',
      children: [
        ExampleModule(
          title: '投影',
          children: [
            ExampleItem(desc: '基础投影', builder: _buildShadowsBase),
            ExampleItem(desc: '中层投影', builder: _buildShadowsMiddle),
            ExampleItem(desc: '上层投影', builder: _buildShadowsTop),
          ],
        ),
      ],
    );
  }

  Widget _buildShadowsBase(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryForeground,
        boxShadow: MyBoxShadows.base,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
    );
  }

  Widget _buildShadowsMiddle(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryForeground,
        boxShadow: MyBoxShadows.middle,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
    );
  }

  Widget _buildShadowsTop(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryForeground,
        boxShadow: MyBoxShadows.top,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
    );
  }
}
