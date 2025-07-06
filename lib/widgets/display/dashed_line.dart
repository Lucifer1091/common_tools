import 'package:flutter/material.dart';

/// Creates a dashed horizontal line widget.
class DashedLine extends StatefulWidget {
  const DashedLine({
    super.key,
    this.width,
    this.height,
    this.dashWidth = 9,
    this.dashSpace = 5,
    this.strokeWidth = 1,
    this.color = Colors.grey,
  });

  // Width of the line
  final double? width;

  // Height of the line
  final double? height;

  // Width of the each dash line.
  final double dashWidth;

  // Space between each dash line.
  final double dashSpace;

  // Color of dash line.
  final Color color;

  // Stroke width for each dash line.
  final double strokeWidth;

  @override
  State<DashedLine> createState() => _DashedLineState();
}

class _DashedLineState extends State<DashedLine> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size(widget.width ?? double.infinity, widget.height ?? 2),
          painter: _DashedLinePainter(
            dashWidth: widget.dashWidth,
            dashSpace: widget.dashSpace,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    this.dashWidth = 9,
    this.dashSpace = 5,
    this.strokeWidth = 1,
    this.color = Colors.grey,
  }) : painter =
           Paint()
             ..color = color
             ..strokeWidth = strokeWidth;
             
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double strokeWidth;
  double startX = 0;
  final Paint painter;

  @override
  void paint(Canvas canvas, Size size) {
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        painter,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    final bool shouldRepaint =
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
    return shouldRepaint;
  }
}

/// Creates a dashed vertical line widget.
class VerticalDashedLine extends StatefulWidget {
  const VerticalDashedLine({
    super.key,
    this.width,
    this.height,
    this.dashHeight = 9,
    this.dashSpace = 5,
    this.strokeWidth = 1,
    this.color = Colors.grey,
  });

  // Width of the line
  final double? width;

  // Height of the line
  final double? height;

  // Width of the each dash line.
  final double dashHeight;

  // Space between each dash line.
  final double dashSpace;

  // Color of dash line.
  final Color color;

  // Stroke width for each dash line.
  final double strokeWidth;

  @override
  State<VerticalDashedLine> createState() => _VerticalDashedLineState();
}

class _VerticalDashedLineState extends State<VerticalDashedLine> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size(widget.width ?? 2, widget.height ?? double.infinity),
          painter: _DashedVerticalLinePainter(
            dashHeight: widget.dashHeight,
            dashSpace: widget.dashSpace,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _DashedVerticalLinePainter extends CustomPainter {
  _DashedVerticalLinePainter({
    this.dashHeight = 8,
    this.dashSpace = 4,
    this.strokeWidth = 1,
    this.color = Colors.grey,
  }) : painter =
           Paint()
             ..color = color
             ..strokeWidth = strokeWidth;

  final double dashHeight;
  final double dashSpace;
  final Color color;
  final double strokeWidth;
  double startY = 0;
  final Paint painter;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedVerticalLinePainter oldDelegate) {
    final bool shouldRepaint =
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashHeight != dashHeight ||
        oldDelegate.dashSpace != dashSpace;
    return shouldRepaint;
  }
}
