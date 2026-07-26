import 'package:flutter/material.dart';

import '../../base/example_widget.dart';

/// 字体示例页面
class TDFontPage extends StatelessWidget {
  const TDFontPage({super.key});

  @override
  Widget build(BuildContext context) {
    // debugPaintBaselinesEnabled = true;
    return ExamplePage(
      padding: const EdgeInsets.all(8),
      title: myTitle(context),
      exampleCodeGroup: 'fonts',
      children: [],
    );
  }
}
