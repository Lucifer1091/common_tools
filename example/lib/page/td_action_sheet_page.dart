import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class IconWithBackground extends StatelessWidget {
  final IconData icon;

  const IconWithBackground({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: ThemeColors.neutral.shade50,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
      child: Center(child: Icon(icon, size: 24.0)),
    );
  }
}

const _nums = ['一', '二', '三', '四'];
List<ActionSheetItem> _gridItems = [
  ActionSheetItem(
    label: '微信',
    icon: Image.asset('assets/img/td_action_sheet_1.png'),
    group: '分享至',
  ),
  ActionSheetItem(
    label: '朋友圈',
    icon: Image.asset('assets/img/td_action_sheet_2.png'),
    group: '分享至',
  ),
  ActionSheetItem(
    label: 'QQ',
    icon: Image.asset('assets/img/td_action_sheet_3.png'),
    group: '分享至',
  ),
  ActionSheetItem(
    label: '企业微信',
    icon: Image.asset('assets/img/td_action_sheet_4.png'),
    group: '分享至',
  ),
  ActionSheetItem(
    label: '收藏',
    icon: const IconWithBackground(icon: Icons.star),
    group: '分享至',
  ),
  ActionSheetItem(
    label: '刷新',
    icon: const IconWithBackground(icon: Icons.refresh),
    group: '分享至',
  ),
  ActionSheetItem(
    label: '下载',
    icon: const IconWithBackground(icon: Icons.download),
    group: '分享至',
  ),
  ActionSheetItem(
    label: '复制',
    icon: const IconWithBackground(icon: Icons.queue),
    group: '分享至',
  ),
];

class TDActionSheetPage extends StatelessWidget {
  const TDActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: myTitle(context),
        desc: '从底部弹出的模态框，提供和当前场景相关的操作动作，也支持提供信息输入和描述。',
        exampleCodeGroup: 'action_sheet',
        children: [
          ExampleModule(
            title: 'Component Types',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '列表型动作面板',
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      _buildBaseListActionSheet(context),
                      SizedBox(height: 16),
                      _buildDescListActionSheet(context),
                      SizedBox(height: 16),
                      _buildIconListActionSheet(context),
                      SizedBox(height: 16),
                      _buildBadgeListActionSheet(context),
                    ],
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '宫格型动作面板',
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      _buildBaseGridActionSheet(context),
                      SizedBox(height: 16),
                      _buildDescGridActionSheet(context),
                      SizedBox(height: 16),
                      _buildPaginationGridActionSheet(context),
                      SizedBox(height: 16),
                      _buildScrollGridActionSheet(context),
                      SizedBox(height: 16),
                      _buildMultiScrollGridActionSheet(context),
                      SizedBox(height: 16),
                      _buildBadgeGridActionSheet(context),
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
                ignoreCode: true,
                desc: '列表型Options状态',
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      _buildBaseListStateActionSheet(context),
                      SizedBox(height: 16),
                      _buildIconListStateActionSheet(context),
                    ],
                  );
                },
              ),
            ],
          ),
          ExampleModule(
            title: 'Component Style',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '列表型对齐方式',
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      _buildBadgeListCenterActionSheet(context),
                      SizedBox(height: 16),
                      _buildIconListCenterActionSheet(context),
                      SizedBox(height: 16),
                      _buildBadgeListLeftActionSheet(context),
                      SizedBox(height: 16),
                      _buildIconListLeftActionSheet(context),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildBaseListActionSheet(BuildContext context) {
  return MyButton(
    text: '常规列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: _nums.map((e) => ActionSheetItem(label: 'Options$e')).toList(),
      );
    },
  );
}

Widget _buildDescListActionSheet(BuildContext context) {
  return MyButton(
    text: '带描述列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: _nums.map((e) => ActionSheetItem(label: 'Options$e')).toList(),
      );
    },
  );
}

