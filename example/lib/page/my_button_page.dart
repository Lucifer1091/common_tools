import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyButtonPage extends StatelessWidget {
  const MyButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.background,
      child: ExamplePage(
        title: tdTitle(context),
        desc:
            'Used to start a closed-loop operation task, such as "delete" an object, "purchase" a product, etc. ',
        exampleCodeGroup: 'button',
        children: [
          ExampleModule(
            title: 'Component Types',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: 'Basic Buttons',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildSecondaryButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDestructiveButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildOutlineButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildGhostButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildTextButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLinkButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: 'Icon Button',
                center: false,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildRectangleIconButton(
                            context,
                            MyButtonIconPosition.left,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildRectangleIconButton(
                            context,
                            MyButtonIconPosition.right,
                          ),
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
                desc: 'Favorite Buttons',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        MyFavoriteButton(
                          size: MyButtonSize.extraLarge,
                          type: MyButtonType.outline,
                          onChanged: (value) {},
                        ),
                        const Gap.horizontal(16),
                        MyFavoriteButton(
                          size: MyButtonSize.extraLarge,
                          icon: Icons.star_border_rounded,
                          selectedIcon: Icons.star_rounded,
                          onChanged: (value) {},
                        ),
                        const Gap.horizontal(16),
                        MyFavoriteButton(
                          size: MyButtonSize.extraLarge,
                          icon: Icons.thumb_up_alt_outlined,
                          selectedIcon: Icons.thumb_up_rounded,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                desc: 'Floating Action Buttons',
                builder: (BuildContext context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        MyButton(
                          isFloating: true,
                          shape: MyButtonShape.circle,
                          size: MyButtonSize.large,
                          icon: Icons.add,
                        ),
                        Gap(16),
                        MyButton(
                          isFloating: true,
                          shape: MyButtonShape.square,
                          size: MyButtonSize.large,
                          icon: Icons.add,
                        ),
                        Gap(16),
                        MyButton(
                          isFloating: true,
                          text: 'Floating',
                          shape: MyButtonShape.round,
                          size: MyButtonSize.large,
                          icon: Icons.add,
                        ),
                      ],
                    ),
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: 'Combination button',
                builder: (_) => _buildCombinationButtons(context),
              ),
            ],
          ),
          ExampleModule(
            title: 'Component State',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: 'Buttons disabled state',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisablePrimaryButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableSecondaryButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableDestructiveButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableOutlineButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableGhostButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableTextButton(context),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableLinkButton(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          ExampleModule(
            title: 'Component Styles',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: 'Button Sizes',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 10),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: _buildExtraLargeButton(context),
                        ),
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
                desc: 'Button Shapes',
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
                          child: _buildPrimaryButton(context),
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
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: MyButton(
                            isExpanded: true,
                            text: 'Filled block button',
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
      ),
    );
  }

  MyButton _buildDisableLinkButton(BuildContext context) {
    return const MyButton(
      text: 'Link',
      size: MyButtonSize.large,
      type: MyButtonType.link,
      enabled: false,
    );
  }

  MyButton _buildDisableTextButton(BuildContext context) {
    return const MyButton(
      text: 'Text',
      size: MyButtonSize.large,
      type: MyButtonType.text,
      enabled: false,
    );
  }

  MyButton _buildFilledButton(BuildContext context) {
    return const MyButton(
      text: 'Filled Button',
      size: MyButtonSize.large,
      type: MyButtonType.primary,
      shape: MyButtonShape.filled,
    );
  }

  MyButton _buildCircleButton(BuildContext context) {
    return const MyButton(
      icon: Icons.dashboard_rounded,
      size: MyButtonSize.large,
      type: MyButtonType.primary,
      shape: MyButtonShape.circle,
    );
  }

  MyButton _buildRoundButton(BuildContext context) {
    return const MyButton(
      text: 'Filled Button',
      size: MyButtonSize.large,
      type: MyButtonType.primary,
      shape: MyButtonShape.round,
    );
  }

  MyButton _buildExtraSmallButton(BuildContext context) {
    return const MyButton(
      text: 'Button 28',
      size: MyButtonSize.extraSmall,
      type: MyButtonType.primary,
    );
  }

  MyButton _buildSmallButton(BuildContext context) {
    return const MyButton(
      text: 'Button 32',
      size: MyButtonSize.small,
      type: MyButtonType.primary,
    );
  }

  MyButton _buildMediumButton(BuildContext context) {
    return const MyButton(
      text: 'Button 36',
      size: MyButtonSize.medium,
      type: MyButtonType.primary,
    );
  }

  MyButton _buildLargeButton(BuildContext context) {
    return const MyButton(
      text: 'Button 40',
      size: MyButtonSize.large,
      type: MyButtonType.primary,
    );
  }

  MyButton _buildExtraLargeButton(BuildContext context) {
    return const MyButton(
      text: 'Button 48',
      size: MyButtonSize.extraLarge,
      type: MyButtonType.primary,
    );
  }

  MyButton _buildDisableGhostButton(BuildContext context) {
    return const MyButton(
      text: 'Ghost',
      size: MyButtonSize.large,
      type: MyButtonType.ghost,
      enabled: false,
    );
  }

  MyButton _buildDisableOutlineButton(BuildContext context) {
    return const MyButton(
      text: 'Outlined',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      enabled: false,
    );
  }

  MyButton _buildDisableDestructiveButton(BuildContext context) {
    return const MyButton(
      text: 'Destructive',
      size: MyButtonSize.large,
      type: MyButtonType.destructive,
      enabled: false,
    );
  }

  MyButton _buildDisableSecondaryButton(BuildContext context) {
    return const MyButton(
      text: 'Secondary',
      size: MyButtonSize.large,
      type: MyButtonType.secondary,

      enabled: false,
    );
  }

  MyButton _buildDisablePrimaryButton(BuildContext context) {
    return const MyButton(
      text: 'Primary',
      size: MyButtonSize.large,
      enabled: false,
    );
  }

  MyButton _buildSquareIconButton(BuildContext context) {
    return const MyButton(
      icon: Icons.dashboard_rounded,
      size: MyButtonSize.large,
      type: MyButtonType.primary,
      shape: MyButtonShape.square,
    );
  }

  MyButton _buildLoadingIconButton(BuildContext context) {
    return MyButton(
      text: 'Loading',
      iconWidget: MyLoader(
        // size: MyLoaderSize.small,
        icon: MyLoaderIcon.circle,
        // iconColor: context.colorScheme.primaryForeground,
      ),
      size: MyButtonSize.large,
      type: MyButtonType.primary,
    );
  }

  MyButton _buildRectangleIconButton(
    BuildContext context,
    MyButtonIconPosition position,
  ) {
    return MyButton(
      text: position.name.capitalize,
      icon: Icons.dashboard_rounded,
      size: MyButtonSize.large,
      type: MyButtonType.primary,
      iconPosition: position,
    );
  }

  MyButton _buildPrimaryButton(BuildContext context) {
    return const MyButton(
      text: 'Primary',
      size: MyButtonSize.large,
      type: MyButtonType.primary,
    );
  }

  MyButton _buildSecondaryButton(BuildContext context) {
    return const MyButton(
      text: 'Secondary',
      size: MyButtonSize.large,
      type: MyButtonType.secondary,
    );
  }

  MyButton _buildDestructiveButton(BuildContext context) {
    return const MyButton(
      text: 'Destructive',
      size: MyButtonSize.large,
      type: MyButtonType.destructive,
    );
  }

  MyButton _buildOutlineButton(BuildContext context) {
    return const MyButton(
      text: 'Outline',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
    );
  }

  MyButton _buildGhostButton(BuildContext context) {
    return const MyButton(
      text: 'Ghost',
      size: MyButtonSize.large,
      type: MyButtonType.ghost,
    );
  }

  MyButton _buildTextButton(BuildContext context) {
    return const MyButton(
      text: 'Text',
      size: MyButtonSize.large,
      type: MyButtonType.text,
    );
  }

  MyButton _buildLinkButton(BuildContext context) {
    return const MyButton(
      text: 'Link',
      size: MyButtonSize.large,
      type: MyButtonType.link,
    );
  }

  Widget _buildCombinationButtons(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 100),
        Expanded(
          child: MyButton(text: 'Cancel', type: MyButtonType.outline),
        ),
        SizedBox(width: 16),
        Expanded(child: MyButton(text: 'Confirm')),
        SizedBox(width: 100),
      ],
    ).constrained();
  }
}
