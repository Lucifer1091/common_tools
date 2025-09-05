library tabbar_gradient_indicator_plus;

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

enum GradientDirection {
  horizontal,
  vertical,
}

class TabBarGradientIndicator extends Decoration {
  const TabBarGradientIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.indicatorWidth = 2,
    this.gradientColor,
    this.gradientDirection = GradientDirection.horizontal,
    this.radius,
    this.fixedWidth,
  });

  final List<Color>? gradientColor;
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final double indicatorWidth;
  final GradientDirection gradientDirection;
  final double? radius;
  final double? fixedWidth;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is TabBarGradientIndicator) {
      return TabBarGradientIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t) ??
            const EdgeInsets.all(0),
      );
    }

    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is TabBarGradientIndicator) {
      return TabBarGradientIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t) ??
            const EdgeInsets.all(0),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(
      decoration: this,
      gradientColor: gradientColor,
      indicatorWidth: indicatorWidth,
      gradientDirection: gradientDirection,
      radius: radius,
      fixedWidth: fixedWidth,
      onChanged: onChanged,
    );
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter({
    required this.decoration,
    VoidCallback? onChanged,
    this.gradientColor,
    this.indicatorWidth = 2,
    required this.gradientDirection,
    required this.radius,
    this.fixedWidth,
  }) : super(onChanged);

  final double indicatorWidth;
  final TabBarGradientIndicator decoration;
  final GradientDirection gradientDirection;
  final double? radius;
  final double? fixedWidth;

  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;
  List<Color>? gradientColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Rect rect = offset &
        insets.deflateSize(
            (configuration.size ?? Size(indicatorWidth, indicatorWidth)));
    final double width = fixedWidth ?? rect.width;
    Rect myRect = Rect.fromLTWH(rect.left + (rect.width - width) / 2,
        rect.bottom - indicatorWidth * 0.5 - 1, width, indicatorWidth * 0.5);

    final horizontal = gradientDirection == GradientDirection.horizontal;
    final from = horizontal ? Offset(myRect.left, 0) : Offset(0, myRect.top);
    final to = horizontal ? Offset(myRect.right, 0) : Offset(0, myRect.bottom);

    final Paint paint = borderSide.toPaint()
      ..strokeWidth = indicatorWidth * 0.5
      ..strokeCap = StrokeCap.square
      ..shader = ui.Gradient.linear(from, to, gradientColor ?? []);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            myRect, Radius.circular(radius ?? (indicatorWidth * 0.25))),
        paint);
  }
}
