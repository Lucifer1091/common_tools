import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyLoaderPage extends StatefulWidget {
  const MyLoaderPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyLoaderPageState();
}

class _MyLoaderPageState extends State<MyLoaderPage> {
  var rowSpace = const SizedBox(width: 52);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      backgroundColor: context.colorScheme.primaryForeground,
      exampleCodeGroup: 'loading',
      desc:
          'Used to indicate the loading status of a page or operation, giving users feedback while alleviating the anxiety of waiting. It consists of one or a group of feedback animations.',
      children: [
        ExampleModule(
          title: 'Basic Usage',
          children: [
            ExampleItem(desc: 'Only Icon', builder: _buildIconLoading),
            ExampleItem(
              desc: 'Icon + Horizontal Text',
              builder: _buildTextIconHorizontalLoading,
            ),
            ExampleItem(
              desc: 'Icon + Vertical Text',
              builder: _buildTextIconVerticalLoading,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Size',
          children: [
            ExampleItem(
              builder: _buildLoadingSizes,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
              builder: _buildLoaderTypes,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: 'Show/Hide Loading',
          ignoreCode: true,
          builder: (_) {
            var list = [
              MyButton(
                text: 'Show Loading',
                onTap: () {
                  MyLoadingController.show(context);
                },
              ),
              const SizedBox(width: 24),
              const MyButton(
                text: 'Hide Loading',
                onTap: MyLoadingController.dismiss,
              ),
            ];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: list),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIconLoading(BuildContext context) {
    return Wrap(
      spacing: 48,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        const MyLoader(icon: MyLoaderIcon.circle),
        const MyLoader(icon: MyLoaderIcon.activity),
        const MyLoader(icon: MyLoaderIcon.dots),
      ],
    );
  }

  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return Wrap(
      spacing: 48,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        MyLoader(
          icon: MyLoaderIcon.circle,
          text: 'Loading…',
          axis: Axis.horizontal,
        ),
        MyLoader(
          icon: MyLoaderIcon.circle,
          axis: Axis.horizontal,
          text: 'Loading failed',
          refreshWidget: MyGestureDetector(
            child: MyText(
              'Refresh',
              fontSize: context.bodyMedium.fontSize,
              textColor: context.colorScheme.primary,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              TDToast.showText('Refresh', context: context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return Wrap(
      spacing: 48,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        MyLoader(
          icon: MyLoaderIcon.circle,
          text: 'Loading…',
          axis: Axis.vertical,
        ),
        MyLoader(
          icon: MyLoaderIcon.wobble,
          text: 'Loading…',
          axis: Axis.vertical,
        ).sizedBox(width: 100),
        MyLoader(
          icon: MyLoaderIcon.circle,
          text: 'Loading failed',
          refreshWidget: MyGestureDetector(
            child: MyText(
              'Refresh',
              fontSize: context.bodyMedium.fontSize,
              textColor: context.colorScheme.primary,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              TDToast.showText('Refresh', context: context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSizes(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 16,
      spacing: 32,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const MyLoader(
          size: MyLoaderSize.extraLarge,
          text: 'Extra Large…',
          axis: Axis.horizontal,
        ),
        const MyLoader(
          size: MyLoaderSize.large,
          text: 'Large…',
          axis: Axis.horizontal,
        ),
        const MyLoader(
          size: MyLoaderSize.medium,
          text: 'Medium…',
          axis: Axis.horizontal,
        ),
        const MyLoader(
          icon: MyCircleLoader(
            options: MyLoaderOptions(size: MyLoaderSize.small, strokeWidth: 3),
          ),
          text: 'Small…',
          axis: Axis.horizontal,
        ),
        MyLoader(
          icon: MyCircleLoader(
            options: MyLoaderOptions(
              size: MyLoaderSize.extraSmall,
              strokeWidth: 2,
            ),
          ),
          text: 'Extra Small…',
          axis: Axis.horizontal,
        ),
      ],
    );
  }

  Widget _buildLoaderTypes(BuildContext context) {
    return Wrap(
      spacing: 48,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        const MyLoader(text: 'Circle'),
        const MyLoader(
          text: 'Line',
          icon: MyLoaderIcon.line,
        ).padding(horizontal: 16),
        const MyLoader(text: 'Dots', icon: MyLoaderIcon.dots),
        const MyLoader(text: 'Spin', icon: MyLoaderIcon.spin),
        const MyLoader(text: 'Cardio', icon: MyLoaderIcon.cardio),
        const MyLoader(text: 'Clock', icon: MyClockLoader(size: 50)),
        const MyLoader(text: 'Activity', icon: MyLoaderIcon.activity),
        const MyLoader(text: 'Wobble', icon: MyLoaderIcon.wobble),
        const MyLoader(text: 'Pacman', icon: MyLoaderIcon.pacman),
        const MyLoader(text: 'Triangle', icon: MyLoaderIcon.triangle),
        const MyLoader(text: 'Square', icon: MyLoaderIcon.square),
        const MyLoader(text: 'Text', icon: MyLoaderIcon.text),
        const MyLoader(text: 'Trefoil', icon: MyLoaderIcon.trefoil),
      ],
    );
  }
}