Widget _buildIconListActionSheet(BuildContext context) {
  return MyButton(
    text: '带图标列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options$e',
                icon: const Icon(Icons.dashboard_rounded),
              ),
            )
            .toList(),
      );
    },
  );
}

Widget _buildBadgeListActionSheet(BuildContext context) {
  return MyButton(
    text: '带徽标列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: [
          ActionSheetItem(
            label: 'Options一',
            badge: const MyBadge(MyBadgeType.redPoint),
          ),
          ActionSheetItem(
            label: 'Options二',
            badge: const MyBadge(MyBadgeType.message, count: 8),
          ),
          ActionSheetItem(
            label: 'Options三',
            badge: const MyBadge(MyBadgeType.message, count: 99),
          ),
          ActionSheetItem(
            label: 'Options四',
            badge: const MyBadge(MyBadgeType.message, message: '99+'),
          ),
        ],
      );
    },
  );
}

Widget _buildBaseGridActionSheet(BuildContext context) {
  return MyButton(
    text: '常规宫格',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        items: _gridItems,
      );
    },
  );
}

Widget _buildDescGridActionSheet(BuildContext context) {
  return MyButton(
    text: '带描述宫格',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        description: '动作面板描述文字',
        items: _gridItems,
      );
    },
  );
}

Widget _buildPaginationGridActionSheet(BuildContext context) {
  return MyButton(
    text: '带翻页宫格',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        showPagination: true,
        items: [
          ..._gridItems,
          ActionSheetItem(
            label: '安卓',
            icon: const IconWithBackground(icon: Icons.android),
          ),
          ActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: Icons.apple),
          ),
          ActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: Icons.chrome_reader_mode),
          ),
          ActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: Icons.star),
          ),
        ],
      );
    },
  );
}

Widget _buildScrollGridActionSheet(BuildContext context) {
  return MyButton(
    text: '多行滚动宫格',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        scrollable: true,
        items: [
          ..._gridItems,
          ActionSheetItem(
            label: '安卓',
            icon: const IconWithBackground(icon: Icons.android),
          ),
          ActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: Icons.apple),
          ),
          ActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: Icons.chrome_reader_mode),
          ),
          ActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: Icons.star),
          ),
          ActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: Icons.airplane_ticket),
          ),
        ],
      );
    },
  );
}

Widget _buildMultiScrollGridActionSheet(BuildContext context) {
  return MyButton(
    text: '带描述多行滚动宫格',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet.showGroupActionSheet(
        context,
        items: [
          ActionSheetItem(
            label: 'Allen',
            icon: Image.asset('assets/img/td_action_sheet_5.png'),
            group: '分享给好友',
          ),
          ActionSheetItem(
            label: 'Nick',
            icon: Image.asset('assets/img/td_action_sheet_6.png'),
            group: '分享给好友',
          ),
          ActionSheetItem(
            label: 'Jacky',
            icon: Image.asset('assets/img/td_action_sheet_7.png'),
            group: '分享给好友',
          ),
          ActionSheetItem(
            label: 'Eric',
            icon: Image.asset('assets/img/td_action_sheet_8.png'),
            group: '分享给好友',
          ),
          ActionSheetItem(
            label: 'Johnsc',
            icon: Image.asset('assets/img/td_action_sheet_5.png'),
            group: '分享给好友',
          ),
          ActionSheetItem(
            label: 'Kevin',
            icon: Image.asset('assets/img/td_action_sheet_6.png'),
            group: '分享给好友',
          ),
          ..._gridItems,
        ],
      );
    },
  );
}

