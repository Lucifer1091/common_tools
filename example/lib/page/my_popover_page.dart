import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../base/example_widget.dart';

class MyPopoverPage extends StatefulWidget {
  const MyPopoverPage({super.key});

  @override
  State<StatefulWidget> createState() => _TDPopoverPage();
}

class _TDPopoverPage extends State<MyPopoverPage> {
  final popoverController = MyPopoverController();

  final List<({String name, String initialValue})> layer = [
    (name: 'Width', initialValue: '100%'),
    (name: 'Max. width', initialValue: '300px'),
    (name: 'Height', initialValue: '25px'),
    (name: 'Max. height', initialValue: 'none'),
  ];

  @override
  void dispose() {
    popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Displays rich content in a portal, triggered by a button.',
      exampleCodeGroup: 'popover',
      backgroundColor: context.colorScheme.primaryForeground,
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [ExampleItem(desc: 'Sample Form', builder: _buildPopover)],
        ),
      ],
    );
  }

  Widget _buildPopover(BuildContext context) {
    return MyPopover(
      controller: popoverController,
      popover: (_) => SizedBox(
        width: 288,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dimensions',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Set the dimensions for the layer.',
              style: context.bodyMedium,
            ),
            const Gap(8),
            ...layer.map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Text(e.name, textAlign: TextAlign.start)),
                  Expanded(
                    flex: 2,
                    child: MyInput(initialValue: e.initialValue),
                  ),
                ],
              ).padding(bottom: 8),
            ),
            const Gap(8),
            CenterRight(
              child: MyButton(text: 'Submit', onTap: popoverController.toggle),
            ),
            const Gap(8),
          ],
        ),
      ),
      child: MyButton(
        type: MyButtonType.outline,
        onTap: popoverController.toggle,
        child: const Text('Open popover'),
      ),
    );
  }
}
