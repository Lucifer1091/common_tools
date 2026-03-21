import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBounce extends StatefulWidget {
  const AnimatedBounce({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.elasticOut,
    this.value = 0.2,
    this.beginScale,
    this.endScale = 1.0,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  /// Bounce intensity used to derive the default starting scale.
  ///
  /// When [beginScale] is not provided, the animation starts from
  /// `max(0, endScale - value)` and settles at [endScale].
  final double value;

  /// Optional explicit starting scale.
  ///
  /// If omitted, the widget derives it from [value].
  final double? beginScale;

  /// Final resting scale after the bounce completes.
  final double endScale;

  /// Alignment used by the scale transition.
  final Alignment alignment;

  @override
  State<AnimatedBounce> createState() => _AnimatedBounceState();
}

class _AnimatedBounceState extends State<AnimatedBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _createAnimation();
    _play();
  }

  @override
  void didUpdateWidget(covariant AnimatedBounce oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    final animationConfigChanged =
        oldWidget.curve != widget.curve ||
        oldWidget.value != widget.value ||
        oldWidget.beginScale != widget.beginScale ||
        oldWidget.endScale != widget.endScale;

    if (animationConfigChanged) {
      _curvedAnimation.dispose();
      _createAnimation();
    }

    if (animationConfigChanged || oldWidget.child != widget.child) {
      _play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _curvedAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _createAnimation() {
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _scaleAnimation = Tween<double>(
      begin: _resolvedBeginScale,
      end: _resolvedEndScale,
    ).animate(_curvedAnimation);
  }

  void _play() {
    unawaited(_controller.forward(from: 0));
  }

  double get _resolvedBeginScale {
    if (widget.beginScale != null) {
      return _normalizedScale(widget.beginScale!);
    }
    return math.max(0, _resolvedEndScale - widget.value).toDouble();
  }

  double get _resolvedEndScale => _normalizedScale(widget.endScale);

  double _normalizedScale(double value) => math.max(0, value).toDouble();
}
