import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class TDRatePage extends StatefulWidget {
  const TDRatePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TDRatePageState();
  }
}

class TDRatePageState extends State<TDRatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: '用于对某行为/事物进行打分。',
      exampleCodeGroup: 'rate',
      backgroundColor: ThemeColors.neutral.shade100,
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [ExampleItem(desc: '带描述评分', builder: _buildMsgRate)],
        ),
      ],
    );
  }

  Widget _buildMsgRate(BuildContext context) {
    return Placeholder();
  }
}
