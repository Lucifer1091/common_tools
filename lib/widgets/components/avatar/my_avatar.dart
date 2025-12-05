import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

enum MyAvatarSize { large, medium, small }

enum MyAvatarType { icon, normal, customText, display, operation }

enum MyAvatarShape { circle, square }

class MyAvatar extends StatelessWidget {
  const MyAvatar({
    super.key,
    this.size = MyAvatarSize.medium,
    this.type = MyAvatarType.normal,
    this.shape = MyAvatarShape.circle,
    this.text,
    this.textColor,
    this.style,
    this.radius,
    this.icon,
    this.avatarUrl,
    this.avatarSize,
    this.avatarDisplayList,
    this.displayText,
    this.onTap,
    this.defaultUrl = '',
    this.avatarDisplayWidget,
    this.avatarDisplayBorder = 2,
    this.avatarDisplayListAsset,
    this.backgroundColor,
    this.fit,
  });

  final String? avatarUrl;
  final MyAvatarSize size;
  final MyAvatarType type;
  final MyAvatarShape shape;
  final String? text;
  final Color? textColor;
  final TextStyle? style;
  final double? radius;
  final double? avatarSize;
  final IconData? icon;
  final String defaultUrl;
  final List<String>? avatarDisplayList;
  final List<String>? avatarDisplayListAsset;
  final double avatarDisplayBorder;
  final Widget? avatarDisplayWidget;
  final String? displayText;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BoxFit? fit;

  double _getAvatarWidth() {
    return avatarSize ??
        switch (size) {
          MyAvatarSize.large => 64,
          MyAvatarSize.medium => 48,
          MyAvatarSize.small => 40,
        };
  }

  TextStyle? _getTextStyle(BuildContext context) {
    return style ??
        switch (size) {
          MyAvatarSize.large => context.titleLarge,
          MyAvatarSize.medium => context.titleMedium,
          MyAvatarSize.small => context.titleSmall,
        }.copyWith(color: textColor ?? context.colorScheme.primaryForeground);
  }

  double _getIconWidth() {
    return switch (size) {
      MyAvatarSize.large => 32,
      MyAvatarSize.medium => 24,
      MyAvatarSize.small => 20,
    };
  }

