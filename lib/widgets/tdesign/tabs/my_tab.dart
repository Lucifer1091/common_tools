import 'package:flutter/material.dart';

import '../../../index.dart';

const double _kTabHeight = 48;

const double _kTextAndIconTabHeight = 72;

enum MyTabSize { large, small }

enum MyTabType { underline, capsule, card }

class MyTab extends Tab {
  @override
  const MyTab({
    super.key,
    super.text,
    super.icon,
    this.iconData,
    super.child,
    this.badge,
    super.height,
    this.textMargin,
    this.enable = true,
    this.size = MyTabSize.small,
    this.type = MyTabType.underline,
    super.iconMargin = const EdgeInsets.only(bottom: 4, right: 4),
  });

  final bool enable;
  final IconData? iconData;
  final MyBadgeConfig? badge;
  final EdgeInsetsGeometry? textMargin;
  final MyTabSize size;
  final MyTabType type;

  @override
  Widget build(BuildContext context) {
    final double calculatedHeight;
    Widget label;

    final Widget? icon0 = icon ?? (iconData != null ? Icon(iconData) : null);

    if (icon0 == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText(context);
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon0;
    } else {
      calculatedHeight = _kTextAndIconTabHeight;
      label = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon0,
          if (iconMargin != null)
            SizedBox(
              width: iconMargin?.horizontal,
              height: iconMargin?.vertical,
            ),
          _buildLabelText(context),
        ],
      );
    }

    if (badge != null && badge!.enabled) {
      label = MyBadgeWrapper(
        top: badge!.top ?? 0,
        right: badge!.right ?? 0,
        badge: badge!.badge,
        child: Padding(padding: textMargin ?? EdgeInsets.zero, child: label),
      );
    }

    final isCapsuleOutlineType = type == MyTabType.capsule;

    return IgnorePointer(
      ignoring: !enable,
      child: Container(
        alignment: Alignment.center,
        margin:
            isCapsuleOutlineType
                ? const EdgeInsets.symmetric(horizontal: 16)
                : null,
        height: height ?? calculatedHeight,
        child: Center(widthFactor: 1, child: label),
      ),
    );
  }

  Widget _buildLabelText(BuildContext context) {
    if (child != null) {
      return DefaultTextStyle.merge(style: context.titleSmall, child: child!);
    }

    return Text(
      text!,
      softWrap: false,
      overflow: TextOverflow.fade,
      style: context.bodyMedium.copyWith(fontSize: _getFontSize(context)),
    );
  }

  double _getFontSize(BuildContext context) {
    if (size == MyTabSize.large) {
      return 16;
    } else {
      return 14;
    }
  }
}
