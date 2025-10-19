import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDCascaderPage extends StatefulWidget {
  const TDCascaderPage({super.key});

  @override
  State<TDCascaderPage> createState() => _TDCascaderPageState();
}

class _TDCascaderPageState extends State<TDCascaderPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.primaryForeground,
      child: ExamplePage(
        title: myTitle(),
        exampleCodeGroup: 'cascader',
        desc: '用于多层级数据的逐级选择',
        children: [],
        test: [],
      ),
    );
  }
}
