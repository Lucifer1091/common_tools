/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDLoadingPage extends StatefulWidget {
  const TDLoadingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDLoadingPageState();
}

class _TDLoadingPageState extends State<TDLoadingPage> {
  var rowSpace = const SizedBox(width: 52);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      backgroundColor: context.colorScheme.primaryForeground,
      exampleCodeGroup: 'loading',
      desc: '用于表示页面或操作的加载状态，给予用户反馈的同时减缓等待的焦虑感，由一个或一组反馈动效组成。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '纯图标', builder: _buildPureIconLoading),
            ExampleItem(
              desc: '图标加文字横向',
              builder: _buildTextIconHorizontalLoading,
            ),
            ExampleItem(
              desc: '图标加文字竖向',
              builder: _buildTextIconVerticalLoading,
            ),
            ExampleItem(desc: '纯文字', builder: _buildPureTextLoading),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(desc: '大尺寸', builder: _buildLargeLoading),
            ExampleItem(desc: '中尺寸', builder: _buildMediumLoading),
            ExampleItem(desc: '小尺寸', builder: _buildSmallLoading),
          ],
        ),
        ExampleModule(
          title: '加载速度',
          children: [
            ExampleItem(desc: '调整加载速度', builder: _buildCustomSpeedLoading),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: '带图标的失败横向Loading',
          ignoreCode: true,
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: TDLoading(
                icon: TDLoadingIcon.circle,
                size: TDLoadingSize.small,
                axis: Axis.horizontal,
                text: '加载失败',
                refreshWidget: GestureDetector(
                  child: TDText(
                    '刷新',
                    fontSize: context.bodySmall.fontSize,
                    textColor: context.colorScheme.primary,
                  ),
                  onTap: () {
                    TDToast.showText('刷新', context: context);
                  },
                ),
              ),
            );
          },
        ),
        ExampleItem(
          desc: '带图标的失败竖向Loading',
          ignoreCode: true,
          builder: (_) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: TDLoading(
                icon: TDLoadingIcon.circle,
                size: TDLoadingSize.small,
                text: '加载失败',
                refreshWidget: GestureDetector(
                  child: TDText(
                    '刷新',
                    fontSize: context.bodySmall.fontSize,
                    textColor: context.colorScheme.primary,
                  ),
                  onTap: () {
                    TDToast.showText('刷新', context: context);
                  },
                ),
              ),
            );
          },
        ),
        ExampleItem(
          desc: '验证居中问题',
          ignoreCode: true,
          builder: (_) {
            var list = const [
              TDLoading(
                size: TDLoadingSize.large,
                icon: TDLoadingIcon.circle,
                text: '加载中…',
                axis: Axis.vertical,
              ),
              TDLoading(
                size: TDLoadingSize.large,
                icon: TDLoadingIcon.activity,
                text: '加载中…',
                axis: Axis.vertical,
              ),
            ];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: list.fold(
                  [],
                  (previousValue, element) => [
                    ...previousValue,
                    Container(
                      color: ThemeColors.neutral.shade500,
                      child: element,
                    ),
                    rowSpace,
                  ],
                ),
              ),
            );
          },
        ),
        ExampleItem(
          desc: '展示/隐藏Loading',
          ignoreCode: true,
          builder: (_) {
            var list = [
              MyButton(
                text: '展示Loading',
                
                onTap: () {
                  TDLoadingController.show(context);
                },
              ),
              const SizedBox(width: 24),
              const MyButton(
                text: '隐藏Loading',
                
                onTap: TDLoadingController.dismiss,
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

  /// 纯图标

  Widget _buildPureIconLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(size: TDLoadingSize.small, icon: TDLoadingIcon.circle),
      const TDLoading(size: TDLoadingSize.small, icon: TDLoadingIcon.activity),
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.point,
        iconColor: context.colorScheme.primary,
      ),
    ]);
  }

  /// 图标加文字横向

  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return _buildRow(const [
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.activity,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }

  /// 图标加文字竖向

  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return _buildRow(const [
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.vertical,
      ),
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.activity,
        text: '加载中…',
        axis: Axis.vertical,
      ),
    ]);
  }

  /// 纯文字

  Widget _buildPureTextLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(size: TDLoadingSize.small, text: '加载中…'),
      TDLoading(
        size: TDLoadingSize.small,
        text: '加载失败',
        textColor: ThemeColors.neutral.shade700,
      ),
      TDLoading(
        size: TDLoadingSize.small,
        text: '加载失败',
        refreshWidget: GestureDetector(
          child: TDText(
            '刷新',
            fontSize: context.bodySmall.fontSize,
            textColor: context.colorScheme.primary,
          ),
          onTap: () {
            TDToast.showText('刷新', context: context);
          },
        ),
      ),
    ]);
  }

  /// 大尺寸

  Widget _buildLargeLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.large,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }

  /// 中尺寸

  Widget _buildMediumLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.medium,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }

  /// 小尺寸

  Widget _buildSmallLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }

  double _currentSliderValue = 1000;

  /// 自定义尺寸

  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDLoading(
            size: TDLoadingSize.small,
            icon: TDLoadingIcon.circle,
            axis: Axis.horizontal,
            text: '加载中…',
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
