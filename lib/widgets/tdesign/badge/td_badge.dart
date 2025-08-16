import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../index.dart';
import '../text/td_text.dart';

enum TDBadgeType { redPoint, message, bubble, square, subscript }

enum TDBadgeBorder { large, small }

enum TDBadgeSize { large, small }

class TDBadge extends StatelessWidget {
  const TDBadge(
    this.type, {
    super.key,
    this.count,
    this.maxCount = 99,
    this.message,
    this.border = TDBadgeBorder.large,
    this.size = TDBadgeSize.small,
    this.color,
    this.textColor,
    this.style,
    this.widthLarge = 32,
    this.widthSmall = 12,
    this.padding,
    this.showZero = true,
  });

  final num? count;

  final num? maxCount;

  final String? message;

  final TDBadgeType type;

  final TDBadgeSize size;

  final TDBadgeBorder border;

  final Color? color;

  final Color? textColor;

  final TextStyle? style;

  final double widthLarge;

  final double widthSmall;

  final EdgeInsetsGeometry? padding;

  final bool showZero;

  Color get background => color ?? ThemeColors.error.shade500;

  double _getBadgeSize() {
    return switch (size) {
      TDBadgeSize.large => 20,
      TDBadgeSize.small => 16,
    };
  }

  TextStyle? _getBadgeStyle(BuildContext context) {
    return switch (size) {
      TDBadgeSize.large => context.labelMedium,
      TDBadgeSize.small => context.labelSmall,
    }?.copyWith(color: textColor, fontWeight: FontWeight.w500);
  }

  bool _isVisible() {
    final value = _getValue();
    try {
      return showZero || double.parse(value) != 0;
    } catch (e) {
      return true;
    }
  }

  String _getValue() {
    if (message.isNotBlank) return message!;

    // If count exceeds maxCount, display '${maxCount}+ such as 99+'
    if (maxCount.getOr() > 0 && count.getOr() > maxCount.getOr()) {
      return '$maxCount+';
    } else {
      return '$count';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Center child = Center(
      child: TDText(
        _getValue(),
        style: _getBadgeStyle(context),
        textAlign: TextAlign.center,
      ),
    );

    switch (type) {
      case TDBadgeType.redPoint:
        return Container(
          alignment: Alignment.center,
          height: _getBadgeSize() / 2,
          width: _getBadgeSize() / 2,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(_getBadgeSize() / 4),
          ),
        );
      case TDBadgeType.message:
        return Visibility(
          visible: _isVisible(),
          child:
              _getValue().length == 1
                  ? Container(
                    height: _getBadgeSize(),
                    width: _getBadgeSize(),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(_getBadgeSize() / 2),
                    ),
                    child: child,
                  )
                  : Container(
                    height: _getBadgeSize(),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(_getBadgeSize() / 2),
                    ),
                    child: child,
                  ),
        );
      case TDBadgeType.subscript:
        return ClipPath(
          clipper: _TrapezoidPath(widthLarge, widthSmall),
          child: Container(
            alignment: Alignment.topRight,
            color: background,
            height: 32,
            width: 32,
            child: Transform.rotate(
              angle: pi / 4,
              child: Padding(
                padding: padding ?? const EdgeInsets.only(left: 4, bottom: 8),
                child: child,
              ),
            ),
          ),
        );
      case TDBadgeType.bubble:
        return Visibility(
          visible: _isVisible(),
          child: Container(
            height: 16,
            padding: const EdgeInsets.only(left: 4, right: 4),
            decoration: BoxDecoration(
              color: background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(1),
              ),
            ),
            child: child,
          ),
        );
      case TDBadgeType.square:
        return Visibility(
          visible: _isVisible(),
          child: IntrinsicWidth(
            child: Container(
              height: _getBadgeSize(),
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: background,
                borderRadius:
                    border == TDBadgeBorder.large
                        ? BorderRadius.circular(8)
                        : BorderRadius.circular(2),
              ),
              child: child,
            ),
          ),
        );
    }
  }
}

class _TrapezoidPath extends CustomClipper<Path> {
  _TrapezoidPath(this.widthLarge, this.widthSmall);

  final double widthLarge;
  final double widthSmall;

  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(widthLarge - widthSmall, 0)
          ..lineTo(widthLarge, widthSmall)
          ..lineTo(widthLarge, widthLarge)
          ..lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
