import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
        ExampleModule(
          title: 'Loading Overlay Types',
          children: [
            ExampleItem(
              desc: 'Async Loading',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MyButton(
                    text: 'Show Loading',
                    onTap: () {
                      MyLoadingOverlay.async(
                        context,
                        size: MyLoaderSize.extraLarge,
                        text:
                            'This loader will be shown for 5 seconds\n'
                            'then it will dismiss automatically.',
                        future: () async {
                          await 5.seconds.delay();
                        },
                      );
                    },
                  ),
                );
              },
            ),
            ExampleItem(
              desc: 'Show/Hide Loading',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MyButton(
                    text: 'Show Loading',
                    onTap: () {
                      MyLoadingOverlay.show(
                        context,
                        icon: MyLoaderIcon.text,
                        size: MyLoaderSize.extraLarge,
                        text: 'Hide Loading Manually',
                        refreshWidget: MyButton(
                          text: 'Dismiss',
                          onTap: MyLoadingOverlay.dismiss,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
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
      runSpacing: 24,
      spacing: 54,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: MyLoaderSize.values.map((size) {
        return MyLoader(
          size: size,
          options: MyLoaderOptions(
            size: size,
            strokeWidth: size == MyLoaderSize.small
                ? 3
                : size == MyLoaderSize.extraSmall
                ? 2
                : null,
          ),
          text: '${size.name.sentenceCase}…',
          axis: Axis.horizontal,
        );
      }).toList(),
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
