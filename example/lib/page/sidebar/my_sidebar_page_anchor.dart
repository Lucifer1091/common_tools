import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MySideBarAnchorPage extends StatefulWidget {
  const MySideBarAnchorPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySideBarAnchorPageState();
  }
}

class MySideBarAnchorPageState extends State<MySideBarAnchorPage> {
  var currentValue = 1;
  var itemHeight = 278.5;
  var titleBarHeight = 44;
  var testButtonHeight = 80.0;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  final _sideBarController = MySideBarController();
  static const threshold = 50;
  var lock = false;
  var list = <MySideItemProps>[];
  final pages = <Widget>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _demoScroller.addListener(() {
        if (lock) return;

        var scrollTop = _demoScroller.offset;
        var index = (scrollTop + threshold) ~/ itemHeight;

        if (currentValue != index) {
          setState(() {
            _sideBarController.selectTo(index);
          });
        }
      });

      for (var i = 0; i < 20; i++) {
        list.add(MySideItemProps(index: i, label: 'Option', value: i));
        pages.add(getAnchorDemo(i));
      }

      list[1].badge = const MyBadge(MyBadgeType.redPoint);
      list[2].badge = const MyBadge(MyBadgeType.message, count: 8);

      _sideBarController.init(list);
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
    if (mounted) {
      setState(() {
        currentValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
      title: 'SideBar Anchor Usage',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: _buildAnchorSideBar,
    );
  }

  Widget _buildAnchorSideBar(BuildContext context) {
    var demoHeight =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        titleBarHeight -
        testButtonHeight;

    // pages.add(
    //   Container(
    //     height: demoHeight - itemHeight,
    //     color: context.colorScheme.background,
    //   ),
    // );

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: MySideBar(
            height: demoHeight,
            style: MySideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
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
      decoration: BoxDecoration(color: context.colorScheme.background),
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
          MyImage(
            source: 'assets/img/empty.png',
            type: MyImageType.squircle,
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
