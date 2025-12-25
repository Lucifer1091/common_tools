import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../base/example_widget.dart';

class MyTagPage extends StatelessWidget {
  const MyTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'A tag is a small, interactive element that represents an attribute, text, entity, or action.',
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
              desc: 'Round Tag',
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
              desc: 'Labels With Icons',
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
              desc: 'Closable Tags',
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
              desc: 'Selectable Tags',
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
                          const SizedBox(width: 80, child: MyText('Fill')),
                          _buildFillSelectTags(context),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 80, child: MyText('Outline')),
                          _buildOutlineSelectTags(context),
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
              desc: 'Display Label',
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      _buildFillShowTags(context),
                      _buildOutlineShowTags(context),
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
                  padding: const EdgeInsets.only(left: 16, top: 16),
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
    return const MyTag(
      'label text',
      iconWidget: Icon(LucideIcons.tag, size: 10),
    );
  }

  Widget _buildIconOutlineTag(BuildContext context) {
    return const MyTag(
      'label text',
      iconWidget: Icon(LucideIcons.tag, size: 10),
    );
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

  Widget _buildFillSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MySelectTag('Unselected', theme: MyTagTheme.primary),
        MySelectTag('Selected', theme: MyTagTheme.primary, isSelected: true),
        MySelectTag('Selected', theme: MyTagTheme.warning, isSelected: true),
        MySelectTag('Disabled', theme: MyTagTheme.primary, enable: false),
      ],
    );
  }

  Widget _buildOutlineSelectTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        MySelectTag('Unselected', theme: MyTagTheme.primary, isOutline: true),
        MySelectTag(
          'Selected',
          theme: MyTagTheme.primary,
          isOutline: true,
          isSelected: true,
        ),
        MySelectTag(
          'Selected',
          theme: MyTagTheme.warning,
          isOutline: true,
          isSelected: true,
        ),
        MySelectTag(
          'Disabled',
          theme: MyTagTheme.primary,
          isOutline: true,
          enable: false,
        ),
      ],
    );
  }

  Widget _buildFillShowTags(BuildContext context) {
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
