import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

const _nums = [
  '一',
  '二',
  '三',
  '四',
  '五',
  '六',
  '七',
  '八',
  '九',
  '十',
  '十一',
  '十二',
  '十三',
  '十四',
  '十五',
  '十六',
  '十七',
  '十八',
  '十九',
  '二十',
  '二一',
  '二二',
  '二三',
  '二四',
  '二五',
  '二六',
  '二七',
  '二八',
  '二九',
  '三十',
];

class TDDrawerPage extends StatelessWidget {
  const TDDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: tdTitle(context),
        desc: '用作一组平行关系页面/内容的切换器，相较于Tab，同屏可展示更多的选项数量。',
        exampleCodeGroup: 'drawer',
        navBarKey: navBarkey,
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '基础抽屉',
                builder: (BuildContext context) {
                  return _buildBaseSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带图标抽屉',
                builder: (BuildContext context) {
                  return _buildIconSimple(context);
                },
              ),
            ],
          ),
          ExampleModule(
            title: '组件样式',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '带标题抽屉',
                builder: (BuildContext context) {
                  return _buildTitleSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带底部插槽样式',
                builder: (BuildContext context) {
                  return _buildBottomSimple(context);
                },
              ),
            ],
          ),
        ],
        test: [
          ExampleItem(
            ignoreCode: true,
            desc: '自定义背景色',
            builder: (BuildContext context) {
              return _buildColorSimple(context);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildBaseSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: '基础抽屉',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
          30,
          (index) => TDDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
        onItemClick: (index, item) {
          print('drawer item被点击，index：$index，title：${item.title}');
        },
      );
    },
  );
}

Widget _buildIconSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: '带图标抽屉',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
          30,
          (index) => TDDrawerItem(
            title: '菜单${_nums[index]}',
            icon: const Icon(Icons.dashboard_rounded),
          ),
        ).toList(),
      );
    },
  );
}

Widget _buildTitleSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: '带图标抽屉',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDDrawerPlacement.left,
        items: List.generate(
          10,
          (index) => TDDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
      );
    },
  );
}

Widget _buildBottomSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: '带底部插槽样式',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDDrawerPlacement.left,
        items: List.generate(
          10,
          (index) => TDDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
        footer: const MyButton(
          text: '操作',
          type: MyButtonType.outline,
          width: double.infinity,
          size: MyButtonSize.large,
        ),
      );
    },
  );
}

Widget _buildColorSimple(BuildContext context) {
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: '自定义背景色',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        backgroundColor: ThemeColors.neutral.shade50,
        placement: TDDrawerPlacement.right,
        items: List.generate(
          10,
          (index) => TDDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
      );
    },
  );
}
