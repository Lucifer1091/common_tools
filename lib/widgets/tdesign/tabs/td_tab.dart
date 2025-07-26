import 'package:flutter/material.dart';

import '../../../extensions/index.dart';
import '../badge/td_badge.dart';

const double _kTabHeight = 48;

const double _kTextAndIconTabHeight = 72;

enum TDTabSize { large, small }

enum TDTabOutlineType { filled, capsule, card }

class TDTab extends Tab {
  @override
  const TDTab({
    super.key,
    super.text,
    super.child,
    super.icon,
    this.badge,
    super.height,
    this.contentHeight,
    this.textMargin,
    this.size = TDTabSize.small,
    this.outlineType = TDTabOutlineType.filled,
    this.enable = true,
    super.iconMargin = const EdgeInsets.only(bottom: 4, right: 4),
  });

  final TDBadge? badge;

  final double? contentHeight;

  final EdgeInsetsGeometry? textMargin;

  final bool enable;

  final TDTabSize size;

  final TDTabOutlineType outlineType;

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
          icon ?? Container(),
          SizedBox(width: iconMargin?.horizontal, height: iconMargin?.vertical),
          _buildLabelText(context),
        ],
      );
    }

    if (badge != null) {
      label = Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(margin: textMargin, child: label),
          Positioned(right: 0, top: 0, child: badge!),
        ],
      );
    }

    final isCapsuleOutlineType = outlineType == TDTabOutlineType.capsule;

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
      return DefaultTextStyle(
        style: DefaultTextStyle.of(
          context,
        ).style.copyWith(fontSize: context.bodySmall?.fontSize ?? 14),
        child: child!,
      );
    }
    return Text(
      text!,
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
    if (size == TDTabSize.large) {
      return 16;
    } else {
      return 14;
    }
  }
}
