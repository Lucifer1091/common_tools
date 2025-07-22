import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../common_tools.dart';

class TDCircleIndicator extends StatefulWidget {
  const TDCircleIndicator({
    super.key,
    this.color,
    this.size = 20.0,
    this.lineWidth = 3.0,
    this.duration = 1000,
  });

  final Color? color;
  final double size;
  final double lineWidth;
  final int duration;

  @override
  _TDCircleIndicatorState createState() => _TDCircleIndicatorState();
}

class _TDCircleIndicatorState extends State<TDCircleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
            vsync: this,
            duration: Duration(milliseconds: widget.duration),
          )
          ..addListener(() => setState(() {}))
          ..repeat();

    _animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 1)),
    );
  }

  @override
  void didUpdateWidget(covariant TDCircleIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = (_animation1.value) * 2 * pi;
    final paintColor = widget.color ?? ThemeColors.blue.shade600;

    return Transform(
      transform: Matrix4.identity()..rotateZ(value),
      alignment: FractionalOffset.center,
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: CustomPaint(
          painter: _CirclePaint(color: paintColor, width: widget.lineWidth),
        ),
      ),
    );
  }
}

class _CirclePaint extends CustomPainter {
  _CirclePaint({required this.color, required this.width});

  final Color color;
  final double width;

  final _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final minLength = min(size.width, size.height);

    _paint.strokeWidth = width;
    _paint.shader = ui.Gradient.sweep(Offset(size.width / 2, size.height / 2), [
      const Color(0x01ffffff),
      color,
    ]);

    if (minLength == size.width) {
      // strokeWidth is centered, so width / 2 needs to be subtracted to make it draw inwards
      canvas.drawArc(
        Rect.fromLTWH(
          width / 2,
          (size.height - size.width) / 2 + width / 2,
          size.width - width,
          size.width - width,
        ),
        0,
        pi * 2,
        false,
        _paint,
      );
    } else {
      canvas.drawArc(
        Rect.fromLTWH(
          (size.width - size.height) / 2 + width / 2,
          width / 2,
          size.height - width,
          size.height - width,
        ),
        0,
        pi * 2,
        false,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
