import 'package:flutter/material.dart';

import '../../../../index.dart';

enum MyTabIndicatorPosition { center, top, bottom }

// enum MyTabIndicatorSize { tiny, normal, full }

enum MyTabIndicatorType { none, dot, line, material, capsule }

class MyTabIndicator extends Decoration {
  const MyTabIndicator({
    required this.context,
    required this.type,
    this.color,
    this.gradient,
    this.radius = 3,
    this.strokeWidth = 2,
    this.paintingStyle = PaintingStyle.fill,
    this.insets = EdgeInsets.zero,
    this.position = MyTabIndicatorPosition.bottom,
  });

  final BuildContext context;
  final MyTabIndicatorType type;
  final Color? color;
  final List<Color>? gradient;

  /// Radius of the dot
  final double radius;

  /// Stroke width (used if [paintingStyle] is [PaintingStyle.stroke])
  final double strokeWidth;

  /// Fill or stroke style
  final PaintingStyle paintingStyle;

  /// Insets for positioning the dot
  final EdgeInsetsGeometry insets;

  /// Dot position: center, top, or bottom
  final MyTabIndicatorPosition position;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => switch (type) {
    MyTabIndicatorType.dot => _DotIndicatorPainter(this, onChanged),
    MyTabIndicatorType.none => _NoIndicatorPainter(),
    _ => _NoIndicatorPainter(),
  };
}

class _NoIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}

class _DotIndicatorPainter extends BoxPainter {
  _DotIndicatorPainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  final MyTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, '');

    final Rect rect = offset & configuration.size!;
    final TextDirection? textDirection = configuration.textDirection;
    final Rect indicator = decoration.insets
        .resolve(textDirection)
        .deflateRect(rect);

    final double x = indicator.left + indicator.width / 2;
    double y;

    switch (decoration.position) {
      case MyTabIndicatorPosition.top:
        y = indicator.top;
      case MyTabIndicatorPosition.bottom:
        y = indicator.bottom;
      case MyTabIndicatorPosition.center:
        y = indicator.top + indicator.height / 2;
    }

    final Paint paint =
        Paint()
          ..color = decoration.color ?? decoration.context.colorScheme.primary
          ..style = decoration.paintingStyle
          ..strokeWidth = decoration.strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(x, y), decoration.radius, paint);
  }
}
