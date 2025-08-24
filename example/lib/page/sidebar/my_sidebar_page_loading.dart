import 'dart:async';

import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MySideBarLoadingPage extends StatefulWidget {
  const MySideBarLoadingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySideBarLoadingPageState();
  }
}

class MySideBarLoadingPageState extends State<MySideBarLoadingPage> {
  var currentValue = 1;
  var itemHeight = 278.5;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  final _sideBarController = MySideBarController();
  static const threshold = 50;
  var lock = false;

  @override
  void initState() {
    super.initState();

    _demoScroller.addListener(() {
      if (lock) {
        return;
      }

      var scrollTop = _demoScroller.offset;
      var index = (scrollTop + threshold) ~/ itemHeight;

      if (currentValue != index) {
        setState(() {
          _sideBarController.selectTo(index);
        });
      }
    });
  }

  Future<void> onSelected(int value) async {
    if (currentValue != value) {
      setState(() {
        currentValue = value;
      });

      lock = true;
      await _demoScroller.animateTo(
        value.toDouble() * itemHeight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
      lock = false;
    }
  }

  void onChanged(int value) {
    setState(() {
      currentValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
      title: 'SideBar 延迟加载',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: _buildLoadingSideBar,
    );
  }

  List<MySideItemProps> list = <MySideItemProps>[];
  List<Widget> pages = <Widget>[];

  void _initData() {
    list = [];
    pages = [];
    for (var i = 0; i < 20; i++) {
      list.add(MySideItemProps(index: i, label: 'Options', value: i));
      pages.add(getLoadingDemo(i));
    }

    pages.add(
      Container(
        height: MediaQuery.of(context).size.height - itemHeight,
        decoration: const BoxDecoration(color: Colors.white),
      ),
    );

    list[1].badge = const MyBadge(MyBadgeType.redPoint);
    list[2].badge = const MyBadge(MyBadgeType.message, count: 8);
    if (_sideBarController.loading) {
      _sideBarController.init(list);
      _sideBarController.selectTo(currentValue);
      // 初始化时避免右侧内容与左侧item不匹配
      _demoScroller.animateTo(
        currentValue.toDouble() * itemHeight,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeIn,
      );
    }
  }

  Widget _buildLoadingSideBar(BuildContext context) {
    // 延迟加载
    Future.delayed(const Duration(seconds: 3), _initData);
    var size = MediaQuery.of(context).size;
    var demoHeight = size.height;

    return Row(
      children: [
        SizedBox(
          width: list.isEmpty ? size.width : 110,
          child: MySideBar(
            height: demoHeight,
            style: MySideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            loading: true,
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
            onChanged: onChanged,
            onSelected: onSelected,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: demoHeight,
            child: SingleChildScrollView(
              controller: _demoScroller,
              child: Column(children: pages),
            ),
          ),
        ),
      ],
    );
  }

  Widget getLoadingDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, right: 9),
            child: MyText('Title$index', style: const TextStyle(fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: displayImageList(),
          ),
        ],
      ),
    );
  }

  Widget displayImageList() {
    return Column(
      children: [
        displayImageItem(),
        const MyDivider(),
        displayImageItem(),
        const MyDivider(),
        displayImageItem(),
        const MyDivider(),
      ],
    );
  }

  Widget displayImageItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          TDImage(
            assetUrl: 'assets/img/empty.png',
            type: TDImageType.roundedSquare,
            width: 48,
            height: 48,
          ),
          SizedBox(width: 16),
          MyText('Title', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
