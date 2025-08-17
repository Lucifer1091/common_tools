import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

/// 字体示例页面
class TDFontPage extends StatelessWidget {
  const TDFontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPaintBaselinesEnabled = true;
    return ExamplePage(
      padding: const EdgeInsets.all(8),
      title: tdTitle(context),
      exampleCodeGroup: 'fonts',
      children: [],
    );
  }
}
