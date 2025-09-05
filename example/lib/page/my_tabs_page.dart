import 'package:common_tools/widgets/tdesign/tabs/indicators/dot_indicator.dart';
import 'package:common_tools/widgets/tdesign/tabs/pointTabIndicator.dart';
import 'package:common_tools/widgets/tdesign/tabs/tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyTabsPage extends StatefulWidget {
  const MyTabsPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyTabsPageState();
}

class _MyTabsPageState extends State<MyTabsPage> with TickerProviderStateMixin {
  TabController? _tabController1;
  TabController? _tabController2;
  TabController? _tabController3;
  TabController? _tabController4;
  List<MyTab> tabs = [];
  List<Widget> tabViews = [];

  List<MyTab> _getTabs() {
    tabs = const [
      MyTab(text: 'Tab 1'),
      MyTab(text: 'Tab 2'),
      MyTab(text: 'Tab 3'),
      MyTab(text: 'Tab 4'),
      MyTab(text: 'Tab 5'),
      MyTab(text: 'Tab 6'),
      MyTab(text: 'Tab 7'),
      MyTab(text: 'Tab 8'),
      MyTab(text: 'Tab 9'),
      MyTab(text: 'Tab 10'),
      MyTab(text: 'Tab 11'),
      MyTab(text: 'Tab 12'),
      MyTab(text: 'Tab 13'),
      MyTab(text: 'Tab 14'),
      MyTab(text: 'Tab 15'),
      MyTab(text: 'Tab 16'),
      MyTab(text: 'Tab 17'),
      MyTab(text: 'Tab 18'),
      MyTab(text: 'Tab 19'),
      MyTab(text: 'Tab 20'),
      MyTab(text: 'Tab 21'),
    ];
    return tabs;
  }

  List<Widget> _getTabViews() {
    tabViews = const [
      NumberedContainer(index: 1),
      NumberedContainer(index: 2),
      NumberedContainer(index: 3),
    ];
    return tabViews;
  }

  @override
  void initState() {
    _initTabController();
    _getTabs();
    super.initState();
  }

  List<MyTab> subList(int length) {
    var temp = <MyTab>[];

    for (var i = 0; i < length; i++) {
      temp.add(tabs[i]);
    }

    return temp;
  }

