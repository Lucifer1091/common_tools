import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyPointBounceIndicator extends StatefulWidget {
  const MyPointBounceIndicator({
    super.key,
    this.color,
    this.size = 20.0,
    this.duration = 1400,
    this.controller,
  });

  final Color? color;
  final double size;
  final int duration;
  final AnimationController? controller;

  @override
  _MyPointBounceIndicatorState createState() => _MyPointBounceIndicatorState();
}

class _MyPointBounceIndicatorState extends State<MyPointBounceIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        (widget.controller ??
              AnimationController(
                vsync: this,
                duration: Duration(milliseconds: widget.duration),
              ))
          ..repeat();
  }

  @override
  void didUpdateWidget(covariant MyPointBounceIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 3.5, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(
                begin: 0,
                end: 1,
                delay: i * .2,
              ).animate(_controller),
              child: SizedBox.fromSize(
                size: Size.square(widget.size * 0.5),
                child: _itemBuilder(i),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return DecoratedBox(
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
    );
  }
}

class DelayTween extends Tween<double> {
  DelayTween({required this.delay, super.begin, super.end});

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
