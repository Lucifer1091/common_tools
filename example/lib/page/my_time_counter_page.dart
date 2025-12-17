import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class MyTimeCounterPage extends StatelessWidget {
  const MyTimeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'Used as a visual tool that tracks the remaining days, hours, and minutes',
      exampleCodeGroup: 'timeCounter',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Default HH:mm:ss',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildSimple,
            ),
            ExampleItem(
              desc: 'Default HH:mm:ss with Milliseconds',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildMillisecondSimple,
            ),
            ExampleItem(
              desc: 'Forward Direction - Stop Watch',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildUpSimple,
            ),
            ExampleItem(
              desc: 'Square Theme',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildSquareSimple,
            ),
            ExampleItem(
              desc: 'Circle Theme',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildRoundSimple,
            ),
            ExampleItem(
              desc: 'With unit',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildUnitSimple,
            ),
            ExampleItem(
              desc: 'Units without background color band',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildCustomUnitSimple,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component size',
          children: [
            ExampleItem(
              desc: 'Only Numbers',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Small')),
                          _buildSmallSize(context),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Medium')),
                          _buildMediumSize(context),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Large')),
                          _buildLargeSize(context),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: 'Square Theme',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Small')),
                          _buildSquareSmallSize(context),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Medium')),
                          _buildSquareMediumSize(context),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Large')),
                          _buildSquareLargeSize(context),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: 'Circle Theme',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Small')),
                          _buildRoundSmallSize(context),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Medium')),
                          _buildRoundMediumSize(context),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 80, child: MyText('Large')),
                          _buildRoundLargeSize(context),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            ExampleItem(
              desc: 'Control countdown',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: _buildControl,
            ),
          ],
        ),
      ],
    );
  }
}

MyTimeCounter _buildSimple(BuildContext context) {
  return const MyTimeCounter(time: 60 * 60 * 1000);
}

MyTimeCounter _buildMillisecondSimple(BuildContext context) {
  return const MyTimeCounter(time: 60 * 60 * 1000, millisecond: true);
}

MyTimeCounter _buildUpSimple(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
    direction: MyTimeCounterDirection.up,
  );
}

MyTimeCounter _buildSquareSimple(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    theme: MyTimeCounterTheme.square,
  );
}

MyTimeCounter _buildRoundSimple(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    theme: MyTimeCounterTheme.round,
  );
}

MyTimeCounter _buildUnitSimple(BuildContext context) {
  return MyTimeCounter(
    time: 60 * 60 * 1000,
    theme: MyTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

MyTimeCounter _buildCustomUnitSimple(BuildContext context) {
  var style = MyTimeCounterStyle.generateStyle(context);
  style.color = context.colorScheme.destructive;
  return MyTimeCounter(time: 60 * 60 * 1000, splitWithUnit: true, style: style);
}

MyTimeCounter _buildSmallSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.small,
  );
}

MyTimeCounter _buildMediumSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.medium,
  );
}

MyTimeCounter _buildLargeSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.large,
  );
}

MyTimeCounter _buildSquareSmallSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.small,
    theme: MyTimeCounterTheme.square,
  );
}

MyTimeCounter _buildSquareMediumSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.medium,
    theme: MyTimeCounterTheme.square,
  );
}

MyTimeCounter _buildSquareLargeSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.large,
    theme: MyTimeCounterTheme.square,
  );
}

MyTimeCounter _buildRoundSmallSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.small,
    theme: MyTimeCounterTheme.round,
  );
}

MyTimeCounter _buildRoundMediumSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.medium,
    theme: MyTimeCounterTheme.round,
  );
}

MyTimeCounter _buildRoundLargeSize(BuildContext context) {
  return const MyTimeCounter(
    time: 60 * 60 * 1000,
    size: MyTimeCounterSize.large,
    theme: MyTimeCounterTheme.round,
  );
}

Widget _buildControl(BuildContext context) {
  var controller = MyTimeCounterController();
  return Wrap(
    direction: Axis.vertical,
    spacing: 8,
    children: [
      Wrap(
        spacing: 8,
        children: [
          MyButton(text: 'Start', onTap: controller.start),
          MyButton(text: 'Stop', onTap: () => controller.reset(0)),
          MyButton(text: 'Reset', onTap: controller.reset),
          MyButton(text: 'Pause', onTap: controller.pause),
          MyButton(text: 'Resume', onTap: controller.resume),
        ],
      ),
      MyTimeCounter(time: 60 * 60 * 1000, controller: controller),
    ],
  );
}
