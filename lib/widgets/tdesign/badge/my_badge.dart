import 'dart:math';

import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyBadgeType { redPoint, message, bubble, square, subscript }

enum MyBadgeBorder { large, small }

enum MyBadgeSize { large, small }

class MyBadge extends StatelessWidget {
  const MyBadge(
    this.type, {
    super.key,
    this.count,
    this.maxCount = 99,
    this.message,
    this.border = MyBadgeBorder.large,
    this.size = MyBadgeSize.small,
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

  final MyBadgeType type;

  final MyBadgeSize size;

  final MyBadgeBorder border;

  final Color? color;

  final Color? textColor;

  final TextStyle? style;

  final double widthLarge;

  final double widthSmall;

  final EdgeInsetsGeometry? padding;

  final bool showZero;

  double _getBadgeSize() {
    return switch (size) {
      MyBadgeSize.large => 20,
      MyBadgeSize.small => 16,
    };
  }

  TextStyle? _getBadgeStyle(BuildContext context) {
    final foreground = textColor ?? context.colorScheme.destructiveForeground;

    return switch (size) {
      MyBadgeSize.large => context.labelMedium,
      MyBadgeSize.small => context.labelSmall,
    }.copyWith(color: foreground, fontWeight: FontWeight.w500);
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
    final background = color ?? context.colorScheme.destructive;

    final Center child = Center(
      child: MyText(
        _getValue(),
        style: _getBadgeStyle(context),
        textAlign: TextAlign.center,
      ),
    );

    switch (type) {
      case MyBadgeType.redPoint:
        return Container(
          alignment: Alignment.center,
          height: _getBadgeSize() / 2,
          width: _getBadgeSize() / 2,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(_getBadgeSize() / 4),
          ),
        );
      case MyBadgeType.message:
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
      case MyBadgeType.subscript:
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
                padding: padding ?? const EdgeInsets.only(left: 4, bottom: 12),
                child: child,
              ),
            ),
          ),
        );
      case MyBadgeType.bubble:
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
      case MyBadgeType.square:
        return Visibility(
          visible: _isVisible(),
          child: IntrinsicWidth(
            child: Container(
              height: _getBadgeSize(),
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: background,
                borderRadius:
                    border == MyBadgeBorder.large
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

class MyBadgeWrapper extends StatelessWidget {
  const MyBadgeWrapper({
    required this.child,
    this.badge,
    super.key,
    this.top,
    this.right,
    this.left,
    this.bottom,
    this.height,
    this.width,
  });

  final Widget child;
  final MyBadge? badge;
  final double? top, right, left, bottom, height, width;

  @override
  Widget build(BuildContext context) {
    if (badge == null) return child;

    final stack = Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: top,
          right: right,
          left: left,
          bottom: bottom,
          child: badge!,
        ),
      ],
    );

    if (height != null || width != null) {
      return SizedBox(height: height, width: width, child: stack);
    }

    return stack;
  }
}

class MyBadgeConfig {
  const MyBadgeConfig({
    this.enabled = true,
    this.top,
    this.right,
    MyBadge? badge,
  }) : badge = badge ?? const MyBadge(MyBadgeType.redPoint);

  final bool enabled;
  final double? top;
  final double? right;
  final MyBadge badge;
}
