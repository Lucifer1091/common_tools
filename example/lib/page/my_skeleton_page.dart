import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

class MySkeletonPage extends StatefulWidget {
  const MySkeletonPage({super.key});

  @override
  State<StatefulWidget> createState() => _MySkeletonPageState();
}

class _MySkeletonPageState extends State<MySkeletonPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          'When the network is slow, show the user the general structure of the page before the actual page data loads.',
      exampleCodeGroup: 'skeleton',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Avatar Skeleton Screen',
              builder: _wrapper(_buildAvatarSkeleton),
              methodName: '_buildAvatarSkeleton',
            ),
            ExampleItem(
              desc: 'Image Skeleton',
              builder: _wrapper(_buildImageSkeleton),
              methodName: '_buildImageSkeleton',
            ),
            ExampleItem(
              desc: 'Text skeleton screen',
              builder: _wrapper(_buildTextSkeleton, isFlexible: true),
              methodName: '_buildTextSkeleton',
            ),
            ExampleItem(
              desc: 'Paragraph skeleton screen',
              builder: _wrapper(_buildParagraphSkeleton, isFlexible: true),
              methodName: '_buildParagraphSkeleton',
            ),
            ExampleItem(
              desc: 'Cell skeleton screen',
              builder: _wrapper(_buildCellSkeleton),
              methodName: '_buildCellSkeleton',
            ),
            ExampleItem(
              desc: 'Grid-style frame screen',
              builder: _wrapper(_buildGridSkeleton),
              methodName: '_buildGridSkeleton',
            ),
            ExampleItem(
              desc: 'Image and text combined skeleton screen',
              builder: _wrapper(_buildCombineSkeleton),
              methodName: '_buildCombineSkeleton',
            ),
            ExampleItem(
              desc: 'Preset card skeleton',
              builder: _wrapper(_buildPresetCardSkeleton, isFlexible: true),
              methodName: '_buildPresetCardSkeleton',
            ),
            ExampleItem(
              desc: 'Preset lines skeleton',
              builder: _wrapper(_buildPresetLinesSkeleton, isFlexible: true),
              methodName: '_buildPresetLinesSkeleton',
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Animations',
          children: [
            ExampleItem(
              desc: 'Gradient loading effect',
              builder: _wrapper(_buildGradientSkeleton, isFlexible: true),
              methodName: '_buildGradientSkeleton',
            ),
            ExampleItem(
              desc: 'Custom style (RTL)',
              builder: _wrapper(_buildCustomStyleSkeleton, isFlexible: true),
              methodName: '_buildCustomStyleSkeleton',
            ),
            ExampleItem(
              desc: 'No animation effect',
              builder: _wrapper(_buildNoneSkeleton, isFlexible: true),
              methodName: '_buildNoneSkeleton',
            ),
          ],
        ),
      ],
    );
  }

  Widget Function(BuildContext) _wrapper(
    Function(BuildContext) builder, {
    bool isFlexible = false,
  }) =>
      (context) => Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: isFlexible
            ? Row(children: [builder(context)])
            : builder(context),
      );

  Widget _buildAvatarSkeleton(BuildContext context) {
    return MySkeleton(theme: MySkeletonTheme.avatar);
  }

  Widget _buildImageSkeleton(BuildContext context) {
    return MySkeleton(theme: MySkeletonTheme.image);
  }

  Widget _buildTextSkeleton(BuildContext context) {
    return MySkeleton(theme: MySkeletonTheme.text);
  }

  Widget _buildParagraphSkeleton(BuildContext context) {
    return MySkeleton(theme: MySkeletonTheme.paragraph);
  }

  Widget _buildCellSkeleton(BuildContext context) {
    var rowColsAvatar = MySkeleton(theme: MySkeletonTheme.avatar);
    var rowColsImage = MySkeleton.fromRowCol(
      rowCol: MySkeletonRowCol(
        objects: const [
          [MySkeletonItem.rect(width: 48, height: 48, flex: null)],
        ],
      ),
    );
    var rowColsContent = MySkeleton.fromRowCol(
      rowCol: MySkeletonRowCol(
        objects: const [
          [MySkeletonItem(), MySkeletonItem.spacer(flex: 1)],
          [MySkeletonItem()],
        ],
      ),
    );

    return Column(
      spacing: 16,
      children: [
        Row(spacing: 12, children: [rowColsAvatar, rowColsContent]),
        Row(spacing: 12, children: [rowColsImage, rowColsContent]),
      ],
    );
  }

  Widget _buildGridSkeleton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 5; i++)
          MySkeleton.fromRowCol(
            rowCol: MySkeletonRowCol(
              objects: const [
                [MySkeletonItem.rect(width: 48, height: 48, flex: null)],
                [MySkeletonItem.text(width: 48, flex: null)],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCombineSkeleton(BuildContext context) {
    var rowCols = Flexible(
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            MySkeleton.fromRowCol(
              rowCol: MySkeletonRowCol(
                objects: [
                  [
                    MySkeletonItem(
                      width: constraints.maxWidth * 0.96,
                      height: constraints.maxWidth,
                      flex: null,
                      style: MySkeletonItemStyle(
                        borderRadius: (context) => MyRadius.extraLarge,
                      ),
                    ),
                  ],
                  [MySkeletonItem.text(width: constraints.maxWidth * 0.96)],
                  const [MySkeletonItem.text(), MySkeletonItem.spacer(flex: 1)],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Row(children: [rowCols, SizedBox(width: 4), rowCols]);
  }

  Widget _buildPresetCardSkeleton(BuildContext context) {
    return MySkeleton.card();
  }

  Widget _buildPresetLinesSkeleton(BuildContext context) {
    return MySkeleton.lines(count: 4);
  }

  Widget _buildGradientSkeleton(BuildContext context) {
    return MySkeleton(
      animation: MySkeletonAnimation.gradient,
      theme: MySkeletonTheme.paragraph,
    );
  }

  Widget _buildNoneSkeleton(BuildContext context) {
    return MySkeleton(
      animation: MySkeletonAnimation.none,
      theme: MySkeletonTheme.paragraph,
    );
  }

  Widget _buildCustomStyleSkeleton(BuildContext context) {
    return MySkeleton.lines(
      count: 4,
      style: const MySkeletonStyle(direction: MySkeletonDirection.rtl),
    );
  }
}
