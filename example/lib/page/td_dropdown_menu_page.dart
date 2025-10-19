import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDDropdownMenuPage extends StatelessWidget {
  const TDDropdownMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: myTitle(context),
        desc: '菜单呈现数个并列的Options类目，用于整个页面的内容筛选，由菜单面板和菜单Options组成。',
        exampleCodeGroup: 'dropdownMenu',
        children: [],
        test: [],
      ),
    );
  }
}
