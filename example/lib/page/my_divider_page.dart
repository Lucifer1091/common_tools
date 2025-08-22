import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyDividerPage extends StatelessWidget {
  const MyDividerPage({super.key});

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
            ExampleItem(
              desc: 'Horizontal Dividers',
              builder: _horizontalDividers,
            ),
            ExampleItem(desc: 'Vertical Dividers', builder: _verticalDividers),
          ],
        ),
        ExampleModule(
          title: 'Component Styles',
          children: [
            ExampleItem(
              desc: 'Horizontal Text / Widget Dividers',
              builder: _horizontalTextDividers,
            ),
            ExampleItem(
              desc: 'Vertical Text / Widget Dividers',
              builder: _verticalTextDividers,
            ),
          ],
        ),
      ],
    );
  }

  Widget _horizontalDividers(BuildContext context) {
    return FlexColumn(
      gap: 24,
      children: [
        const MyDivider(),
        const MyDivider(type: MyDividerType.dotted),
        const MyDivider(type: MyDividerType.dashed),
        const MyDivider(type: MyDividerType.wavy),
      ],
    );
  }

  Widget _verticalDividers(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FlexRow(
        gap: 16,
        children: [
          Gap(4),
          MyText('Hello', textColor: context.colorScheme.mutedForeground),
          const MyDivider(direction: Axis.vertical),
          MyText('World', textColor: context.colorScheme.mutedForeground),
          const MyDivider(type: MyDividerType.dotted, direction: Axis.vertical),
          MyText('Text', textColor: context.colorScheme.mutedForeground),
          const MyDivider(type: MyDividerType.dashed, direction: Axis.vertical),
          MyText(' Message', textColor: context.colorScheme.mutedForeground),
          const MyDivider(type: MyDividerType.wavy, direction: Axis.vertical),
        ],
      ),
    );
  }

  Widget _horizontalTextDividers(BuildContext context) {
    return FlexColumn(
      gap: 16,
      children: [
        MyDivider(text: 'Left', alignment: MyTextAlignment.left),
        MyDivider(
          text: 'Center',
          alignment: MyTextAlignment.center,
          type: MyDividerType.dotted,
        ),
        MyDivider(
          text: 'Right',
          alignment: MyTextAlignment.right,
          type: MyDividerType.dashed,
        ),
        MyDivider(
          text: 'Left',
          alignment: MyTextAlignment.left,
          type: MyDividerType.wavy,
        ),
        MyDivider(
          widget: Icon(
            Icons.star_outline_rounded,
            color: context.colorScheme.mutedForeground,
          ),
          alignment: MyTextAlignment.center,
          type: MyDividerType.dotted,
        ),
        MyDivider(
          widget: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          alignment: MyTextAlignment.right,
          type: MyDividerType.dashed,
        ),
      ],
    );
  }

  Widget _verticalTextDividers(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FlexRow(
        gap: 32,
        children: [
          SizedBox.shrink(),
          MyDivider(
            text: 'Text Message',
            alignment: MyTextAlignment.left,
            direction: Axis.vertical,
          ),
          MyDivider(
            text: 'Text Message',
            alignment: MyTextAlignment.center,
            type: MyDividerType.dotted,
            direction: Axis.vertical,
          ),
          MyDivider(
            text: 'Text Message',
            alignment: MyTextAlignment.right,
            type: MyDividerType.dashed,
            direction: Axis.vertical,
          ),
          MyDivider(
            text: 'Text Message',
            alignment: MyTextAlignment.right,
            type: MyDividerType.wavy,
            direction: Axis.vertical,
          ),
          MyDivider(
            widget: Icon(
              Icons.star_outline_rounded,
              color: context.colorScheme.mutedForeground,
            ),
            alignment: MyTextAlignment.center,
            type: MyDividerType.dotted,
            direction: Axis.vertical,
          ),
          MyDivider(
            widget: Container(
              width: 5,
              height: 50,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            alignment: MyTextAlignment.center,
            type: MyDividerType.dashed,
            direction: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
