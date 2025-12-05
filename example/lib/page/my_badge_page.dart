import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../base/example_widget.dart';

class MyBadgePage extends StatefulWidget {
  const MyBadgePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyBadgePageState();
}

class _MyBadgePageState extends State<MyBadgePage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          'Used to inform users of the status changes of the area or the number of pending tasks. ',
      exampleCodeGroup: 'badge',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Red Dot',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildRedPointMessageBadge(context),
                    _buildRedPointIconBadge(context),
                    _buildRedPointButtonBadge(context),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: 'Number Badge',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildMessageNumberBadge(context),
                    _buildIconNumberBadge(context),
                    _buildButtonNumberBadge(context),
                  ],
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              desc: 'Circle / Square / Bubble',
              builder: (context) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCircleBadge(context),
                    _buildSquareBadge(context),
                    _buildBubbleBadge(context),
                  ],
                );
              },
            ),
            ExampleItem(desc: 'Subscript', builder: _buildSubscriptBadge),
          ],
        ),
        ExampleModule(
          title: 'Component Size',
          children: [
            ExampleItem(
              desc: 'Large / Medium',
              builder: (context) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLargeBadge(context),
                    _buildMediumBadge(context),
                  ],
                );
              },
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          ignoreCode: true,
          desc: 'Does not exceed the upper limit',
          builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_buildLessThanMaxCountBadge(context)],
            );
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: 'Exceeds the upper limit',
          builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_buildMoreThanMaxCountBadge(context)],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRedPointMessageBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: SizedBox(
        height: 24,
        width: 40,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            MyText('Info'),
            const Positioned(
              right: 0,
              top: 0,
              child: MyBadge(MyBadgeType.redPoint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedPointIconBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: const SizedBox(
        width: 27,
        height: 27,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Icon(LucideIcons.bell),
            Positioned(right: 0, top: 0, child: MyBadge(MyBadgeType.redPoint)),
          ],
        ),
      ),
    );
  }

  Widget _buildRedPointButtonBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Stack(
        alignment: Alignment.bottomLeft,
        clipBehavior: Clip.none,
        children: [
          MyButton(
            text: 'Button',
            size: MyButtonSize.large,
            type: MyButtonType.primary,
          ),
          Positioned(right: -2, top: -2, child: MyBadge(MyBadgeType.redPoint)),
        ],
      ),
    );
  }

  Widget _buildMessageNumberBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16),
      child: SizedBox(
        width: 54,
        height: 36,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            MyText('Info'),
            const Positioned(
              left: 28,
              bottom: 18,
              child: MyBadge(MyBadgeType.message, count: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconNumberBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16),
      child: const SizedBox(
        width: 42,
        height: 36,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Icon(LucideIcons.bell),
            Positioned(
              left: 18,
              bottom: 18,
              child: MyBadge(MyBadgeType.message, count: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonNumberBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: MyBadgeWrapper(
        right: -4,
        top: -4,
        badge: MyBadge(MyBadgeType.message, count: 8),
        child: MyButton(text: 'Button', size: MyButtonSize.large),
      ),
    );
  }

  Widget _buildCircleBadge(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 34,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Icon(LucideIcons.bell),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: MyBadge(MyBadgeType.message, count: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareBadge(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 34,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Icon(LucideIcons.bell),
                Positioned(
                  left: 20,
                  bottom: 18,
                  child: MyBadge(
                    MyBadgeType.square,
                    border: MyBadgeBorder.small,
                    count: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 67,
            height: 56,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(MyRadius.medium),
                  ),
                  height: 48,
                  width: 48,
                  child: const Icon(LucideIcons.shoppingBag),
                ),
                const Positioned(
                  right: 0,
                  top: 0,
                  child: MyBadge(MyBadgeType.bubble, message: 'Points'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptBadge(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          color: context.colorScheme.secondary,
          height: 48,
          width: MediaQuery.of(context).size.width,
          child: MyText('Single Line Title'),
        ),
        const MyBadge(MyBadgeType.subscript, message: 'NEW'),
      ],
    );
  }

  Widget _buildLargeBadge(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 70,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                MyAvatar(
                  size: MyAvatarSize.large,
                  type: MyAvatarType.icon,
                  backgroundColor: context.colorScheme.secondary,
                ),
                Positioned(
                  left: 48,
                  bottom: 48,
                  child: MyBadge(
                    MyBadgeType.message,
                    size: MyBadgeSize.large,
                    count: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediumBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 54,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                MyAvatar(
                  size: MyAvatarSize.medium,
                  type: MyAvatarType.icon,
                  backgroundColor: context.colorScheme.secondary,
                ),
                Positioned(
                  left: 36,
                  bottom: 36,
                  child: MyBadge(MyBadgeType.message, count: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessThanMaxCountBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: const SizedBox(
        width: 60,
        height: 50,
        child: Stack(
          children: [
            Positioned(left: 0, bottom: 0, child: Icon(LucideIcons.bell)),
            Positioned(
              left: 18,
              bottom: 18,
              child: MyBadge(
                MyBadgeType.square,
                count: 8888,
                maxCount: 9000,
                size: MyBadgeSize.large,
                border: MyBadgeBorder.large,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreThanMaxCountBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: const SizedBox(
        width: 60,
        height: 50,
        child: Stack(
          children: [
            Positioned(left: 0, bottom: 0, child: Icon(LucideIcons.bell)),
            Positioned(
              left: 18,
              bottom: 18,
              child: MyBadge(
                MyBadgeType.square,
                count: 888,
                maxCount: 99,
                size: MyBadgeSize.large,
                border: MyBadgeBorder.large,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
