import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class TDPopoverPage extends StatefulWidget {
  const TDPopoverPage({super.key});

  @override
  State<StatefulWidget> createState() => _TDPopoverPage();
}

class _TDPopoverPage extends State<TDPopoverPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于文字提示的气泡框。',
      exampleCodeGroup: 'popover',
      backgroundColor: context.colorScheme.primaryForeground,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '带箭头的弹出气泡', builder: _buildPopover),
            ExampleItem(desc: '不带箭头的弹出气泡', builder: _buildNoArrowPopover),
            ExampleItem(desc: '自定义内容弹出气泡', builder: _buildNCustomPopover),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(flex: 1, child: _buildDarkPopover(context)),
                          Expanded(flex: 1, child: _buildLightPopover(context)),
                          Expanded(flex: 1, child: _buildInfoPopover(context)),
                        ],
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildSuccessPopover(context),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildWarningPopover(context),
                          ),
                          Expanded(flex: 1, child: _buildErrorPopover(context)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '顶部弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(flex: 1, child: _buildTopLeftPopover(context)),
                      Expanded(flex: 1, child: _buildTopPopover(context)),
                      Expanded(flex: 1, child: _buildTopRightPopover(context)),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '底部弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildBottomLeftPopover(context),
                      ),
                      Expanded(flex: 1, child: _buildBottomPopover(context)),
                      Expanded(
                        flex: 1,
                        child: _buildBottomRightPopover(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '右侧弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildRightTopPopover(context),
                            _buildRightPopover(context),
                            _buildRightBottomPopover(context),
                          ],
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '左侧弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildLeftTopPopover(context),
                            _buildLeftPopover(context),
                            _buildLeftBottomPopover(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
      test: [ExampleItem(desc: '显示多行内容', builder: _buildMultiLinePopover)],
    );
  }

  Widget _buildPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '带箭头',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(context: context, content: '弹出气泡内容');
            },
          );
        },
      ),
    );
  }

  Widget _buildNoArrowPopover(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return MyButton(
          size: MyButtonSize.medium,
          text: '不带箭头',
          type: MyButtonType.outline,
          

          onTap: () {
            TDPopover.showPopover(
              context: context,
              content: '弹出气泡内容',
              showArrow: false,
            );
          },
        );
      },
    );
  }

  Widget _buildPopoverList(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: TDText('选项1', style: TextStyle(color: Colors.white)),
        ),
        TDDivider(color: context.colorScheme.primaryForeground, height: 0.5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: TDText('选项2', style: TextStyle(color: Colors.white)),
        ),
        TDDivider(color: context.colorScheme.primaryForeground, height: 0.5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: TDText('选项3', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildNCustomPopover(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return MyButton(
          text: '自定义内容',
          type: MyButtonType.outline,
          

          onTap: () {
            TDPopover.showPopover(
              context: context,
              padding: const EdgeInsets.all(0),
              width: 108,
              height: 148,
              contentWidget: _buildPopoverList(context),
            );
          },
        );
      },
    );
  }

  Widget _buildDarkPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '深色',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(context: context, content: '弹出气泡内容');
            },
          );
        },
      ),
    );
  }

  Widget _buildLightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '浅色',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.light,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '品牌色',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.info,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSuccessPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '成功色',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.success,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWarningPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '警告色',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.warning,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '错误色',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.error,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '顶部左',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topLeft,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '顶部中',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.top,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '顶部右',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topRight,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '底部左',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomLeft,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '底部中',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottom,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '底部右',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomRight,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRightTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '右侧上',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightTop,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '右侧中',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.right,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRightBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '右侧下',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightBottom,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLeftTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '左侧上',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftTop,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '左侧中',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.left,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLeftBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '左侧下',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftBottom,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMultiLinePopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return MyButton(
            size: MyButtonSize.medium,
            text: '多行内容',
            type: MyButtonType.outline,
            

            onTap: () {
              TDPopover.showPopover(
                context: context,
                width: 200,
                content: '弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容',
              );
            },
          );
        },
      ),
    );
  }
}
