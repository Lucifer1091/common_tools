import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    return ExamplePage(
      title: myTitle(context),
      desc:
          'Used as a switcher for a set of parallel pages/contents, it can display more options on the same screen than Tab.',
      exampleCodeGroup: 'drawer',
      navBarKey: navBarkey,
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Basic drawer', builder: _buildBaseSimple),
            ExampleItem(desc: 'Drawer with icons', builder: _buildIconSimple),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: 'Drawer with title', builder: _buildTitleSimple),
            ExampleItem(
              desc: 'Drawer with footer',
              builder: _buildBottomSimple,
            ),
          ],
        ),
      ],
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
          (index) => MyDrawerItem(title: _nums[index]),
        ).toList(),
        onItemTap: (index, item) {
          debugPrint(
            'drawer Item is clicked, index: $index，title：${item.title}',
          );
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
            title: _nums[index],
            icon: const Icon(LucideIcons.layoutDashboard300),
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
          (index) => MyDrawerItem(title: _nums[index]),
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
          (index) => MyDrawerItem(title: _nums[index]),
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
