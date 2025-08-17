import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDButtonPage extends StatefulWidget {
  const TDButtonPage({super.key});

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
                    MyButton(
                      isBlock: true,
                      text: '填充block按钮',
                      theme: MyButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    MyButton(
                      isBlock: true,
                      text: '描边block按钮',
                      type: MyButtonType.outline,
                      theme: MyButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    MyButton(
                      isBlock: true,
                      text: '文字block按钮',
                      type: MyButtonType.text,
                      theme: MyButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    MyButton(
                      isBlock: true,
                      text: '幽灵block按钮',
                      type: MyButtonType.ghost,
                      theme: MyButtonTheme.primary,
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
              return MyButton(
                text: '点击跳转',
                size: MyButtonSize.large,
                // type: TDButtonType.text,
                shape: MyButtonShape.rectangle,
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

  MyButton _buildLightTextButton(BuildContext context) {
    return const MyButton(
      text: '文字按钮',
      size: MyButtonSize.large,
      type: MyButtonType.text,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.light,
    );
  }

  MyButton _buildLightStrokeButton(BuildContext context) {
    return const MyButton(
      text: '描边按钮',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.light,
    );
  }

  MyButton _buildDangerTextButton(BuildContext context) {
    return const MyButton(
      text: '文字按钮',
      size: MyButtonSize.large,
      type: MyButtonType.text,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.danger,
    );
  }

  MyButton _buildDangerStrokeButton(BuildContext context) {
    return const MyButton(
      text: '描边按钮',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.danger,
    );
  }

  MyButton _buildDangerFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.danger,
    );
  }

  MyButton _buildDefaultTextButton(BuildContext context) {
    return const MyButton(
      text: '文字按钮',
      size: MyButtonSize.large,
      type: MyButtonType.text,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.defaults,
    );
  }

  MyButton _buildDefaultStrokeButton(BuildContext context) {
    return const MyButton(
      text: '描边按钮',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.defaults,
    );
  }

  MyButton _buildFilledButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.filled,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildCircleButton(BuildContext context) {
    return const MyButton(
      icon: Icons.app_blocking,
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.circle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildRoundButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.round,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildExtraSmallButton(BuildContext context) {
    return const MyButton(
      text: '按钮28',
      size: MyButtonSize.extraSmall,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildSmallButton(BuildContext context) {
    return const MyButton(
      text: '按钮32',
      size: MyButtonSize.small,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildMediumButton(BuildContext context) {
    return const MyButton(
      text: '按钮40',
      size: MyButtonSize.medium,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildLargeButton(BuildContext context) {
    return const MyButton(
      text: '按钮48',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const MyButton(
      text: '文字按钮',
      size: MyButtonSize.large,
      type: MyButtonType.text,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
      enabled: true,
    );
  }

  MyButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const MyButton(
      text: '描边按钮',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
      enabled: true,
    );
  }

  MyButton _buildDisableDefaultFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.defaults,
      enabled: true,
    );
  }

  MyButton _buildDisableLightFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.light,
      enabled: true,
    );
  }

  MyButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
      enabled: true,
    );
  }

  MyButton _buildFilledFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      icon: Icons.app_blocking,
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      theme: MyButtonTheme.primary,
      isBlock: true,
    );
  }

  MyButton _buildDefaultGhostButton(BuildContext context) {
    return const MyButton(
      text: '幽灵按钮',
      size: MyButtonSize.large,
      type: MyButtonType.ghost,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.defaults,
    );
  }

  MyButton _buildDangerGhostButton(BuildContext context) {
    return const MyButton(
      text: '幽灵按钮',
      size: MyButtonSize.large,
      type: MyButtonType.ghost,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.danger,
    );
  }

  MyButton _buildPrimaryGhostButton(BuildContext context) {
    return const MyButton(
      text: '幽灵按钮',
      size: MyButtonSize.large,
      type: MyButtonType.ghost,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildSquareIconButton(BuildContext context) {
    return const MyButton(
      icon: Icons.app_blocking,
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.square,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildLoadingIconButton(BuildContext context) {
    return MyButton(
      text: '加载中',
      iconWidget: TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        iconColor: context.colorScheme.primaryForeground,
      ),
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildRectangleIconButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      icon: Icons.app_blocking,
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildPrimaryTextButton(BuildContext context) {
    return const MyButton(
      text: '文字按钮',
      size: MyButtonSize.large,
      type: MyButtonType.text,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildPrimaryStrokeButton(BuildContext context) {
    return const MyButton(
      text: '描边按钮',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildDefaultFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.defaults,
    );
  }

  MyButton _buildPrimaryFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.primary,
    );
  }

  MyButton _buildLightFillButton(BuildContext context) {
    return const MyButton(
      text: '填充按钮',
      size: MyButtonSize.large,
      type: MyButtonType.fill,
      shape: MyButtonShape.rectangle,
      theme: MyButtonTheme.light,
    );
  }

  Widget _buildCombinationButtons(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 16),
        Expanded(
          child: MyButton(
            text: '填充按钮',
            size: MyButtonSize.large,
            type: MyButtonType.fill,
            shape: MyButtonShape.rectangle,
            theme: MyButtonTheme.light,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: MyButton(
            text: '填充按钮',
            size: MyButtonSize.large,
            type: MyButtonType.fill,
            shape: MyButtonShape.rectangle,
            theme: MyButtonTheme.primary,
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildChildTestButton(BuildContext context) {
    return MyButton(child: Container(height: 24, width: 24, color: Colors.red));
  }

  Widget _buildRightIconButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: const Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          MyButton(
            text: '填充按钮',
            icon: Icons.app_blocking,
            size: MyButtonSize.large,
            type: MyButtonType.fill,
            shape: MyButtonShape.rectangle,
            theme: MyButtonTheme.primary,
            iconPosition: MyButtonIconPosition.right,
          ),
          MyButton(
            icon: Icons.app_blocking,
            size: MyButtonSize.large,
            type: MyButtonType.fill,
            shape: MyButtonShape.rectangle,
            theme: MyButtonTheme.primary,
            iconPosition: MyButtonIconPosition.right,
          ),
          MyButton(
            text: '间距20',
            icon: Icons.app_blocking,
            size: MyButtonSize.large,
            type: MyButtonType.fill,
            shape: MyButtonShape.rectangle,
            theme: MyButtonTheme.primary,
            iconPosition: MyButtonIconPosition.right,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.primary,
                  MyButtonState.pressed,
                ),
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                enabled: true,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.light,
                  MyButtonState.pressed,
                ),
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                enabled: true,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.defaults,
                  MyButtonState.pressed,
                ),
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                enabled: true,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.danger,
                  MyButtonState.pressed,
                ),
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                enabled: true,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                type: MyButtonType.outline,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.primary,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.outline,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                enabled: true,
                type: MyButtonType.outline,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                type: MyButtonType.outline,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.light,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.outline,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                enabled: true,
                type: MyButtonType.outline,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                type: MyButtonType.outline,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.defaults,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.outline,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                enabled: true,
                type: MyButtonType.outline,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                type: MyButtonType.outline,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                style: MyButtonStyle.fill(
                  context,
                  MyButtonTheme.danger,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.outline,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                enabled: true,
                type: MyButtonType.outline,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                type: MyButtonType.text,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                style: MyButtonStyle.text(
                  context,
                  MyButtonTheme.primary,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.text,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                enabled: true,
                type: MyButtonType.text,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                type: MyButtonType.text,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                style: MyButtonStyle.text(
                  context,
                  MyButtonTheme.light,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.text,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                enabled: true,
                type: MyButtonType.text,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                type: MyButtonType.text,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                style: MyButtonStyle.text(
                  context,
                  MyButtonTheme.defaults,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.text,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                enabled: true,
                type: MyButtonType.text,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                type: MyButtonType.text,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                style: MyButtonStyle.text(
                  context,
                  MyButtonTheme.danger,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.text,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                enabled: true,
                type: MyButtonType.text,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                type: MyButtonType.ghost,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                style: MyButtonStyle.ghost(
                  context,
                  MyButtonTheme.primary,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.ghost,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.primary,
                enabled: true,
                type: MyButtonType.ghost,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                type: MyButtonType.ghost,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                style: MyButtonStyle.ghost(
                  context,
                  MyButtonTheme.light,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.ghost,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.light,
                enabled: true,
                type: MyButtonType.ghost,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                type: MyButtonType.ghost,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                style: MyButtonStyle.ghost(
                  context,
                  MyButtonTheme.defaults,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.ghost,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.defaults,
                enabled: true,
                type: MyButtonType.ghost,
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
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                type: MyButtonType.ghost,
              ),
              MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                style: MyButtonStyle.ghost(
                  context,
                  MyButtonTheme.danger,
                  MyButtonState.pressed,
                ),
                type: MyButtonType.ghost,
              ),
              const MyButton(
                icon: Icons.app_blocking,
                text: 'Button',
                theme: MyButtonTheme.danger,
                enabled: true,
                type: MyButtonType.ghost,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
