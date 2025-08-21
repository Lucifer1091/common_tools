import 'package:flutter/material.dart';

/// A wavy divider that can be used to separate content.
class WavyDivider extends StatelessWidget {
  const WavyDivider({super.key, this.width, this.color});

  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: width,
      child: CustomPaint(
        painter: WavyLinePainter(width: width, color: color),
        child: Container(),
      ),
    );
  }
}

/// A custom painter that paints a wavy line.
class WavyLinePainter extends CustomPainter {
  const WavyLinePainter({this.width, this.color});
  final double? width;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color ?? Colors.grey.shade300
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final Path path = Path();
    final double waveWidth =
        size.width / (width != null ? (width! * 0.03) : 25);
    final double waveHeight = 6;

    path.moveTo(0, size.height / 2);
    for (double i = 0; i < size.width; i += waveWidth) {
      path
        ..relativeQuadraticBezierTo(
          waveWidth / 4,
          -waveHeight,
          waveWidth / 2,
          0,
        )
        ..relativeQuadraticBezierTo(
          waveWidth / 4,
          waveHeight,
          waveWidth / 2,
          0,
        );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
