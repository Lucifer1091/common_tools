import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBlur extends ImplicitlyAnimatedWidget {
  const AnimatedBlur({
    this.child,
    this.blur = 8,
    this.enabled = true,
    super.duration = const Duration(milliseconds: 200),
    super.key,
    this.blendMode = BlendMode.srcOver,
    this.clipToBounds = false,
    super.curve,
    super.onEnd,
  });

  final double blur;
  final Widget? child;
  final bool enabled;
  final BlendMode blendMode;

  /// Clips the backdrop filter to this widget's paint bounds.
  ///
  /// Keeping this enabled avoids blurring more of the scene than necessary,
  /// which is usually both visually correct and better for performance.
  final bool clipToBounds;

  @override
  AnimatedWidgetBaseState<AnimatedBlur> createState() => _AnimatedBlurState();
}

class _AnimatedBlurState extends AnimatedWidgetBaseState<AnimatedBlur> {
  Tween<double>? _blurTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _blurTween =
        visitor(
              _blurTween,
              widget.blur,
              (value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final blur = (_blurTween?.evaluate(animation) ?? 0).clamp(
      0.0,
      double.infinity,
    );
    final child = widget.child ?? const SizedBox.shrink();

    if (!widget.enabled || blur <= 0.001) return child;

    Widget filteredChild = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      blendMode: widget.blendMode,
      child: child,
    );

    if (widget.clipToBounds) filteredChild = ClipRect(child: filteredChild);

    return filteredChild;
  }
}
