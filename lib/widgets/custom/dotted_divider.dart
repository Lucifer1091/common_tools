import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({
    super.key,
    this.vertical = false,
    this.dashWidth = 2.0,
    this.dividerColor = Colors.grey,
    this.backgroundColor = Colors.white,
  });

  final bool vertical;
  final double dashWidth;
  final Color dividerColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: vertical ? 2 : double.infinity,
      height: vertical ? double.infinity : 2,
      child: CustomPaint(
        painter: _DashedLinePainter(
          vertical: vertical,
          dashWidth: dashWidth,
          dividerColor: dividerColor,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.vertical,
    required this.dashWidth,
    this.dividerColor = Colors.grey,
  });
  final bool vertical;
  final double dashWidth;
  Color dividerColor;

  @override
  void paint(Canvas canvas, Size size) {
    double dashPx = dashWidth, gapPx = 3, pos = 0;
    final paint = Paint()..color = dividerColor;
    if (vertical) {
      while (pos < size.height) {
        canvas.drawLine(Offset(0, pos), Offset(0, pos + dashPx), paint);
        pos += dashPx + gapPx;
      }
    } else {
      while (pos < size.width) {
        canvas.drawLine(Offset(pos, 0), Offset(pos + dashPx, 0), paint);
        pos += dashPx + gapPx;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
