import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class MyTagPage extends StatelessWidget {
  const MyTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'Used to indicate the category, attribute, or status of the subject.',
      exampleCodeGroup: 'tag',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Basic Tags',
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
              desc: 'Arc Label',
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
              desc: 'Mark Tag',
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
              desc: 'Labels with icons',
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
              desc: 'Closable tabs',
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
              desc: 'Selectable tags',
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 80, child: MyText('dark')),
                          _buildDarkSelectTags(context),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 80, child: MyText('light')),
                          _buildLightSelectTags(context),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 80, child: MyText('outline')),
                          _buildOutlineSelectTags(context),
                        ],
                      ),
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
          title: 'Component States',
          children: [
            ExampleItem(
              desc: 'Display label',
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      _buildLightShowTags(context),
                      _buildDarkShowTags(context),
                      _buildOutlineShowTags(context),
                      _buildLightOutlineShowTags(context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Size',
          children: [
            ExampleItem(
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      _buildAllSizeTags(context),
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
          desc: 'Theme displays that are not filled with light colors',
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                MyTag('tag text'),
                MyTag('tag text', theme: MyTagTheme.primary),
                MyTag('tag text', theme: MyTagTheme.warning),
                MyTag('tag text', theme: MyTagTheme.danger),
                MyTag('tag text', theme: MyTagTheme.success),
                MyTag('tag text', theme: MyTagTheme.success),
              ],
            );
          },
        ),
        ExampleItem(
          desc: 'Light-colored themed displays',
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                MyTag('tag text', isLight: true),
                MyTag('tag text', isLight: true, theme: MyTagTheme.primary),
                MyTag('tag text', isLight: true, theme: MyTagTheme.warning),
                MyTag('tag text', isLight: true, theme: MyTagTheme.danger),
                MyTag('tag text', isLight: true, theme: MyTagTheme.success),
              ],
            );
          },
        ),
        ExampleItem(
          desc: 'Display of various themes without light-colored outlines',
          ignoreCode: true,
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                MyTag('label text', isOutline: true),
                MyTag('label text', isOutline: true, theme: MyTagTheme.primary),
                MyTag('label text', isOutline: true, theme: MyTagTheme.warning),
                MyTag('label text', isOutline: true, theme: MyTagTheme.danger),
                MyTag('label text', isOutline: true, theme: MyTagTheme.success),
              ],
            );
          },
        ),
        ExampleItem(
          desc: 'Light-colored outlines for each theme display',
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                MyTag('label text', isOutline: true, isLight: true),
                MyTag(
                  'label text',
                  isOutline: true,
                  isLight: true,
                  theme: MyTagTheme.primary,
                ),
                MyTag(
                  'label text',
                  isOutline: true,
                  isLight: true,
                  theme: MyTagTheme.warning,
                ),
                MyTag(
                  'label text',
                  isOutline: true,
                  isLight: true,
                  theme: MyTagTheme.danger,
                ),
                MyTag(
                  'label text',
                  isOutline: true,
                  isLight: true,
                  theme: MyTagTheme.success,
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc:
              'The close icon color will not change across the various themes.',
          builder: (context) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                MyTag('label text', isOutline: true, needCloseIcon: true),
                MyTag(
                  'label text',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: MyTagTheme.primary,
                ),
                MyTag(
                  'label text',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: MyTagTheme.warning,
                ),
                MyTag(
                  'label text',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: MyTagTheme.danger,
                ),
                MyTag(
                  'label text',
                  isOutline: true,
                  needCloseIcon: true,
                  theme: MyTagTheme.success,
                ),
                MyTag('label text', needCloseIcon: true),
                MyTag(
                  'label text',
                  needCloseIcon: true,
                  theme: MyTagTheme.primary,
                ),
                MyTag(
                  'label text',
                  needCloseIcon: true,
                  theme: MyTagTheme.warning,
                ),
                MyTag(
                  'label text',
                  needCloseIcon: true,
                  theme: MyTagTheme.danger,
                ),
                MyTag(
                  'label text',
                  needCloseIcon: true,
                  theme: MyTagTheme.success,
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: 'Tabs with icons that can be closed',
          builder: (context) {
            return Row(
              children: const [
                SizedBox(width: 16),
                MyTag('label text', icon: Icons.discount, needCloseIcon: true),
                SizedBox(width: 16),
                MyTag(
                  'label text',
                  icon: Icons.discount,
                  needCloseIcon: true,
                  isOutline: true,
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: 'Each size test',
          builder: (context) {
            return Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      MyTag(
                        'extraLarge',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.extraLarge,
                      ),
                      MyTag(
                        'large',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.large,
                      ),
                      MyTag(
                        'medium',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.medium,
                      ),
                      MyTag(
                        'small',
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.small,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      MyTag(
                        'extraLarge',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.extraLarge,
                      ),
                      MyTag(
                        'large',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.large,
                      ),
                      MyTag(
                        'medium',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.medium,
                      ),
                      MyTag(
                        'small',
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        size: MyTagSize.small,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: 'Optional state tests',
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
                      MySelectTag('Tag', theme: MyTagTheme.primary),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isSelected: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        disableSelect: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: MyTagShape.mark,
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
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isLight: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isLight: true,
                        isSelected: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        isLight: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isLight: true,
                        disableSelect: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: MyTagShape.mark,
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
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isSelected: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        isOutline: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        disableSelect: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: MyTagShape.mark,
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
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        isSelected: true,
                        shape: MyTagShape.mark,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        isOutline: true,
                        isLight: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        disableSelect: true,
                      ),
                      MySelectTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: MyTagShape.mark,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: 'Demonstrating tests in each state',
          builder: (context) {
            return Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      MyTag('Tag', theme: MyTagTheme.primary),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        shape: MyTagShape.round,
                        disable: true,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: MyTagShape.mark,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      MyTag('Tag', theme: MyTagTheme.primary, isLight: true),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        shape: MyTagShape.round,
                        isLight: true,
                        disable: true,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: MyTagShape.mark,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      MyTag('Tag', theme: MyTagTheme.primary, isOutline: true),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        shape: MyTagShape.round,
                        isOutline: true,
                        disable: true,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: MyTagShape.mark,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        shape: MyTagShape.mark,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        shape: MyTagShape.round,
                        isOutline: true,
                        isLight: true,
                        disable: true,
                      ),
                      MyTag(
                        'Tag',
                        theme: MyTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: Icons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: MyTagShape.mark,
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

  MyTag _buildSimpleOutlineTag(BuildContext context) {
    return const MyTag('label text', isOutline: true);
  }

  MyTag _buildSimpleFillTag(BuildContext context) {
    return const MyTag('label text');
  }

  Widget _buildCircleFillTag(BuildContext context) {
    return const MyTag('label text', shape: MyTagShape.round);
  }

  Widget _buildCircleOutlineTag(BuildContext context) {
    return const MyTag('label text', shape: MyTagShape.round, isOutline: true);
  }

  Widget _buildMarkFillTag(BuildContext context) {
    return const MyTag('label text', shape: MyTagShape.mark);
  }

  Widget _buildMarkOutlineTag(BuildContext context) {
    return const MyTag('label text', shape: MyTagShape.mark, isOutline: true);
  }

  Widget _buildIconFillTag(BuildContext context) {
    return const MyTag('label text', icon: Icons.discount);
  }

  Widget _buildIconOutlineTag(BuildContext context) {
    return const MyTag('label text', icon: Icons.discount, isOutline: true);
  }

  Widget _buildCloseFillTag(BuildContext context) {
    return MyTag(
      'label text',
      needCloseIcon: true,
      onCloseTap: () {
        TDToast.showText('Click to close', context: context);
      },
    );
  }

  Widget _buildCloseOutlineTag(BuildContext context) {
    return MyTag(
      'label text',
      needCloseIcon: true,
      isOutline: true,
      onCloseTap: () {
        TDToast.showText('Click to close', context: context);
      },
    );
  }

  Widget _buildDarkSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MySelectTag('unselected', theme: MyTagTheme.primary),
        MySelectTag(
          'Selected state',
          theme: MyTagTheme.primary,
          isSelected: true,
        ),
        MySelectTag(
          'Not selectable',
          theme: MyTagTheme.primary,
          disableSelect: true,
        ),
      ],
    );
  }

  Widget _buildLightSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MySelectTag('unselected', theme: MyTagTheme.primary, isLight: true),
        MySelectTag(
          'Selected state',
          theme: MyTagTheme.primary,
          isLight: true,
          isSelected: true,
        ),
        MySelectTag(
          'Not selectable',
          theme: MyTagTheme.primary,
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
        MySelectTag('unselected', theme: MyTagTheme.primary, isOutline: true),
        MySelectTag(
          'Selected state',
          theme: MyTagTheme.primary,
          isOutline: true,
          isSelected: true,
        ),
        MySelectTag(
          'Not selectable',
          theme: MyTagTheme.primary,
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
        MySelectTag(
          'unselected',
          theme: MyTagTheme.primary,
          isOutline: true,
          isLight: true,
        ),
        MySelectTag(
          'Selected state',
          theme: MyTagTheme.primary,
          isOutline: true,
          isLight: true,
          isSelected: true,
        ),
        MySelectTag(
          'Not selectable',
          theme: MyTagTheme.primary,
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
        MyTag('Default', isLight: true),

        MyTag('Primary', isLight: true, theme: MyTagTheme.primary),

        MyTag('Warning', isLight: true, theme: MyTagTheme.warning),

        MyTag('Danger', isLight: true, theme: MyTagTheme.danger),

        MyTag('Success', isLight: true, theme: MyTagTheme.success),
      ],
    );
  }

  Widget _buildDarkShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MyTag('Default'),
        MyTag('Primary', theme: MyTagTheme.primary),
        MyTag('Warning', theme: MyTagTheme.warning),
        MyTag('Danger', theme: MyTagTheme.danger),
        MyTag('Success', theme: MyTagTheme.success),
      ],
    );
  }

  Widget _buildOutlineShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MyTag('Default', isOutline: true),

        MyTag('Primary', isOutline: true, theme: MyTagTheme.primary),

        MyTag('Warning', isOutline: true, theme: MyTagTheme.warning),

        MyTag('Danger', isOutline: true, theme: MyTagTheme.danger),

        MyTag('Success', isOutline: true, theme: MyTagTheme.success),
      ],
    );
  }

  Widget _buildLightOutlineShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MyTag('Default', isOutline: true, isLight: true),
        MyTag(
          'primary',
          isOutline: true,
          isLight: true,
          theme: MyTagTheme.primary,
        ),
        MyTag(
          'warning',
          isOutline: true,
          isLight: true,
          theme: MyTagTheme.warning,
        ),
        MyTag(
          'danger',
          isOutline: true,
          isLight: true,
          theme: MyTagTheme.danger,
        ),
        MyTag(
          'success',
          isOutline: true,
          isLight: true,
          theme: MyTagTheme.success,
        ),
      ],
    );
  }

  Widget _buildAllSizeTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MyTag('ExtraLarge', size: MyTagSize.extraLarge),
        MyTag('Large', size: MyTagSize.large),
        MyTag('Medium', size: MyTagSize.medium),
        MyTag('Small', size: MyTagSize.small),
      ],
    );
  }

  Widget _buildAllSizeCloseTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MyTag('ExtraLarge', needCloseIcon: true, size: MyTagSize.extraLarge),
        MyTag('Large', needCloseIcon: true, size: MyTagSize.large),
        MyTag('Medium', needCloseIcon: true, size: MyTagSize.medium),
        MyTag('Small', needCloseIcon: true, size: MyTagSize.small),
      ],
    );
  }
}
