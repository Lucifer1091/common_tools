import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDTextareaPage extends StatefulWidget {
  const TDTextareaPage({Key? key}) : super(key: key);

  @override
  _TDTextareaPageState createState() => _TDTextareaPageState();
}

class _TDTextareaPageState extends State<TDTextareaPage> {
  var controller = <TextEditingController>[];

  @override
  void initState() {
    for (var i = 0; i < 20; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: const Color(0xFFF0F2F5),
      title: tdTitle(),
      desc: '用于多行文本信息输入。',
      exampleCodeGroup: 'textarea',
      children: [],
      test: [],
    );
  }
}
