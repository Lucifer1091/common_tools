import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

///
/// TDPopup演示
///
class TDPopupPage extends StatefulWidget {
  const TDPopupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDPopupPageState();
  }
}

class TDPopupPageState extends State<TDPopupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      padding: const EdgeInsets.only(top: 16),
      backgroundColor: Colors.white,
      exampleCodeGroup: 'popup',
      desc: '由其他控件触发，屏幕滑出或弹出一块自定义内容区域',
      navBarKey: navBarkey,
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(builder: _buildPopFromTop),
            ExampleItem(builder: _buildPopFromLeft),
            ExampleItem(builder: _buildPopFromCenter),
            ExampleItem(builder: _buildPopFromBottom),
            ExampleItem(builder: _buildPopFromRight),
          ],
        ),
        ExampleModule(
          title: '组件示例',
          children: [
            ExampleItem(builder: _buildPopFromBottomWithOperationAndTitle),
            ExampleItem(builder: _buildPopFromBottomWithOperation),
            ExampleItem(builder: _buildPopFromBottomWithCloseAndTitle),
            ExampleItem(builder: _buildPopFromBottomWithCloseAndLeftTitle),
            ExampleItem(builder: _buildPopFromBottomWithClose),
            ExampleItem(builder: _buildPopFromBottomWithTitle),
            ExampleItem(builder: _buildPopFromCenterWithClose),
            ExampleItem(builder: _buildPopFromCenterWithUnderClose),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: '操作栏超长文本,指定颜色',
          builder: (_) {
            return MyButton(
              text: '底部弹出层-带Title及操作',
              isExpanded: true,

              type: MyButtonType.outline,
              size: MyButtonSize.large,
              onTap: () {
                Navigator.of(context).push(
                  MySlidePopupRoute(
                    modalBarrierColor: ThemeColors.neutral.shade800,
                    slideTransitionFrom: MySlideFrom.bottom,
                    builder: (context) {
                      return TDPopupBottomConfirmPanel(
                        title:
                            'Title CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle Character',
                        leftText: '点这里确认!',
                        leftTextColor: context.colorScheme.primary,
                        leftClick: () {
                          TDToast.showText('确认', context: context);
                          Navigator.maybePop(context);
                        },
                        rightText: '关闭',
                        rightTextColor: ThemeColors.error.shade500,
                        rightClick: () {
                          Navigator.maybePop(context);
                        },
                        child: Container(height: 200),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        ExampleItem(
          desc: '带关闭超长文本',
          builder: (_) {
            return MyButton(
              text: '底部弹出层-带Title及操作',
              isExpanded: true,

              type: MyButtonType.outline,
              size: MyButtonSize.large,
              onTap: () {
                Navigator.of(context).push(
                  MySlidePopupRoute(
                    modalBarrierColor: ThemeColors.neutral.shade800,
                    slideTransitionFrom: MySlideFrom.bottom,
                    builder: (context) {
                      return TDPopupBottomDisplayPanel(
                        title:
                            'Title CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle Character',
                        closeColor: ThemeColors.error.shade500,
                        closeClick: () {
                          Navigator.maybePop(context);
                        },
                        child: Container(height: 200),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        ExampleItem(
          desc: '修改圆角',
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '底部弹出层-修改圆角',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.bottom,
                          builder: (context) {
                            return TDPopupBottomDisplayPanel(
                              title:
                                  'Title CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle Character',
                              closeColor: ThemeColors.error.shade500,
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              radius: 6,
                              child: Container(height: 200),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '底部弹出层-修改圆角',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.bottom,
                          builder: (context) {
                            return TDPopupBottomConfirmPanel(
                              title:
                                  'Title CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle Character',
                              leftText: '点这里确认!',
                              leftTextColor: context.colorScheme.primary,
                              leftClick: () {
                                TDToast.showText('确认', context: context);
                                Navigator.maybePop(context);
                              },
                              rightText: '关闭',
                              rightTextColor: ThemeColors.error.shade500,
                              rightClick: () {
                                Navigator.maybePop(context);
                              },
                              radius: 6,
                              child: Container(height: 200),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '居中弹出层-修改圆角',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.center,
                          builder: (context) {
                            return TDPopupCenterPanel(
                              closeColor: ThemeColors.error.shade500,
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              radius: 6,
                              child: const SizedBox(height: 240, width: 240),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '居中弹出层-底部关闭-修改圆角',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.center,
                          builder: (context) {
                            return TDPopupCenterPanel(
                              closeUnderBottom: true,
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              radius: 6,
                              child: const SizedBox(height: 240, width: 240),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '自定义位置',
          builder: (_) {
            return MyButton(
              text: '自定义位置',
              isExpanded: true,

              type: MyButtonType.outline,
              size: MyButtonSize.large,
              onTap: () {
                var renderBox =
                    navBarkey.currentContext!.findRenderObject() as RenderBox;
                Navigator.of(context).push(
                  MySlidePopupRoute(
                    modalBarrierColor: ThemeColors.neutral.shade800,
                    slideTransitionFrom: MySlideFrom.right,
                    modalTop: renderBox.size.height,
                    builder: (context) {
                      return Container(color: Colors.white, width: 280);
                    },
                  ),
                );
              },
            );
          },
        ),
        ExampleItem(
          desc: '弹出层包含输入框且不会被键盘遮挡',
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '底部弹出层-键盘弹默认遮挡',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.bottom,
                          builder: (context) {
                            return TDPopupBottomDisplayPanel(
                              title:
                                  'Title CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle Character',
                              closeColor: ThemeColors.error.shade500,
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              radius: 6,
                              child: Material(
                                child: SizedBox(
                                  height: 100,
                                  // child: TDInput(
                                  //   type: TDInputType.normal,
                                  //   leftLabel: '标签文字',
                                  //   hintText: '请输入文字',
                                  //   maxLength: 10,
                                  //   additionInfo: '最大输入10个字符',
                                  //   backgroundColor: Colors.white,
                                  // ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '底部弹出层-键盘弹出不遮挡',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.bottom,
                          focusMove: true,
                          builder: (context) {
                            return TDPopupBottomDisplayPanel(
                              title:
                                  'Title CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle CharacterTitle Character',
                              closeColor: ThemeColors.error.shade500,
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              radius: 6,
                              child: Material(
                                child: SizedBox(
                                  height: 100,
                                  // child: TDInput(
                                  //   type: TDInputType.normal,
                                  //   leftLabel: '标签文字',
                                  //   hintText: '请输入文字',
                                  //   maxLength: 10,
                                  //   additionInfo: '最大输入10个字符',
                                  //   backgroundColor: Colors.white,
                                  // ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '居中弹出层-键盘弹出不遮挡',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.center,
                          focusMove: true,
                          builder: (context) {
                            return TDPopupCenterPanel(
                              closeColor: ThemeColors.error.shade500,
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              radius: 6,
                              child: Material(
                                child: SizedBox(
                                  height: 340,
                                  child: Column(
                                    children: [
                                      // TDInput(
                                      //   type: TDInputType.normal,
                                      //   leftLabel: '标签文字1',
                                      //   hintText: '请输入文字1',
                                      //   maxLength: 10,
                                      //   backgroundColor: Colors.white,
                                      // ),
                                      // TDInput(
                                      //   type: TDInputType.normal,
                                      //   leftLabel: '标签文字2',
                                      //   hintText: '请输入文字2',
                                      //   maxLength: 10,
                                      //   backgroundColor: Colors.white,
                                      // ),
                                      // TDInput(
                                      //   type: TDInputType.normal,
                                      //   leftLabel: '标签文字3',
                                      //   hintText: '请输入文字3',
                                      //   maxLength: 10,
                                      //   backgroundColor: Colors.white,
                                      // ),
                                      // TDInput(
                                      //   type: TDInputType.normal,
                                      //   leftLabel: '标签文字4',
                                      //   hintText: '请输入文字4',
                                      //   maxLength: 10,
                                      //   backgroundColor: Colors.white,
                                      // ),
                                      // TDInput(
                                      //   type: TDInputType.normal,
                                      //   leftLabel: '会被键盘遮挡的输入框1',
                                      //   hintText: '会被键盘遮挡小部分',
                                      //   maxLength: 10,
                                      //   backgroundColor: Colors.white,
                                      // ),
                                      // TDInput(
                                      //   type: TDInputType.normal,
                                      //   leftLabel: '会被键盘遮挡的输入框2',
                                      //   hintText: '会被键盘遮挡全遮挡',
                                      //   maxLength: 10,
                                      //   backgroundColor: Colors.white,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '可拖动全屏',
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '可拖动全屏',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.bottom,
                          builder: (context) {
                            return TDPopupBottomDisplayPanel(
                              title: 'Title Character',
                              draggable: true,
                              closeColor: ThemeColors.error.shade500,
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              child: Container(height: 200),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MyButton(
                    text: '可拖动全屏-带Title及操作',
                    isExpanded: true,

                    type: MyButtonType.outline,
                    size: MyButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        MySlidePopupRoute(
                          modalBarrierColor: ThemeColors.neutral.shade800,
                          slideTransitionFrom: MySlideFrom.bottom,
                          builder: (context) {
                            return TDPopupBottomConfirmPanel(
                              title: 'Title Character',
                              draggable: true,
                              leftClick: () {
                                Navigator.maybePop(context);
                              },
                              rightClick: () {
                                TDToast.showText('确定', context: context);
                                Navigator.maybePop(context);
                              },
                              child: Container(height: 200),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPopFromTop(BuildContext context) {
    return MyButton(
      text: '顶部弹出',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.top,
            open: () {
              print('open');
            },
            opened: () {
              print('opened');
            },
            builder: (context) {
              return Container(color: Colors.white, height: 240);
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromLeft(BuildContext context) {
    return MyButton(
      text: '左侧弹出',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.left,
            builder: (context) {
              return Container(color: Colors.white, width: 280);
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromCenter(BuildContext context) {
    return MyButton(
      text: '中间弹出',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.center,
            builder: (context) {
              return Container(color: Colors.white, width: 240, height: 240);
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottom(BuildContext context) {
    return MyButton(
      text: '底部弹出',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.bottom,
            builder: (context) {
              return Container(color: Colors.white, height: 240);
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromRight(BuildContext context) {
    return MyButton(
      text: '右侧弹出',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.right,
            builder: (context) {
              return Container(color: Colors.white, width: 280);
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithOperationAndTitle(BuildContext context) {
    return MyButton(
      text: '底部弹出层-带Title及操作',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.bottom,
            builder: (context) {
              return TDPopupBottomConfirmPanel(
                title: 'Title Character',
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TDToast.showText('确定', context: context);
                  Navigator.maybePop(context);
                },
                child: Container(height: 200),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithOperation(BuildContext context) {
    return MyButton(
      text: '底部弹出层-带操作',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.bottom,
            builder: (context) {
              return TDPopupBottomConfirmPanel(
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TDToast.showText('确定', context: context);
                  Navigator.maybePop(context);
                },
                child: Container(height: 200),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithCloseAndTitle(BuildContext context) {
    return MyButton(
      text: '底部弹出层-带Title及关闭',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: 'Title Character',
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: Container(height: 200),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithCloseAndLeftTitle(BuildContext context) {
    return MyButton(
      text: '底部弹出层-带左边Title及关闭',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: 'Title Character',
                titleLeft: true,
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: Container(height: 200),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithClose(BuildContext context) {
    return MyButton(
      text: '底部弹出层-带关闭',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: Container(height: 200),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithTitle(BuildContext context) {
    return MyButton(
      text: '底部弹出层-仅Title',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            slideTransitionFrom: MySlideFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: 'Title Character',
                hideClose: true,
                // closeClick: () {
                //   Navigator.maybePop(context);
                // },
                child: Container(height: 200),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromCenterWithClose(BuildContext context) {
    return MyButton(
      text: '居中弹出层-带关闭',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            isDismissible: false,
            slideTransitionFrom: MySlideFrom.center,
            builder: (context) {
              return TDPopupCenterPanel(
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: const SizedBox(width: 240, height: 240),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromCenterWithUnderClose(BuildContext context) {
    return MyButton(
      text: '居中弹出层-关闭在下方',
      isExpanded: true,

      type: MyButtonType.outline,
      size: MyButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            modalBarrierColor: ThemeColors.neutral.shade800,
            isDismissible: false,
            slideTransitionFrom: MySlideFrom.center,
            builder: (context) {
              return TDPopupCenterPanel(
                closeUnderBottom: true,
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: const SizedBox(width: 240, height: 240),
              );
            },
          ),
        );
      },
    );
  }
}
