import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDTimeCounterPage extends StatelessWidget {
  const TDTimeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: tdTitle(context),
        desc: '用于实时展示计时数值。',
        exampleCodeGroup: 'timeCounter',
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '时分秒',
                center: false,
                padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return _buildSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带毫秒',
                center: false,
                padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return _buildMillisecondSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '正向计时',
                center: false,
                padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return _buildUpSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带方形底',
                center: false,
                padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return _buildSquareSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带圆形底',
                center: false,
                padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return _buildRoundSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带单位',
                center: false,
                padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return _buildUnitSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '无底色带单位',
                center: false,
                padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return _buildCustomUnitSimple(context);
                },
              ),
            ],
          ),
          ExampleModule(
            title: '组件尺寸',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '纯数字',
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
                            SizedBox(width: 80, child: Text('小')),
                            _buildSmallSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('中')),
                            _buildMediumSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('大')),
                            _buildLargeSize(context),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带方形底',
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
                            SizedBox(width: 80, child: Text('小')),
                            _buildSquareSmallSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('中')),
                            _buildSquareMediumSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('大')),
                            _buildSquareLargeSize(context),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带圆形底',
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
                            SizedBox(width: 80, child: Text('小')),
                            _buildRoundSmallSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('中')),
                            _buildRoundMediumSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('大')),
                            _buildRoundLargeSize(context),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带单位',
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
                            SizedBox(width: 80, child: Text('小')),
                            _buildUnitSmallSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('中')),
                            _buildUnitMediumSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('大')),
                            _buildUnitLargeSize(context),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '无底色带单位',
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
                            SizedBox(width: 80, child: Text('小')),
                            _buildCustomUnitSmallSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('中')),
                            _buildCustomUnitMediumSize(context),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('大')),
                            _buildCustomUnitLargeSize(context),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
        test: [
          ExampleItem(
            ignoreCode: true,
            desc: '控制倒计时',
            center: false,
            padding: const EdgeInsets.only(left: 16),
            builder: (BuildContext context) {
              return _buildControl(context);
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '自定义显示位数',
            center: false,
            padding: const EdgeInsets.only(left: 16),
            builder: (BuildContext context) {
              return _buildCustomNum(context);
            },
          ),
        ],
      ),
    );
  }
}

TDTimeCounter _buildSimple(BuildContext context) {
  return const TDTimeCounter(time: 60 * 60 * 1000);
}

TDTimeCounter _buildMillisecondSimple(BuildContext context) {
  return const TDTimeCounter(time: 60 * 60 * 1000, millisecond: true);
}

TDTimeCounter _buildUpSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
    direction: TDTimeCounterDirection.up,
  );
}

TDTimeCounter _buildSquareSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    theme: TDTimeCounterTheme.square,
  );
}

TDTimeCounter _buildRoundSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    theme: TDTimeCounterTheme.round,
  );
}

TDTimeCounter _buildUnitSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

TDTimeCounter _buildCustomUnitSimple(BuildContext context) {
  var style = TDTimeCounterStyle.generateStyle(context);
  style.timeColor = ThemeColors.error.shade500;
  return TDTimeCounter(time: 60 * 60 * 1000, splitWithUnit: true, style: style);
}

TDTimeCounter _buildSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
  );
}

TDTimeCounter _buildMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
  );
}

TDTimeCounter _buildLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
  );
}

TDTimeCounter _buildSquareSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
    theme: TDTimeCounterTheme.square,
  );
}

TDTimeCounter _buildSquareMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
    theme: TDTimeCounterTheme.square,
  );
}

TDTimeCounter _buildSquareLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
    theme: TDTimeCounterTheme.square,
  );
}

TDTimeCounter _buildRoundSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
    theme: TDTimeCounterTheme.round,
  );
}

TDTimeCounter _buildRoundMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
    theme: TDTimeCounterTheme.round,
  );
}

TDTimeCounter _buildRoundLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
    theme: TDTimeCounterTheme.round,
  );
}

TDTimeCounter _buildUnitSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

TDTimeCounter _buildUnitMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

TDTimeCounter _buildUnitLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

TDTimeCounter _buildCustomUnitSmallSize(BuildContext context) {
  var style = TDTimeCounterStyle.generateStyle(
    context,
    size: TDTimeCounterSize.small,
  );
  style.timeColor = ThemeColors.error.shade500;
  return TDTimeCounter(time: 60 * 60 * 1000, splitWithUnit: true, style: style);
}

TDTimeCounter _buildCustomUnitMediumSize(BuildContext context) {
  var style = TDTimeCounterStyle.generateStyle(
    context,
    size: TDTimeCounterSize.medium,
  );
  style.timeColor = ThemeColors.error.shade500;
  return TDTimeCounter(time: 60 * 60 * 1000, splitWithUnit: true, style: style);
}

TDTimeCounter _buildCustomUnitLargeSize(BuildContext context) {
  var style = TDTimeCounterStyle.generateStyle(
    context,
    size: TDTimeCounterSize.large,
  );
  style.timeColor = ThemeColors.error.shade500;
  return TDTimeCounter(time: 60 * 60 * 1000, splitWithUnit: true, style: style);
}

Widget _buildControl(BuildContext context) {
  var controller = TDTimeCounterController();
  return Wrap(
    direction: Axis.vertical,
    spacing: 8,
    children: [
      Wrap(
        spacing: 8,
        children: [
          MyButton(
            text: '开始',
            size: MyButtonSize.extraSmall,
            onTap: () {
              controller.start();
            },
          ),
          MyButton(
            text: '结束',
            size: MyButtonSize.extraSmall,
            onTap: () {
              controller.reset(0);
            },
          ),
          MyButton(
            text: '重置',
            size: MyButtonSize.extraSmall,
            onTap: () {
              controller.reset();
            },
          ),
          MyButton(
            text: '暂停',
            size: MyButtonSize.extraSmall,
            onTap: () {
              controller.pause();
            },
          ),
          MyButton(
            text: '继续',
            size: MyButtonSize.extraSmall,
            onTap: () {
              controller.resume();
            },
          ),
        ],
      ),
      TDTimeCounter(
        time: 60 * 60 * 1000,
        controller: controller,
        // autoStart: false,
      ),
    ],
  );
}

TDTimeCounter _buildCustomNum(BuildContext context) {
  return const TDTimeCounter(time: 2000 * 60 * 1000, format: 'mmmmmmm分sss秒');
}
