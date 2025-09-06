import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MyGradientTabIndicator extends Decoration {
  const MyGradientTabIndicator({
    this.borderSide = const BorderSide(width: 2, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.indicatorWidth = 2,
    this.colors,
    this.direction = Axis.horizontal,
    this.radius,
    this.fixedWidth,
  });

  final List<Color>? colors;
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final double indicatorWidth;
  final Axis direction;
  final double? radius;
  final double? fixedWidth;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is MyGradientTabIndicator) {
      return MyGradientTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t) ?? EdgeInsets.zero,
      );
    }

    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is MyGradientTabIndicator) {
      return MyGradientTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t) ?? EdgeInsets.zero,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(
      decoration: this,
      colors: colors,
      indicatorWidth: indicatorWidth,
      direction: direction,
      radius: radius,
      fixedWidth: fixedWidth,
      onChanged: onChanged,
    );
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter({
    required this.decoration,
    required this.direction,
    required this.radius,
    VoidCallback? onChanged,
    this.colors,
    this.indicatorWidth = 2,
    this.fixedWidth,
  }) : super(onChanged);

  final double indicatorWidth;
  final MyGradientTabIndicator decoration;
  final Axis direction;
  final double? radius;
  final double? fixedWidth;

  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;
  List<Color>? colors;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, '');

    final Rect rect =
        offset &
        insets.deflateSize(
          configuration.size ?? Size(indicatorWidth, indicatorWidth),
        );
    final double width = fixedWidth ?? rect.width;
    final Rect myRect = Rect.fromLTWH(
      rect.left + (rect.width - width) / 2,
      rect.bottom - indicatorWidth * 0.5 - 1,
      width,
      indicatorWidth * 0.5,
    );

    final horizontal = direction == Axis.horizontal;
    final from = horizontal ? Offset(myRect.left, 0) : Offset(0, myRect.top);
    final to = horizontal ? Offset(myRect.right, 0) : Offset(0, myRect.bottom);

    final Paint paint =
        borderSide.toPaint()
          ..strokeWidth = indicatorWidth * 0.5
          ..strokeCap = StrokeCap.square
          ..shader = ui.Gradient.linear(from, to, colors ?? []);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        myRect,
        Radius.circular(radius ?? (indicatorWidth * 0.25)),
      ),
      paint,
    );
  }
}