Widget _buildBadgeGridActionSheet(BuildContext context) {
  return MyButton(
    text: '带徽标宫格型',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet.showGridActionSheet(
        context,
        items: [
          ActionSheetItem(
            label: '微信',
            icon: Image.asset('assets/img/td_action_sheet_1.png'),
            badge: const MyBadge(MyBadgeType.message, message: 'NEW'),
          ),
          ActionSheetItem(
            label: '朋友圈',
            icon: Image.asset('assets/img/td_action_sheet_2.png'),
          ),
          ActionSheetItem(
            label: 'QQ',
            icon: Image.asset('assets/img/td_action_sheet_3.png'),
          ),
          ActionSheetItem(
            label: '企业微信',
            icon: Image.asset('assets/img/td_action_sheet_4.png'),
          ),
          ActionSheetItem(
            label: '收藏',
            icon: const IconWithBackground(icon: Icons.star),
            badge: const MyBadge(MyBadgeType.redPoint),
          ),
          ActionSheetItem(
            label: '刷新',
            icon: const IconWithBackground(icon: Icons.refresh),
          ),
          ActionSheetItem(
            label: '下载',
            icon: const IconWithBackground(icon: Icons.download),
            badge: const MyBadge(MyBadgeType.message, count: 8),
          ),
          ActionSheetItem(
            label: '复制',
            icon: const IconWithBackground(icon: Icons.queue),
          ),
        ],
      );
    },
  );
}

Widget _buildBaseListStateActionSheet(BuildContext context) {
  return MyButton(
    text: '列表型Options状态',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: [
          ActionSheetItem(label: '默认Options'),
          ActionSheetItem(
            label: '自定义Options',
            textStyle: TextStyle(color: context.colorScheme.primary),
          ),
          ActionSheetItem(label: '失效Options', disabled: true),
          ActionSheetItem(
            label: '警告Options',
            textStyle: const TextStyle(color: Colors.red),
          ),
        ],
        onSelected: (item, index) {
          print('选中了：${item.label}');
        },
      );
    },
  );
}

Widget _buildIconListStateActionSheet(BuildContext context) {
  return MyButton(
    text: '列表型带图标状态',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: [
          ActionSheetItem(
            label: '默认Options',
            icon: const Icon(Icons.dashboard_rounded),
          ),
          ActionSheetItem(
            label: '自定义Options',
            icon: const Icon(Icons.dashboard_rounded),
            textStyle: TextStyle(color: context.colorScheme.primary),
          ),
          ActionSheetItem(
            label: '失效Options',
            icon: const Icon(Icons.dashboard_rounded),
            disabled: true,
          ),
          ActionSheetItem(
            label: '警告Options',
            icon: const Icon(Icons.dashboard_rounded),
            textStyle: const TextStyle(color: Colors.red),
          ),
        ],
        onSelected: (item, index) {
          print('选中了：${item.label}');
        },
      );
    },
  );
}

Widget _buildBadgeListCenterActionSheet(BuildContext context) {
  return MyButton(
    text: '居中带徽标列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: [
          ActionSheetItem(
            label: 'Options一',
            badge: const MyBadge(MyBadgeType.redPoint),
          ),
          ActionSheetItem(
            label: 'Options二',
            badge: const MyBadge(MyBadgeType.message, count: 8),
          ),
          ActionSheetItem(
            label: 'Options三',
            badge: const MyBadge(MyBadgeType.message, message: '99'),
          ),
        ],
      );
    },
  );
}

Widget _buildIconListCenterActionSheet(BuildContext context) {
  return MyButton(
    text: '居中带图标列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options$e',
                icon: const Icon(Icons.dashboard_rounded),
              ),
            )
            .toList(),
      );
    },
  );
}

Widget _buildBadgeListLeftActionSheet(BuildContext context) {
  return MyButton(
    text: '左对齐带徽标列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        align: TDActionSheetAlign.left,
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options$e',
                badge: const MyBadge(MyBadgeType.redPoint),
              ),
            )
            .toList(),
      );
    },
  );
}

Widget _buildIconListLeftActionSheet(BuildContext context) {
  return MyButton(
    text: '左对齐带图标列表',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        align: TDActionSheetAlign.left,
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options$e',
                icon: const Icon(Icons.dashboard_rounded),
              ),
            )
            .toList(),
      );
    },
  );
}
