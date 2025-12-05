import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyAvatarPage extends StatefulWidget {
  const MyAvatarPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyAvatarPageState();
}

class _MyAvatarPageState extends State<MyAvatarPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.primaryForeground,
      title: myTitle(),
      exampleCodeGroup: 'avatar',
      desc: 'Avatars are used to represent people or objects.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Image Avatar', builder: _buildImageAvatar),
            ExampleItem(desc: 'Character Avatar', builder: _buildTextAvatar),
            ExampleItem(desc: 'Icon Avatar', builder: _buildIconAvatar),
            ExampleItem(desc: 'Avatar with Logo', builder: _buildBadgeAvatar),
          ],
        ),
        ExampleModule(
          title: 'Special Type',
          children: [
            ExampleItem(
              desc: 'Avatar Group for Pure Display',
              builder: _buildDisplayAvatar,
            ),
            ExampleItem(
              desc: 'Avatar Group with Operations',
              builder: _buildOperationAvatar,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Size',
          children: [
            ExampleItem(desc: 'Large Size: 64px', builder: _buildLargeAvatar),
            ExampleItem(desc: 'Medium Size: 48px', builder: _buildMediumAvatar),
            ExampleItem(desc: 'Small Size: 40px', builder: _buildSmallAvatar),
          ],
        ),
      ],
    );
  }

  Widget _buildImageAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 32),
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.normal,
            shape: MyAvatarShape.square,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
        ],
      ),
    );
  }

  Widget _buildTextAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 32),
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.customText,
            shape: MyAvatarShape.square,
            text: 'A',
          ),
        ],
      ),
    );
  }

  Widget _buildIconAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          MyAvatar(size: MyAvatarSize.medium, type: MyAvatarType.icon),
          SizedBox(width: 32),
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.icon,
            shape: MyAvatarShape.square,
          ),
        ],
      ),
    );
  }

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
                MyAvatar(
                  size: MyAvatarSize.medium,
                  type: MyAvatarType.normal,
                  defaultUrl: 'assets/img/td_avatar_1.png',
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: MyBadge(MyBadgeType.redPoint),
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
                MyAvatar(
                  size: MyAvatarSize.medium,
                  type: MyAvatarType.customText,
                  text: 'A',
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: MyBadge(MyBadgeType.message, count: 8),
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
                MyAvatar(size: MyAvatarSize.medium, type: MyAvatarType.icon),
                Positioned(
                  right: 0,
                  top: 0,
                  child: MyBadge(MyBadgeType.message, count: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayAvatar(BuildContext context) {
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: MyAvatar(
        size: MyAvatarSize.medium,
        type: MyAvatarType.display,
        displayText: '+5',
        avatarDisplayListAsset: avatarList,
      ),
    );
  }

  Widget _buildOperationAvatar(BuildContext context) {
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: MyAvatar(
        size: MyAvatarSize.medium,
        type: MyAvatarType.operation,
        avatarDisplayListAsset: avatarList,
        onTap: () {
          TDToast.showText('点击了操作', context: context);
        },
      ),
    );
  }

  Widget _buildLargeAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          MyAvatar(
            size: MyAvatarSize.large,
            type: MyAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 32),
          MyAvatar(
            size: MyAvatarSize.large,
            type: MyAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 32),
          MyAvatar(size: MyAvatarSize.large, type: MyAvatarType.icon),
        ],
      ),
    );
  }

  Widget _buildMediumAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 48),
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 48),
          MyAvatar(size: MyAvatarSize.medium, type: MyAvatarType.icon),
        ],
      ),
    );
  }

  Widget _buildSmallAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          MyAvatar(
            size: MyAvatarSize.small,
            type: MyAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',
          ),
          SizedBox(width: 56),
          MyAvatar(
            size: MyAvatarSize.small,
            type: MyAvatarType.customText,
            text: 'A',
          ),
          SizedBox(width: 56),
          MyAvatar(size: MyAvatarSize.small, type: MyAvatarType.icon),
        ],
      ),
    );
  }
}
