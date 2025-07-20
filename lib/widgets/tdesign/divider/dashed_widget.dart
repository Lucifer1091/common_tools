import 'dart:math';

import 'package:flutter/material.dart';

class DashedWidget extends StatelessWidget {
  const DashedWidget({
    super.key,
    this.color = Colors.black,
    this.gap = 2,
    this.solidLength = 2,
    this.width,
    this.height,
    this.direction = Axis.horizontal,
  });

  final Color color;
  final double gap;
  final double solidLength;
  final double? width;
  final double? height;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        child: CustomPaint(
          painter: DashedPainter(
            color: color,
            strokeWidth: height ?? 1,
            direction: direction,
          ),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height ?? MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: DashedPainter(
            color: color,
            strokeWidth: width ?? 1,
            direction: direction,
          ),
        ),
      );
    }
  }
}

class DashedPainter extends CustomPainter {
  DashedPainter({
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.gap = 2,
    this.solidLength = 2,
    this.direction = Axis.horizontal,
  });

  final Color color;
  final double strokeWidth;
  final double gap;
  final double solidLength;
  final Axis direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    final start = Offset.zero;
    Offset end;
    if (direction == Axis.horizontal) {
      end = Offset(size.width, 0);
    } else {
      // 不能为0，防止除0错误
      end = Offset(0.00001, size.height);
    }
    final path = getDashedPath(start, end);

    canvas.drawPath(path, paint);
  }

  Path getDashedPath(Offset start, Offset end) {
    final size = Size(end.dx - start.dx, end.dy - start.dy);
    final path = Path()..moveTo(start.dx, start.dy);
    var shouldDraw = true;
    var currentOffset = Offset(start.dx, start.dy);

    final radians = atan(size.height / size.width);

    final gapDx =
        cos(radians) * gap < 0 ? cos(radians) * gap * -1 : cos(radians) * gap;

    final gapDy =
        sin(radians) * gap < 0 ? sin(radians) * gap * -1 : sin(radians) * gap;

    final solidDx =
        cos(radians) * solidLength < 0
            ? cos(radians) * solidLength * -1
            : cos(radians) * solidLength;

    final solidDy =
        sin(radians) * solidLength < 0
            ? sin(radians) * solidLength * -1
            : sin(radians) * solidLength;

    double getDx() {
      return shouldDraw ? solidDx : gapDx;
    }

    double getDy() {
      return shouldDraw ? solidDy : gapDy;
    }

    while (currentOffset.dx <= end.dx && currentOffset.dy <= end.dy) {
      shouldDraw
          ? path.lineTo(currentOffset.dx, currentOffset.dy)
          : path.moveTo(currentOffset.dx, currentOffset.dy);
      currentOffset = Offset(
        currentOffset.dx + getDx(),
        currentOffset.dy + getDy(),
      );
      shouldDraw = !shouldDraw;
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
