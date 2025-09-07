import 'package:flutter/material.dart';

import '../../../index.dart';

const double _kTabHeight = 48;

const double _kTextAndIconTabHeight = 72;

enum MyTabSize { large, small }

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
    this.enabled = true,
    this.size = MyTabSize.small,
    super.iconMargin = const EdgeInsets.only(bottom: 4, right: 8),
  });

  final bool enabled;
  final IconData? iconData;
  final MyBadgeConfig? badge;
  final EdgeInsetsGeometry? textMargin;
  final MyTabSize size;

  @override
  Widget build(BuildContext context) {
    final double calculatedHeight;
    Widget label;

    final Widget? icon0 =
        icon ?? (iconData != null ? Icon(iconData, size: _getIconSize) : null);

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

    return IgnorePointer(
      ignoring: !enabled,
      child: Container(
        alignment: Alignment.center,
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
      style: context.bodyMedium.copyWith(fontSize: _getFontSize),
    );
  }

  double get _getFontSize => switch (size) {
    MyTabSize.large => 16,
    MyTabSize.small => 14,
  };

  double get _getIconSize => switch (size) {
    MyTabSize.large => 22,
    MyTabSize.small => 20,
  };
}
