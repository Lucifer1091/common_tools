import 'package:flutter/cupertino.dart';
import 'package:example/common_tools_catalog.dart';

import '../base/example_widget.dart';

class TDTreeSelectPage extends StatefulWidget {
  const TDTreeSelectPage({super.key});

  @override
  State<StatefulWidget> createState() => _TDTreeSelectPageState();
}

class _TDTreeSelectPageState extends State<TDTreeSelectPage> {
  String? inputText;
  List<dynamic> values1 = [1, 11];
  List<dynamic> values2 = [
    1,
    [11, 12, 13],
  ];
  List<dynamic> values3 = [1, 11, 111];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: '适用于选择树形的数据结构',
      exampleCodeGroup: 'tree',
      backgroundColor: ThemeColors.neutral.shade100,
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: '基础树形选择', builder: _buildDefaultTreeSelect),
            ExampleItem(desc: '多选树形选择', builder: _buildMultipleTreeSelect),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: '三级树形选择', builder: _buildThirdTreeSelect),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultTreeSelect(BuildContext context) {
    return Placeholder();
  }

  Widget _buildMultipleTreeSelect(BuildContext context) {
    return Placeholder();
  }

  Widget _buildThirdTreeSelect(BuildContext context) {
    return Placeholder();
  }
}
