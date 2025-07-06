import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/recognizer.dart';

class DisableScrollbar extends StatelessWidget {
  const DisableScrollbar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      child: child,
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.invertedStylus,
  };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

class BouncingScrollBehavior extends ScrollBehavior {
  // Disable overscroll glow.
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) => child;

  // Set physics to bouncing.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

/// Usage
/// ```dart
/// child: BouncingScrollWrapperX.builder(
///        context,
///        widget!,
////       dragWithMouse: true,
///      ),
/// ```
class BouncingScrollWrapperX extends StatelessWidget {
  const BouncingScrollWrapperX({
    required this.child,
    super.key,
    this.dragWithMouse = false,
  });

  final Widget child;
  final bool dragWithMouse;

  static Widget builder(
    BuildContext context,
    Widget child, {
    bool dragWithMouse = false,
  }) {
    return BouncingScrollWrapperX(dragWithMouse: dragWithMouse, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: BouncingScrollBehavior().copyWith(
        overscroll: false,
        scrollbars: false,
        dragDevices:
            dragWithMouse
                ? {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.invertedStylus,
                }
                : null,
      ),
      child: child,
    );
  }
}

class ClampingScrollBehavior extends ScrollBehavior {
  // Disable overscroll glow.
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  // Set physics to clamping.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

/// Usage
/// ```dart
/// child: ClampingScrollWrapperX.builder(
///        context,
///        widget!,
////       dragWithMouse: true,
///      ),
/// ```
class ClampingScrollWrapperX extends StatelessWidget {
  const ClampingScrollWrapperX({
    required this.child,
    super.key,
    this.dragWithMouse = false,
  });
  final Widget child;
  final bool dragWithMouse;

  static Widget builder(
    BuildContext context,
    Widget child, {
    bool dragWithMouse = false,
  }) {
    return ClampingScrollWrapperX(dragWithMouse: dragWithMouse, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ClampingScrollBehavior().copyWith(
        overscroll: false,
        scrollbars: false,
        dragDevices:
            dragWithMouse
                ? {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.invertedStylus,
                }
                : null,
      ),
      child: child,
    );
  }
}
