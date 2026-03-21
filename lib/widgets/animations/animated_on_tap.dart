import 'dart:async';

import 'package:flutter/widgets.dart';

class AnimatedOnTap extends StatefulWidget {
  const AnimatedOnTap({
    required this.onTap,
    required this.child,
    super.key,
    this.scale = 0.95,
    this.duration = const Duration(milliseconds: 125),
    this.curve = Curves.easeOutSine,
    this.reverseCurve,
    this.alignment = Alignment.center,
    this.cursor = SystemMouseCursors.click,
    this.enabled = true,
    this.behavior = HitTestBehavior.deferToChild,
  }) : assert(scale > 0, 'scale must be greater than zero');

  final VoidCallback onTap;
  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;
  final Curve? reverseCurve;
  final Alignment alignment;
  final MouseCursor cursor;
  final bool enabled;
  final HitTestBehavior behavior;

  @override
  State<AnimatedOnTap> createState() => _AnimatedOnTapState();
}

class _AnimatedOnTapState extends State<AnimatedOnTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late CurvedAnimation _curvedAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _configureAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimatedOnTap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    final animationConfigChanged =
        widget.scale != oldWidget.scale ||
        widget.curve != oldWidget.curve ||
        widget.reverseCurve != oldWidget.reverseCurve;

    if (animationConfigChanged) {
      _curvedAnimation.dispose();
      _configureAnimation();
    }

    if (!widget.enabled && oldWidget.enabled) {
      unawaited(_pressOut());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _curvedAnimation.dispose();
    super.dispose();
  }

  void _configureAnimation() {
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve ?? widget.curve.flipped,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.scale,
    ).animate(_curvedAnimation);
  }

  Future<void> _pressIn() async {
    if (!widget.enabled || _controller.isCompleted) {
      return;
    }

    try {
      await _controller.forward();
    } on TickerCanceled {
      // The controller was disposed while the press animation was active.
    }
  }

  Future<void> _pressOut() async {
    if (_controller.isDismissed) {
      return;
    }

    try {
      await _controller.reverse();
    } on TickerCanceled {
      // The controller was disposed while the release animation was active.
    }
  }

  Future<void> _handleTap() async {
    if (!widget.enabled) {
      return;
    }

    if (!_controller.isCompleted) {
      await _pressIn();
    }

    try {
      widget.onTap();
    } finally {
      if (mounted) {
        await _pressOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      enabled: widget.enabled,
      mouseCursor: widget.enabled ? widget.cursor : MouseCursor.defer,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            unawaited(_handleTap());
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: widget.behavior,
        onTap: widget.enabled ? () => unawaited(_handleTap()) : null,
        onTapDown: widget.enabled ? (_) => unawaited(_pressIn()) : null,
        onTapCancel: widget.enabled ? () => unawaited(_pressOut()) : null,
        child: RepaintBoundary(
          child: ScaleTransition(
            alignment: widget.alignment,
            scale: _scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
