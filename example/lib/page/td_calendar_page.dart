import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';
import '../../base/example_widget.dart';

class TDCalendarPage extends StatelessWidget {
  const TDCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: myTitle(context),
        desc: '按照日历形式展示数据或日期的容器。',
        exampleCodeGroup: 'calendar',
        children: [],
      ),
    );
  }
}
