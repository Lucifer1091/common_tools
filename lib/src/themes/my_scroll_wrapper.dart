import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/my_radius.dart';
import '../extensions/context/theme.dart';

class MyScrollbar extends StatelessWidget {
  const MyScrollbar({
    required this.child,
    this.controller,
    super.key,
    this.theme,
  });

  final Widget child;
  final ScrollController? controller;
  final ScrollbarThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data:
          theme ??
          ScrollbarThemeData(
            crossAxisMargin: 4,
            thumbColor: WidgetStateProperty.all(context.colorScheme.border),
            radius: MyRadi.small,
            interactive: true,
            thickness: WidgetStateProperty.all(7),
          ),
      child: Scrollbar(controller: controller, child: child),
    );
  }
}

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
            return MyScrollbar(controller: details.controller, child: child);
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
      color: context.colorScheme.secondary,
      child: child,
    );
  }
}

class MyScrollWrapper extends StatelessWidget {
  const MyScrollWrapper({
    required this.child,
    super.key,
    this.dragWithMouse = true,
    this.overscroll = true,
    this.scrollbars = true,
  });

  final bool dragWithMouse, overscroll, scrollbars;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior().copyWith(
        overscroll: overscroll,
        scrollbars: scrollbars,
        dragDevices: dragWithMouse
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
