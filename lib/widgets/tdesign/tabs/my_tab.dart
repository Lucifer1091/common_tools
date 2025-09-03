import 'package:flutter/material.dart';

import '../../../index.dart';

const double _kTabHeight = 48;

const double _kTextAndIconTabHeight = 72;

enum MyTabSize { large, small }

enum MyTabOutlineType { filled, capsule, card }

class MyTab extends Tab {
  @override
  const MyTab({
    super.key,
    super.text,
    super.icon,
    super.child,
    this.badge,
    super.height,
    this.textMargin,
    this.enable = true,
    this.size = MyTabSize.small,
    this.outlineType = MyTabOutlineType.filled,
    super.iconMargin = const EdgeInsets.only(bottom: 4, right: 4),
  });

  final bool enable;
  final MyBadgeConfig? badge;
  final EdgeInsetsGeometry? textMargin;
  final MyTabSize size;
  final MyTabOutlineType outlineType;

  @override
  Widget build(BuildContext context) {
    final double calculatedHeight;
    Widget label;

    if (icon == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText(context);
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon!;
    } else {
      calculatedHeight = _kTextAndIconTabHeight;
      label = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) icon!,
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
      label = Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Padding(padding: textMargin ?? EdgeInsets.zero, child: label),
          Positioned(
            top: badge!.top ?? 0,
            right: badge!.right ?? 0,
            child: badge!.badge,
          ),
        ],
      );
    }

    final isCapsuleOutlineType = outlineType == MyTabOutlineType.capsule;

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

    return MyText(
      text,
      softWrap: false,
      overflow: TextOverflow.fade,
      style: TextStyle(fontSize: _getFontSize(context)),
    );
  }

  double _getFontSize(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);

    if (defaultTextStyle.style.fontSize != null) {
      return defaultTextStyle.style.fontSize!;
    }

    if (size == MyTabSize.large) {
      return 16;
    } else {
      return 14;
    }
  }
}
