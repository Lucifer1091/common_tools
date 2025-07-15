import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../text/td_text.dart';

enum TDBadgeType { redPoint, message, bubble, square, subscript }

enum TDBadgeBorder { large, small }

enum TDBadgeSize { large, small }

class TDBadge extends StatefulWidget {
  const TDBadge(
    this.type, {
    super.key,
    this.count,
    this.maxCount = '99',
    this.border = TDBadgeBorder.large,
    this.size = TDBadgeSize.small,
    this.color,
    this.textColor,
    this.message,
    this.widthLarge = 32,
    this.widthSmall = 12,
    this.padding,
    this.showZero = true,
  });

  final String? count;

  final String? maxCount;

  final TDBadgeType type;

  final TDBadgeSize size;

  final TDBadgeBorder border;

  final Color? color;

  final Color? textColor;

  final String? message;

  final double widthLarge;

  final double widthSmall;

  final EdgeInsetsGeometry? padding;

  final bool showZero;

  @override
  State<StatefulWidget> createState() => _TDBadgeState();
}

class _TDBadgeState extends State<TDBadge> {
  String badgeNum = '';

  void updateBadgeNum(String? newCount) {
    if (newCount == null) return;

    setState(() {
      // If newCount exceeds maxCount, display '${maxCount}+'
      final countValue = int.tryParse(newCount) ?? 0;
      final maxCountValue = int.tryParse(widget.maxCount ?? '') ?? 0;
      if (maxCountValue > 0 && countValue > maxCountValue) {
        badgeNum = '$maxCountValue+';
      } else {
        badgeNum = newCount;
      }
    });
  }

  double getBadgeSize() {
    switch (widget.size) {
      case TDBadgeSize.large:
        return 20;
      case TDBadgeSize.small:
        return 16;
    }
  }

  Font? getBadgeFont(BuildContext context) {
    switch (widget.size) {
      case TDBadgeSize.large:
        return TDTheme.of(context).fontMarkSmall;
      case TDBadgeSize.small:
        return TDTheme.of(context).fontMarkExtraSmall;
    }
  }

  bool isVisible() {
    final value = getValue();
    try {
      return widget.showZero || double.parse(value) != 0;
    } catch (e) {
      return true;
    }
  }

  String getValue() {
    return ((widget.message ?? '').isNotEmpty
            ? widget.message
            : (widget.count ?? '').isNotEmpty
            ? widget.count
            : '0')
        as String;
  }

  @override
  Widget build(BuildContext context) {
    updateBadgeNum(widget.count);

    switch (widget.type) {
      case TDBadgeType.redPoint:
        return Container(
          alignment: Alignment.center,
          height: getBadgeSize() / 2,
          width: getBadgeSize() / 2,
          decoration: BoxDecoration(
            color: widget.color ?? TDTheme.of(context).errorColor6,
            borderRadius: BorderRadius.circular(getBadgeSize() / 4),
          ),
        );
      case TDBadgeType.message:
        return Visibility(
          visible: isVisible(),
          child:
              badgeNum.length == 1
                  ? Container(
                    height: getBadgeSize(),
                    width: getBadgeSize(),
                    decoration: BoxDecoration(
                      color: widget.color ?? TDTheme.of(context).errorColor6,
                      borderRadius: BorderRadius.circular(getBadgeSize() / 2),
                    ),
                    child: Center(
                      child: TDText(
                        widget.message ?? badgeNum,
                        forceVerticalCenter: true,
                        font: getBadgeFont(context),
                        fontWeight: FontWeight.w500,
                        textColor:
                            widget.textColor ?? TDTheme.of(context).whiteColor1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  : Container(
                    height: getBadgeSize(),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: widget.color ?? TDTheme.of(context).errorColor6,
                      borderRadius: BorderRadius.circular(getBadgeSize() / 2),
                    ),
                    child: Center(
                      child: TDText(
                        widget.message ?? badgeNum,
                        forceVerticalCenter: true,
                        font: getBadgeFont(context),
                        fontWeight: FontWeight.w500,
                        textColor:
                            widget.textColor ?? TDTheme.of(context).whiteColor1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
        );
      case TDBadgeType.subscript:
        return ClipPath(
          clipper: TrapezoidPath(widget.widthLarge, widget.widthSmall),
          child: Container(
            alignment: Alignment.topRight,
            color: widget.color ?? TDTheme.of(context).errorColor6,
            height: 32,
            width: 32,
            child: Transform.rotate(
              angle: pi / 4,
              child: Padding(
                padding:
                    widget.padding ?? const EdgeInsets.only(left: 4, bottom: 8),
                child: TDText(
                  widget.message ?? badgeNum,
                  font: getBadgeFont(context),
                  fontWeight: FontWeight.w500,
                  textColor:
                      widget.textColor ?? TDTheme.of(context).whiteColor1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      case TDBadgeType.bubble:
        return Visibility(
          visible: isVisible(),
          child: Container(
            height: 16,
            padding: const EdgeInsets.only(left: 4, right: 4),
            decoration: BoxDecoration(
              color: widget.color ?? TDTheme.of(context).errorColor6,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(1),
              ),
            ),
            child: Center(
              child: TDText(
                widget.message ?? badgeNum,
                forceVerticalCenter: true,
                font: getBadgeFont(context),
                fontWeight: FontWeight.w500,
                textColor: widget.textColor ?? TDTheme.of(context).whiteColor1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      case TDBadgeType.square:
        return Visibility(
          visible: isVisible(),
          child: IntrinsicWidth(
            child: Container(
              height: getBadgeSize(),
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: widget.color ?? TDTheme.of(context).errorColor6,
                borderRadius:
                    widget.border == TDBadgeBorder.large
                        ? BorderRadius.circular(8)
                        : BorderRadius.circular(2),
              ),
              child: Center(
                child: TDText(
                  widget.message ?? badgeNum,
                  forceVerticalCenter: true,
                  font: getBadgeFont(context),
                  fontWeight: FontWeight.w500,
                  textColor:
                      widget.textColor ?? TDTheme.of(context).whiteColor1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
    }
  }
}

class TrapezoidPath extends CustomClipper<Path> {
  TrapezoidPath(this.widthLarge, this.widthSmall);

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
