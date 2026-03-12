import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class IconWithBackground extends StatelessWidget {
  final IconData icon;

  const IconWithBackground({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 24.0,
          color: context.colorScheme.secondaryForeground,
        ),
      ),
    );
  }
}

const _nums = ['1', '2', '3', '4'];

List<ActionSheetItem> _gridItems = [
  ActionSheetItem(
    label: 'WeChat',
    icon: Image.asset('assets/img/td_action_sheet_1.png'),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Moments',
    icon: Image.asset('assets/img/td_action_sheet_2.png'),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'QQ',
    icon: Image.asset('assets/img/td_action_sheet_3.png'),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'WeChat',
    icon: Image.asset('assets/img/td_action_sheet_4.png'),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Favorites',
    icon: const IconWithBackground(icon: LucideIcons.star),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Refresh',
    icon: const IconWithBackground(icon: LucideIcons.refreshCcw),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Download',
    icon: const IconWithBackground(icon: LucideIcons.download),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Copy',
    icon: const IconWithBackground(icon: LucideIcons.copy),
    group: 'Share to',
  ),
];

class MyActionSheetPage extends StatelessWidget {
  const MyActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          "A modal window pops up from the bottom, providing actions related to the current scene, and also supporting information input and descriptions.",
      exampleCodeGroup: 'action_sheet',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'List Style Action Panel',
              builder: (BuildContext context) {
                return Column(
                  spacing: 16,
                  children: [
                    _buildBaseListActionSheet(context),
                    _buildDescListActionSheet(context),
                    _buildIconListActionSheet(context),
                    _buildBadgeListActionSheet(context),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: 'Grid Style Action Panel',
              builder: (BuildContext context) {
                return Column(
                  spacing: 16,
                  children: [
                    _buildBaseGridActionSheet(context),
                    _buildDescGridActionSheet(context),
                    _buildPaginationGridActionSheet(context),
                    _buildScrollGridActionSheet(context),
                    _buildMultiScrollGridActionSheet(context),
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
              desc: 'List Type Options state',
              builder: (BuildContext context) {
                return Column(
                  spacing: 16,
                  children: [
                    _buildBaseListStateActionSheet(context),
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
              desc: 'List Alignment',
              builder: (BuildContext context) {
                return Column(
                  spacing: 16,
                  children: [
                    _buildBadgeListCenterActionSheet(context),
                    _buildIconListCenterActionSheet(context),
                    _buildBadgeListLeftActionSheet(context),
                    _buildIconListLeftActionSheet(context),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildBaseListActionSheet(BuildContext context) {
  return MyButton(
    text: 'Regular List',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        items: _nums.map((e) => ActionSheetItem(label: 'Options $e')).toList(),
      );
    },
  );
}

Widget _buildDescListActionSheet(BuildContext context) {
  return MyButton(
    text: 'List With Description',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action Panel',
        items: _nums.map((e) => ActionSheetItem(label: 'Options $e')).toList(),
      );
    },
  );
}

Widget _buildIconListActionSheet(BuildContext context) {
  return MyButton(
    text: 'With Icons',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options $e',
                icon: const Icon(LucideIcons.layoutDashboard),
              ),
            )
            .toList(),
      );
    },
  );
}

Widget _buildBadgeListActionSheet(BuildContext context) {
  return MyButton(
    text: 'With Badge',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        items: [
          ActionSheetItem(
            label: 'Options 1',
            badge: const MyBadge(MyBadgeType.redPoint),
          ),
          ActionSheetItem(
            label: 'Options 2',
            badge: const MyBadge(MyBadgeType.message, count: 8),
          ),
          ActionSheetItem(
            label: 'Options 3',
            badge: const MyBadge(MyBadgeType.message, count: 99),
          ),
          ActionSheetItem(
            label: 'Options 4',
            badge: const MyBadge(MyBadgeType.message, message: '99+'),
          ),
        ],
      );
    },
  );
}

Widget _buildBaseGridActionSheet(BuildContext context) {
  return MyButton(
    text: 'Regular Grid',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        theme: MyActionSheetTheme.grid,
        count: 8,
        items: _gridItems,
      );
    },
  );
}

Widget _buildDescGridActionSheet(BuildContext context) {
  return MyButton(
    text: 'Grid With Description',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        theme: MyActionSheetTheme.grid,
        count: 8,
        description: 'Action Panel',
        items: _gridItems,
      );
    },
  );
}

Widget _buildPaginationGridActionSheet(BuildContext context) {
  return MyButton(
    text: 'Pagination grid',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        theme: MyActionSheetTheme.grid,
        count: 8,
        showPagination: true,
        items: [
          ..._gridItems,
          ActionSheetItem(
            label: 'Android',
            icon: const IconWithBackground(icon: LucideIcons.play),
          ),
          ActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: LucideIcons.apple),
          ),
          ActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: LucideIcons.chromium),
          ),
          ActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: LucideIcons.star),
          ),
        ],
      );
    },
  );
}

Widget _buildScrollGridActionSheet(BuildContext context) {
  return MyButton(
    text: 'Multi Line Scrollable Grid',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        theme: MyActionSheetTheme.grid,
        count: 8,
        scrollable: true,
        items: [
          ..._gridItems,
          ActionSheetItem(
            label: 'Android',
            icon: const IconWithBackground(icon: LucideIcons.play),
          ),
          ActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: LucideIcons.apple),
          ),
          ActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: LucideIcons.chromium),
          ),
          ActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: LucideIcons.star),
          ),
          ActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: LucideIcons.github),
          ),
        ],
      );
    },
  );
}

