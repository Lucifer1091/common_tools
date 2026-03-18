import 'package:common_tools/widgets/components/toast/my_toast.dart';
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
            ExampleItem(desc: 'Avatar with Badge', builder: _buildBadgeAvatar),
          ],
        ),
        ExampleModule(
          title: 'Special Type',
          children: [
            // ExampleItem(desc: 'Avatar Group', builder: _buildAvatarGroup),
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
        spacing: 32,
        children: [
          MyAvatar(placeholder: 'assets/img/td_avatar_1.png'),
          MyAvatar(
            shape: MyAvatarShape.square,
            placeholder: 'assets/img/td_avatar_1.png',
          ),
        ],
      ),
    );
  }

  Widget _buildTextAvatar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        spacing: 32,
        children: [
          MyAvatar(type: MyAvatarType.initials, initials: 'AA'),
          MyAvatar(
            type: MyAvatarType.initials,
            shape: MyAvatarShape.square,
            initials: 'AC',
          ),
          MyAvatar(
            type: MyAvatarType.initials,
            shape: MyAvatarShape.square,
            initials: 'Justin Greaves'.initials,
          ),
        ],
      ),
    );
  }

  Widget _buildIconAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        spacing: 32,
        children: [
          MyAvatar(type: MyAvatarType.icon),
          MyAvatar(type: MyAvatarType.icon, shape: MyAvatarShape.square),
        ],
      ),
    );
  }

  Widget _buildBadgeAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        spacing: 32,
        children: [
          MyBadgeWrapper(
            height: 51,
            width: 51,
            right: 0,
            top: 0,
            badge: MyBadge(MyBadgeType.redPoint),
            child: MyAvatar(
              size: MyAvatarSize.medium,
              type: MyAvatarType.normal,
              placeholder: 'assets/img/td_avatar_1.png',
            ),
          ),
          MyBadgeWrapper(
            height: 51,
            width: 51,
            right: 0,
            top: 0,
            badge: MyBadge(MyBadgeType.message, count: 8),
            child: MyAvatar(
              size: MyAvatarSize.medium,
              type: MyAvatarType.initials,
              initials: 'AC',
            ),
          ),
          MyBadgeWrapper(
            height: 51,
            width: 51,
            right: 0,
            top: 0,
            badge: MyBadge(MyBadgeType.message, count: 12),
            child: MyAvatar(type: MyAvatarType.icon),
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
      child: Row(
        spacing: 16,
        children: [
          MyAvatar(
            type: MyAvatarType.display,
            infoText: '+5',
            avatars: avatarList,
          ),
          MyAvatar(
            distance: 16,
            direction: Axis.vertical,
            type: MyAvatarType.display,
            infoText: '+5',
            avatars: avatarList,
          ),
        ],
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
      child: Row(
        spacing: 16,
        children: [
          MyAvatar(
            type: MyAvatarType.operation,
            avatars: avatarList,
            onTap: () {
              MyToast.info(title: 'On Add User Tap', context: context);
            },
          ),
          MyAvatar(
            direction: Axis.vertical,
            type: MyAvatarType.operation,
            avatars: avatarList,
            onTap: () {
              MyToast.info(title: 'On Add User Tap', context: context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLargeAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        spacing: 32,
        children: [
          MyAvatar(
            size: MyAvatarSize.large,
            type: MyAvatarType.normal,
            placeholder: 'assets/img/td_avatar_1.png',
          ),
          MyAvatar(
            size: MyAvatarSize.large,
            type: MyAvatarType.initials,
            initials: 'AA',
          ),
          MyAvatar(size: MyAvatarSize.large, type: MyAvatarType.icon),
        ],
      ),
    );
  }

  Widget _buildMediumAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        spacing: 48,
        children: [
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.normal,
            placeholder: 'assets/img/td_avatar_1.png',
          ),
          MyAvatar(
            size: MyAvatarSize.medium,
            type: MyAvatarType.initials,
            initials: 'AC',
          ),
          MyAvatar(size: MyAvatarSize.medium, type: MyAvatarType.icon),
        ],
      ),
    );
  }

  Widget _buildSmallAvatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        spacing: 56,
        children: [
          MyAvatar(
            size: MyAvatarSize.small,
            type: MyAvatarType.normal,
            placeholder: 'assets/img/td_avatar_1.png',
          ),
          MyAvatar(
            size: MyAvatarSize.small,
            type: MyAvatarType.initials,
            initials: 'AA',
          ),
          MyAvatar(size: MyAvatarSize.small, type: MyAvatarType.icon),
        ],
      ),
    );
  }
}
