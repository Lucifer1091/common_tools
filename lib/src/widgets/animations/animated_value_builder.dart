import 'dart:async';

import 'package:flutter/widgets.dart';

typedef ValueLerp<T> = T Function(T a, T b, double t);

typedef AnimatedChildBuilder<T> =
    Widget Function(BuildContext context, T value, Widget? child);

typedef MyAnimationBuilder<T> =
    Widget Function(BuildContext context, Animation<T> animation);

typedef AnimatedChildValueBuilder<T> =
    Widget Function(
      BuildContext context,
      T oldValue,
      T newValue,
      double t,
      Widget? child,
    );

class AnimatedValueBuilder<T> extends StatefulWidget {
  const AnimatedValueBuilder({
    required this.value,
    required this.duration,
    required AnimatedChildBuilder<T> this.builder,
    super.key,
    this.initialValue,
    this.onEnd,
    this.curve = Curves.linear,
    this.lerp,
    this.child,
  }) : animationBuilder = null,
       rawBuilder = null;

  const AnimatedValueBuilder.raw({
    required this.value,
    required this.duration,
    required AnimatedChildValueBuilder<T> builder,
    super.key,
    this.initialValue,
    this.onEnd,
    this.curve = Curves.linear,
    this.child,
    this.lerp,
  }) : animationBuilder = null,
       rawBuilder = builder,
       builder = null;

  const AnimatedValueBuilder.animation({
    required this.value,
    required this.duration,
    required MyAnimationBuilder<T> builder,
    super.key,
    this.initialValue,
    this.onEnd,
    this.curve = Curves.linear,
    this.lerp,
  }) : builder = null,
       animationBuilder = builder,
       child = null,
       rawBuilder = null;

  final T? initialValue;
  final T value;
  final Duration duration;
  final AnimatedChildBuilder<T>? builder;
  final MyAnimationBuilder<T>? animationBuilder;
  final AnimatedChildValueBuilder<T>? rawBuilder;
  final void Function(T value)? onEnd;
  final Curve curve;
  final ValueLerp<T>? lerp;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => AnimatedValueBuilderState<T>();
}

class AnimatedValueBuilderState<T> extends State<AnimatedValueBuilder<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<T> _animation;
  late T _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? widget.value;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _createCurvedAnimation();
    _rebuildAnimation(start: _currentValue, end: widget.value);

    if (widget.initialValue != null && widget.initialValue != widget.value) {
      unawaited(_controller.forward());
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(AnimatedValueBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentValue = _animation.value;
    _currentValue = currentValue;

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    final curveChanged = widget.curve != oldWidget.curve;
    if (curveChanged) {
      _disposeCurvedAnimation();
      _createCurvedAnimation();
    }

    final shouldRebuildAnimation =
        curveChanged ||
        oldWidget.value != widget.value ||
        oldWidget.lerp != widget.lerp;

    if (!shouldRebuildAnimation) {
      return;
    }

    _rebuildAnimation(start: currentValue, end: widget.value);

    if (currentValue == widget.value) {
      _controller.value = 1;
    } else {
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _disposeCurvedAnimation();
    _controller.dispose();
    super.dispose();
  }

  void _createCurvedAnimation() {
    _curvedAnimation = CurvedAnimation(parent: _controller, curve: widget.curve)
      ..addStatusListener(_handleStatusChanged);
  }

  void _disposeCurvedAnimation() {
    _curvedAnimation
      ..removeStatusListener(_handleStatusChanged)
      ..dispose();
  }

  void _rebuildAnimation({required T start, required T end}) {
    _animation = _curvedAnimation.drive(
      LerpedAnimatable<T>(
        start: start,
        end: end,
        lerp: (a, b, t) => lerpValue(a, b, t, lerp: widget.lerp),
      ),
    );
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onEnd?.call(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationBuilder != null) {
      return widget.animationBuilder!(context, _animation);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: _builder,
      child: widget.child,
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    if (widget.rawBuilder != null) {
      return widget.rawBuilder!(
        context,
        _currentValue,
        widget.value,
        _curvedAnimation.value,
        child,
      );
    }

    return widget.builder!(context, _animation.value, child);
  }
}

class LerpedAnimatable<T> extends Animatable<T> {
  LerpedAnimatable({
    required this.start,
    required this.end,
    required this.lerp,
  });

  final T start;
  final T end;
  final ValueLerp<T> lerp;

  @override
  T transform(double t) => lerp(start, end, t);

  @override
  String toString() => 'LerpedAnimatable($start, $end)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LerpedAnimatable<T> &&
        other.start == start &&
        other.end == end &&
        other.lerp == lerp;
  }

  @override
  int get hashCode => Object.hash(start, end, lerp);
}

T lerpValue<T>(T a, T b, double t, {ValueLerp<T>? lerp}) {
  if (lerp != null) {
    return lerp(a, b, t);
  }

  if (a is int && b is int) {
    return (a + ((b - a) * t)).round() as T;
  }

  if (a is double && b is double) {
    return (a + ((b - a) * t)) as T;
  }

  if (a is Offset && b is Offset) {
    return Offset.lerp(a, b, t)! as T;
  }

  if (a is Size && b is Size) {
    return Size.lerp(a, b, t)! as T;
  }

  if (a is Rect && b is Rect) {
    return Rect.lerp(a, b, t)! as T;
  }

  if (a is Radius && b is Radius) {
    return Radius.lerp(a, b, t)! as T;
  }

  if (a is Color && b is Color) {
    return Color.lerp(a, b, t)! as T;
  }

  if (a is Alignment && b is Alignment) {
    return Alignment.lerp(a, b, t)! as T;
  }

  if (a is AlignmentGeometry && b is AlignmentGeometry) {
    return AlignmentGeometry.lerp(a, b, t)! as T;
  }

  if (a is EdgeInsets && b is EdgeInsets) {
    return EdgeInsets.lerp(a, b, t)! as T;
  }

  if (a is EdgeInsetsGeometry && b is EdgeInsetsGeometry) {
    return EdgeInsetsGeometry.lerp(a, b, t)! as T;
  }

  throw FlutterError(
    'Could not lerp values of type ${a.runtimeType}. '
    'Provide a custom lerp function for $a and $b.',
  );
}
