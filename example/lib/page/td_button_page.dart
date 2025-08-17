import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDButtonPage extends StatefulWidget {
  const TDButtonPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDButtonPageState();
}

class _TDButtonPageState extends State<TDButtonPage> {
  void onTap() {
    TDToast.showText('点击了按钮', context: context);
  }

  void onLongPress() {
    TDToast.showText('长按了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: tdTitle(),
        desc: '用于开启一个闭环的操作任务，如“删除”对象、“购买”商品等。',
        exampleCodeGroup: 'button',
        // padding: const EdgeInsets.only(top: 8, bottom: 8, ),
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '基础按钮',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryStrokeButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryTextButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '图标按钮',
                center: false,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildRectangleIconButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildSquareIconButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLoadingIconButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '幽灵按钮',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    color: ThemeColors.neutral.shade50,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryGhostButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDangerGhostButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultGhostButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '组合按钮',
                builder: (_) => _buildCombinationButtons(context),
              ),
              ExampleItem(desc: '通栏按钮', builder: _buildFilledFillButton),
            ],
          ),
          ExampleModule(
            title: '组件状态',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '按钮禁用状态',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisablePrimaryFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableLightFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableDefaultFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisablePrimaryStrokeButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisablePrimaryTextButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          ExampleModule(
            title: '组件主题',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '按钮尺寸',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 10),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: _buildLargeButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: _buildMediumButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: _buildSmallButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: _buildExtraSmallButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '按钮形状',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 6,
                            top: 6,
                          ),
                          child: _buildPrimaryFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: _buildSquareIconButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: _buildRoundButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            right: 16,
                            left: 6,
                            top: 6,
                          ),
                          child: _buildCircleButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: _buildFilledButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '按钮主题',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        /// 默认主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultStrokeButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultTextButton(context),
                        ),

                        /// primary主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryStrokeButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryTextButton(context),
                        ),

                        /// danger主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDangerFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDangerStrokeButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDangerTextButton(context),
                        ),

                        /// light主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightFillButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightStrokeButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightTextButton(context),
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
            desc: '测试child',
            builder: (context) {
              return _buildChildTestButton(context);
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '通栏按钮测试',
            builder: (context) {
              return Container(
                color: Colors.grey,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TDButton(
                      isBlock: true,
                      text: '填充block按钮',
                      theme: TDButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TDButton(
                      isBlock: true,
                      text: '描边block按钮',
                      type: TDButtonType.outline,
                      theme: TDButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TDButton(
                      isBlock: true,
                      text: '文字block按钮',
                      type: TDButtonType.text,
                      theme: TDButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TDButton(
                      isBlock: true,
                      text: '幽灵block按钮',
                      type: TDButtonType.ghost,
                      theme: TDButtonTheme.primary,
                    ),
                  ],
                ),
              );
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '各种按钮状态测试',
            builder: _buildStatusDisplay,
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '按钮中路由跳转',
            builder: (context) {
              return TDButton(
                text: '点击跳转',
                size: TDButtonSize.large,
                // type: TDButtonType.text,
                shape: TDButtonShape.rectangle,
                onTap: () async {
                  var result = await Navigator.of(context)
                      .pushNamedAndRemoveUntil('divider', (router) {
                        return true;
                      });
                  print('pushNamedAndRemoveUntil result: $result');
                },
              );
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '图标在文字右侧',
            builder: (context) {
              return _buildRightIconButton(context);
            },
          ),
        ],
      ),
    );
  }

  TDButton _buildLightTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }

  TDButton _buildLightStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }

  TDButton _buildDangerTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  TDButton _buildDangerStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  TDButton _buildDangerFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  TDButton _buildDefaultTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaults,
    );
  }

  TDButton _buildDefaultStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaults,
    );
  }

  TDButton _buildFilledButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.filled,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildCircleButton(BuildContext context) {
    return const TDButton(
      icon: Icons.app_blocking,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.circle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildRoundButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.round,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildExtraSmallButton(BuildContext context) {
    return const TDButton(
      text: '按钮28',
      size: TDButtonSize.extraSmall,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildSmallButton(BuildContext context) {
    return const TDButton(
      text: '按钮32',
      size: TDButtonSize.small,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildMediumButton(BuildContext context) {
    return const TDButton(
      text: '按钮40',
      size: TDButtonSize.medium,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildLargeButton(BuildContext context) {
    return const TDButton(
      text: '按钮48',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }

  TDButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }

  TDButton _buildDisableDefaultFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaults,
      disabled: true,
    );
  }

  TDButton _buildDisableLightFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
      disabled: true,
    );
  }

  TDButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }

  TDButton _buildFilledFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      icon: Icons.app_blocking,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      theme: TDButtonTheme.primary,
      isBlock: true,
    );
  }

  TDButton _buildDefaultGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaults,
    );
  }

  TDButton _buildDangerGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  TDButton _buildPrimaryGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildSquareIconButton(BuildContext context) {
    return const TDButton(
      icon: Icons.app_blocking,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.square,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildLoadingIconButton(BuildContext context) {
    return TDButton(
      text: '加载中',
      iconWidget: TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        iconColor: context.colorScheme.primaryForeground,
      ),
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildRectangleIconButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      icon: Icons.app_blocking,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildPrimaryTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildDefaultFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaults,
    );
  }

  TDButton _buildPrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  TDButton _buildLightFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }

  Widget _buildCombinationButtons(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 16),
        Expanded(
          child: TDButton(
            text: '填充按钮',
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.light,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TDButton(
            text: '填充按钮',
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.primary,
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildChildTestButton(BuildContext context) {
    return TDButton(child: Container(height: 24, width: 24, color: Colors.red));
  }

  Widget _buildRightIconButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: const Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          TDButton(
            text: '填充按钮',
            icon: Icons.app_blocking,
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.primary,
            iconPosition: TDButtonIconPosition.right,
          ),
          TDButton(
            icon: Icons.app_blocking,
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.primary,
            iconPosition: TDButtonIconPosition.right,
          ),
          TDButton(
            text: '间距20',
            icon: Icons.app_blocking,
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.primary,
            iconPosition: TDButtonIconPosition.right,
            iconTextSpacing: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDisplay(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        /// fill
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.primary,
                  TDButtonStatus.active,
                ),
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.light,
                  TDButtonStatus.active,
                ),
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.defaults,
                  TDButtonStatus.active,
                ),
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                disabled: true,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.danger,
                  TDButtonStatus.active,
                ),
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
              ),
            ],
          ),
        ),

        /// outline
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.primary,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.light,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.defaults,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.fill(
                  context,
                  TDButtonTheme.danger,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),

        /// text
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.text(
                  context,
                  TDButtonTheme.primary,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.text(
                  context,
                  TDButtonTheme.light,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                style: TDButtonStyle.text(
                  context,
                  TDButtonTheme.defaults,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.text(
                  context,
                  TDButtonTheme.danger,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),

        /// ghost
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.ghost(
                  context,
                  TDButtonTheme.primary,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.ghost(
                  context,
                  TDButtonTheme.light,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                style: TDButtonStyle.ghost(
                  context,
                  TDButtonTheme.defaults,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.defaults,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.ghost(
                  context,
                  TDButtonTheme.danger,
                  TDButtonStatus.active,
                ),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
