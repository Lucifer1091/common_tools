import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDAvatarPage extends StatefulWidget {
  const TDAvatarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDAvatarPageState();
}

class _TDAvatarPageState extends State<TDAvatarPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.primaryForeground,
      title: tdTitle(),
      exampleCodeGroup: 'avatar',
      desc: '用于告知用户，该区域的状态变化或者待处理任务的数量。',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: '图片头像', builder: _buildImageAvatar),
            ExampleItem(desc: '字符头像', builder: _buildTextAvatar),
            ExampleItem(desc: '图标头像', builder: _buildIconAvatar),
            ExampleItem(desc: '带徽标头像', builder: _buildBadgeAvatar),
          ],
        ),
        ExampleModule(
          title: '特殊类型',
          children: [
            ExampleItem(desc: '纯展示的头像组', builder: _buildDisplayAvatar),
            ExampleItem(desc: '带操作的头像组', builder: _buildOperationAvatar),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(desc: '大尺寸 :64px', builder: _buildLargeAvatar),
            ExampleItem(desc: '中尺寸 :48px', builder: _buildMediumAvatar),
            ExampleItem(desc: '小尺寸 :40px', builder: _buildSmallAvatar),
          ],
        ),
      ],
    );
  }

  /// 图片头像

  Widget _buildImageAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 32),
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.normal,
            shape: TDAvatarShape.square,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
        ],
      ),
    );
  }

  /// 字符头像

  Widget _buildTextAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 32),
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            shape: TDAvatarShape.square,
            text: 'A',
          ),
        ],
      ),
    );
  }

  /// 图标头像

  Widget _buildIconAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          TDAvatar(size: TDAvatarSize.medium, type: TDAvatarType.icon),
          SizedBox(width: 32),
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.icon,
            shape: TDAvatarShape.square,
          ),
        ],
      ),
    );
  }

  /// 带徽标头像

  Widget _buildBadgeAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            height: 51,
            width: 51,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDAvatar(
                  size: TDAvatarSize.medium,
                  type: TDAvatarType.normal,
                  defaultUrl: 'assets/img/td_avatar_1.png',
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: TDBadge(TDBadgeType.redPoint),
                ),
              ],
            ),
          ),
          SizedBox(width: 32),
          SizedBox(
            height: 51,
            width: 51,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDAvatar(
                  size: TDAvatarSize.medium,
                  type: TDAvatarType.customText,
                  text: 'A',
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: TDBadge(TDBadgeType.message, count: 8),
                ),
              ],
            ),
          ),
          SizedBox(width: 32),
          SizedBox(
            width: 51,
            height: 51,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDAvatar(size: TDAvatarSize.medium, type: TDAvatarType.icon),
                Positioned(
                  right: 0,
                  top: 0,
                  child: TDBadge(TDBadgeType.message, count: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 纯展示的头像组

  Widget _buildDisplayAvatar(BuildContext context) {
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: TDAvatar(
        size: TDAvatarSize.medium,
        type: TDAvatarType.display,
        displayText: '+5',
        avatarDisplayListAsset: avatarList,
      ),
    );
  }

  /// 带操作的头像组

  Widget _buildOperationAvatar(BuildContext context) {
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: TDAvatar(
        size: TDAvatarSize.medium,
        type: TDAvatarType.operation,
        avatarDisplayListAsset: avatarList,
        onTap: () {
          TDToast.showText('点击了操作', context: context);
        },
      ),
    );
  }

  /// 组件尺寸 大尺寸

  Widget _buildLargeAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          TDAvatar(
            size: TDAvatarSize.large,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 32),
          TDAvatar(
            size: TDAvatarSize.large,
            type: TDAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 32),
          TDAvatar(size: TDAvatarSize.large, type: TDAvatarType.icon),
        ],
      ),
    );
  }

  /// 组件尺寸 中尺寸

  Widget _buildMediumAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 48),
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 48),
          TDAvatar(size: TDAvatarSize.medium, type: TDAvatarType.icon),
        ],
      ),
    );
  }

  /// 组件尺寸 小尺寸

  Widget _buildSmallAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          TDAvatar(
            size: TDAvatarSize.small,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 56),
          TDAvatar(
            size: TDAvatarSize.small,
            type: TDAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 56),
          TDAvatar(size: TDAvatarSize.small, type: TDAvatarType.icon),
        ],
      ),
    );
  }
}
