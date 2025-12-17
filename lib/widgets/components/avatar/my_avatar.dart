import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

enum MyAvatarSize { large, medium, small }

enum MyAvatarType { icon, normal, initials, display, operation }

enum MyAvatarShape { circle, square }

class MyAvatar extends StatelessWidget {
  const MyAvatar({
    super.key,
    this.size = MyAvatarSize.medium,
    this.type = MyAvatarType.normal,
    this.shape = MyAvatarShape.circle,
    this.initials,
    this.textColor,
    this.style,
    this.radius,
    this.icon,
    this.avatar,
    this.placeholder,
    this.avatars,
    this.avatarSize,
    this.infoText,
    this.onTap,
    this.infoWidget,
    this.infoBorder = 2,
    this.backgroundColor,
    this.fit,
  });

  final Object? avatar, placeholder;
  final MyAvatarSize size;
  final MyAvatarType type;
  final MyAvatarShape shape;
  final String? initials;
  final Color? textColor;
  final TextStyle? style;
  final double? radius;
  final double? avatarSize;
  final IconData? icon;
  final List<Object>? avatars;
  final double infoBorder;
  final Widget? infoWidget;
  final String? infoText;
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

  TextStyle? _getTextStyle(BuildContext context, {Color? color}) {
    return style ??
        switch (size) {
          MyAvatarSize.large => context.titleLarge,
          MyAvatarSize.medium => context.titleMedium,
          MyAvatarSize.small => context.titleSmall,
        }.copyWith(
          color: color ?? textColor ?? context.colorScheme.primaryForeground,
        );
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

  static const Map<MyAvatarShape, MyImageType> _imageTypeMap = {
    MyAvatarShape.square: MyImageType.squircle,
    MyAvatarShape.circle: MyImageType.circle,
  };

  @override
  Widget build(BuildContext context) {
    final bgColor = context.colorScheme.primary.withValues(alpha: 0.15);
    switch (type) {
      case MyAvatarType.icon:
        return MyGestureDetector(
          onTap: onTap,
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color: backgroundColor ?? bgColor,
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
        return MyGestureDetector(
          onTap: onTap,
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color: backgroundColor ?? bgColor,
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: MyImage(
              source: avatar ?? placeholder,
              type: _imageTypeMap[shape] ?? MyImageType.squircle,
            ),
          ),
        );
      case MyAvatarType.initials:
        return MyGestureDetector(
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
                initials,
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
    final bgColor = context.colorScheme.primary.withValues(alpha: 0.15);

    final list = <Widget>[];

    if (avatars.isBlank) return const NoWidget();

    var length = 0;

    if (avatars != null) {
      length = avatars!.length;
      for (var i = 0; i < avatars!.length + 1; i++) {
        final left = (_getAvatarWidth() - _getDisplayPadding()) * i;
        if (i == avatars!.length) {
          list.add(
            Positioned(
              left: left,
              child: MyGestureDetector(
                onTap: onTap,
                child: Container(
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        _getAvatarWidth() - _getDisplayPadding(),
                      ),
                      side: BorderSide(
                        color: context.colorScheme.background,
                        width: infoBorder,
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
                      color: context.colorScheme.background,
                      width: infoBorder,
                    ),
                  ),
                ),
                child: MyImage(
                  source: avatars![i],
                  fit: fit ?? BoxFit.cover,
                  type: _imageTypeMap[shape] ?? MyImageType.squircle,
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
    final bgColor = context.colorScheme.primary.withValues(alpha: 0.15);

    final list = <Widget>[];

    if (avatars.isBlank) return const NoWidget();

    var length = 0;

    if (avatars != null) {
      length = avatars!.length;

      for (var i = avatars!.length; i >= 0; i--) {
        final left = (_getAvatarWidth() - _getDisplayPadding()) * i;

        if (i == avatars!.length) {
          list.add(
            Positioned(
              left: left,
              child: Container(
                width: _getAvatarWidth(),
                height: _getAvatarWidth(),
                clipBehavior: Clip.hardEdge,
                decoration: ShapeDecoration(
                  color: bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getAvatarWidth() - _getDisplayPadding(),
                    ),
                    side: BorderSide(
                      color: context.colorScheme.background,
                      width: infoBorder,
                    ),
                  ),
                ),
                child:
                    infoWidget ??
                    Center(
                      child: MyText(
                        infoText,
                        textAlign: TextAlign.center,
                        style: _getTextStyle(
                          context,
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
                      color: context.colorScheme.background,
                      width: infoBorder,
                    ),
                  ),
                ),
                child: MyImage(
                  source: avatars![i],
                  fit: fit ?? BoxFit.cover,
                  type: _imageTypeMap[shape] ?? MyImageType.squircle,
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
