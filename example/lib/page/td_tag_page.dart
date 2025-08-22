import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDTagPage extends StatelessWidget {
  const TDTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      desc: '用于表明主体的类目，属性或状态',
      exampleCodeGroup: 'tag',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: '基础标签',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  children: [
                    const SizedBox(width: 16),
                    _buildSimpleFillTag(context),
                    const SizedBox(width: 16),
                    _buildSimpleOutlineTag(context),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: '圆弧标签',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  children: [
                    const SizedBox(width: 16),
                    _buildCircleFillTag(context),
                    const SizedBox(width: 16),
                    _buildCircleOutlineTag(context),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: 'Mark标签',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  children: [
                    const SizedBox(width: 16),
                    _buildMarkFillTag(context),
                    const SizedBox(width: 16),
                    _buildMarkOutlineTag(context),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: '带图标的标签',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  children: [
                    const SizedBox(width: 16),
                    _buildIconFillTag(context),
                    const SizedBox(width: 16),
                    _buildIconOutlineTag(context),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: '可关闭的标签',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  children: [
                    const SizedBox(width: 16),
                    _buildCloseFillTag(context),
                    const SizedBox(width: 16),
                    _buildCloseOutlineTag(context),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: '可选中的标签',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      // 非浅色填充
                      Row(
                        children: [
                          const SizedBox(width: 80, child: MyText('dark')),
                          _buildDarkSelectTags(context),
                        ],
                      ),
                      // 浅色填充
                      Row(
                        children: [
                          const SizedBox(width: 80, child: MyText('light')),
                          _buildLightSelectTags(context),
                        ],
                      ),
                      // 非浅色描边
                      Row(
                        children: [
                          const SizedBox(width: 80, child: MyText('outline')),
                          _buildOutlineSelectTags(context),
                        ],
                      ),
                      // 浅色描边
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: MyText('light-outline'),
                          ),
                          _buildLightOutlineSelectTags(context),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State（主题）',
          children: [
            ExampleItem(
              desc: '展示型标签',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      // 浅色填充
                      _buildLightShowTags(context),

                      // 非浅色填充
                      _buildDarkShowTags(context),

                      // 非浅色描边
                      _buildOutlineShowTags(context),

                      // 浅色描边
                      _buildLightOutlineShowTags(context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      // 不带关闭
                      _buildAllSizeTags(context),
                      // 带关闭
                      _buildAllSizeCloseTags(context),
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
          desc: '非浅色填充的各主题展示',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag('标签文字'),
                TDTag('标签文字', theme: TDTagTheme.primary),
                TDTag('标签文字', theme: TDTagTheme.warning),
                TDTag('标签文字', theme: TDTagTheme.danger),
                TDTag('标签文字', theme: TDTagTheme.success),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '浅色填充的各主题展示',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag('标签文字', isLight: true),
                TDTag('标签文字', isLight: true, theme: TDTagTheme.primary),
                TDTag('标签文字', isLight: true, theme: TDTagTheme.warning),
                TDTag('标签文字', isLight: true, theme: TDTagTheme.danger),
                TDTag('标签文字', isLight: true, theme: TDTagTheme.success),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '非浅色描边的各主题展示',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag('标签文字', isOutline: true),
                TDTag('标签文字', isOutline: true, theme: TDTagTheme.primary),
                TDTag('标签文字', isOutline: true, theme: TDTagTheme.warning),
                TDTag('标签文字', isOutline: true, theme: TDTagTheme.danger),
                TDTag('标签文字', isOutline: true, theme: TDTagTheme.success),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '浅色描边的各主题展示',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag('标签文字', isOutline: true, isLight: true),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  isLight: true,
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  isLight: true,
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  isLight: true,
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  isLight: true,
                  theme: TDTagTheme.success,
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '各主题关闭图标颜色不会变',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                TDTag('标签文字', isOutline: true, needCloseIcon: true),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.success,
                ),
                TDTag('标签文字', needCloseIcon: true),
                TDTag('标签文字', needCloseIcon: true, theme: TDTagTheme.primary),
                TDTag('标签文字', needCloseIcon: true, theme: TDTagTheme.warning),
                TDTag('标签文字', needCloseIcon: true, theme: TDTagTheme.danger),
                TDTag('标签文字', needCloseIcon: true, theme: TDTagTheme.success),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '带图标可关闭的标签',
          ignoreCode: true,
          builder: (context) {
            return Row(
              children: const [
                SizedBox(width: 16),
                TDTag('标签文字', icon: Icons.discount, needCloseIcon: true),
                SizedBox(width: 16),
                TDTag(
                  '标签文字',
                  icon: Icons.discount,
                  needCloseIcon: true,
                  isOutline: true,
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '各尺寸测试',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                // 带图标和关闭
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDTag(
                        '加大尺寸',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.extraLarge,
                      ),
                      TDTag(
                        '大尺寸',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.large,
                      ),
                      TDTag(
                        '中尺寸',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.medium,
                      ),
                      TDTag(
                        '小尺寸',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.small,
                      ),
                    ],
                  ),
                ),
                // 带图标和关闭,描边
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDTag(
                        '加大尺寸',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.extraLarge,
                      ),
                      TDTag(
                        '大尺寸',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.large,
                      ),
                      TDTag(
                        '中尺寸',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.medium,
                      ),
                      TDTag(
                        '小尺寸',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: TDTagSize.small,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '可选各状态测试',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                // Normal
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDSelectTag('Tag', theme: TDTagTheme.primary),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isSelected: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        disableSelect: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
                // Light
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isLight: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isLight: true,
                        isSelected: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        isLight: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isLight: true,
                        disableSelect: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
                // Outline
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isSelected: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        isOutline: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        disableSelect: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
                // Outline-Light
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        isSelected: true,
                        shape: TDTagShape.mark,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        isOutline: true,
                        isLight: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        disableSelect: true,
                      ),
                      TDSelectTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '展示各状态测试',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                // Normal
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDTag('Tag', theme: TDTagTheme.primary),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        shape: TDTagShape.round,
                        disable: true,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
                // Light
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDTag('Tag', theme: TDTagTheme.primary, isLight: true),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        shape: TDTagShape.round,
                        isLight: true,
                        disable: true,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
                // Outline
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDTag('Tag', theme: TDTagTheme.primary, isOutline: true),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        shape: TDTagShape.round,
                        isOutline: true,
                        disable: true,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
                // Outline-Light
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: TDTagShape.mark,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        shape: TDTagShape.round,
                        isOutline: true,
                        isLight: true,
                        disable: true,
                      ),
                      TDTag(
                        'Tag',
                        theme: TDTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TDTagShape.mark,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  TDTag _buildSimpleOutlineTag(BuildContext context) {
    return const TDTag('标签文字', isOutline: true);
  }

  TDTag _buildSimpleFillTag(BuildContext context) {
    return const TDTag('标签文字');
  }

  Widget _buildCircleFillTag(BuildContext context) {
    return const TDTag('标签文字', shape: TDTagShape.round);
  }

  Widget _buildCircleOutlineTag(BuildContext context) {
    return const TDTag('标签文字', shape: TDTagShape.round, isOutline: true);
  }

  Widget _buildMarkFillTag(BuildContext context) {
    return const TDTag('标签文字', shape: TDTagShape.mark);
  }

  Widget _buildMarkOutlineTag(BuildContext context) {
    return const TDTag('标签文字', shape: TDTagShape.mark, isOutline: true);
  }

  Widget _buildIconFillTag(BuildContext context) {
    return const TDTag('标签文字', icon: Icons.discount);
  }

  Widget _buildIconOutlineTag(BuildContext context) {
    return const TDTag('标签文字', icon: Icons.discount, isOutline: true);
  }

  Widget _buildCloseFillTag(BuildContext context) {
    return TDTag(
      '标签文字',
      needCloseIcon: true,
      onCloseTap: () {
        TDToast.showText('点击关闭', context: context);
      },
    );
  }

  Widget _buildCloseOutlineTag(BuildContext context) {
    return TDTag(
      '标签文字',
      needCloseIcon: true,
      isOutline: true,
      onCloseTap: () {
        TDToast.showText('点击关闭', context: context);
      },
    );
  }

  Widget _buildDarkSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDSelectTag('未选中态', theme: TDTagTheme.primary),
        TDSelectTag('已选中态', theme: TDTagTheme.primary, isSelected: true),
        TDSelectTag('不可选态', theme: TDTagTheme.primary, disableSelect: true),
      ],
    );
  }

  Widget _buildLightSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDSelectTag('未选中态', theme: TDTagTheme.primary, isLight: true),
        TDSelectTag(
          '已选中态',
          theme: TDTagTheme.primary,
          isLight: true,
          isSelected: true,
        ),
        TDSelectTag(
          '不可选态',
          theme: TDTagTheme.primary,
          isLight: true,
          disableSelect: true,
        ),
      ],
    );
  }

  Widget _buildOutlineSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDSelectTag('未选中态', theme: TDTagTheme.primary, isOutline: true),
        TDSelectTag(
          '已选中态',
          theme: TDTagTheme.primary,
          isOutline: true,
          isSelected: true,
        ),
        TDSelectTag(
          '不可选态',
          theme: TDTagTheme.primary,
          isOutline: true,
          disableSelect: true,
        ),
      ],
    );
  }

  Widget _buildLightOutlineSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDSelectTag(
          '未选中态',
          theme: TDTagTheme.primary,
          isOutline: true,
          isLight: true,
        ),
        TDSelectTag(
          '已选中态',
          theme: TDTagTheme.primary,
          isOutline: true,
          isLight: true,
          isSelected: true,
        ),
        TDSelectTag(
          '不可选态',
          theme: TDTagTheme.primary,
          isOutline: true,
          isLight: true,
          disableSelect: true,
        ),
      ],
    );
  }

  Widget _buildLightShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认', isLight: true),
        TDTag('主要', isLight: true, theme: TDTagTheme.primary),
        TDTag('警告', isLight: true, theme: TDTagTheme.warning),
        TDTag('危险', isLight: true, theme: TDTagTheme.danger),
        TDTag('成功', isLight: true, theme: TDTagTheme.success),
      ],
    );
  }

  Widget _buildDarkShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认'),
        TDTag('主要', theme: TDTagTheme.primary),
        TDTag('警告', theme: TDTagTheme.warning),
        TDTag('危险', theme: TDTagTheme.danger),
        TDTag('成功', theme: TDTagTheme.success),
      ],
    );
  }

  Widget _buildOutlineShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认', isOutline: true),
        TDTag('主要', isOutline: true, theme: TDTagTheme.primary),
        TDTag('警告', isOutline: true, theme: TDTagTheme.warning),
        TDTag('危险', isOutline: true, theme: TDTagTheme.danger),
        TDTag('成功', isOutline: true, theme: TDTagTheme.success),
      ],
    );
  }

  Widget _buildLightOutlineShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认', isOutline: true, isLight: true),
        TDTag('主要', isOutline: true, isLight: true, theme: TDTagTheme.primary),
        TDTag('警告', isOutline: true, isLight: true, theme: TDTagTheme.warning),
        TDTag('危险', isOutline: true, isLight: true, theme: TDTagTheme.danger),
        TDTag('成功', isOutline: true, isLight: true, theme: TDTagTheme.success),
      ],
    );
  }

  Widget _buildAllSizeTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('加大尺寸', size: TDTagSize.extraLarge),
        TDTag('大尺寸', size: TDTagSize.large),
        TDTag('中尺寸', size: TDTagSize.medium),
        TDTag('小尺寸', size: TDTagSize.small),
      ],
    );
  }

  Widget _buildAllSizeCloseTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('加大尺寸', needCloseIcon: true, size: TDTagSize.extraLarge),
        TDTag('大尺寸', needCloseIcon: true, size: TDTagSize.large),
        TDTag('中尺寸', needCloseIcon: true, size: TDTagSize.medium),
        TDTag('小尺寸', needCloseIcon: true, size: TDTagSize.small),
      ],
    );
  }
}
