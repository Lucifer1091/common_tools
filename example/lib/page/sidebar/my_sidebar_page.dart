import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MySideBarPage extends StatefulWidget {
  const MySideBarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySideBarPageState();
  }
}

class MySideBarPageState extends State<MySideBarPage> {
  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'sideBar',
      desc: '用于内容分类后的展示切换。',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: '侧边导航用法',
              ignoreCode: true,
              builder: _buildNavigatorSideBar,
            ),
            ExampleItem(
              desc: '图标侧边导航',
              builder: _buildIconSideBar,
              methodName: '_buildIconSideBar',
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              desc: '侧边导航样式',
              ignoreCode: true,
              builder: _buildStyleSideBar,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: '延迟加载', ignoreCode: true, builder: _loadingSideBar),
      ],
    );
  }

  Widget _buildNavigatorSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          getCustomButton(context, '锚点用法', 'SideBarAnchor'),

          const SizedBox(height: 16),

          getCustomButton(context, '切页用法', 'SideBarPagination'),
        ],
      ),
    );
  }

  Widget _buildIconSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [getCustomButton(context, '带图标侧边导航', 'SideBarIcon')],
      ),
    );
  }

  Widget _buildStyleSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          getCustomButton(context, '非通栏选项样式', 'SideBarOutline'),

          const SizedBox(height: 16),
          getCustomButton(context, '自定义样式', 'SideBarCustom'),
        ],
      ),
    );
  }

  Widget _loadingSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [getCustomButton(context, '延迟加载', 'SideBarLoading')],
      ),
    );
  }

  MyButton getCustomButton(
    BuildContext context,
    String text,
    String routeName,
  ) {
    return MyButton(
      text: text,
      width: MediaQuery.of(context).size.width - 16 * 2,
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      onTap: () {
        Navigator.pushNamed(
          context,
          PlatformChecker.isWeb ? routeName : '$routeName',
        );
      },
    );
  }
}
