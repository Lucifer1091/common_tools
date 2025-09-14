import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

@immutable
class MyHoverStrategies {
  const MyHoverStrategies({this.hover = const {}, this.unhover = const {}});

  final Set<MyHoverStrategy> hover;
  final Set<MyHoverStrategy> unhover;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyHoverStrategies &&
        setEquals(other.hover, hover) &&
        setEquals(other.unhover, unhover);
  }

  @override
  int get hashCode => hover.hashCode ^ unhover.hashCode;

  MyHoverStrategies copyWith({
    Set<MyHoverStrategy>? hover,
    Set<MyHoverStrategy>? unhover,
  }) {
    return MyHoverStrategies(
      hover: hover ?? this.hover,
      unhover: unhover ?? this.unhover,
    );
  }
}

enum MyHoverStrategy {
  onTapDown,
  onTapUp,
  onTapCancel,
  onLongPressStart,
  onLongPressCancel,
  onLongPressUp,
  onLongPressDown,
  onLongPressEnd,
  onDoubleTapDown,
  onDoubleTapCancel,
  onForcePressStart,
  onForcePressEnd,
}

/// A special [GestureDetector] that handles the hovering state of the [child]
/// on devices where the hover is not supported (eg mobile) with the help of
/// [hoverStrategies].
///
/// If the device supports mouse, the [hoverStrategies] will be ignored and
/// [MouseRegion] will be used instead.
class MyGestureDetector extends StatelessWidget {
  const MyGestureDetector({
    required this.child,
    super.key,
    this.cursor = SystemMouseCursors.click,
    this.hoverStrategies,
    this.behavior,
    this.onHover,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
    this.supportedDevices,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.forceStartPressure = 0.4,
    this.forcePeakPressure = 0.85,
    this.excludeFromSemantics = false,
  });

  final MyHoverStrategies? hoverStrategies;
  final ValueChanged<bool>? onHover;
  final MouseCursor cursor;
  final Widget child;
  final VoidCallback? onTap;
  final ValueChanged<TapDownDetails>? onTapDown;
  final ValueChanged<TapUpDetails>? onTapUp;
  final VoidCallback? onTapCancel;
  final VoidCallback? onSecondaryTap;
  final ValueChanged<TapDownDetails>? onSecondaryTapDown;
  final ValueChanged<TapUpDetails>? onSecondaryTapUp;
  final VoidCallback? onSecondaryTapCancel;
  final VoidCallback? onLongPress;
  final ValueChanged<LongPressStartDetails>? onLongPressStart;
  final VoidCallback? onLongPressCancel;
  final VoidCallback? onLongPressUp;
  final ValueChanged<LongPressMoveUpdateDetails>? onLongPressMoveUpdate;
  final ValueChanged<LongPressDownDetails>? onLongPressDown;
  final ValueChanged<LongPressEndDetails>? onLongPressEnd;
  final VoidCallback? onDoubleTap;
  final ValueChanged<TapDownDetails>? onDoubleTapDown;
  final VoidCallback? onDoubleTapCancel;
  final Duration? longPressDuration;

  /// The kind of devices that are allowed to be recognized.
  ///
  /// If set to null, events from all device types will be recognized. Defaults
  /// to null.
  final Set<PointerDeviceKind>? supportedDevices;

  /// The pointer is in contact with the screen and has pressed with sufficient
  /// force to initiate a force press. The amount of force is at least
  /// [ForcePressGestureRecognizer.startPressure].
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressStartCallback? onForcePressStart;

  /// The pointer is in contact with the screen and has pressed with the maximum
  /// force. The amount of force is at least
  /// [ForcePressGestureRecognizer.peakPressure].
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressPeakCallback? onForcePressPeak;

  /// A pointer is in contact with the screen, has previously passed the
  /// [ForcePressGestureRecognizer.startPressure] and is either moving on the
  /// plane of the screen, pressing the screen with varying forces or both
  /// simultaneously.
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressUpdateCallback? onForcePressUpdate;

  /// The pointer tracked by [onForcePressStart] is no longer in contact with
  /// the screen.
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressEndCallback? onForcePressEnd;

  final double forceStartPressure;
  final double forcePeakPressure;
  final HitTestBehavior? behavior;

