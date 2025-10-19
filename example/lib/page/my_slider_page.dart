import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MySliderPage extends StatefulWidget {
  const MySliderPage({super.key});

  @override
  State<StatefulWidget> createState() => _MySliderPageState();
}

class DisplayRangeData {
  final Position currentPosition;
  final double currentTapValue;
  final Offset? tapOffset;

  DisplayRangeData({
    required this.currentPosition,
    required this.currentTapValue,
    this.tapOffset,
  });
}

class _MySliderPageState extends State<MySliderPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Used to select the value, range, and gear on the horizontal axis.',
      exampleCodeGroup: 'slider',
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Single Cursor Slider',
              builder: _buildSingleHandle,
            ),
            ExampleItem(
              desc: 'Dual Cursor Slider',
              builder: _buildDoubleHandle,
            ),
            ExampleItem(
              desc: 'Single Cursor Slider with Numeric Value',
              builder: _buildSingleHandleWithNumber,
            ),
            ExampleItem(
              desc: 'Dual Cursor Slider with Numeric Value',
              builder: _buildDoubleHandleWithNumber,
            ),
            ExampleItem(
              desc: 'Single Cursor Slider with Scale',
              builder: _buildSingleHandleWithScale,
            ),
            ExampleItem(
              desc: 'Dual Cursor Slider with Scale',
              builder: _buildDoubleHandleWithScale,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              desc: 'Disabled State',
              builder: _buildDisableSingleHandle,
            ),
            ExampleItem(builder: _buildDisableDoubleHandleWithNumber),
            ExampleItem(builder: _buildDisableDoubleHandleWithScale),
          ],
        ),
        ExampleModule(
          title: 'Component Events',
          children: [
            ExampleItem(desc: 'onTap', builder: _buildOnTapSingleHandle),
            ExampleItem(builder: _buildOnTapDoubleHandle),
            ExampleItem(
              desc: 'onThumbTextTap',
              builder: _buildOnThumbTextTapSingleHandle,
            ),
            ExampleItem(builder: _buildOnThumbTextTapDoubleHandle),
          ],
        ),
        ExampleModule(
          title: 'Special Style',
          children: [
            ExampleItem(
              desc: 'Capsule Slider',
              builder: _buildCapsuleSingleHandleWithNumber,
            ),
            ExampleItem(builder: _buildCapsuleDoubleHandle),
            ExampleItem(builder: _buildCapsuleSingleHandle),
            ExampleItem(builder: _buildCapsuleDoubleHandleWithNumber),
            ExampleItem(builder: _buildCapsuleSingleHandleWithScale),
            ExampleItem(builder: _buildCapsuleDoubleHandleWithScale),
            ExampleItem(desc: 'Capsule Slider', builder: _buildCapsule),
            ExampleItem(
              desc: 'Custom Box Style',
              builder: _buildCustomDecoration,
            ),
            ExampleItem(
              desc: 'Custom Slide Track Color',
              builder: _buildCustomActiveColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleHandle(BuildContext context) {
    return MySlider(
      sliderThemeData: MySliderThemeData(context: context, min: 0, max: 100),
      value: 10,
      onChanged: (value) {},
    );
  }

  Widget _buildDoubleHandle(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData(context: context, min: 0, max: 100),
      value: const RangeValues(10, 60),
      onChanged: (value) {},
    );
  }

  Widget _buildSingleHandleWithNumber(BuildContext context) {
    return MySlider(
      sliderThemeData: MySliderThemeData(
        context: context,
        showThumbValue: true,
        scaleFormatter: (value) => value.toInt().toString(),
        min: 0,
        max: 100,
      ),
      value: 10,
      leftLabel: '0',
      rightLabel: '100',
      onChanged: (value) {},
    );
  }

  Widget _buildDoubleHandleWithNumber(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.round().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(40, 60),
      onChanged: (value) {},
    );
  }

  Widget _buildSingleHandleWithScale(BuildContext context) {
    return MySlider(
      sliderThemeData: MySliderThemeData(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: 60,
      onChanged: (value) {},
    );
  }

  Widget _buildDoubleHandleWithScale(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(40, 70),
      onChanged: (value) {},
    );
  }

  Widget _buildDisableSingleHandle(BuildContext context) {
    return MySlider(
      sliderThemeData: MySliderThemeData(context: context, min: 0, max: 100),
      leftLabel: '0',
      rightLabel: '100',
      value: 40,
    );
  }

  Widget _buildDisableDoubleHandleWithNumber(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(20, 60),
    );
  }

  Widget _buildDisableDoubleHandleWithScale(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(20, 60),
    );
  }

  Widget _buildOnTapSingleHandle(BuildContext context) {
    var currentValue = 40.0;
    Offset? tapOffset;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText('Value: ${currentValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (tapOffset != null)
                  MyText(
                    'Tap at (${tapOffset!.dx.toStringAsFixed(0)}, ${tapOffset!.dy.toStringAsFixed(0)})',
                  ),
              ],
            ),
            MySlider(
              sliderThemeData: MySliderThemeData(
                context: context,
                min: 0,
                max: 100,
                showThumbValue: true,
              ),
              leftLabel: '0',
              rightLabel: '100',
              value: currentValue,
              onChanged: (value) {},
              onTap: (offset, value) {
                setState(() {
                  currentValue = value;
                  tapOffset = offset;
                });
                print('onTap  offset: $offset, value: $value');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOnTapDoubleHandle(BuildContext context) {
    final displayRangeDataNotifier = ValueNotifier<DisplayRangeData>(
      DisplayRangeData(
        currentPosition: Position.start,
        currentTapValue: 40.0,
        tapOffset: null,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<DisplayRangeData>(
          valueListenable: displayRangeDataNotifier,
          builder: (context, data, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText('Position: ${data.currentPosition}'),
                const SizedBox(width: 10),
                MyText('Value: ${data.currentTapValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (data.tapOffset != null)
                  MyText(
                    'Tap at (${data.tapOffset!.dx.toStringAsFixed(0)}, ${data.tapOffset!.dy.toStringAsFixed(0)})',
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        MyRangeSlider(
          sliderThemeData: MySliderThemeData(
            context: context,
            min: 0,
            max: 100,
            showThumbValue: true,
          ),
          leftLabel: '0',
          rightLabel: '100',
          value: const RangeValues(10, 60),
          onChanged: (value) {},
          onTap: (position, offset, value) {
            displayRangeDataNotifier.value = DisplayRangeData(
              currentPosition: position,
              currentTapValue: value,
              tapOffset: offset,
            );
            print('onTap offset: $offset, value: $value');
          },
        ),
      ],
    );
  }

  Widget _buildOnThumbTextTapSingleHandle(BuildContext context) {
    var currentValue = 40.0;
    Offset? tapOffset;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText('Value: ${currentValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (tapOffset != null)
                  MyText(
                    'Tap at (${tapOffset!.dx.toStringAsFixed(0)}, ${tapOffset!.dy.toStringAsFixed(0)})',
                  ),
              ],
            ),
            MySlider(
              sliderThemeData: MySliderThemeData(
                context: context,
                min: 0,
                max: 100,
                showThumbValue: true,
              ),
              leftLabel: '0',
              rightLabel: '100',
              value: currentValue,
              onChanged: (value) {},
              onThumbTextTap: (offset, value) {
                setState(() {
                  currentValue = value;
                  tapOffset = offset;
                });
                print('onTap  offset: $offset, value: $value');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOnThumbTextTapDoubleHandle(BuildContext context) {
    final displayRangeDataNotifier = ValueNotifier<DisplayRangeData>(
      DisplayRangeData(
        currentPosition: Position.start,
        currentTapValue: 40.0,
        tapOffset: null,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<DisplayRangeData>(
          valueListenable: displayRangeDataNotifier,
          builder: (context, data, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText('Position: ${data.currentPosition}'),
                const SizedBox(width: 10),
                MyText('Value: ${data.currentTapValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (data.tapOffset != null)
                  MyText(
                    'Tap at (${data.tapOffset!.dx.toStringAsFixed(0)}, ${data.tapOffset!.dy.toStringAsFixed(0)})',
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        MyRangeSlider(
          sliderThemeData: MySliderThemeData(
            context: context,
            min: 0,
            max: 100,
            showThumbValue: true,
          ),
          leftLabel: '0',
          rightLabel: '100',
          value: const RangeValues(10, 60),
          onChanged: (value) {},
          onThumbTextTap: (position, offset, value) {
            displayRangeDataNotifier.value = DisplayRangeData(
              currentPosition: position,
              currentTapValue: value,
              tapOffset: offset,
            );
            print('onTap offset: $offset, value: $value');
          },
        ),
      ],
    );
  }

  Widget _buildCapsuleSingleHandleWithNumber(BuildContext context) {
    return MySlider(
      sliderThemeData: MySliderThemeData.capsule(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: 40,
      onChanged: (value) {},
    );
  }

  Widget _buildCapsuleDoubleHandle(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData.capsule(
        context: context,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(20, 60),
      onChanged: (value) {},
    );
  }

  Widget _buildCapsuleSingleHandle(BuildContext context) {
    return MySlider(
      sliderThemeData: MySliderThemeData.capsule(
        context: context,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: 40,
      onChanged: (value) {},
    );
  }

  Widget _buildCapsuleDoubleHandleWithNumber(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData.capsule(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(20, 60),
      onChanged: (value) {},
    );
  }

  Widget _buildCapsuleSingleHandleWithScale(BuildContext context) {
    return MySlider(
      sliderThemeData: MySliderThemeData.capsule(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: 60,
      onChanged: (value) {},
    );
  }

  Widget _buildCapsule(BuildContext context) {
    return Column(
      children: [
        MySlider(
          sliderThemeData: MySliderThemeData.capsule(
            context: context,
            showThumbValue: true,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        MyRangeSlider(
          sliderThemeData: MySliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        MySlider(
          sliderThemeData: MySliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          leftLabel: '0',
          rightLabel: '100',
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        MyRangeSlider(
          sliderThemeData: MySliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            showThumbValue: true,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          leftLabel: '0',
          rightLabel: '100',
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        MySlider(
          sliderThemeData: MySliderThemeData.capsule(
            context: context,
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: 60,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        MyRangeSlider(
          sliderThemeData: MySliderThemeData.capsule(
            context: context,
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          // divisions: 5,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildCustomDecoration(BuildContext context) {
    return Column(
      children: [
        MySlider(
          sliderThemeData: MySliderThemeData(
            context: context,
            min: 0,
            max: 100,
          ),
          value: 40,
          boxDecoration: const BoxDecoration(color: Colors.amber),
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        MyRangeSlider(
          sliderThemeData: MySliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          boxDecoration: const BoxDecoration(color: Colors.deepOrangeAccent),
          value: const RangeValues(20, 60),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildCapsuleDoubleHandleWithScale(BuildContext context) {
    return MyRangeSlider(
      sliderThemeData: MySliderThemeData.capsule(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(20, 60),
      onChanged: (value) {},
    );
  }

  Widget _buildCustomActiveColor(BuildContext context) {
    return Column(
      children: [
        MySlider(
          sliderThemeData: MySliderThemeData(
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.green,
            context: context,
            min: 0,
            max: 100,
          ),
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        MyRangeSlider(
          sliderThemeData: MySliderThemeData.capsule(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.red,
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
