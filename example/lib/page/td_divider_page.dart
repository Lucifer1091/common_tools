import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDDividerPage extends StatelessWidget {
  const TDDividerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      desc:
          'Used to segment, organize, and refine logically organized element content and page structure.',
      exampleCodeGroup: 'divider',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Horizontal Divider', builder: _verticalDivider),
            ExampleItem(
              desc: 'Text Horizontal Divider',
              builder: _verticalTextDivider,
            ),
            ExampleItem(
              desc: 'Vertical Divider',
              builder: _horizontalTextDivider,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component States',
          children: [
            ExampleItem(desc: 'Dashed Style', builder: _dashedDivider),
          ],
        ),
      ],
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Container(alignment: Alignment.center, child: const MyDivider()),
    );
  }

  Widget _verticalTextDivider(BuildContext context) {
    return Column(
      children: const [
        MyDivider(text: 'Left', alignment: MyTextAlignment.left),
        Gap(20),
        MyDivider(text: 'Center', alignment: MyTextAlignment.center),
        Gap(20),
        MyDivider(text: 'Right', alignment: MyTextAlignment.right),
      ],
    );
  }

  Widget _horizontalTextDivider(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Gap(16),
          MyText(
            'Text Message',
            textColor: context.colorScheme.mutedForeground,
          ),
          const MyDivider(
            width: 0.5,
            height: 12,
            margin: EdgeInsets.only(left: 16, right: 16),
          ),
          MyText(
            'Text Message',
            textColor: context.colorScheme.mutedForeground,
          ),
          const MyDivider(
            width: 0.5,
            height: 12,
            margin: EdgeInsets.only(left: 16, right: 16),
            isDashed: true,
            direction: Axis.vertical,
          ),
          MyText(
            'Text Message',
            textColor: context.colorScheme.mutedForeground,
          ),
        ],
      ),
    );
  }

  Widget _dashedDivider(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 20),
        MyDivider(isDashed: true),
        SizedBox(height: 20),
        MyDivider(
          text: 'Text Message',
          alignment: MyTextAlignment.left,
          isDashed: true,
        ),
        SizedBox(height: 20),
        MyDivider(
          text: 'Text Message',
          alignment: MyTextAlignment.center,
          isDashed: true,
        ),
        SizedBox(height: 20),
        MyDivider(
          text: 'Text Message',
          alignment: MyTextAlignment.right,
          isDashed: true,
        ),
      ],
    );
  }
}
