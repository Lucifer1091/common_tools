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

const _nums = ['One', 'Two', 'Three', 'Four'];

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
    label: 'WeChat for Business',
    icon: Image.asset('assets/img/td_action_sheet_4.png'),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Favorites',
    icon: const IconWithBackground(icon: Icons.star),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Refresh',
    icon: const IconWithBackground(icon: Icons.refresh),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Download',
    icon: const IconWithBackground(icon: Icons.download),
    group: 'Share to',
  ),
  ActionSheetItem(
    label: 'Copy',
    icon: const IconWithBackground(icon: Icons.queue),
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
              desc: 'List-style action panel',
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
              desc: 'Grid-style Action Panel',
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
              desc: 'List-type Options state',
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
              desc: 'List alignment',
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
        items: _nums.map((e) => ActionSheetItem(label: 'Options$e')).toList(),
      );
    },
  );
}

Widget _buildDescListActionSheet(BuildContext context) {
  return MyButton(
    text: 'List with description',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action panel description text',
        items: _nums.map((e) => ActionSheetItem(label: 'Options$e')).toList(),
      );
    },
  );
}

Widget _buildIconListActionSheet(BuildContext context) {
  return MyButton(
    text: 'With icon list',
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
    text: 'With logo list',
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
    text: 'Regular palace grid',
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
    text: 'Grid with description',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        theme: MyActionSheetTheme.grid,
        count: 8,
        description: 'Action panel description text',
        items: _gridItems,
      );
    },
  );
}

Widget _buildPaginationGridActionSheet(BuildContext context) {
  return MyButton(
    text: 'Page-turning grid',
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
    text: 'Multi-line scrolling grid',
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
    text: 'Multi-line scrolling grid with description',
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
    text: 'Logo-patterned grid',
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
            icon: const IconWithBackground(icon: Icons.star),
            badge: const MyBadge(MyBadgeType.redPoint),
          ),
          ActionSheetItem(
            label: 'Refresh',
            icon: const IconWithBackground(icon: Icons.refresh),
          ),
          ActionSheetItem(
            label: 'Download',
            icon: const IconWithBackground(icon: Icons.download),
            badge: const MyBadge(MyBadgeType.message, count: 8),
          ),
          ActionSheetItem(
            label: 'Copy',
            icon: const IconWithBackground(icon: Icons.queue),
          ),
        ],
      );
    },
  );
}

Widget _buildBaseListStateActionSheet(BuildContext context) {
  return MyButton(
    text: 'List-type Options state',
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
            textStyle: const TextStyle(color: Colors.red),
          ),
        ],
        onSelected: (item, index) {
          print('Selected: ${item.label}');
        },
      );
    },
  );
}

Widget _buildIconListStateActionSheet(BuildContext context) {
  return MyButton(
    text: 'List-type status with icons',
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
            icon: const Icon(Icons.dashboard_rounded),
          ),
          ActionSheetItem(
            label: 'Custom Options',
            icon: const Icon(Icons.dashboard_rounded),
            textStyle: TextStyle(color: context.colorScheme.primary),
          ),
          ActionSheetItem(
            label: 'Invalid Options',
            icon: const Icon(Icons.dashboard_rounded),
            disabled: true,
          ),
          ActionSheetItem(
            label: 'Warning Options',
            icon: const Icon(Icons.dashboard_rounded),
            textStyle: const TextStyle(color: Colors.red),
          ),
        ],
        onSelected: (item, index) {
          print('Selected: ${item.label}');
        },
      );
    },
  );
}

Widget _buildBadgeListCenterActionSheet(BuildContext context) {
  return MyButton(
    text: 'Centered list with logo',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action Sheet Description Text',
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
    text: 'Centered list with icons',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action panel description text',
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
    text: 'Left-aligned list with logo',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action panel description text',
        align: MyActionSheetAlign.left,
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
    text: 'Left-aligned list with icons',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyActionSheet(
        context,
        visible: true,
        description: 'Action panel description text',
        align: MyActionSheetAlign.left,
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
