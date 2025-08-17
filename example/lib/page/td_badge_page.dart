import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDBadgePage extends StatefulWidget {
  const TDBadgePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDBadgePageState();
}

class _TDBadgePageState extends State<TDBadgePage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于告知用户，该区域的状态变化或者待处理任务的数量。',
      exampleCodeGroup: 'badge',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '红点徽标',
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
              desc: '数字徽标',
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
            ExampleItem(
              desc: '自定义徽标',
              ignoreCode: true,
              builder: (context) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCustomBadgeShowingNumberEight(context),
                    _buildCustomBadgeShowingNumberZero(context),
                    _buildCustomBadgeWithoutShowingNumberZero(context),
                  ],
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '圆形徽标', builder: _buildCircleBadge),
            ExampleItem(desc: '方形徽标', builder: _buildSquareBadge),
            ExampleItem(desc: '气泡徽标', builder: _buildBubbleBadge),
            ExampleItem(desc: '角标', builder: _buildSubscriptBadge),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(desc: 'Large', builder: _buildLargeBadge),
            ExampleItem(desc: 'Medium', builder: _buildMediumBadge),
          ],
        ),
      ],
      test: [
        ExampleItem(
          ignoreCode: true,
          desc: '未超过上限',
          builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_buildLessThanMaxCountBadge(context)],
            );
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '超过上限',
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
        width: 40,
        height: 24,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            TDText('消息'),
            const Positioned(
              right: 0,
              top: 0,
              child: TDBadge(TDBadgeType.redPoint),
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
            Icon(Icons.notifications),
            Positioned(right: 0, top: 0, child: TDBadge(TDBadgeType.redPoint)),
          ],
        ),
      ),
    );
  }

  Widget _buildRedPointButtonBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: const SizedBox(
        width: 83,
        height: 48,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            MyButton(
              width: 80,
              height: 48,
              text: '按钮',
              size: MyButtonSize.large,
              type: MyButtonType.fill,
            ),
            Positioned(right: 0, top: 0, child: TDBadge(TDBadgeType.redPoint)),
          ],
        ),
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
            TDText('消息'),
            const Positioned(
              left: 28,
              bottom: 18,
              child: TDBadge(TDBadgeType.message, count: 8),
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
            Icon(Icons.notifications),
            Positioned(
              left: 18,
              bottom: 18,
              child: TDBadge(TDBadgeType.message, count: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonNumberBadge(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 16),
      child: const SizedBox(
        width: 86,
        height: 54,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            MyButton(
              width: 80,
              height: 48,
              text: '按钮',
              size: MyButtonSize.large,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: TDBadge(TDBadgeType.message, count: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBadgeShowingNumberEight(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      child: SizedBox(
        width: 64,
        height: 56,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.neutral.shade100,
                borderRadius: BorderRadius.circular(MyRadius.medium),
              ),
              height: 48,
              width: 48,
              child: const Icon(Icons.notifications),
            ),
            const Positioned(
              right: 0,
              top: 0,
              child: TDBadge(TDBadgeType.message, count: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBadgeShowingNumberZero(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      child: SizedBox(
        width: 64,
        height: 56,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.neutral.shade100,
                borderRadius: BorderRadius.circular(MyRadius.medium),
              ),
              height: 48,
              width: 48,
              child: const Icon(Icons.notifications_active_sharp),
            ),
            const Positioned(
              right: 0,
              top: 0,
              child: TDBadge(TDBadgeType.message, count: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBadgeWithoutShowingNumberZero(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      child: SizedBox(
        width: 64,
        height: 56,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.neutral.shade100,
                borderRadius: BorderRadius.circular(MyRadius.medium),
              ),
              height: 48,
              width: 48,
              child: const Icon(Icons.notifications),
            ),
            const Positioned(
              right: 0,
              top: 0,
              child: TDBadge(TDBadgeType.message, count: 0, showZero: false),
            ),
          ],
        ),
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
                Icon(Icons.notifications),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: TDBadge(TDBadgeType.message, count: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareBadge(BuildContext context) {
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
                Icon(Icons.notifications),
                Positioned(
                  left: 20,
                  bottom: 18,
                  child: TDBadge(
                    TDBadgeType.square,
                    border: TDBadgeBorder.small,
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
                    color: ThemeColors.neutral.shade100,
                    borderRadius: BorderRadius.circular(MyRadius.medium),
                  ),
                  height: 48,
                  width: 48,
                  child: const Icon(Icons.shop),
                ),
                const Positioned(
                  right: 0,
                  top: 0,
                  child: TDBadge(TDBadgeType.bubble, message: '领积分'),
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
          color: Colors.white,
          height: 48,
          width: MediaQuery.of(context).size.width,
          child: TDText('单行标题'),
        ),
        const TDBadge(TDBadgeType.subscript, message: 'NEW'),
      ],
    );
  }

  Widget _buildLargeBadge(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 70,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDAvatar(size: TDAvatarSize.large, type: TDAvatarType.icon),
                Positioned(
                  left: 48,
                  bottom: 48,
                  child: TDBadge(
                    TDBadgeType.message,
                    size: TDBadgeSize.large,
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
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: const Row(
        children: [
          SizedBox(
            width: 120,
            height: 54,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDAvatar(size: TDAvatarSize.medium, type: TDAvatarType.icon),
                Positioned(
                  left: 36,
                  bottom: 36,
                  child: TDBadge(TDBadgeType.message, count: 8),
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
            Positioned(left: 0, bottom: 0, child: Icon(Icons.notifications)),
            Positioned(
              left: 18,
              bottom: 18,
              child: TDBadge(
                TDBadgeType.square,
                count: 8888,
                maxCount: 9000,
                size: TDBadgeSize.large,
                border: TDBadgeBorder.large,
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
            Positioned(left: 0, bottom: 0, child: Icon(Icons.notifications)),
            Positioned(
              left: 18,
              bottom: 18,
              child: TDBadge(
                TDBadgeType.square,
                count: 888,
                maxCount: 99,
                size: TDBadgeSize.large,
                border: TDBadgeBorder.large,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