  void _initTabController() {
    _tabController1 = TabController(length: 2, vsync: this);
    _tabController2 = TabController(length: 3, vsync: this);
    _tabController3 = TabController(length: 4, vsync: this);
    _tabController4 = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc:
          'A set of layered sections of content—known as tab panels—that are displayed one at a time.',
      exampleCodeGroup: 'tabs',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Non Scrollable', builder: _buildItemWithSplit1),
            ExampleItem(
              builder: _buildItemWithSplit2,
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: _buildItemWithSplit3,
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: _buildItemWithSplit4,
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(desc: 'Scrollable', builder: _buildItemWithSpace),
            ExampleItem(
              desc: 'Options Card with Icon',
              builder: _buildItemWithIcon,
            ),
            ExampleItem(
              desc: 'Options Card with Micro Logo',
              builder: _buildItemWithLogo,
            ),
            ExampleItem(
              desc: 'Options Card with Content Area',
              builder: _buildItemWithContent,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              desc: 'Options card status',
              builder: _buildItemWithStatus,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              desc: 'Options card size',
              builder: _buildItemWithSizeSmall,
            ),
            ExampleItem(
              builder: _buildItemWithSizeBig,
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              desc: 'Options card style',
              builder: _buildItemWithOutlineNormal,
            ),
            ExampleItem(
              builder: _buildItemWithOutlineCard,
              padding: const EdgeInsets.only(top: 16),
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: 'Custom subscript attributes',
          builder: _customIndicatorStyle,
        ),
        ExampleItem(
          desc: 'Custom underline style',
          builder: _customDividerStyle,
        ),
        ExampleItem(
          desc: 'No underline - height is 0',
          builder: _hideBottomDivider,
        ),
        ExampleItem(
          desc: 'Capsule type can modify the background color',
          builder: _capsuleBackgroundColor,
        ),
      ],
    );
  }

  Widget _buildItemWithSplit1(BuildContext context) {
    return MyTabBar(
      tabs: subList(2),
      controller: _tabController1,
      indicator: MyDotIndicator(distanceFromCenter: 15),
    );
  }

  Widget _buildItemWithSplit2(BuildContext context) {
    return MyTabBar(
      tabs: subList(3),
      controller: _tabController2,
      indicator: PointTabIndicator(),
    );
  }

  Widget _buildItemWithSplit3(BuildContext context) {
    return MyTabBar(
      tabs: subList(4),
      controller: _tabController3,
      indicator: TabIndicator(height: 5, width: 5, radius: 5),
    );
  }

  Widget _buildItemWithSplit4(BuildContext context) {
    return MyTabBar(tabs: subList(5), controller: _tabController4);
  }

  Widget _buildItemWithSpace(BuildContext context) {
    return MyTabBar(
      tabs: subList(16),
      controller: TabController(length: 16, vsync: this),
      labelPadding: const EdgeInsets.all(10),
      isScrollable: true,
    );
  }

  Widget _buildItemWithIcon(BuildContext context) {
    var tabs = [
      const MyTab(
        text: 'Options',
        icon: Icon(Icons.dashboard_rounded, size: 18),
      ),
      const MyTab(
        text: 'Options',
        icon: Icon(Icons.dashboard_rounded, size: 18),
      ),
      const MyTab(
        text: 'Options',
        icon: Icon(Icons.dashboard_rounded, size: 18),
      ),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 3, vsync: this),
    );
  }

  Widget _buildItemWithLogo(BuildContext context) {
    var tabs = [
      const MyTab(
        text: 'Options',
        textMargin: EdgeInsets.only(right: 8),
        badge: MyBadgeConfig(),
      ),
      const MyTab(
        text: 'Options',
        textMargin: EdgeInsets.only(right: 16, top: 2, bottom: 2),
        badge: MyBadgeConfig(badge: MyBadge(MyBadgeType.message, count: 8)),
      ),
      const MyTab(
        text: 'Options',
        height: 48,
        icon: Icon(Icons.dashboard_rounded, size: 18),
      ),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 3, vsync: this),
    );
  }

  Widget _buildItemWithContent(BuildContext context) {
    var tabController = TabController(length: 3, vsync: this);
    return SizedBox(
      height: 120 + 48,
      child: Column(
        children: [
          MyTabBar(
            tabs: subList(3),
            controller: tabController,

            isScrollable: false,
          ),
          Container(
            height: 120,
            color: Colors.white,
            child: MyTabView(
              controller: tabController,
              children: _getTabViews(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemWithStatus(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Selected'),
      const MyTab(text: 'Default'),
      const MyTab(text: 'Disabled', enable: false),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 3, vsync: this),
    );
  }

  Widget _buildItemWithSizeSmall(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Small size'),
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 4, vsync: this),
    );
  }

  Widget _buildItemWithSizeBig(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Large size', size: MyTabSize.large),
      const MyTab(text: 'Options', size: MyTabSize.large),
      const MyTab(text: 'Options', size: MyTabSize.large),
      const MyTab(text: 'Options', size: MyTabSize.large),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 4, vsync: this),
    );
  }

  Widget _buildItemWithOutlineNormal(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
    ];
    return MyTabBar(
      tabs: tabs,
      type: MyTabType.capsule,
      controller: TabController(length: 4, vsync: this),

      showIndicator: false,
    );
  }

  Widget _buildItemWithOutlineCard(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
      const MyTab(text: 'Options'),
    ];
    return MyTabBar(
      tabs: tabs,
      type: MyTabType.card,
      controller: TabController(length: 4, vsync: this),

      showIndicator: false,
    );
  }

  Widget _customIndicatorStyle(BuildContext context) {
    return MyTabBar(
      tabs: subList(2),
      controller: _tabController1,

      indicatorColor: Colors.red,
      indicatorHeight: 20,
      indicatorWidth: 10,
      indicatorPadding: const EdgeInsets.only(left: 20),
    );
  }

  Widget _customDividerStyle(BuildContext context) {
    return MyTabBar(
      tabs: subList(2),
      controller: _tabController1,

      dividerColor: Colors.red,
      dividerHeight: 5,
    );
  }

  Widget _hideBottomDivider(BuildContext context) {
    return MyTabBar(
      tabs: subList(2),
      controller: _tabController1,

      dividerColor: Colors.red,
      dividerHeight: 0,
    );
  }

  Widget _capsuleBackgroundColor(BuildContext context) {
    return MyTabBar(
      tabs: subList(2),
      controller: _tabController1,
      backgroundColor: Colors.red,
      type: MyTabType.capsule,
    );
  }
}

class NumberedContainer extends StatelessWidget {
  final int index;
  final double? width;
  final double? height;
  final bool fill;
  final BorderRadius? radius;

  const NumberedContainer({
    super.key,
    required this.index,
    this.width,
    this.height,
    this.fill = true,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    var colors = MyColors.values;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fill
            ? colors[(colors.length - 1 - index) % colors.length]
            : null,
        borderRadius: radius ?? MyBorderRadius.small,
      ),
      child: Center(
        child: MyText(
          index.toString(),
          fontSize: 24,
          textColor: context.colorScheme.primaryForeground,
        ),
      ),
    );
  }
}
