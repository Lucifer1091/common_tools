import 'package:flutter/material.dart';

/// A widget that draws a gradient border around its child.
class GradientBorder extends StatelessWidget {
  const GradientBorder({
    required this.gradient,
    required this.child,
    super.key,
    this.strokeWidth = 1,
    this.borderRadius = 0,
  });

  final Gradient gradient;
  final Widget child;
  final double strokeWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      strokeWidth: strokeWidth,
      gradient: gradient,
      borderRadius: borderRadius,
      child: child,
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter({
    required this.gradient,
    this.strokeWidth = 1,
    this.borderRadius = 0,
  });

  final double strokeWidth;
  final Gradient gradient;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPath =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(borderRadius),
          ),
        );

    final paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height),
          )
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    canvas.drawPath(borderPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GradientBorderContainer extends StatelessWidget {
  const GradientBorderContainer({
    required this.child,
    required this.gradient,
    super.key,
    this.strokeWidth = 1,
    this.borderRadius = 0,
  });

  final Widget child;
  final double strokeWidth;
  final Gradient gradient;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        strokeWidth: strokeWidth,
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Container(child: child),
    );
  }
}
