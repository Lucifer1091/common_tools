import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

/// Adds a tilt-and-depth hover effect around a custom child.
class AnimatedHover extends StatefulWidget {
  const AnimatedHover({
    required this.builder,
    super.key,
    this.onTap,
    this.depth = 0,
    this.depthColor = Colors.transparent,
    this.shadow,
  }) : assert(depth >= 0, 'depth must be greater than or equal to zero.');

  /// Builds the content that reacts to hover state changes.
  final Widget Function(BuildContext context, bool isHovered) builder;

  /// Extra translation applied to the content while hovering.
  final double depth;

  /// Base background color used by the hover surface.
  final Color depthColor;

  /// Shadow painted behind the hover surface.
  final BoxShadow? shadow;

  /// Called when the surface is tapped.
  final GestureTapCallback? onTap;

  @override
  AnimatedHoverState createState() => AnimatedHoverState();
}

/// State for [AnimatedHover].
class AnimatedHoverState extends State<AnimatedHover>
    with SingleTickerProviderStateMixin {
  static const BorderRadius _outerBorderRadius = BorderRadius.all(
    Radius.circular(15),
  );
  static const BorderRadius _innerBorderRadius = BorderRadius.all(
    Radius.circular(10),
  );
  static const Duration _resetDuration = Duration(milliseconds: 150);
  static const Duration _glowFadeDuration = Duration(milliseconds: 500);
  static const double _glowSize = 100;
  static const double _glowHalfSize = _glowSize / 2;
  static const double _perspective = 0.001;
  static const double _maxTilt = 0.3;

  late final AnimationController _resetController;
  late final CurvedAnimation _resetCurve;
  late final ValueNotifier<bool> _hoveredNotifier;
  late final ValueNotifier<_InteractionState> _interactionNotifier;

  Animation<Offset>? _resetAnimation;
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      duration: _resetDuration,
      vsync: this,
    )..addStatusListener(_handleResetStatusChanged);

    _resetCurve = CurvedAnimation(
      parent: _resetController,
      curve: Curves.easeInOut,
    );
    _hoveredNotifier = ValueNotifier<bool>(false);
    _interactionNotifier = ValueNotifier<_InteractionState>(
      const _InteractionState.initial(),
    );
  }

  /// Resets the hover effect back to the centered resting position.
  void reset(Size size) {
    _startReset(size);
  }

  @override
  void dispose() {
    _hoveredNotifier.dispose();
    _interactionNotifier.dispose();
    _resetCurve.dispose();
    _resetController
      ..removeStatusListener(_handleResetStatusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = constraints.biggest;

        if (!_hasFiniteSize(size)) {
          return _buildFallback(context);
        }

        _lastSize = size;

        return MouseRegion(
          onEnter: (_) => _setHovered(true),
          onExit: (_) => _handlePointerExit(size),
          onHover: (details) {
            _handlePointerUpdate(details.localPosition, size);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onPanDown: (DragDownDetails details) {
              _handlePointerUpdate(details.localPosition, size);
            },
            onPanUpdate: (DragUpdateDetails details) {
              _handlePointerUpdate(details.localPosition, size);
            },
            onPanEnd: (_) => _handlePointerExit(size),
            onPanCancel: () => _handlePointerExit(size),
            child: ValueListenableBuilder<bool>(
              valueListenable: _hoveredNotifier,
              builder: (BuildContext context, bool isHovered, Widget? _) {
                return ValueListenableBuilder<_InteractionState>(
                  valueListenable: _interactionNotifier,
                  child: RepaintBoundary(
                    child: widget.builder(context, isHovered),
                  ),
                  builder:
                      (
                        BuildContext context,
                        _InteractionState interaction,
                        Widget? child,
                      ) {
                        return AnimatedBuilder(
                          animation: _resetController,
                          child: child,
                          builder: (BuildContext context, Widget? child) {
                            final pointer = _currentPointerPosition(size);
                            final metrics = _HoverMetrics.fromPointer(
                              pointer: pointer,
                              size: size,
                              depth: widget.depth,
                              isDefaultPosition: interaction.isDefaultPosition,
                            );

                            return Transform(
                              transform: _buildTiltTransform(metrics),
                              alignment: Alignment.center,
                              child: SizedBox.fromSize(
                                size: size,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: widget.depthColor,
                                    borderRadius: _outerBorderRadius,
                                    boxShadow: widget.shadow != null
                                        ? <BoxShadow>[widget.shadow!]
                                        : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: _innerBorderRadius,
                                    child: ColoredBox(
                                      color: widget.depthColor,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Transform.translate(
                                            offset: metrics.contentOffset,
                                            child: child,
                                          ),
                                          IgnorePointer(
                                            child: Transform.translate(
                                              offset: metrics.glowOffset,
                                              child: AnimatedOpacity(
                                                opacity:
                                                    interaction
                                                        .isDefaultPosition
                                                    ? 0
                                                    : 1,
                                                duration: _glowFadeDuration,
                                                curve: Curves.decelerate,
                                                child: const _HoverGlow(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Matrix4 _buildTiltTransform(_HoverMetrics metrics) {
    return Matrix4.identity()
      ..setEntry(3, 2, _perspective)
      ..rotateX(metrics.rotateX)
      ..rotateY(metrics.rotateY);
  }

  Widget _buildFallback(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: ValueListenableBuilder<bool>(
          valueListenable: _hoveredNotifier,
          builder: (BuildContext context, bool isHovered, Widget? _) =>
              widget.builder(context, isHovered),
        ),
      ),
    );
  }

  Offset _centerFor(Size size) => Offset(size.width / 2, size.height / 2);

  Offset _clampToBounds(Offset offset, Size size) {
    return Offset(
      offset.dx.clamp(0.0, size.width),
      offset.dy.clamp(0.0, size.height),
    );
  }

  Offset _currentPointerPosition(Size size) {
    if (_resetController.isAnimating && _resetAnimation != null) {
      return _resetAnimation!.value;
    }

    final interaction = _interactionNotifier.value;
    if (interaction.isDefaultPosition) {
      return _centerFor(size);
    }

    return _clampToBounds(interaction.pointer, size);
  }

  bool _hasFiniteSize(Size size) =>
      size.width.isFinite &&
      size.height.isFinite &&
      size.width > 0 &&
      size.height > 0;

  void _handlePointerExit(Size size) {
    _setHovered(false);
    _startReset(size);
  }

  void _handlePointerUpdate(Offset localPosition, Size size) {
    final nextPointer = _clampToBounds(localPosition, size);
    _lastSize = size;

    if (_resetController.isAnimating) {
      _resetController.stop();
      _resetAnimation = null;
    }

    _setHovered(true);

    final nextInteraction = _InteractionState(
      pointer: nextPointer,
      isDefaultPosition: false,
    );

    if (_interactionNotifier.value != nextInteraction) {
      _interactionNotifier.value = nextInteraction;
    }
  }

  void _handleResetStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed || _lastSize == null) {
      return;
    }

    final centeredState = _InteractionState(
      pointer: _centerFor(_lastSize!),
      isDefaultPosition: true,
    );

    _resetAnimation = null;
    if (_interactionNotifier.value != centeredState) {
      _interactionNotifier.value = centeredState;
    }
  }

  void _setHovered(bool value) {
    if (_hoveredNotifier.value != value) {
      _hoveredNotifier.value = value;
    }
  }

  void _startReset(Size size) {
    final start = _currentPointerPosition(size);
    final end = _centerFor(size);

    if (start == end) {
      final centeredState = _InteractionState(
        pointer: end,
        isDefaultPosition: true,
      );

      _resetAnimation = null;
      if (_interactionNotifier.value != centeredState) {
        _interactionNotifier.value = centeredState;
      }
      return;
    }

    _lastSize = size;
    _resetAnimation = Tween<Offset>(
      begin: start,
      end: end,
    ).animate(_resetCurve);

    unawaited(_resetController.forward(from: 0));
  }
}

class _HoverGlow extends StatelessWidget {
  const _HoverGlow();

  static const BoxShadow _glowShadow = BoxShadow(
    color: Color.fromARGB(56, 255, 255, 255),
    blurRadius: 100,
    spreadRadius: 40,
  );

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AnimatedHoverState._glowSize,
      height: AnimatedHoverState._glowSize,
      child: DecoratedBox(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[_glowShadow]),
      ),
    );
  }
}

class _HoverMetrics {
  const _HoverMetrics({
    required this.contentOffset,
    required this.glowOffset,
    required this.rotateX,
    required this.rotateY,
  });

  factory _HoverMetrics.fromPointer({
    required Offset pointer,
    required Size size,
    required double depth,
    required bool isDefaultPosition,
  }) {
    final normalizedX = (pointer.dx / size.width).clamp(0.0, 1.0);
    final normalizedY = (pointer.dy / size.height).clamp(0.0, 1.0);
    final translatedX = (normalizedX - 0.5) * 2;
    final translatedY = (normalizedY - 0.5) * 2;

    return _HoverMetrics(
      contentOffset: isDefaultPosition
          ? Offset.zero
          : Offset(depth * translatedX, depth * translatedY),
      glowOffset: Offset(
        (size.width - AnimatedHoverState._glowHalfSize) - pointer.dx,
        (size.height - AnimatedHoverState._glowHalfSize) - pointer.dy,
      ),
      rotateX: isDefaultPosition
          ? 0.0
          : AnimatedHoverState._maxTilt * translatedY,
      rotateY: isDefaultPosition
          ? 0.0
          : -AnimatedHoverState._maxTilt * translatedX,
    );
  }

  final Offset contentOffset;
  final Offset glowOffset;
  final double rotateX;
  final double rotateY;
}

class _InteractionState {
  const _InteractionState({
    required this.pointer,
    required this.isDefaultPosition,
  });

  const _InteractionState.initial()
    : pointer = Offset.zero,
      isDefaultPosition = true;

  final Offset pointer;
  final bool isDefaultPosition;

  @override
  bool operator ==(Object other) {
    return other is _InteractionState &&
        other.pointer == pointer &&
        other.isDefaultPosition == isDefaultPosition;
  }

  @override
  int get hashCode => Object.hash(pointer, isDefaultPosition);
}
