import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyTabsPage extends StatefulWidget {
  const MyTabsPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyTabsPageState();
}

class _MyTabsPageState extends State<MyTabsPage> with TickerProviderStateMixin {
  TabController? _tabController4;
  TabController? _tabController5;
  List<MyTab> tabs = [];
  List<Widget> tabViews = [];
  List<Color> gradient = [Color(0xff579CFA), Color(0xff2FDEE7)];

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
    _tabController4 = TabController(length: 4, vsync: this);
    _tabController5 = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'A set of layered sections of content are displayed one at a time.',
      exampleCodeGroup: 'tabs',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Non Scrollable', builder: _buildNonScrollable),
            ExampleItem(desc: 'Scrollable', builder: _buildScrollable),
            ExampleItem(desc: 'Icon', builder: _buildTabWithIcon),
            ExampleItem(desc: 'Badge', builder: _buildTabWithBadge),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              builder: _buildTabWithStatus,
              padding: EdgeInsets.only(top: 8),
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              builder: _buildSmallTabs,
              padding: const EdgeInsets.only(top: 8),
            ),
            ExampleItem(
              builder: _buildLargeTabs,
              padding: const EdgeInsets.only(top: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Tab Indicator Types',
          children: [
            ExampleItem(
              builder: _buildIndicator,
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(
                  ctx,
                  gradient: gradient,
                  type: MyTabIndicatorType.line,
                  size: MyTabIndicatorSize.normal,
                ),
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(
                  ctx,
                  type: MyTabIndicatorType.line,
                  size: MyTabIndicatorSize.full,
                ),
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(ctx, type: MyTabIndicatorType.dot),
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(
                  ctx,
                  size: MyTabIndicatorSize.full,
                  type: MyTabIndicatorType.material,
                ),
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(
                  ctx,
                  gradient: gradient,
                  size: MyTabIndicatorSize.normal,
                  type: MyTabIndicatorType.material,
                ),
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(
                  ctx,
                  size: MyTabIndicatorSize.tiny,
                  type: MyTabIndicatorType.material,
                ),
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(
                  ctx,
                  type: MyTabIndicatorType.capsule,
                ),
                labelColor: ctx.colorScheme.primaryForeground,
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              builder: (ctx) => _buildIndicator(
                ctx,
                indicator: MyTabIndicator(
                  ctx,
                  type: MyTabIndicatorType.capsule,
                  style: PaintingStyle.stroke,
                ),
              ),
              padding: const EdgeInsets.only(top: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Tab View',
          children: [
            ExampleItem(
              builder: _buildTabView,
              padding: EdgeInsets.only(top: 8),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNonScrollable(BuildContext context) {
    return MyTabBar(tabs: subList(5), controller: _tabController5);
  }

  Widget _buildScrollable(BuildContext context) {
    return MyTabBar(
      tabs: subList(16),
      controller: TabController(length: 16, vsync: this),
      labelPadding: const EdgeInsets.all(10),
      isScrollable: true,
    );
  }

  Widget _buildTabWithIcon(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Tab 1', iconData: LucideIcons.layoutGrid),
      const MyTab(text: 'Tab 2', iconData: LucideIcons.layoutPanelLeft),
      const MyTab(text: 'Tab 3', iconData: LucideIcons.layoutPanelTop),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 3, vsync: this),
    );
  }

  Widget _buildTabWithBadge(BuildContext context) {
    var tabs = [
      const MyTab(
        text: 'Tab 1',
        textMargin: EdgeInsets.only(right: 10),
        badge: MyBadgeConfig(),
      ),
      const MyTab(
        text: 'Tab 2',
        textMargin: EdgeInsets.only(right: 20, top: 2, bottom: 2),
        badge: MyBadgeConfig(badge: MyBadge(MyBadgeType.message, count: 8)),
      ),
      const MyTab(text: 'Tab 3', iconData: LucideIcons.layoutPanelLeft),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 3, vsync: this),
    );
  }

  Widget _buildTabView(BuildContext context) {
    var tabController = TabController(length: 3, vsync: this);
    return SizedBox(
      height: 150 + 48,
      child: Column(
        children: [
          MyTabBar(
            tabs: subList(3),
            controller: tabController,
            isScrollable: false,
          ),
          SizedBox(
            height: 150,
            child: MyTabView(
              controller: tabController,
              children: _getTabViews(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabWithStatus(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Selected'),
      const MyTab(text: 'Default'),
      const MyTab(text: 'Disabled', enabled: false),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 3, vsync: this),
    );
  }

  Widget _buildSmallTabs(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Small size'),
      const MyTab(text: 'Tab 2'),
      const MyTab(text: 'Tab 3'),
      const MyTab(text: 'Tab 4', iconData: LucideIcons.layoutPanelLeft),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 4, vsync: this),
    );
  }

  Widget _buildLargeTabs(BuildContext context) {
    var tabs = [
      const MyTab(text: 'Large size', size: MyTabSize.large),
      const MyTab(text: 'Tab 2', size: MyTabSize.large),
      const MyTab(text: 'Tab 3', size: MyTabSize.large),
      const MyTab(
        text: 'Tab 4',
        size: MyTabSize.large,
        iconData: LucideIcons.layoutPanelLeft,
      ),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: TabController(length: 4, vsync: this),
    );
  }

  Widget _buildIndicator(
    BuildContext context, {
    Color? labelColor,
    MyTabIndicator? indicator,
  }) {
    var tabs = const [
      MyTab(text: 'Tab 1'),
      MyTab(
        text: 'Tab 2',
        textMargin: EdgeInsets.only(right: 20, top: 2, bottom: 2),
        badge: MyBadgeConfig(badge: MyBadge(MyBadgeType.message, count: 8)),
      ),
      MyTab(text: 'Tab 3'),
      MyTab(text: 'Tab 4', iconData: LucideIcons.layoutPanelLeft),
    ];
    return MyTabBar(
      tabs: tabs,
      controller: _tabController4,
      indicator: indicator,
      labelColor: labelColor,
    );
  }

  @override
  void dispose() {
    _tabController4?.dispose();
    _tabController5?.dispose();
    super.dispose();
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
