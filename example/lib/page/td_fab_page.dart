import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class TDFabPage extends StatefulWidget {
  const TDFabPage({super.key});

  @override
  State<StatefulWidget> createState() => _TDFabPageState();
}

class _TDFabPageState extends State<TDFabPage> {
  bool showBorder = false;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'fab',
      children: [
        ExampleModule(title: 'Component types', children: [
          ],
        ),
        ExampleModule(title: 'Component status', children: [
            
          ],
        ),
      ],
    );
  }
}
