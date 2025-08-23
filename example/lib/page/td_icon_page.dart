import 'package:flutter/material.dart';

import '../../base/example_widget.dart';

class TDIconPage extends StatefulWidget {
  const TDIconPage({super.key});

  @override
  State<StatefulWidget> createState() => _TDIconPageState();
}

class _TDIconPageState extends State<TDIconPage> {
  bool showBorder = false;

  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: 'Icon 作为UI构成中重要的元素，一定程度上影响UI界面整体呈现出的风格。',
      exampleCodeGroup: 'icon',
      children: [ExampleModule(title: 'title', children: [])],
    );
  }
}
