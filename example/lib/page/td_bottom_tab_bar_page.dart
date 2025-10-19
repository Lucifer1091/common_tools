import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyBottomTabBarPage extends StatefulWidget {
  const MyBottomTabBarPage({super.key});

  @override
  State<MyBottomTabBarPage> createState() => _MyBottomTabBarPageState();
}

class _MyBottomTabBarPageState extends State<MyBottomTabBarPage>
    with SingleTickerProviderStateMixin {
  final List _tabs = const ['Tab 1', 'Tab 2', 'Tab 3'];

  late TabController _tabController;

  void onTapTab(BuildContext context, String tabName) {
    // TDToast.showText('Clicked $tabName', context: context);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          'Used to quickly switch between different functional modules, located at the bottom of the page.',
      exampleCodeGroup: 'bottomTabBar',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Plain Text Bar', builder: _textTypeTabBar4tabs),
          ],
        ),
      ],
    );
  }

  Widget _textTypeTabBar4tabs(BuildContext context) {
    return SizedBox.shrink();
  }
}