Widget _buildMultiScrollGridActionSheet(BuildContext context) {
  return MyButton(
    text: 'Multi Line Scrollable Grid With Description',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet.showGroupActionSheet(
        context,
        items: [
          ActionSheetItem(
            label: 'Allen',
            icon: Image.asset('assets/img/td_action_sheet_5.png'),
            group: 'Share with friends',
          ),
          ActionSheetItem(
            label: 'Nick',
            icon: Image.asset('assets/img/td_action_sheet_6.png'),
            group: 'Share with friends',
          ),
          ActionSheetItem(
            label: 'Jacky',
            icon: Image.asset('assets/img/td_action_sheet_7.png'),
            group: 'Share with friends',
          ),
          ActionSheetItem(
            label: 'Eric',
            icon: Image.asset('assets/img/td_action_sheet_8.png'),
            group: 'Share with friends',
          ),
          ActionSheetItem(
            label: 'Johnsc',
            icon: Image.asset('assets/img/td_action_sheet_5.png'),
            group: 'Share with friends',
          ),
          ActionSheetItem(
            label: 'Kevin',
            icon: Image.asset('assets/img/td_action_sheet_6.png'),
            group: 'Share with friends',
          ),
          ..._gridItems,
        ],
      );
    },
  );
}

Widget _buildBadgeGridActionSheet(BuildContext context) {
  return MyButton(
    text: 'With Badge',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet.showGridActionSheet(
        context,
        items: [
          ActionSheetItem(
            label: 'WeChat',
            icon: Image.asset('assets/img/td_action_sheet_1.png'),
            badge: const MyBadge(MyBadgeType.message, message: 'NEW'),
          ),
          ActionSheetItem(
            label: 'Friends Circle',
            icon: Image.asset('assets/img/td_action_sheet_2.png'),
          ),
          ActionSheetItem(
            label: 'QQ',
            icon: Image.asset('assets/img/td_action_sheet_3.png'),
          ),
          ActionSheetItem(
            label: 'Enterprise WeChat',
            icon: Image.asset('assets/img/td_action_sheet_4.png'),
          ),
          ActionSheetItem(
            label: 'Collection',
            icon: const IconWithBackground(icon: LucideIcons.star),
            badge: const MyBadge(MyBadgeType.redPoint),
          ),
          ActionSheetItem(
            label: 'Refresh',
            icon: const IconWithBackground(icon: LucideIcons.refreshCcw),
          ),
          ActionSheetItem(
            label: 'Download',
            icon: const IconWithBackground(icon: LucideIcons.download),
            badge: const MyBadge(MyBadgeType.message, count: 8),
          ),
          ActionSheetItem(
            label: 'Copy',
            icon: const IconWithBackground(icon: LucideIcons.copy),
          ),
        ],
      );
    },
  );
}

Widget _buildBaseListStateActionSheet(BuildContext context) {
  return MyButton(
    text: 'List Type Options State',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        items: [
          ActionSheetItem(label: 'Default Options'),
          ActionSheetItem(
            label: 'Custom Options',
            textStyle: TextStyle(color: context.colorScheme.primary),
          ),
          ActionSheetItem(label: 'Disabled Options', disabled: true),
          ActionSheetItem(
            label: 'Warning Options',
            textStyle: TextStyle(color: context.colorScheme.destructive),
          ),
        ],
        onSelected: (item, index) {
          debugPrint('Selected: ${item.label}');
        },
      );
    },
  );
}

Widget _buildIconListStateActionSheet(BuildContext context) {
  return MyButton(
    text: 'List Type Status With Icons',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        items: [
          ActionSheetItem(
            label: 'Default Options',
            icon: const Icon(LucideIcons.layoutDashboard),
          ),
          ActionSheetItem(
            label: 'Custom Options',
            icon: const Icon(LucideIcons.layoutDashboard),
            textStyle: TextStyle(color: context.colorScheme.primary),
          ),
          ActionSheetItem(
            label: 'Invalid Options',
            icon: const Icon(LucideIcons.layoutDashboard),
            disabled: true,
          ),
          ActionSheetItem(
            label: 'Warning Options',
            icon: const Icon(LucideIcons.layoutDashboard),
            textStyle: const TextStyle(color: Colors.red),
          ),
        ],
        onSelected: (item, index) {
          debugPrint('Selected: ${item.label}');
        },
      );
    },
  );
}

Widget _buildBadgeListCenterActionSheet(BuildContext context) {
  return MyButton(
    text: 'Centered List With Badge',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action Sheet',
        items: [
          ActionSheetItem(
            label: 'Options One',
            badge: const MyBadge(MyBadgeType.redPoint),
          ),
          ActionSheetItem(
            label: 'Options Two',
            badge: const MyBadge(MyBadgeType.message, count: 8),
          ),
          ActionSheetItem(
            label: 'Options Three',
            badge: const MyBadge(MyBadgeType.message, message: '99'),
          ),
        ],
      );
    },
  );
}

Widget _buildIconListCenterActionSheet(BuildContext context) {
  return MyButton(
    text: 'Centered List With Icons',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action Panel',
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options $e',
                icon: const Icon(LucideIcons.layoutDashboard),
              ),
            )
            .toList(),
      );
    },
  );
}

Widget _buildBadgeListLeftActionSheet(BuildContext context) {
  return MyButton(
    text: 'Left Aligned List With Badge',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action Panel',
        align: MyActionSheetAlign.left,
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options $e',
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
    text: 'Left Aligned List With Icons',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action Panel',
        align: MyActionSheetAlign.left,
        items: _nums
            .map(
              (e) => ActionSheetItem(
                label: 'Options $e',
                icon: const Icon(LucideIcons.layoutDashboard),
              ),
            )
            .toList(),
      );
    },
  );
}
