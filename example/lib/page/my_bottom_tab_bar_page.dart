import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

Widget? _selectedIcon;

Widget? _unSelectedIcon;

class MyBottomTabBarPage extends StatefulWidget {
  const MyBottomTabBarPage({super.key});

  @override
  State<MyBottomTabBarPage> createState() => _MyBottomTabBarPageState();
}

class _MyBottomTabBarPageState extends State<MyBottomTabBarPage> {
  void onTapTab(BuildContext context, String tabName) {
    // TDToast.showText('Clicked $tabName', context: context);
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
      desc:
          'Used to quickly switch between different functional modules, located at the bottom of the page.',
      exampleCodeGroup: 'bottomTabBar',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Plain Text Bar', builder: _textTypeTabBar4tabs),
            ExampleItem(
              desc: 'Icon plus text label bar',
              builder: _iconTextTypeTabBar4tabs,
            ),
            ExampleItem(
              desc: 'Pure icon tab bar',
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _iconTypeTabBar4tabs(context),
                );
              },
            ),
            ExampleItem(
              desc: 'Dual-level text label bar',
              builder: _expansionPanelTypeTabBar,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              ignoreCode: true,
              desc: 'Weakly selected tab bar',
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
            ExampleItem(
              desc: 'Suspended Capsule Label Bar',
              builder: _capsuleTabBar,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Event',
          children: [
            ExampleItem(
              desc: 'Long press trigger',
              builder: _capsuleTabBarOnLongPress,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: 'Custom top line style',
          builder: _buildCustomTopStyle,
        ),
        ExampleItem(
          desc: 'Customize the background color of the selection',
          builder: _customBgColor,
        ),
        ExampleItem(
          ignoreCode: true,
          desc: 'Set the text label bar background',
          builder: (context) {
            return _customBgTypeTabBar(context);
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: 'Externally set the selected item of the tabbar',
          builder: (context) {
            return _setCurrentIndexToTabBar(context);
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: 'Icon default size bottom text does not overflow',
          builder: (context) {
            return _iconTextTypeTabBarOverflow(context);
          },
        ),
        ExampleItem(
          desc: 'onTap supports repeated triggering',
          builder: _allowMultipleTaps,
        ),
        ExampleItem(
          desc: 'Support water ripple effect',
          builder: _needInkWellTabBar,
        ),
      ],
    );
  }

  Widget _textTypeTabBar4tabs(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.text,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
      ],
    );
  }

  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
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
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: selectedIcon,
          unselectedIcon: unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: selectedIcon,
          unselectedIcon: unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: selectedIcon,
          unselectedIcon: unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 3');
          },
        ),
      ],
    );
  }

  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.icon,
      useVerticalDivider: true,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
      ],
    );
  }

  Widget _expansionPanelTypeTabBar(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.expansionPanel,
      useVerticalDivider: true,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Expand items',
          onTap: () {
            onTapTab(context, 'Expand items');
          },
          popUpButtonConfig: TDBottomTabBarPopUpBtnConfig(
            popUpDialogConfig: TDBottomTabBarPopUpShapeConfig(
              radius: 10,
              arrowWidth: 16,
              arrowHeight: 8,
            ),
            items: ['Expand items一', 'Expand items二', 'Expand items三'].reversed
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
              TDToast.showText('Clicked $v', context: context);
            },
          ),
        ),
      ],
    );
  }

  Widget _weakSelectTextTabBar(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.text,
      componentType: MyBottomTabBarComponentType.normal,
      useVerticalDivider: true,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          badgeConfig: MyBadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 3');
          },
        ),
      ],
    );
  }

  Widget _weakSelectIconTabBar(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.icon,
      componentType: MyBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: MyBadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 3');
          },
        ),
      ],
    );
  }

  Widget _weakSelectIconTextTabBar(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      componentType: MyBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: MyBadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 3');
          },
        ),
      ],
    );
  }

  Widget _capsuleTabBar(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      componentType: MyBottomTabBarComponentType.label,
      outlineType: MyBottomTabBarOutlineType.capsule,
      useVerticalDivider: true,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 3');
          },
        ),
      ],
    );
  }

  Widget _capsuleTabBarOnLongPress(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      componentType: MyBottomTabBarComponentType.label,
      outlineType: MyBottomTabBarOutlineType.capsule,
      useVerticalDivider: true,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
          onLongPress: () {
            print('Long pressed Label 1');
            TDToast.showText('Long pressed Label 1', context: context);
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
          onLongPress: () {
            TDToast.showText('Long press Label 2', context: context);
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 3');
          },
          onLongPress: () {
            TDToast.showText('Long press Label 3', context: context);
          },
        ),
      ],
    );
  }

  Widget _buildCustomTopStyle(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      topBorder: const BorderSide(color: Colors.red, width: 5),
      barHeight: 61,
      componentType: MyBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: MyBadgeConfig(
            showBadge: true,
            badge: const MyBadge(MyBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 3');
          },
        ),
      ],
    );
  }

  Widget _customBgColor(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      selectedBgColor: ThemeColors.error.shade200,
      unselectedBgColor: ThemeColors.neutral.shade200,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
      ],
    );
  }

  Widget _customBgTypeTabBar(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.text,
      backgroundColor: ThemeColors.success.shade500,
      selectedBgColor: ThemeColors.error.shade50,
      unselectedBgColor: ThemeColors.blue.shade50,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          label: 'Label',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          unselectedStyle: TextStyle(color: ThemeColors.neutral.shade900),
          onTap: () {
            onTapTab(context, 'Label 1');
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
                Center(child: MyText('Page 1, swipe left to view page 2')),
                Center(child: MyText('Page 2, swipe right to view page 1')),
              ],
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          MyBottomTabBar(
            currentIndex: currentIndex,
            MyBottomTabBarBasicType.icon,
            useVerticalDivider: true,
            navigationTabs: [
              MyBottomTabBarTabConfig(
                selectedIcon: _selectedIcon,
                unselectedIcon: _unSelectedIcon,
                onTap: () {
                  onTapTab(context, 'Label 1');
                },
              ),
              MyBottomTabBarTabConfig(
                selectedIcon: _selectedIcon,
                unselectedIcon: _unSelectedIcon,
                onTap: () {
                  onTapTab(context, 'Label 2');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _allowMultipleTaps(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.text,
      useVerticalDivider: false,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          allowMultipleTaps: true,
          label: 'Support repeated clicks',
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Repeat clicks are not supported',
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
      ],
    );
  }

  Widget _needInkWellTabBar(BuildContext context) {
    return MyBottomTabBar(
      MyBottomTabBarBasicType.iconText,
      needInkWell: true,
      navigationTabs: [
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 1');
          },
        ),
        MyBottomTabBarTabConfig(
          label: '',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
        MyBottomTabBarTabConfig(
          label: 'Label',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, 'Label 2');
          },
        ),
      ],
    );
  }
}
