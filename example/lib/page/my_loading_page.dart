import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyLoadingPage extends StatefulWidget {
  const MyLoadingPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyLoadingPageState();
}

class _MyLoadingPageState extends State<MyLoadingPage> {
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
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Pure Icon', builder: _buildPureIconLoading),
            ExampleItem(
              desc: 'Icon + Text Horizontal',
              builder: _buildTextIconHorizontalLoading,
            ),
            ExampleItem(
              desc: 'Icon + Text Vertical',
              builder: _buildTextIconVerticalLoading,
            ),
            ExampleItem(desc: 'Pure Text', builder: _buildPureTextLoading),
          ],
        ),
        ExampleModule(
          title: 'Component Size',
          children: [
            ExampleItem(desc: 'Large', builder: _buildLargeLoading),
            ExampleItem(desc: 'Medium', builder: _buildMediumLoading),
            ExampleItem(desc: 'Small', builder: _buildSmallLoading),
          ],
        ),
        ExampleModule(
          title: 'Loading Speed',
          children: [
            ExampleItem(
              desc: 'Adjust loading speed',
              builder: _buildCustomSpeedLoading,
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

  Widget _buildRow(List<Widget> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.fold(
            [],
            (previousValue, element) => [...previousValue, element, rowSpace],
          ),
        ),
      ),
    );
  }

  Widget _buildPureIconLoading(BuildContext context) {
    return _buildRow([
      const MyLoader(size: MyLoaderSize.small, icon: MyLoaderIcon.circle),
      const MyLoader(size: MyLoaderSize.small, icon: MyLoaderIcon.activity),
      MyLoader(
        size: MyLoaderSize.small,
        icon: MyLoaderIcon.point,
        iconColor: context.colorScheme.primary,
      ),
    ]);
  }

  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return _buildRow([
      MyLoader(
        size: MyLoaderSize.small,
        icon: MyLoaderIcon.circle,
        text: 'Loading…',
        axis: Axis.horizontal,
      ),
      MyLoader(
        size: MyLoaderSize.small,
        icon: MyLoaderIcon.activity,
        text: 'Loading…',
        axis: Axis.horizontal,
      ),
      MyLoader(
        icon: MyLoaderIcon.circle,
        size: MyLoaderSize.small,
        axis: Axis.horizontal,
        text: 'Loading failed',
        refreshWidget: GestureDetector(
          child: MyText(
            'Refresh',
            fontSize: context.bodySmall.fontSize,
            textColor: context.colorScheme.primary,
          ),
          onTap: () {
            TDToast.showText('Refresh', context: context);
          },
        ),
      ),
    ]);
  }

  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return _buildRow([
      MyLoader(
        size: MyLoaderSize.small,
        icon: MyLoaderIcon.circle,
        text: 'Loading…',
        axis: Axis.vertical,
      ),
      MyLoader(
        size: MyLoaderSize.small,
        icon: MyLoaderIcon.activity,
        text: 'Loading…',
        axis: Axis.vertical,
      ),
      MyLoader(
        icon: MyLoaderIcon.circle,
        size: MyLoaderSize.small,
        text: 'Loading failed',
        refreshWidget: GestureDetector(
          child: MyText(
            'Refresh',
            fontSize: context.bodySmall.fontSize,
            textColor: context.colorScheme.primary,
          ),
          onTap: () {
            TDToast.showText('Refresh', context: context);
          },
        ),
      ),
    ]);
  }

  Widget _buildPureTextLoading(BuildContext context) {
    return _buildRow([
      const MyLoader(size: MyLoaderSize.small, text: 'Loading…'),
      MyLoader(
        size: MyLoaderSize.small,
        text: 'Loading failed',
        textColor: context.colorScheme.mutedForeground,
      ),
      MyLoader(
        size: MyLoaderSize.small,
        text: 'Loading failed',
        refreshWidget: GestureDetector(
          child: MyText(
            'Refresh',
            fontSize: context.bodySmall.fontSize,
            textColor: context.colorScheme.primary,
          ),
          onTap: () {
            TDToast.showText('Refresh', context: context);
          },
        ),
      ),
    ]);
  }

  Widget _buildLargeLoading(BuildContext context) {
    return _buildRow([
      const MyLoader(
        size: MyLoaderSize.large,
        icon: MyLoaderIcon.circle,
        text: 'Loading…',
        axis: Axis.horizontal,
      ),
    ]);
  }

  Widget _buildMediumLoading(BuildContext context) {
    return _buildRow([
      const MyLoader(
        size: MyLoaderSize.medium,
        icon: MyLoaderIcon.circle,
        text: 'Loading…',
        axis: Axis.horizontal,
      ),
    ]);
  }

  Widget _buildSmallLoading(BuildContext context) {
    return _buildRow([
      const MyLoader(
        size: MyLoaderSize.small,
        icon: MyLoaderIcon.circle,
        text: 'Loading…',
        axis: Axis.horizontal,
      ),
    ]);
  }

  double _currentSliderValue = 1000;

  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyLoader(
            size: MyLoaderSize.small,
            icon: MyLoaderIcon.circle,
            axis: Axis.horizontal,
            text: 'Loading…',
            duration: _currentSliderValue.round(),
          ),
          TDSlider(
            value: _currentSliderValue,
            sliderThemeData: TDSliderThemeData(
              context: context,
              max: 2000,
              min: -20,
              divisions: 100,
              showThumbValue: true,
              scaleFormatter: (value) => value.toInt().toString(),
            ),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
