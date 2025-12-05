part of 'my_divider.dart';

/// A wavy divider that can be used to separate content horizontally or vertically.
class _WavyDivider extends StatelessWidget {
  const _WavyDivider({
    this.length,
    this.thickness = 2,
    this.color,
    this.direction = Axis.horizontal,
    this.waveLength = 20,
    this.waveHeight = 6,
  });

  /// Length of the divider (width for horizontal, height for vertical)
  final double? length;

  /// Thickness of the wavy line
  final double thickness;

  /// Color of the wavy line
  final Color? color;

  /// Direction of the divider
  final Axis direction;

  /// Wave length of the waves (higher value = wider waves)
  final double waveLength;

  /// Wave height of the waves (higher value = taller waves)
  final double waveHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          direction == Axis.horizontal
              ? length ?? MediaQuery.of(context).size.width
              : thickness,
      height:
          direction == Axis.horizontal
              ? thickness
              : length ?? MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: _WavyLinePainter(
          color: color,
          thickness: thickness,
          direction: direction,
          waveLength: waveLength,
          waveHeight: waveHeight,
        ),
      ),
    );
  }
}

/// A custom painter that paints a wavy line horizontally or vertically.
class _WavyLinePainter extends CustomPainter {
  const _WavyLinePainter({
    required this.direction,
    this.thickness,
    this.waveLength,
    this.waveHeight,
    this.color,
  });

  final double? thickness;
  final Color? color;
  final Axis direction;
  final double? waveLength;
  final double? waveHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color ?? Colors.grey.shade300
          ..strokeWidth = thickness ?? 2
          ..style = PaintingStyle.stroke;

    final Path path = Path();
    final double waveLength = this.waveLength ?? 20;
    final double waveHeight = 6;

    if (direction == Axis.horizontal) {
      path.moveTo(0, size.height / 2);
      for (double x = 0; x < size.width; x += waveLength) {
        path
          ..relativeQuadraticBezierTo(
            waveLength / 4,
            -waveHeight,
            waveLength / 2,
            0,
          )
          ..relativeQuadraticBezierTo(
            waveLength / 4,
            waveHeight,
            waveLength / 2,
            0,
          );
      }
    } else {
      path.moveTo(size.width / 2, 0);
      for (double y = 0; y < size.height; y += waveLength) {
        path
          ..relativeQuadraticBezierTo(
            -waveHeight,
            waveLength / 4,
            0,
            waveLength / 2,
          )
          ..relativeQuadraticBezierTo(
            waveHeight,
            waveLength / 4,
            0,
            waveLength / 2,
          );
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
