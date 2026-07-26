import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../extensions/context/theme.dart';

class MyDottedBorder extends StatelessWidget {
  const MyDottedBorder({
    required this.child,
    this.color,
    this.dotsWidth = 5.0,
    this.gap = 3.0,
    this.radius = 0,
    this.strokeWidth = 1.0,
    this.padding,
    super.key,
  }) : assert(dotsWidth > 0, 'dotsWidth must be greater than zero'),
       assert(gap >= 0, 'gap must be non-negative'),
       assert(radius >= 0, 'radius must be non-negative'),
       assert(strokeWidth >= 0, 'strokeWidth must be non-negative');

  final Color? color;
  final double strokeWidth;
  final double dotsWidth;
  final double gap;
  final double radius;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.colorScheme.primary;
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(2),
      child: RepaintBoundary(child: child),
    );

    if (strokeWidth <= 0) return content;

    return CustomPaint(
      isComplex: true,
      painter: _DottedCustomPaint(
        color: resolvedColor,
        dottedLength: dotsWidth,
        space: gap,
        strokeWidth: strokeWidth,
        radius: radius,
      ),
      child: content,
    );
  }
}

class _DottedCustomPaint extends CustomPainter {
  _DottedCustomPaint({
    required this.color,
    required this.dottedLength,
    required this.space,
    required this.strokeWidth,
    required this.radius,
  }) : _paint = Paint()
         ..isAntiAlias = true
         ..style = PaintingStyle.stroke;

  final Color color;
  final double dottedLength;
  final double space;
  final double strokeWidth;
  final double radius;
  final Paint _paint;
  Size? _cachedSize;
  Path? _cachedDashedPath;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || strokeWidth <= 0) return;

    _paint
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawPath(_dashPathFor(size), _paint);
  }

  Path _dashPathFor(Size size) {
    if (_cachedSize == size && _cachedDashedPath != null) {
      return _cachedDashedPath!;
    }

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    final dashedPath = Path();
    for (final ui.PathMetric metric in path.computeMetrics()) {
      double start = 0;
      while (start < metric.length) {
        final end = math.min(start + dottedLength, metric.length);
        dashedPath.addPath(metric.extractPath(start, end), Offset.zero);
        start = end + space;
      }
    }

    _cachedSize = size;
    _cachedDashedPath = dashedPath;
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant _DottedCustomPaint oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dottedLength != dottedLength ||
        oldDelegate.space != space ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
