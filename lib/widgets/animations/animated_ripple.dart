import 'dart:async' show unawaited;
import 'dart:math' as math show max, min, pi, sin;

import 'package:flutter/material.dart';

/// Paints expanding ripple waves behind a centered child widget.
class RippleWave extends StatefulWidget {
  const RippleWave({
    required this.child,
    super.key,
    this.color = Colors.teal,
    this.duration = const Duration(milliseconds: 1500),
    this.repeat = true,
    this.childTween,
    this.animationController,
    this.waveCount = 5,
  }) : assert(waveCount > 0, 'waveCount must be greater than zero.'),
       assert(duration > Duration.zero, 'duration must be greater than zero.');

  /// Color used for the ripple waves and the radial glow behind [child].
  final Color color;

  /// Widget displayed at the center of the ripple animation.
  final Widget child;

  /// Optional scale tween applied to [child].
  ///
  /// When omitted, the child gently scales from `0.9` to `1.0`.
  final Tween<double>? childTween;

  /// Duration of a single ripple cycle.
  final Duration duration;

  /// Whether internally managed animations should loop continuously.
  final bool repeat;

  /// Optional controller for externally managed playback.
  ///
  /// When this is provided, the widget listens to the controller but does not
  /// start, stop, or dispose it.
  final AnimationController? animationController;

  /// Number of ripple rings painted at a time.
  final int waveCount;

  @override
  RippleWaveState createState() => RippleWaveState();
}

/// State for [RippleWave].
class RippleWaveState extends State<RippleWave>
    with SingleTickerProviderStateMixin {
  static final Tween<double> _defaultChildTween = Tween<double>(
    begin: 0.9,
    end: 1,
  );

  late AnimationController _controller;
  late CurvedAnimation _curveAnimation;
  late Animation<double> _scaleAnimation;
  int _playbackGeneration = 0;

  bool get _ownsController => widget.animationController == null;
  Animatable<double> get _resolvedChildTween =>
      widget.childTween ?? _defaultChildTween;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _createScaleAnimation();
    _syncPlayback();
  }

  @override
  void didUpdateWidget(covariant RippleWave oldWidget) {
    super.didUpdateWidget(oldWidget);

    final controllerChanged =
        oldWidget.animationController != widget.animationController;

    if (controllerChanged) {
      _curveAnimation.dispose();

      if (oldWidget.animationController == null) {
        _controller.dispose();
      }

      _controller = _createController();
      _createScaleAnimation();
    } else {
      if (_ownsController && oldWidget.duration != widget.duration) {
        _controller.duration = widget.duration;
      }

      if (oldWidget.childTween != widget.childTween) {
        _curveAnimation.dispose();
        _createScaleAnimation();
      }
    }

    if (controllerChanged ||
        oldWidget.repeat != widget.repeat ||
        (_ownsController && oldWidget.duration != widget.duration)) {
      _syncPlayback();
    }
  }

  /// Stops the animation and clears any visible ripple state.
  Future<void> stopAnimation() async {
    _playbackGeneration++;
    _controller.stop();

    if (_controller.value != 0) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _playbackGeneration++;
    _curveAnimation.dispose();

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RipplePainter(
        animation: _controller,
        waveCount: widget.waveCount,
        color: widget.color,
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(999)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: <Color>[widget.color, Colors.transparent],
              ),
            ),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: RepaintBoundary(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }

  AnimationController _createController() {
    return widget.animationController ??
        AnimationController(duration: widget.duration, vsync: this);
  }

  void _createScaleAnimation() {
    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: const _CurveWave(),
    );
    _scaleAnimation = _resolvedChildTween.animate(_curveAnimation);
  }

  void _syncPlayback() {
    _playbackGeneration++;

    if (!_ownsController) {
      return;
    }

    _controller.stop();

    if (widget.repeat) {
      unawaited(_controller.repeat());
      return;
    }

    unawaited(_playOnce(_playbackGeneration));
  }

  Future<void> _playOnce(int generation) async {
    try {
      await _controller.forward(from: 0);
    } on TickerCanceled {
      return;
    }

    if (!mounted || generation != _playbackGeneration) {
      return;
    }

    _controller.reset();
  }
}

class _CurveWave extends Curve {
  const _CurveWave();

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return t;
    }

    return math.sin(t * math.pi);
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({
    required this.animation,
    required this.waveCount,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int waveCount;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final effectiveWaveCount = math.max(1, waveCount);
    final center = size.center(Offset.zero);
    final maxRadius = math.min(size.width, size.height) / 2;
    final totalWaves = effectiveWaveCount + 1;
    final animationValue = animation.value;
    final paint = Paint();

    for (var wave = 0; wave <= effectiveWaveCount; wave++) {
      final normalizedValue = (wave + animationValue) / totalWaves;
      final opacity = (1.0 - normalizedValue).clamp(0.0, 1.0);

      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(center, maxRadius * normalizedValue, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.waveCount != waveCount ||
        oldDelegate.color != color;
  }
}
