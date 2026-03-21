import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An iOS-style home-screen wiggle animation.
///
/// This widget is useful for edit-mode states where an icon or tile needs a
/// subtle continuous shake. The default motion mirrors the classic iOS icon
/// jiggle: a very small alternating rotation with optional per-item delay so
/// a grid can feel slightly staggered instead of perfectly synchronized.
class AnimatedShake extends StatefulWidget {
  const AnimatedShake({
    required this.child,
    super.key,
    this.enabled = true,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.linear,
    this.settleDuration = const Duration(milliseconds: 120),
    this.settleCurve = Curves.easeOut,
    this.rotationDegrees = 2,
    this.horizontalOffset = 0,
    this.verticalOffset = 0,
    this.alignment = Alignment.center,
  });

  /// The widget to animate.
  final Widget child;

  /// Whether the shake animation should be active.
  final bool enabled;

  /// Duration of one shake cycle.
  final Duration duration;

  /// Optional delay before the animation starts.
  ///
  /// This is especially useful when multiple icons should feel organically
  /// staggered, like iOS home-screen edit mode.
  final Duration delay;

  /// Curve applied across each animation cycle.
  final Curve curve;

  /// Duration used to return the widget to its neutral pose when disabled.
  final Duration settleDuration;

  /// Curve used while returning the widget to its neutral pose.
  final Curve settleCurve;

  /// Maximum rotation in degrees applied during the shake.
  final double rotationDegrees;

  /// Optional horizontal offset used during the shake.
  final double horizontalOffset;

  /// Optional vertical offset used during the shake.
  final double verticalOffset;

  /// Alignment used by the rotation transform.
  final Alignment alignment;

  @override
  State<AnimatedShake> createState() => _AnimatedShakeState();
}

class _AnimatedShakeState extends State<AnimatedShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<double> _rotation;
  late Animation<double> _offsetX;
  late Animation<double> _offsetY;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      debugLabel: 'AnimatedShake',
    );
    _createAnimations();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimatedShake oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    final animationConfigChanged =
        oldWidget.curve != widget.curve ||
        oldWidget.rotationDegrees != widget.rotationDegrees ||
        oldWidget.horizontalOffset != widget.horizontalOffset ||
        oldWidget.verticalOffset != widget.verticalOffset;

    if (animationConfigChanged) {
      _curvedAnimation.dispose();
      _createAnimations();
    }

    if (animationConfigChanged ||
        oldWidget.enabled != widget.enabled ||
        oldWidget.delay != widget.delay) {
      _syncAnimation();
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _curvedAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _createAnimations() {
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    final maxRotation = _degreesToRadians(widget.rotationDegrees);

    _rotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -maxRotation), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -maxRotation, end: 0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0, end: maxRotation), weight: 20),
      TweenSequenceItem(tween: Tween(begin: maxRotation, end: 0), weight: 40),
    ]).animate(_curvedAnimation);

    _offsetX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: -widget.horizontalOffset),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.horizontalOffset, end: 0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: widget.horizontalOffset),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.horizontalOffset, end: 0),
        weight: 40,
      ),
    ]).animate(_curvedAnimation);

    _offsetY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: -widget.verticalOffset),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.verticalOffset, end: 0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: widget.verticalOffset),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.verticalOffset, end: 0),
        weight: 40,
      ),
    ]).animate(_curvedAnimation);
  }

  void _syncAnimation() {
    _delayTimer?.cancel();

    if (widget.enabled) {
      void start() {
        if (!mounted || !widget.enabled) return;
        unawaited(_controller.repeat());
      }

      if (widget.delay > Duration.zero) {
        _delayTimer = Timer(widget.delay, start);
      } else {
        start();
      }
      return;
    }

    _settleToNeutral();
  }

  void _settleToNeutral() {
    _controller.stop();

    if (_controller.value == 0 || _controller.value == 1) {
      _controller.value = 0;
      return;
    }

    unawaited(
      _controller
          .animateTo(
            1,
            duration: widget.settleDuration,
            curve: widget.settleCurve,
          )
          .then((_) {
            if (!mounted || widget.enabled) return;
            _controller.value = 0;
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetX.value, _offsetY.value),
          child: Transform.rotate(
            angle: _rotation.value,
            alignment: widget.alignment,
            child: child,
          ),
        );
      },
    );
  }

  double _degreesToRadians(double degrees) => degrees * (math.pi / 180);
}
