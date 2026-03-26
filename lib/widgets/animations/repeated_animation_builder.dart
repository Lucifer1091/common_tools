import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../index.dart';

enum MyRepeatMode { repeat, reverse, pingPong, pingPongReverse }

class RepeatedAnimationBuilder<T> extends StatefulWidget {
  const RepeatedAnimationBuilder({
    required this.start,
    required this.end,
    required this.duration,
    required this.builder,
    super.key,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.mode = MyRepeatMode.repeat,
    this.child,
    this.lerp,
    this.play = true,
    this.reverseDuration,
  }) : animationBuilder = null;

  const RepeatedAnimationBuilder.animation({
    required this.start,
    required this.end,
    required this.duration,
    required this.animationBuilder,
    super.key,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.mode = MyRepeatMode.repeat,
    this.child,
    this.lerp,
    this.play = true,
    this.reverseDuration,
  }) : builder = null;

  final T start;
  final T end;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;
  final MyRepeatMode mode;
  final Widget Function(BuildContext context, T value, Widget? child)? builder;
  final Widget Function(BuildContext context, Animation<T> animation)?
  animationBuilder;
  final Widget? child;
  final ValueLerp<T>? lerp;
  final bool play;

  @override
  State<RepeatedAnimationBuilder<T>> createState() =>
      _RepeatedAnimationBuilderState<T>();
}

class _RepeatedAnimationBuilderState<T>
    extends State<RepeatedAnimationBuilder<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<T> _animation;
  bool _isReversing = false;

  bool get _startsReversed =>
      widget.mode == MyRepeatMode.reverse ||
      widget.mode == MyRepeatMode.pingPongReverse;

  bool get _pingPong =>
      widget.mode == MyRepeatMode.pingPong ||
      widget.mode == MyRepeatMode.pingPongReverse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener(_handleStatusChanged);
    _configureAnimation();

    if (widget.play) {
      _resumePlayback();
    }
  }

  @override
  void didUpdateWidget(covariant RepeatedAnimationBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final animationConfigChanged =
        oldWidget.start != widget.start ||
        oldWidget.end != widget.end ||
        oldWidget.duration != widget.duration ||
        oldWidget.reverseDuration != widget.reverseDuration ||
        oldWidget.curve != widget.curve ||
        oldWidget.reverseCurve != widget.reverseCurve ||
        oldWidget.mode != widget.mode ||
        oldWidget.lerp != widget.lerp;

    if (animationConfigChanged) {
      _disposeCurvedAnimation();
      _configureAnimation();
    }

    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _resumePlayback();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleStatusChanged);
    _disposeCurvedAnimation();
    _controller.dispose();
    super.dispose();
  }

  void _configureAnimation() {
    _controller.duration =
        _startsReversed
            ? widget.reverseDuration ?? widget.duration
            : widget.duration;
    _controller.reverseDuration =
        _startsReversed ? widget.duration : widget.reverseDuration;

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve:
          _startsReversed ? widget.reverseCurve ?? widget.curve : widget.curve,
      reverseCurve:
          _startsReversed ? widget.curve : widget.reverseCurve ?? widget.curve,
    );

    _animation = _curvedAnimation.drive(
      LerpedAnimatable<T>(
        start: _startsReversed ? widget.end : widget.start,
        end: _startsReversed ? widget.start : widget.end,
        lerp: (a, b, t) => lerpValue(a, b, t, lerp: widget.lerp),
      ),
    );
  }

  void _disposeCurvedAnimation() {
    _curvedAnimation.dispose();
  }

  void _resumePlayback() {
    if (_isReversing) {
      final resumeValue = _controller.value == 0 ? 1.0 : _controller.value;
      unawaited(_controller.reverse(from: resumeValue));
      return;
    }

    final resumeValue = _controller.value == 1 ? 0.0 : _controller.value;
    unawaited(_controller.forward(from: resumeValue));
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.forward) {
      _isReversing = false;
      return;
    }

    if (status == AnimationStatus.reverse) {
      _isReversing = true;
      return;
    }

    if (status == AnimationStatus.completed) {
      if (_pingPong) {
        _isReversing = true;
        unawaited(_controller.reverse());
      } else {
        _isReversing = false;
        _controller.reset();
        unawaited(_controller.forward());
      }
    } else if (status == AnimationStatus.dismissed) {
      _isReversing = false;

      if (_pingPong) {
        unawaited(_controller.forward());
      } else {
        _controller.reset();
        unawaited(_controller.forward());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationBuilder != null) {
      return widget.animationBuilder!(context, _animation);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return widget.builder!(context, _animation.value, widget.child);
      },
    );
  }
}
