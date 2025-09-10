import 'dart:math' as math show sin, pi;

import 'package:flutter/animation.dart';

class DelayTween extends Tween<double> {
  DelayTween({required this.delay, super.begin, super.end});

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
