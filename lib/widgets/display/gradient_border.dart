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
  });

  final Gradient gradient;
  final Widget child;
  final double strokeWidth;
  final double? borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        gradient: gradient,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius ?? 8,
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
  });

  final Gradient gradient;
  final double strokeWidth;
  final double borderRadius;
  final Paint paintObject = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final Rect innerRect = Rect.fromLTRB(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final RRect innerRoundedRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(borderRadius),
    );

    final Rect outerRect = Offset.zero & size;
    final RRect outerRoundedRect = RRect.fromRectAndRadius(
      outerRect,
      Radius.circular(borderRadius),
    );

    paintObject.shader = gradient.createShader(outerRect);
    final Path borderPath = _calculateBorderPath(
      outerRoundedRect,
      innerRoundedRect,
    );
    canvas.drawPath(borderPath, paintObject);
  }

  Path _calculateBorderPath(RRect outerRRect, RRect innerRRect) {
    final Path outerRectPath = Path()..addRRect(outerRRect);
    final Path innerRectPath = Path()..addRRect(innerRRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
