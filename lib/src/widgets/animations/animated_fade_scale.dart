import 'dart:async';

import 'package:flutter/material.dart';

/// A convenience wrapper around Flutter's built-in [FadeTransition] and
/// [ScaleTransition].
///
/// The animation starts with the child being invisible and scaled down,
/// and then fades in and scales up to its normal size.
class AnimatedFadeScale extends StatefulWidget {
  const AnimatedFadeScale({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.beginScale = 0.92,
    this.endScale = 1.0,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
    this.alignment = Alignment.center,
    this.reverseCurve,
    this.value,
  });

  /// The child widget to be animated.
  final Widget child;

  /// The duration of the animation.
  final Duration duration;

  /// The delay before the animation starts.
  final Duration delay;

  /// The curve of the animation.
  final Curve curve;

  /// The curve to use when running the animation in reverse.
  final Curve? reverseCurve;

  /// The starting scale of the child widget.
  final double beginScale;

  /// The ending scale of the child widget.
  final double endScale;

  /// The starting opacity of the child widget.
  final double beginOpacity;

  /// The ending opacity of the child widget.
  final double endOpacity;

  /// The alignment used for the scale transition.
  final Alignment alignment;

  /// An optional value that controls the animation progress directly.
  ///
  /// When provided, the animation will be set to this value immediately,
  /// overriding any animation or delay settings. This allows for manual
  /// synchronization with other animations or events. If not provided,
  /// the animation will run automatically based on the [duration] and [delay].
  final double? value;

  @override
  State<AnimatedFadeScale> createState() => _AnimatedFadeScaleState();
}

class _AnimatedFadeScaleState extends State<AnimatedFadeScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      debugLabel: 'AnimatedFadeScale',
    );

    _createAnimations();
    _syncAnimation(restartFromBeginning: true);
  }

  @override
  void didUpdateWidget(AnimatedFadeScale oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    final transitionConfigChanged =
        oldWidget.curve != widget.curve ||
        oldWidget.reverseCurve != widget.reverseCurve ||
        oldWidget.beginScale != widget.beginScale ||
        oldWidget.endScale != widget.endScale ||
        oldWidget.beginOpacity != widget.beginOpacity ||
        oldWidget.endOpacity != widget.endOpacity;

    if (transitionConfigChanged) {
      _curvedAnimation.dispose();
      _createAnimations();
    }

    final shouldRestartAutoAnimation =
        widget.value == null &&
        (oldWidget.value != widget.value ||
            oldWidget.child != widget.child ||
            oldWidget.delay != widget.delay);

    final shouldSyncValue =
        widget.value != null &&
        (oldWidget.value != widget.value || transitionConfigChanged);

    if (shouldRestartAutoAnimation || shouldSyncValue) {
      _syncAnimation(restartFromBeginning: shouldRestartAutoAnimation);
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
      reverseCurve: widget.reverseCurve,
    );

    _opacityAnimation = Tween<double>(
      begin: widget.beginOpacity,
      end: widget.endOpacity,
    ).animate(_curvedAnimation);

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(_curvedAnimation);
  }

  void _syncAnimation({required bool restartFromBeginning}) {
    _delayTimer?.cancel();

    if (widget.value != null) {
      _controller.value = _normalizedValue(widget.value!);
      return;
    }

    void startAnimation() {
      if (!mounted || widget.value != null) return;
      unawaited(
        _controller.forward(from: restartFromBeginning ? 0 : _controller.value),
      );
    }

    if (widget.delay > Duration.zero) {
      _delayTimer = Timer(widget.delay, startAnimation);
    } else {
      startAnimation();
    }
  }

  double _normalizedValue(double value) {
    return value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }
}
