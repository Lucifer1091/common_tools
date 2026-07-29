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
    this.followerAnchor = Alignment.bottomCenter,
    this.targetAnchor = Alignment.bottomCenter,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyAnchorAuto &&
        other.offset == offset &&
        other.followTargetOnResize == followTargetOnResize &&
        other.followerAnchor == followerAnchor &&
        other.targetAnchor == targetAnchor;
  }

  @override
  int get hashCode =>
      offset.hashCode ^
      followTargetOnResize.hashCode ^
      followerAnchor.hashCode ^
      targetAnchor.hashCode;
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

  Offset? _calculatedTarget;
  bool _calculatedPreferBelow = true;
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
        if (_calculatedTarget != null) {
          setState(() {
            _calculatedTarget = null;
            _calculatedPreferBelow = true;
          });
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
    final overlaySize = (true == overlay?.hasSize) ? overlay!.size : Size.zero;
    final verticalGap = anchor.offset.dy.abs();

    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayAncestor);
    final bottomRight = box.localToGlobal(
      box.size.bottomRight(Offset.zero),
      ancestor: overlayAncestor,
    );

    final availableBelow =
        overlayAncestor.size.height - bottomRight.dy - verticalGap;
    final availableAbove = topLeft.dy - verticalGap;
    final shouldOpenAbove =
        overlaySize.height > availableBelow &&
        (overlaySize.height <= availableAbove ||
            availableAbove > availableBelow);

    final targetOffset = switch ((anchor.targetAnchor, shouldOpenAbove)) {
      (
        (Alignment.topLeft || Alignment.centerLeft || Alignment.bottomLeft),
        true,
      ) =>
        box.size.topLeft(Offset.zero),
      (
        (Alignment.topCenter || Alignment.center || Alignment.bottomCenter),
        true,
      ) =>
        box.size.topCenter(Offset.zero),
      (
        (Alignment.topRight || Alignment.centerRight || Alignment.bottomRight),
        true,
      ) =>
        box.size.topRight(Offset.zero),
      (
        (Alignment.topLeft || Alignment.centerLeft || Alignment.bottomLeft),
        false,
      ) =>
        box.size.bottomLeft(Offset.zero),
      (
        (Alignment.topCenter || Alignment.center || Alignment.bottomCenter),
        false,
      ) =>
        box.size.bottomCenter(Offset.zero),
      (
        (Alignment.topRight || Alignment.centerRight || Alignment.bottomRight),
        false,
      ) =>
        box.size.bottomRight(Offset.zero),
      (final alignment, _) => throw Exception(
        """MyAnchorAuto doesn't support the alignment $alignment you provided""",
      ),
    };

    var followerOffset = switch (anchor.followerAnchor) {
      Alignment.topLeft ||
      Alignment.centerLeft ||
      Alignment.bottomLeft => Offset(-overlaySize.width / 2, 0),
      Alignment.topCenter ||
      Alignment.center ||
      Alignment.bottomCenter => Offset.zero,
      Alignment.topRight ||
      Alignment.centerRight ||
      Alignment.bottomRight => Offset(overlaySize.width / 2, 0),
      final alignment => throw Exception(
        """MyAnchorAuto doesn't support the alignment $alignment you provided""",
      ),
    };

    followerOffset += targetOffset;
    followerOffset += Offset(anchor.offset.dx, 0);

    final target = box.localToGlobal(followerOffset, ancestor: overlayAncestor);

    if (target != _calculatedTarget ||
        _calculatedPreferBelow != !shouldOpenAbove) {
      if (mounted) {
        setState(() {
          _calculatedTarget = target;
          _calculatedPreferBelow = !shouldOpenAbove;
        });
      }
    } else if (overlay == null) {
      _schedulePositionCalculation();
    }
  }

  Widget buildAutoPosition(BuildContext context, MyAnchorAuto anchor) {
    if (anchor.followTargetOnResize) {
      final viewportSize = MediaQuery.sizeOf(context);
      if (_lastViewportSize != viewportSize) {
        _lastViewportSize = viewportSize;
        _schedulePositionCalculation();
      }
    }

    if (_calculatedTarget == null) {
      _schedulePositionCalculation();
      return const SizedBox.shrink();
    }

    final target = _calculatedTarget!;

    final overlay = overlayKey.currentContext?.findRenderObject() as RenderBox?;

    if (overlay == null) {
      _schedulePositionCalculation();
    }

    return CustomSingleChildLayout(
      delegate: MyPositionDelegate(
        target: target,
        verticalOffset: anchor.offset.dy.abs(),
        preferBelow: _calculatedPreferBelow,
      ),
      child: KeyedSubtree(
        key: overlayKey,
        child: Visibility.maintain(
          // The overlay layout details are available only after the view is
          // rendered, in this way we can avoid the flickering effect.
          visible: overlay != null,
          child: IgnorePointer(
            ignoring: overlay == null,
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

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
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
        preferBelow != oldDelegate.preferBelow;
  }
}