  /// Whether to exclude these gestures from the semantics tree. For
  /// example, the long-press gesture for showing a tooltip is
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  // See https://github.com/nank1ro/flutter-shadcn-ui/issues/319
  Offset correctGlobalPosition(BuildContext context, Offset globalPosition) {
    // Get the root navigator's overlay (screen coordinates)
    final rootNavigator = Navigator.maybeOf(context, rootNavigator: true);
    final rootOverlay = rootNavigator?.overlay;
    if (rootOverlay == null) return globalPosition;

    // Get the shell navigator's overlay (nearest Navigator)
    final shellNavigator = Navigator.maybeOf(context);
    final shellOverlay = shellNavigator?.overlay;
    if (shellOverlay == null || shellOverlay == rootOverlay) {
      return globalPosition;
    }

    final shellRenderObject = shellOverlay.context.findRenderObject();
    if (shellRenderObject is! RenderBox) {
      return globalPosition;
    }

    final shellOffset = shellRenderObject.localToGlobal(Offset.zero);
    final correctedPosition = globalPosition - shellOffset;

    return correctedPosition;
  }

  MyHoverStrategies _hoverStrategies() {
    return const MyHoverStrategies(
      hover: {
        MyHoverStrategy.onTapDown,
        MyHoverStrategy.onLongPressDown,
        MyHoverStrategy.onLongPressStart,
      },
      unhover: {
        MyHoverStrategy.onTapUp,
        MyHoverStrategy.onTapCancel,
        MyHoverStrategy.onLongPressUp,
        MyHoverStrategy.onLongPressEnd,
        MyHoverStrategy.onLongPressCancel,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final supportsMouse = switch (Theme.of(context).platform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.fuchsia => false,
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux => true,
    };

    final effectiveHoverStrategies = hoverStrategies ?? _hoverStrategies();

    final gestures = <Type, GestureRecognizerFactory>{};
    final gestureSettings = MediaQuery.maybeGestureSettingsOf(context);

    void setHover(MyHoverStrategy strategy) {
      // If the device supports mouse, we don't need to use any hover strategy.
      if (supportsMouse) return;

      if (effectiveHoverStrategies.hover.contains(strategy)) {
        onHover?.call(true);
      } else if (effectiveHoverStrategies.unhover.contains(strategy)) {
        onHover?.call(false);
      }
    }

    void effectiveOnTapDown(TapDownDetails d) {
      setHover(MyHoverStrategy.onTapDown);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onTapDown?.call(d.copyWith(globalPosition: correctedGlobalPosition));
    }

    void effectiveOnSecondaryTapDown(TapDownDetails d) {
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onSecondaryTapDown?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnSecondaryTapUp(TapUpDetails d) {
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onSecondaryTapUp?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnSecondaryTapCancel() {
      onSecondaryTapCancel?.call();
    }

    void effectiveOnSecondaryTap() {
      onSecondaryTap?.call();
    }

    void effectiveOnTapUp(TapUpDetails d) {
      setHover(MyHoverStrategy.onTapUp);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onTapUp?.call(d.copyWith(globalPosition: correctedGlobalPosition));
    }

    void effectiveOnTapCancel() {
      setHover(MyHoverStrategy.onTapCancel);
      onTapCancel?.call();
    }

    void effectiveOnDoubleTapDown(TapDownDetails d) {
      setHover(MyHoverStrategy.onDoubleTapDown);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onDoubleTapDown?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnDoubleTapCancel() {
      setHover(MyHoverStrategy.onDoubleTapCancel);
      onDoubleTapCancel?.call();
    }

    void effectiveOnLongPressStart(LongPressStartDetails d) {
      setHover(MyHoverStrategy.onLongPressStart);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onLongPressStart?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnLongPressCancel() {
      setHover(MyHoverStrategy.onLongPressCancel);
      onLongPressCancel?.call();
    }

    void effectiveOnLongPressUp() {
      setHover(MyHoverStrategy.onLongPressUp);
      onLongPressUp?.call();
    }

    void effectiveOnLongPressDown(LongPressDownDetails d) {
      setHover(MyHoverStrategy.onLongPressDown);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onLongPressDown?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnLongPressEnd(LongPressEndDetails d) {
      setHover(MyHoverStrategy.onLongPressEnd);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      onLongPressEnd?.call(d.copyWith(globalPosition: correctedGlobalPosition));
    }

    gestures[TapGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(
            debugOwner: this,
            supportedDevices: supportedDevices,
          ),
          (TapGestureRecognizer instance) {
            instance
              ..onTapDown = effectiveOnTapDown
              ..onTapUp = effectiveOnTapUp
              ..onTap = onTap
              ..onTapCancel = effectiveOnTapCancel
              ..onSecondaryTapDown = effectiveOnSecondaryTapDown
              ..onSecondaryTapUp = effectiveOnSecondaryTapUp
              ..onSecondaryTap = effectiveOnSecondaryTap
              ..onSecondaryTapCancel = effectiveOnSecondaryTapCancel
              ..gestureSettings = gestureSettings
              ..supportedDevices = supportedDevices;
          },
        );

    if (onDoubleTap != null ||
        onDoubleTapDown != null ||
        onDoubleTapCancel != null) {
      gestures[DoubleTapGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
            () => DoubleTapGestureRecognizer(
              debugOwner: this,
              supportedDevices: supportedDevices,
            ),
            (DoubleTapGestureRecognizer instance) {
              instance
                ..onDoubleTapDown = effectiveOnDoubleTapDown
                ..onDoubleTap = onDoubleTap
                ..onDoubleTapCancel = effectiveOnDoubleTapCancel
                ..gestureSettings = gestureSettings
                ..supportedDevices = supportedDevices;
            },
          );
    }

    if (onLongPressDown != null ||
        onLongPressCancel != null ||
        onLongPress != null ||
        onLongPressStart != null ||
        onLongPressMoveUpdate != null ||
        onLongPressUp != null ||
        onLongPressEnd != null) {
      gestures[LongPressGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(
              duration: longPressDuration ?? kLongPressTimeout,
              debugOwner: this,
              supportedDevices: supportedDevices,
            ),
            (LongPressGestureRecognizer instance) {
              instance
                ..onLongPressDown = effectiveOnLongPressDown
                ..onLongPressCancel = effectiveOnLongPressCancel
                ..onLongPress = onLongPress
                ..onLongPressStart = effectiveOnLongPressStart
                ..onLongPressMoveUpdate = onLongPressMoveUpdate
                ..onLongPressUp = effectiveOnLongPressUp
                ..onLongPressEnd = effectiveOnLongPressEnd
                ..gestureSettings = gestureSettings
                ..supportedDevices = supportedDevices;
            },
          );
    }

    if (onForcePressStart != null ||
        onForcePressPeak != null ||
        onForcePressUpdate != null ||
        onForcePressEnd != null) {
      gestures[ForcePressGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<ForcePressGestureRecognizer>(
            () => ForcePressGestureRecognizer(
              debugOwner: this,
              supportedDevices: supportedDevices,
              startPressure: forceStartPressure,
              peakPressure: forcePeakPressure,
            ),
            (ForcePressGestureRecognizer instance) {
              instance
                ..onStart = onForcePressStart
                ..onPeak = onForcePressPeak
                ..onUpdate = onForcePressUpdate
                ..onEnd = onForcePressEnd
                ..gestureSettings = gestureSettings
                ..supportedDevices = supportedDevices;
            },
          );
    }

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) {
        onHover?.call(true);
      },
      onExit: (_) {
        onHover?.call(false);
      },
      child: RawGestureDetector(
        gestures: gestures,
        behavior: behavior,
        excludeFromSemantics: excludeFromSemantics,
        child: child,
      ),
    );
  }
}

extension TapDownDetailsExtension on TapDownDetails {
  TapDownDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    PointerDeviceKind? kind,
  }) {
    return TapDownDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      kind: kind ?? this.kind,
    );
  }
}

extension TapUpDetailsExtension on TapUpDetails {
  TapUpDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    PointerDeviceKind? kind,
  }) {
    return TapUpDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      kind: kind ?? this.kind,
    );
  }
}

extension LongPressStartDetailsExtension on LongPressStartDetails {
  LongPressStartDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
  }) {
    return LongPressStartDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
    );
  }
}

extension LongPressMoveUpdateDetailsExtension on LongPressMoveUpdateDetails {
  LongPressMoveUpdateDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    Offset? offsetFromOrigin,
    Offset? localOffsetFromOrigin,
  }) {
    return LongPressMoveUpdateDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      offsetFromOrigin: offsetFromOrigin ?? this.offsetFromOrigin,
      localOffsetFromOrigin:
          localOffsetFromOrigin ?? this.localOffsetFromOrigin,
    );
  }
}

extension LongPressEndDetailsExtension on LongPressEndDetails {
  LongPressEndDetails copyWith({
    Velocity? velocity,
    Offset? globalPosition,
    Offset? localPosition,
  }) {
    return LongPressEndDetails(
      velocity: velocity ?? this.velocity,
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
    );
  }
}

extension LongPressDownDetailsExtension on LongPressDownDetails {
  LongPressDownDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    PointerDeviceKind? kind,
  }) {
    return LongPressDownDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      kind: kind ?? this.kind,
    );
  }
}
