import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The position of the [MyPortal] in the global coordinate system.
sealed class MyAnchorBase {
  const MyAnchorBase();
}

/// Automatically infers the position of the [MyPortal] in the global
/// coordinate system adjusting according to the [offset],
/// [followerAnchor] and [targetAnchor] properties.
@immutable
class MyAnchorAuto extends MyAnchorBase {
  const MyAnchorAuto({
    this.offset = Offset.zero,
    this.followTargetOnResize = true,
    this.followerAnchor = Alignment.topCenter,
    this.targetAnchor = Alignment.bottomCenter,
    this.allowHorizontalFlip = true,
    this.allowVerticalFlip = true,
    this.viewportPadding = const EdgeInsets.all(8),
  });

  /// The offset of the overlay from the target widget.
  final Offset offset;

  /// Whether the overlay is automatically adjusted to follow the target
  /// widget when the target widget moves dues to a window resize.
  final bool followTargetOnResize;

  /// The coordinates of the overlay from which the overlay starts, which
  /// is calculated from the initial [targetAnchor].
  final Alignment followerAnchor;

  /// The coordinates of the target from which the overlay starts.
  final Alignment targetAnchor;

  /// Whether the overlay may be mirrored horizontally to remain on screen.
  final bool allowHorizontalFlip;

  /// Whether the overlay may be mirrored vertically to remain on screen.
  final bool allowVerticalFlip;

  /// Minimum distance kept between the overlay and the viewport edge.
  final EdgeInsets viewportPadding;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyAnchorAuto &&
        other.offset == offset &&
        other.followTargetOnResize == followTargetOnResize &&
        other.followerAnchor == followerAnchor &&
        other.targetAnchor == targetAnchor &&
        other.allowHorizontalFlip == allowHorizontalFlip &&
        other.allowVerticalFlip == allowVerticalFlip &&
        other.viewportPadding == viewportPadding;
  }

  @override
  int get hashCode =>
      offset.hashCode ^
      followTargetOnResize.hashCode ^
      followerAnchor.hashCode ^
      targetAnchor.hashCode ^
      allowHorizontalFlip.hashCode ^
      allowVerticalFlip.hashCode ^
      viewportPadding.hashCode;
}

/// Manually specifies the position of the [MyPortal] in the global
/// coordinate system.
@immutable
class MyAnchor extends MyAnchorBase {
  const MyAnchor({
    this.childAlignment = Alignment.topLeft,
    this.overlayAlignment = Alignment.bottomLeft,
    this.offset = Offset.zero,
  });

  final Alignment childAlignment;
  final Alignment overlayAlignment;
  final Offset offset;

  static const center = MyAnchor(
    childAlignment: Alignment.topCenter,
    overlayAlignment: Alignment.bottomCenter,
  );

  MyAnchor copyWith({
    Alignment? childAlignment,
    Alignment? overlayAlignment,
    Offset? offset,
  }) {
    return MyAnchor(
      childAlignment: childAlignment ?? this.childAlignment,
      overlayAlignment: overlayAlignment ?? this.overlayAlignment,
      offset: offset ?? this.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyAnchor &&
        other.childAlignment == childAlignment &&
        other.overlayAlignment == overlayAlignment &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return childAlignment.hashCode ^
        overlayAlignment.hashCode ^
        offset.hashCode;
  }
}

@immutable
class MyGlobalAnchor extends MyAnchorBase {
  const MyGlobalAnchor(this.offset);

  /// The global offset where the overlay is positioned.
  final Offset offset;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyGlobalAnchor && other.offset == offset;
  }

  @override
  int get hashCode => offset.hashCode;
}

class MyPortal extends StatefulWidget {
  const MyPortal({
    required this.child,
    required this.portalBuilder,
    required this.visible,
    required this.anchor,
    super.key,
  });

  final Widget child;
  final WidgetBuilder portalBuilder;
  final bool visible;
  final MyAnchorBase anchor;

  @override
  State<MyPortal> createState() => _MyPortalState();
}

class _MyPortalState extends State<MyPortal> {
  final layerLink = LayerLink();
  final overlayPortalController = OverlayPortalController();
  final overlayKey = GlobalKey();

  Offset? _calculatedPosition;
  bool _overlayReady = false;
  Size? _lastViewportSize;
  bool _positionCalculationScheduled = false;