  double _getAvatarRadius(BuildContext context) {
    return radius ??
        switch (shape) {
          MyAvatarShape.circle => _getAvatarWidth() / 2,
          MyAvatarShape.square => 8,
        };
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MyAvatarType.icon:
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  context.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: Center(
              child: Icon(
                icon ?? LucideIcons.user,
                size: _getIconWidth(),
                color: context.colorScheme.primary,
              ),
            ),
          ),
        );
      case MyAvatarType.normal:
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  context.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
              image:
                  avatarUrl != null
                      ? DecorationImage(image: NetworkImage(avatarUrl!))
                      : defaultUrl != ''
                      ? DecorationImage(image: AssetImage(defaultUrl))
                      : null,
            ),
          ),
        );
      case MyAvatarType.customText:
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color: backgroundColor ?? context.colorScheme.primary,
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: Center(
              child: MyText(
                text,
                textAlign: TextAlign.center,
                style: _getTextStyle(context),
              ),
            ),
          ),
        );
      case MyAvatarType.display:
        return _buildDisplayAvatar(context);
      case MyAvatarType.operation:
        return _buildOperationAvatar(context);
    }
  }

  double _getDisplayPadding() {
    return switch (size) {
      MyAvatarSize.large => 10,
      MyAvatarSize.medium => 8,
      MyAvatarSize.small => 6,
    };
  }

  Widget _buildOperationAvatar(BuildContext context) {
    final list = <Widget>[];

    if (avatarDisplayList.isBlank && avatarDisplayListAsset.isBlank) {
      return const NoWidget();
    }

    var length = 0;

    if (avatarDisplayList != null) {
      length = avatarDisplayList!.length;
      for (var i = 0; i < avatarDisplayList!.length + 1; i++) {
        final left = (_getAvatarWidth() - _getDisplayPadding()) * i;
        if (i == avatarDisplayList!.length) {
          list.add(
            Positioned(
              left: left,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        _getAvatarWidth() - _getDisplayPadding(),
                      ),
                      side: BorderSide(
                        color: Colors.white,
                        width: avatarDisplayBorder,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon ?? LucideIcons.userPlus,
                      size: _getIconWidth(),
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          list.add(
            Positioned(
              left: left,
              child: Container(
                width: _getAvatarWidth(),
                height: _getAvatarWidth(),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getAvatarWidth() - _getDisplayPadding(),
                    ),
                    side: BorderSide(
                      color: Colors.white,
                      width: avatarDisplayBorder,
                    ),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(avatarDisplayList![i]),
                    fit: fit ?? BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
      }
    } else if (avatarDisplayListAsset != null) {
      length = avatarDisplayListAsset!.length;

      for (var i = 0; i < avatarDisplayListAsset!.length + 1; i++) {
        final left = (_getAvatarWidth() - _getDisplayPadding()) * i;

        if (i == avatarDisplayListAsset!.length) {
          list.add(
            Positioned(
              left: left,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        _getAvatarWidth() - _getDisplayPadding(),
                      ),
                      side: BorderSide(
                        color: Colors.white,
                        width: avatarDisplayBorder,
                      ),
                    ),
                  ),
                  child: Center(
                    child:
                        avatarDisplayWidget ??
                        Icon(
                          icon ??  LucideIcons.userPlus,
                          size: _getIconWidth(),
                          color: context.colorScheme.primary,
                        ),
                  ),
                ),
              ),
            ),
          );
        } else {
          list.add(
            Positioned(
              left: left,
              child: Container(
                width: _getAvatarWidth(),
                height: _getAvatarWidth(),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getAvatarWidth() - _getDisplayPadding(),
                    ),
                    side: BorderSide(
                      color: Colors.white,
                      width: avatarDisplayBorder,
                    ),
                  ),
                  image: DecorationImage(
                    image: AssetImage(avatarDisplayListAsset![i]),
                    fit: fit ?? BoxFit.fill,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return SizedBox(
      height: _getAvatarWidth(),
      width: _getAvatarWidth() * (length + 1) - length * _getDisplayPadding(),
      child: Stack(children: list),
    );
  }

  Widget _buildDisplayAvatar(BuildContext context) {
    final list = <Widget>[];

    if (avatarDisplayList.isBlank && avatarDisplayListAsset.isBlank) {
      return const NoWidget();
    }

    var length = 0;

    if (avatarDisplayList != null) {
      length = avatarDisplayList!.length;

      for (var i = avatarDisplayList!.length; i >= 0; i--) {
        final left = (_getAvatarWidth() - _getDisplayPadding()) * i;

        if (i == avatarDisplayList!.length) {
          list.add(
            Positioned(
              left: left,
              child: Container(
                width: _getAvatarWidth(),
                height: _getAvatarWidth(),
                clipBehavior: Clip.hardEdge,
                decoration: ShapeDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getAvatarWidth() - _getDisplayPadding(),
                    ),
                    side: BorderSide(
                      color: Colors.white,
                      width: avatarDisplayBorder,
                    ),
                  ),
                ),
                child:
                    avatarDisplayWidget ??
                    Center(
                      child: MyText(
                        displayText,
                        textAlign: TextAlign.center,
                        style: _getTextStyle(context),
                      ),
                    ),
              ),
            ),
          );
        } else {
          list.add(
            Positioned(
              left: left,
              child: Container(
                width: _getAvatarWidth(),
                height: _getAvatarWidth(),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getAvatarWidth() - _getDisplayPadding(),
                    ),
                    side: BorderSide(
                      color: Colors.white,
                      width: avatarDisplayBorder,
                    ),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(avatarDisplayList![i]),
                    fit: fit ?? BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
      }
    } else if (avatarDisplayListAsset != null) {
      length = avatarDisplayListAsset!.length;

      for (var i = avatarDisplayListAsset!.length; i >= 0; i--) {
        final left = (_getAvatarWidth() - _getDisplayPadding()) * i;

        if (i == avatarDisplayListAsset!.length) {
          list.add(
            Positioned(
              left: left,
              child: Container(
                width: _getAvatarWidth(),
                height: _getAvatarWidth(),
                clipBehavior: Clip.hardEdge,
                decoration: ShapeDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getAvatarWidth() - _getDisplayPadding(),
                    ),
                    side: BorderSide(
                      color: Colors.white,
                      width: avatarDisplayBorder,
                    ),
                  ),
                ),
                child:
                    avatarDisplayWidget ??
                    Center(
                      child: MyText(
                        displayText,
                        textAlign: TextAlign.center,
                        style: _getTextStyle(context),
                      ),
                    ),
              ),
            ),
          );
        } else {
          list.add(
            Positioned(
              left: left,
              child: Container(
                width: _getAvatarWidth(),
                height: _getAvatarWidth(),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getAvatarWidth() - _getDisplayPadding(),
                    ),
                    side: BorderSide(
                      color: Colors.white,
                      width: avatarDisplayBorder,
                    ),
                  ),
                  image: DecorationImage(
                    image: AssetImage(avatarDisplayListAsset![i]),
                    fit: fit ?? BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return SizedBox(
      height: _getAvatarWidth(),
      width: _getAvatarWidth() * (length + 1) - length * _getDisplayPadding(),
      child: Stack(children: list),
    );
  }
}
