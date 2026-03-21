import 'dart:async';

import 'package:flutter/widgets.dart';

/// Animates a child replacement by fading the old child out, swapping content,
/// then fading and sliding the new child in.
class AnimatedFadeSlide extends StatefulWidget {
  const AnimatedFadeSlide({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 350),
    this.fadeCurve = Curves.easeOut,
    this.slideCurve = Curves.easeOutCubic,
    this.initialSlideOffset = const Offset(0.05, 0),
    this.transitionKey,
    this.animateOnInitialBuild = true,
    this.onTransitionComplete,
  });

  final Widget child;
  final Duration duration;
  final Curve fadeCurve;
  final Curve slideCurve;
  final Offset initialSlideOffset;

  /// Identity that forces a transition when it changes.
  final Object? transitionKey;
  final bool animateOnInitialBuild;
  final VoidCallback? onTransitionComplete;

  static AnimatedFadeSlide fast({
    required Widget child,
    Key? key,
    Object? transitionKey,
  }) {
    return AnimatedFadeSlide(
      key: key,
      transitionKey: transitionKey,
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }

  static AnimatedFadeSlide slow({
    required Widget child,
    Key? key,
    Object? transitionKey,
  }) {
    return AnimatedFadeSlide(
      key: key,
      transitionKey: transitionKey,
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }

  @override
  State<AnimatedFadeSlide> createState() => _AnimatedFadeSlideState();
}

class _AnimatedFadeSlideState extends State<AnimatedFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late Widget _displayedChild;
  Object? _previousTransitionKey;
  Widget? _pendingChild;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _displayedChild = widget.child;
    _previousTransitionKey = widget.transitionKey;
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _configureAnimations();

    if (widget.animateOnInitialBuild) {
      unawaited(_controller.forward());
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedFadeSlide oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    final animationConfigChanged =
        widget.duration != oldWidget.duration ||
        widget.fadeCurve != oldWidget.fadeCurve ||
        widget.slideCurve != oldWidget.slideCurve ||
        widget.initialSlideOffset != oldWidget.initialSlideOffset;

    if (animationConfigChanged) {
      _configureAnimations();
    }

    _handleContentUpdate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _configureAnimations() {
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.6, curve: widget.fadeCurve),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.initialSlideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.slideCurve));
  }

  void _handleContentUpdate() {
    if (_shouldTriggerTransition()) {
      _previousTransitionKey = widget.transitionKey;
      _pendingChild = widget.child;
      _startTransitionIfNeeded();
      return;
    }

    if (_isTransitioning) {
      if (_pendingChild != null) {
        _pendingChild = widget.child;
      } else if (!identical(_displayedChild, widget.child)) {
        setState(() {
          _displayedChild = widget.child;
        });
      }
      return;
    }

    if (!identical(_displayedChild, widget.child)) {
      setState(() {
        _displayedChild = widget.child;
      });
    }
  }

  bool _shouldTriggerTransition() {
    if (widget.transitionKey != null || _previousTransitionKey != null) {
      return widget.transitionKey != _previousTransitionKey;
    }

    return !Widget.canUpdate(_displayedChild, widget.child);
  }

  void _startTransitionIfNeeded() {
    if (_isTransitioning || !mounted) {
      return;
    }

    unawaited(_runTransitionLoop());
  }

  Future<void> _runTransitionLoop() async {
    if (!mounted || _isTransitioning) {
      return;
    }

    _isTransitioning = true;

    try {
      while (mounted && _pendingChild != null) {
        await _controller.reverse();

        if (!mounted) {
          return;
        }

        final nextChild = _pendingChild;
        _pendingChild = null;

        if (nextChild == null) {
          break;
        }

        setState(() {
          _displayedChild = nextChild;
        });

        await _controller.forward(from: 0);

        if (!mounted) {
          return;
        }

        widget.onTransitionComplete?.call();
      }
    } on TickerCanceled {
      // The controller was disposed while a transition was in flight.
    } finally {
      _isTransitioning = false;

      if (mounted && _pendingChild != null) {
        _startTransitionIfNeeded();
      }
    }
  }

  Future<void> triggerTransition() async {
    _pendingChild = widget.child;
    _startTransitionIfNeeded();
  }

  bool get isTransitioning => _isTransitioning;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: _displayedChild),
    );
  }
}
