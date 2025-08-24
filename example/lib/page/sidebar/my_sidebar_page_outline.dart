import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MySideBarOutlinePage extends StatefulWidget {
  const MySideBarOutlinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySideBarOutlinePageState();
  }
}

class MySideBarOutlinePageState extends State<MySideBarOutlinePage> {
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
      title: 'SideBar 非通栏选项样式',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: _buildOutlineSideBar,
    );
  }

  Widget _buildOutlineSideBar(BuildContext context) {
    // 非通栏选项样式
    final list = <MySideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(MySideItemProps(index: i, label: '选项', value: i));
      pages.add(getAnchorDemo(i));
    }

    pages.add(
      Container(
        height: MediaQuery.of(context).size.height - itemHeight,
        decoration: const BoxDecoration(color: Colors.white),
      ),
    );

    list[1].badge = const MyBadge(MyBadgeType.redPoint);
    list[2].badge = const MyBadge(MyBadgeType.message, count: 8);

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: MySideBar(
            height: demoHeight,
            style: MySideBarStyle.outline,
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

  Widget getAnchorDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, right: 9),
            child: MyText('标题$index', style: const TextStyle(fontSize: 14)),
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
          MyText('标题', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
