import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

Widget? _selectedIcon;

Widget? _unSelectedIcon;

class TDBottomTabBarPage extends StatefulWidget {
  const TDBottomTabBarPage({Key? key}) : super(key: key);

  @override
  State<TDBottomTabBarPage> createState() => _TDBottomTabBarPageState();
}

class _TDBottomTabBarPageState extends State<TDBottomTabBarPage> {
  void onTapTab(BuildContext context, String tabName) {
    TDToast.showText('点击了 $tabName', context: context);
  }

  @override
  Widget build(BuildContext context) {
    _selectedIcon = Icon(
      Icons.dashboard_rounded,
      size: 20,
      color: context.colorScheme.primary,
    );
    _unSelectedIcon = Icon(
      Icons.dashboard_rounded,
      size: 20,
      color: context.colorScheme.primary,
    );
    return ExamplePage(
      title: tdTitle(),
      desc: '用于在不同功能模块之间进行快速切换，位于页面底部。',
      exampleCodeGroup: 'bottomTabBar',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              ignoreCode: true,
              desc: '纯文本标签栏',
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _textTypeTabBar(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _textTypeTabBar3tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _textTypeTabBar4tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _textTypeTabBar5tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '图标加文本标签栏',
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTextTypeTabBar(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTextTypeTabBar3tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTextTypeTabBar4tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTextTypeTabBar5tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '纯图标标签栏',
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTypeTabBar(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTypeTabBar3tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTypeTabBar4tabs(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTypeTabBar5tabs(context),
                );
              },
            ),
            ExampleItem(desc: '双层级文本标签栏', builder: _expansionPanelTypeTabBar),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              ignoreCode: true,
              desc: '弱选中标签栏',
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _weakSelectTextTabBar(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _weakSelectIconTabBar(context),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _weakSelectIconTextTabBar(context),
                );
              },
            ),
            ExampleItem(desc: '悬浮胶囊标签栏', builder: _capsuleTabBar),
          ],
        ),
        ExampleModule(
          title: '组件事件',
          children: [
            ExampleItem(desc: '长按触发', builder: _capsuleTabBarOnLongPress),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: '自定义上边线样式', builder: _buildCustomTopStyle),
        ExampleItem(desc: '自定义选择的背景颜色', builder: _customBgColor),
        ExampleItem(
          ignoreCode: true,
          desc: '设置文本标签栏背景',
          builder: (context) {
            return _customBgTypeTabBar(context);
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '外部设置tabbar的选中项',
          builder: (context) {
            return _setCurrentIndexToTabBar(context);
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: 'icon默认大小底部文字不溢出',
          builder: (context) {
            return _iconTextTypeTabBarOverflow(context);
          },
        ),
        ExampleItem(desc: 'onTap支持重复触发', builder: _allowMultipleTaps),
        ExampleItem(desc: '支持水波纹效果', builder: _needInkWellTabBar),
      ],
    );
  }

  Widget _textTypeTabBar(BuildContext context) {
    var _currentIndex = 0;
    void _onTapTab(
      BuildContext context,
      String tabName,
      int currentIndex,
      int currentSelectIndex,
    ) {
      print(
        '点击了 $tabName, 当前index: $currentIndex, 当前选择index: $currentSelectIndex',
      );
      if (currentIndex == currentSelectIndex) {
        TDToast.showText('$tabName 已经被选中了', context: context);
        return;
      }
      TDToast.showText('点击了 $tabName', context: context);
    }

    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      currentIndex: _currentIndex,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            _onTapTab(context, '标签1', 0, _currentIndex);
            _currentIndex = 0;
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            _onTapTab(context, '标签2', 1, _currentIndex);
            _currentIndex = 1;
          },
        ),
      ],
    );
  }

  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
      ],
    );
  }

  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
      ],
    );
  }

  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
      ],
    );
  }

  Widget _iconTextTypeTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _iconTextTypeTabBarOverflow(BuildContext context) {
    final selectedIcon = Icon(
      Icons.dashboard_rounded,
      color: context.colorScheme.primary,
    );
    final unSelectedIcon = Icon(
      Icons.dashboard_rounded,
      color: context.colorScheme.primary,
    );
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: selectedIcon,
          unselectedIcon: unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: selectedIcon,
          unselectedIcon: unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: selectedIcon,
          unselectedIcon: unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  Widget _iconTypeTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _expansionPanelTypeTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.expansionPanel,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '展开项',
          onTap: () {
            onTapTab(context, '展开项');
          },
          popUpButtonConfig: TDBottomTabBarPopUpBtnConfig(
            popUpDialogConfig: TDBottomTabBarPopUpShapeConfig(
              radius: 10,
              arrowWidth: 16,
              arrowHeight: 8,
            ),
            items: ['展开项一', '展开项二', '展开项三'].reversed
                .map(
                  (e) => PopUpMenuItem(
                    value: e,
                    itemWidget: SizedBox(
                      //height: 30,
                      child: Text(e, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              TDToast.showText('点击了 $v', context: context);
            },
          ),
        ),
      ],
    );
  }

  Widget _weakSelectTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          badgeConfig: BadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  Widget _weakSelectIconTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  Widget _weakSelectIconTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  Widget _capsuleTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.label,
      outlineType: TDBottomTabBarOutlineType.capsule,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  Widget _capsuleTabBarOnLongPress(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.label,
      outlineType: TDBottomTabBarOutlineType.capsule,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
          onLongPress: () {
            print('长按了标签1');
            TDToast.showText('长按了标签1', context: context);
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
          onLongPress: () {
            TDToast.showText('长按了标签2', context: context);
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
          onLongPress: () {
            TDToast.showText('长按了标签3', context: context);
          },
        ),
      ],
    );
  }

  Widget _buildCustomTopStyle(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      topBorder: const BorderSide(color: Colors.red, width: 5),
      barHeight: 61,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  Widget _customBgColor(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      selectedBgColor: ThemeColors.error.shade200,
      unselectedBgColor: ThemeColors.neutral.shade200,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _customBgTypeTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      backgroundColor: ThemeColors.success.shade500,
      selectedBgColor: ThemeColors.error.shade50,
      unselectedBgColor: ThemeColors.blue.shade50,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          unselectTabTextStyle: TextStyle(color: ThemeColors.neutral.shade900),
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
      ],
    );
  }

  var currentIndex = 0;

  Widget _setCurrentIndexToTabBar(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              children: const [
                Center(child: MyText('页面1,手指左滑查看页面2')),
                Center(child: MyText('页面2,手指右滑查看页面1')),
              ],
              onPageChanged: (index) {
                setState(() {
                  // 修改选择index
                  currentIndex = index;
                });
              },
            ),
          ),
          TDBottomTabBar(
            // 设置选择index
            currentIndex: currentIndex,
            TDBottomTabBarBasicType.icon,
            useVerticalDivider: true,
            navigationTabs: [
              TDBottomTabBarTabConfig(
                selectedIcon: _selectedIcon,
                unselectedIcon: _unSelectedIcon,
                onTap: () {
                  onTapTab(context, '标签1');
                },
              ),
              TDBottomTabBarTabConfig(
                selectedIcon: _selectedIcon,
                unselectedIcon: _unSelectedIcon,
                onTap: () {
                  onTapTab(context, '标签2');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _allowMultipleTaps(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          allowMultipleTaps: true,
          tabText: '支持重复点击',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '不支持重复点击',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }

  Widget _needInkWellTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      needInkWell: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
      ],
    );
  }
}
