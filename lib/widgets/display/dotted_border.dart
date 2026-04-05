import 'dart:ui';

import 'package:flutter/material.dart';

import '../../index.dart';

class MyDottedBorder extends StatefulWidget {
  const MyDottedBorder({
    required this.child,
    this.color,
    this.dotsWidth = 5.0,
    this.gap = 3.0,
    this.radius = 0,
    this.strokeWidth = 1.0,
    this.padding,
    super.key,
  });

  final Color? color;
  final double strokeWidth;
  final double dotsWidth;
  final double gap;
  final double radius;
  final Widget child;
  final EdgeInsets? padding;

  @override
  _MyDottedBorderState createState() => _MyDottedBorderState();
}

class _MyDottedBorderState extends State<MyDottedBorder> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedCustomPaint(
        color: widget.color ?? context.colorScheme.primary,
        dottedLength: widget.dotsWidth,
        space: widget.gap,
        strokeWidth: widget.strokeWidth,
        radius: widget.radius,
      ),
      child: Container(
        padding: widget.padding ?? EdgeInsets.all(2),
        child: widget.child,
      ),
    );
  }
}

class _DottedCustomPaint extends CustomPainter {
  _DottedCustomPaint({
    this.color,
    this.dottedLength,
    this.space,
    this.strokeWidth,
    this.radius,
  });

  Color? color;
  double? dottedLength;
  double? space;
  double? strokeWidth;
  double? radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..isAntiAlias = true
          ..filterQuality = FilterQuality.high
          ..color = color!
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth!;

    final Path path =
        Path()..addRRect(
          RRect.fromLTRBR(
            0,
            0,
            size.width,
            size.height,
            Radius.circular(radius!),
          ),
        );

    final Path draw = buildDashPath(path, dottedLength!, space!);
    canvas.drawPath(draw, paint);
  }

  Path buildDashPath(Path path, double dottedLength, double space) {
    final Path r = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double start = 0;
      while (start < metric.length) {
        final double end = start + dottedLength;
        r.addPath(metric.extractPath(start, end), Offset.zero);
        start = end + space;
      }
    }
    return r;
  }

  @override
  bool shouldRepaint(_DottedCustomPaint oldDelegate) => true;
}
