import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MySideBarCustomPage extends StatefulWidget {
  const MySideBarCustomPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySideBarCustomPageState();
  }
}

class MySideBarCustomPageState extends State<MySideBarCustomPage> {
  var currentValue = 1;
  final _pageController = PageController(initialPage: 1);
  final _sideBarController = MySideBarController();

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
      title: 'SideBar Custom',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: _buildCustomSideBar,
    );
  }

  Widget _buildCustomSideBar(BuildContext context) {
    // 自定义样式
    final list = <MySideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(MySideItemProps(index: i, label: 'Options', value: i));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const MyBadge(MyBadgeType.redPoint);
    list[2].badge = const MyBadge(MyBadgeType.message, count: 8);
    list[1].textStyle = const TextStyle(color: Colors.green);

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        currentValue = value;
      }
    }

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: MySideBar(
            height: demoHeight,
            style: MySideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map(
                  (ele) => MySideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    textStyle: ele.textStyle,
                    icon: ele.icon,
                  ),
                )
                .toList(),
            selectedTextStyle: TextStyle(color: Colors.red),
            onSelected: setCurrentValue,
            contentPadding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
            selectedBgColor: Colors.blue,
            unSelectedBgColor: Colors.yellow,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: demoHeight,
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              children: pages,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getPageDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: MyText('Title$index', style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          displayImageList(),
        ],
      ),
    );
  }

  Widget getAnchorDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: MyText('Title$index', style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          displayImageList(),
        ],
      ),
    );
  }

  Widget displayImageList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            displayImageItem('Title Character'),
            displayImageItem('Title Character'),
            displayImageItem('Up to Six Characters'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            displayImageItem('Title Character'),
            displayImageItem('Title Character'),
            displayImageItem('Up to Six Characters'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            displayImageItem('Title Character'),
            displayImageItem('Title Character'),
            displayImageItem('Up to Six Characters'),
          ],
        ),
      ],
    );
  }

  Widget displayImageItem(String title) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const MyImage(
            source: 'assets/img/empty.png',
            type: MyImageType.squircle,
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 8),
          MyText(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
