import 'package:flutter/material.dart';

// GradientBorder
class GradientBorder extends StatelessWidget {
  const GradientBorder({
    required this.gradient,
    required this.child,
    this.strokeWidth = 1,
    this.borderRadius,
    this.padding = 0,
    super.key,
  }) : assert(strokeWidth >= 0, 'strokeWidth must be non-negative'),
       assert(
         borderRadius == null || borderRadius >= 0,
         'borderRadius must be non-negative',
       ),
       assert(padding >= 0, 'padding must be non-negative');

  final Gradient gradient;
  final Widget child;
  final double strokeWidth;
  final double? borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final resolvedRadius = borderRadius ?? 8;

    if (strokeWidth <= 0) {
      return Padding(padding: EdgeInsets.all(padding), child: child);
    }

    return CustomPaint(
      isComplex: true,
      painter: _GradientBorderPainter(
        gradient: gradient,
        strokeWidth: strokeWidth,
        borderRadius: resolvedRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding + strokeWidth),
        child: child,
      ),
    );
  }
}

/// GradientPainter
class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter({
    required this.gradient,
    required this.strokeWidth,
    required this.borderRadius,
  }) : _paint = Paint()..isAntiAlias = true;

  final Gradient gradient;
  final double strokeWidth;
  final double borderRadius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || strokeWidth <= 0) return;

    final outerRect = Offset.zero & size;
    final inset = strokeWidth.clamp(0.0, size.shortestSide / 2);
    final innerRect = outerRect.deflate(inset);
    final outerRoundedRect = RRect.fromRectAndRadius(
      outerRect,
      Radius.circular(borderRadius),
    );

    _paint.shader = gradient.createShader(outerRect);

    if (innerRect.isEmpty) {
      canvas.drawRRect(outerRoundedRect, _paint);
      return;
    }

    final innerRadius = (borderRadius - inset).clamp(0.0, double.infinity);
    final innerRoundedRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(innerRadius),
    );

    canvas.drawDRRect(outerRoundedRect, innerRoundedRect, _paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
