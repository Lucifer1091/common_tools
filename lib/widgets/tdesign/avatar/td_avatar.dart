import 'package:flutter/material.dart';

import '../../../index.dart';
import '../../../extensions/iterable/index.dart';
import '../../custom/index.dart';
import '../text/td_text.dart';

enum TDAvatarSize { large, medium, small }

enum TDAvatarType { icon, normal, customText, display, operation }

enum TDAvatarShape { circle, square }

class TDAvatar extends StatelessWidget {
  const TDAvatar({
    super.key,
    this.size = TDAvatarSize.medium,
    this.type = TDAvatarType.normal,
    this.shape = TDAvatarShape.circle,
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

  final TDAvatarSize size;

  final TDAvatarType type;

  final TDAvatarShape shape;

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
          TDAvatarSize.large => 64,
          TDAvatarSize.medium => 48,
          TDAvatarSize.small => 40,
        };
  }

  TextStyle? _getTextStyle(BuildContext context) {
    return style ??
        switch (size) {
          TDAvatarSize.large => context.titleLarge,
          TDAvatarSize.medium => context.titleMedium,
          TDAvatarSize.small => context.titleSmall,
        }?.copyWith(color: textColor);
  }

  double _getIconWidth() {
    return switch (size) {
      TDAvatarSize.large => 32,
      TDAvatarSize.medium => 24,
      TDAvatarSize.small => 20,
    };
  }

  double _getAvatarRadius(BuildContext context) {
    return radius ??
        switch (shape) {
          TDAvatarShape.circle => _getAvatarWidth() / 2,
          TDAvatarShape.square => 8,
        };
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TDAvatarType.icon:
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color: backgroundColor ?? context.colorScheme.background,
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: Center(
              child: Icon(
                icon ?? Icons.person_outline_rounded,
                size: _getIconWidth(),
                color: context.colorScheme.primary,
              ),
            ),
          ),
        );
      case TDAvatarType.normal:
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color: backgroundColor ?? context.colorScheme.background,
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
      case TDAvatarType.customText:
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
              child: TDText(
                text,
                textAlign: TextAlign.center,
                style: _getTextStyle(context),
              ),
            ),
          ),
        );
      case TDAvatarType.display:
        return _buildDisplayAvatar(context);
      case TDAvatarType.operation:
        return _buildOperationAvatar(context);
    }
  }

  double _getDisplayPadding() {
    return switch (size) {
      TDAvatarSize.large => 10,
      TDAvatarSize.medium => 8,
      TDAvatarSize.small => 6,
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
                    color: context.colorScheme.background,
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
                      icon ?? Icons.person_add_alt,
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
                    color: context.colorScheme.background,
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
                          icon ?? Icons.person_add_alt,
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
                  color: context.colorScheme.background,
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
                      child: TDText(
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
                  color: context.colorScheme.background,
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
                      child: TDText(
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
