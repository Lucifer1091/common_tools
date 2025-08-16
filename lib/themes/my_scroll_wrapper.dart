import 'dart:ui';
import 'package:flutter/material.dart';
import 'my_theme.dart';

class MyScrollBehavior extends ScrollBehavior {
  const MyScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // When modifying this function, consider modifying the implementation in
    // the base class ScrollBehavior as well.
    switch (axisDirectionToAxis(details.direction)) {
      case Axis.horizontal:
        return child;
      case Axis.vertical:
        switch (getPlatform(context)) {
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            return Scrollbar(controller: details.controller, child: child);
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.iOS:
            return child;
        }
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // When modifying this function, consider modifying the implementation in
    // the base class ScrollBehavior as well.
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
      case TargetPlatform.android:
        return StretchingOverscrollIndicator(
          axisDirection: details.direction,
          clipBehavior: details.decorationClipBehavior ?? Clip.hardEdge,
          child: child,
        );
      case TargetPlatform.fuchsia:
        break;
    }

    return GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: MyTheme.of(context).colorScheme.secondary,
      child: child,
    );
  }
}

class MyScrollWrapper extends StatelessWidget {
  const MyScrollWrapper({
    required this.child,
    this.dragWithMouse = true,
    super.key,
  });

  final bool dragWithMouse;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior().copyWith(
        overscroll: false,
        scrollbars: false,
        dragDevices:
            dragWithMouse
                ? <PointerDeviceKind>{
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.invertedStylus,
                  PointerDeviceKind.trackpad,
                  // The VoiceAccess sends pointer events with unknown type when scrolling
                  // scrollables.
                  PointerDeviceKind.unknown,
                }
                : null,
      ),
      child: child,
    );
  }
}

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