  @override
  void initState() {
    super.initState();
    updateVisibility();
  }

  @override
  void didUpdateWidget(covariant MyPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      updateVisibility();
    } else if (widget.visible && oldWidget.anchor != widget.anchor) {
      _schedulePositionCalculation();
    }
  }

  @override
  void dispose() {
    hide();
    super.dispose();
  }

  void updateVisibility() {
    final shouldShow = widget.visible;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (shouldShow) {
        _calculatePosition();
        show();
      } else {
        if (_calculatedPosition != null) {
          setState(() {
            _calculatedPosition = null;
            _overlayReady = false;
          });
        } else if (_overlayReady) {
          setState(() => _overlayReady = false);
        }
        hide();
      }
    });
  }

  void hide() {
    if (overlayPortalController.isShowing) {
      overlayPortalController.hide();
    }
  }

  void show() {
    if (!overlayPortalController.isShowing) {
      overlayPortalController.show();
    }
  }

  void _schedulePositionCalculation() {
    if (_positionCalculationScheduled) return;
    _positionCalculationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _positionCalculationScheduled = false;
      if (!mounted) return;
      _calculatePosition();
    });
  }

  void _calculatePosition() {
    if (!mounted || widget.anchor is! MyAnchorAuto) return;

    final anchor = widget.anchor as MyAnchorAuto;

    final box = context.findRenderObject();
    final overlayState = Overlay.of(context, debugRequiredFor: widget);
    final overlayAncestor = overlayState.context.findRenderObject();

    final ready =
        box is RenderBox &&
        box.attached &&
        box.hasSize &&
        overlayAncestor is RenderBox &&
        overlayAncestor.attached &&
        overlayAncestor.hasSize;

    if (!ready) {
      _schedulePositionCalculation();
      return;
    }

    final overlay = overlayKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayReady = overlay != null && overlay.attached && overlay.hasSize;
    final overlaySize = overlayReady ? overlay.size : Size.zero;
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayAncestor);
    final viewport = Offset.zero & overlayAncestor.size;
    final safeViewport = Rect.fromLTRB(
      viewport.left + anchor.viewportPadding.left,
      viewport.top + anchor.viewportPadding.top,
      viewport.right - anchor.viewportPadding.right,
      viewport.bottom - anchor.viewportPadding.bottom,
    );
    final position = _resolveAutoPosition(
      targetTopLeft: topLeft,
      targetSize: box.size,
      overlaySize: overlaySize,
      viewport: safeViewport,
      anchor: anchor,
    );

    if (position != _calculatedPosition || _overlayReady != overlayReady) {
      if (mounted) {
        setState(() {
          _calculatedPosition = position;
          _overlayReady = overlayReady;
        });
      }
    } else if (!overlayReady) {
      _schedulePositionCalculation();
    }
  }

  Offset _resolveAutoPosition({
    required Offset targetTopLeft,
    required Size targetSize,
    required Size overlaySize,
    required Rect viewport,
    required MyAnchorAuto anchor,
  }) {
    final horizontalFirst =
        (anchor.targetAnchor.x - anchor.followerAnchor.x).abs() >
        (anchor.targetAnchor.y - anchor.followerAnchor.y).abs();
    final candidates = <({bool flipX, bool flipY})>[
      (flipX: false, flipY: false),
      if (horizontalFirst && anchor.allowHorizontalFlip)
        (flipX: true, flipY: false),
      if (!horizontalFirst && anchor.allowVerticalFlip)
        (flipX: false, flipY: true),
      if (horizontalFirst && anchor.allowVerticalFlip)
        (flipX: false, flipY: true),
      if (!horizontalFirst && anchor.allowHorizontalFlip)
        (flipX: true, flipY: false),
      if (anchor.allowHorizontalFlip && anchor.allowVerticalFlip)
        (flipX: true, flipY: true),
    ];

    Offset? preferred;
    for (final candidate in candidates) {
      final targetAnchor = _flipAlignment(
        anchor.targetAnchor,
        flipX: candidate.flipX,
        flipY: candidate.flipY,
      );
      final followerAnchor = _flipAlignment(
        anchor.followerAnchor,
        flipX: candidate.flipX,
        flipY: candidate.flipY,
      );
      final offset = Offset(
        candidate.flipX ? -anchor.offset.dx : anchor.offset.dx,
        candidate.flipY ? -anchor.offset.dy : anchor.offset.dy,
      );
      final targetPoint =
          targetTopLeft + _alignmentOffset(targetSize, targetAnchor);
      final origin =
          targetPoint - _alignmentOffset(overlaySize, followerAnchor) + offset;
      preferred ??= origin;
      final bounds = origin & overlaySize;
      if (viewport.contains(bounds.topLeft) &&
          viewport.contains(bounds.bottomRight)) {
        return origin;
      }
    }

    final value = preferred ?? targetTopLeft;
    final maxX = math.max(viewport.left, viewport.right - overlaySize.width);
    final maxY = math.max(viewport.top, viewport.bottom - overlaySize.height);
    return Offset(
      value.dx.clamp(viewport.left, maxX),
      value.dy.clamp(viewport.top, maxY),
    );
  }

  Alignment _flipAlignment(
    Alignment alignment, {
    required bool flipX,
    required bool flipY,
  }) {
    return Alignment(
      flipX ? -alignment.x : alignment.x,
      flipY ? -alignment.y : alignment.y,
    );
  }

  Offset _alignmentOffset(Size size, Alignment alignment) {
    return Offset(
      (alignment.x + 1) * size.width / 2,
      (alignment.y + 1) * size.height / 2,
    );
  }

  Widget buildAutoPosition(BuildContext context, MyAnchorAuto anchor) {
    if (anchor.followTargetOnResize) {
      final viewportSize = MediaQuery.sizeOf(context);
      if (_lastViewportSize != viewportSize) {
        _lastViewportSize = viewportSize;
        _schedulePositionCalculation();
      }
    }

    if (_calculatedPosition == null) {
      _schedulePositionCalculation();
      return const SizedBox.shrink();
    }

    final position = _calculatedPosition!;

    final overlay = overlayKey.currentContext?.findRenderObject() as RenderBox?;

    if (overlay == null) {
      _schedulePositionCalculation();
    }

    return CustomSingleChildLayout(
      delegate: MyPositionDelegate(
        target: position,
        verticalOffset: 0,
        preferBelow: true,
        exactPosition: true,
      ),
      child: KeyedSubtree(
        key: overlayKey,
        child: Visibility.maintain(
          // The overlay layout details are available only after the view is
          // rendered, in this way we can avoid the flickering effect.
          visible: _overlayReady,
          child: IgnorePointer(
            ignoring: !_overlayReady,
            child: widget.portalBuilder(context),
          ),
        ),
      ),
    );
  }

  Widget buildManualPosition(BuildContext context, MyAnchor anchor) {
    return CompositedTransformFollower(
      link: layerLink,
      offset: anchor.offset,
      followerAnchor: anchor.childAlignment,
      targetAnchor: anchor.overlayAlignment,
      child: widget.portalBuilder(context),
    );
  }

  Widget buildGlobalPosition(BuildContext context, MyGlobalAnchor anchor) {
    return CustomSingleChildLayout(
      delegate: MyPositionDelegate(
        target: anchor.offset,
        verticalOffset: 0,
        preferBelow: true,
      ),
      child: widget.portalBuilder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: (context) {
          return Center(
            widthFactor: 1,
            heightFactor: 1,
            child: switch (widget.anchor) {
              final MyAnchorAuto anchor => buildAutoPosition(context, anchor),
              final MyAnchor anchor => buildManualPosition(context, anchor),
              final MyGlobalAnchor anchor => buildGlobalPosition(
                context,
                anchor,
              ),
            },
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// A delegate for computing the layout of an overlay to be displayed above or
/// below a target specified in the global coordinate system.
class MyPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of an overlay.
  MyPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
    this.exactPosition = false,
  });

  /// The offset of the target the overlay is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// overlay.
  final double verticalOffset;

  /// Whether the overlay is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  /// Whether [target] is the exact top-left position of the overlay.
  final bool exactPosition;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if (exactPosition) return target;
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      margin: 0,
    );
  }

  @override
  bool shouldRelayout(MyPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow ||
        exactPosition != oldDelegate.exactPosition;
  }
}
