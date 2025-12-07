import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MySideBarPaginationPage extends StatefulWidget {
  const MySideBarPaginationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySideBarPaginationPageState();
  }
}

class MySideBarPaginationPageState extends State<MySideBarPaginationPage> {
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
      title: 'SideBar Pagination',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: _buildPaginationSideBar,
    );
  }

  Widget _buildPaginationSideBar(BuildContext context) {
    final list = <MySideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(MySideItemProps(index: i, label: 'Options', value: i));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const MyBadge(MyBadgeType.redPoint);
    list[2].badge = const MyBadge(MyBadgeType.message, count: 8);

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);

      if (currentValue != value) currentValue = value;
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
                    icon: ele.icon,
                  ),
                )
                .toList(),
            onSelected: setCurrentValue,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: demoHeight,
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
          ),
        ),
      ],
    );
  }

  Widget getPageDemo(int index) {
    return Container(
      decoration: BoxDecoration(color: context.colorScheme.background),
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
      decoration: BoxDecoration(color: context.colorScheme.background),
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
            image: 'assets/img/empty.png',
            type: MyImageType.roundedSquare,
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
