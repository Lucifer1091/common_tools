import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

const _nums = [
  'Monday',
  'Twenty',
  'Third',
  'Fourth',
  'Five',
  'Sixth',
  'Seventh',
  'Eighth',
  'Nineth',
  'Tenth',
  'Eleventh',
  'Twelve',
  'Thirteenth',
  'Fourteenth',
  'Fifteenth',
  'Sixteenth',
  'Seventeenth',
  'Eighteenth',
  'Nineteenth',
  'Twenty',
  'Twenty-one',
  'Twenty-two',
  'Twenty-three',
  'Twenty-four',
  'Twenty-five',
  'Twenty-six',
  'Twenty-seven',
  'Twenty-eight',
  'Twenty-nine',
  'Thirty',
];

class MyDrawerPage extends StatelessWidget {
  const MyDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: tdTitle(context),
        desc:
            'Used as a switcher for a set of parallel pages/contents, it can display more options on the same screen than Tab.',
        exampleCodeGroup: 'drawer',
        navBarKey: navBarkey,
        children: [
          ExampleModule(
            title: 'Component Types',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: 'Basic drawer',
                builder: (BuildContext context) {
                  return _buildBaseSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: 'Drawer with icons',
                builder: (BuildContext context) {
                  return _buildIconSimple(context);
                },
              ),
            ],
          ),
          ExampleModule(
            title: 'Component Style',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: 'Drawer with title',
                builder: (BuildContext context) {
                  return _buildTitleSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: 'Drawer with footer',
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
            desc: 'Custom background color',
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
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: 'Basic drawer',
    isExpanded: true,
    type: MyButtonType.outline,
    size: MyButtonSize.large,
    onTap: () {
      MyDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
          30,
          (index) => MyDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
        onItemClick: (index, item) {
          print('drawer Item is clicked, index: $index，title：${item.title}');
        },
      );
    },
  );
}

Widget _buildIconSimple(BuildContext context) {
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: 'Drawer with icons',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      MyDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
          30,
          (index) => MyDrawerItem(
            title: '菜单${_nums[index]}',
            icon: const Icon(Icons.dashboard_rounded),
          ),
        ).toList(),
      );
    },
  );
}

Widget _buildTitleSimple(BuildContext context) {
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: 'Drawer with title',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      MyDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: 'Title',
        placement: MyDrawerPlacement.left,
        items: List.generate(
          10,
          (index) => MyDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
      );
    },
  );
}

Widget _buildBottomSimple(BuildContext context) {
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return MyButton(
    text: 'Drawer with footer',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      MyDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: 'Title',
        placement: MyDrawerPlacement.left,
        items: List.generate(
          10,
          (index) => MyDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
        footer: const MyButton(
          text: 'Action',
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
    text: 'Custom background color',
    isExpanded: true,
    type: MyButtonType.outline,

    size: MyButtonSize.large,
    onTap: () {
      MyDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: 'Title',
        backgroundColor: ThemeColors.neutral.shade50,
        placement: MyDrawerPlacement.right,
        items: List.generate(
          10,
          (index) => MyDrawerItem(title: '菜单${_nums[index]}'),
        ).toList(),
      );
    },
  );
}
