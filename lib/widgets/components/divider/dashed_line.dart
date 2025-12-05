part of 'my_divider.dart';

/// Creates a dashed line widget that supports both horizontal and vertical directions.
class _DashedLine extends StatelessWidget {
  const _DashedLine({
    this.width,
    this.height,
    this.dashLength = 9,
    this.dashSpace = 5,
    this.thickness = 2,
    this.color = Colors.grey,
    this.direction = Axis.horizontal,
  });

  /// Width of the line (for horizontal) or thickness (for vertical)
  final double? width;

  /// Height of the line (for vertical) or thickness (for horizontal)
  final double? height;

  /// Length of each dash (width for horizontal, height for vertical)
  final double dashLength;

  /// Space between each dash
  final double dashSpace;

  /// Color of dash line
  final Color color;

  /// Stroke width for each dash line
  final double thickness;

  /// Direction of the dashed line
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.horizontal ? width : thickness,
      height: direction == Axis.horizontal ? thickness : height,
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size(
            direction == Axis.horizontal
                ? (width ?? double.infinity)
                : thickness,
            direction == Axis.horizontal
                ? thickness
                : (height ?? double.infinity),
          ),
          painter: _DashedLinePainter(
            dashLength: dashLength,
            dashSpace: dashSpace,
            color: color,
            strokeWidth: thickness,
            direction: direction,
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.dashLength,
    required this.dashSpace,
    required this.strokeWidth,
    required this.color,
    required this.direction,
  }) : painter =
           Paint()
             ..color = color
             ..strokeWidth = strokeWidth;

  final double dashLength;
  final double dashSpace;
  final Color color;
  final double strokeWidth;
  final Axis direction;
  final Paint painter;

  @override
  void paint(Canvas canvas, Size size) {
    if (direction == Axis.horizontal) {
      double startX = 0;
      final centerY = size.height / 2;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, centerY),
          Offset(startX + dashLength, centerY),
          painter,
        );
        startX += dashLength + dashSpace;
      }
    } else {
      double startY = 0;
      final centerX = size.width / 2;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(centerX, startY),
          Offset(centerX, startY + dashLength),
          painter,
        );
        startY += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.direction != direction;
  }
}
