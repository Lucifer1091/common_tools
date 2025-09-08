import 'package:flutter/material.dart';

class BallScaleRippleMultipleIndicator extends StatefulWidget {
  const BallScaleRippleMultipleIndicator({
    super.key,
    this.radius = 20,
    this.ballColor = Colors.white,
    this.duration = const Duration(milliseconds: 1000),
  });

  final double radius;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() =>
      _BallScaleRippleMultipleIndicatorState();
}

class _BallScaleRippleMultipleIndicatorState
    extends State<BallScaleRippleMultipleIndicator>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation = Tween<double>(begin: 0, end: widget.radius).animate(_animation)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller
            ..reset()
            ..forward();
        }
      });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Size _measureSize() {
    final size = 2 * widget.radius;
    return Size(size, size);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _BallScaleRippleMultipleIndicatorPainter(
            animationValue: _animation.value,
            radius: widget.radius,
            ballColor: widget.ballColor,
            duration: widget.duration,
          ),
        );
      },
    );
  }
}

class _BallScaleRippleMultipleIndicatorPainter extends CustomPainter {
  _BallScaleRippleMultipleIndicatorPainter({
    required this.animationValue,
    required this.radius,
    required this.ballColor,
    required this.duration,
  }) : offsetList = <double>[radius, radius * .7, radius * .4],
       strokeList = <double>[1.2, .84, 0.48];

  final double animationValue;
  final double radius;
  final Color ballColor;
  final Duration duration;
  final List<double> offsetList;
  final List<double> strokeList;

  @override
  void paint(Canvas canvas, Size size) {
    final percent = animationValue / radius;
    final paint =
        Paint()
          ..isAntiAlias = true
          ..color = Color.fromARGB(
            (255 * percent).round(),
            (ballColor.r * 255.0).round() & 0xff,
            (ballColor.g * 255.0).round() & 0xff,
            (ballColor.b * 255.0).round() & 0xff,
          )
          ..style = PaintingStyle.stroke;

    final center = Offset(radius, radius);

    for (var i = 0; i < offsetList.length; i++) {
      canvas.save();
      paint.strokeWidth = strokeList[i] * percent;
      canvas..drawCircle(center, offsetList[i] * percent, paint)
      ..restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
