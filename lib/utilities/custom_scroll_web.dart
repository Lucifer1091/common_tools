part of 'utilities.dart';

class BouncingScrollBehavior extends ScrollBehavior {
  // Disable overscroll glow.
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

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
  final Widget child;
  final bool dragWithMouse;

  const BouncingScrollWrapperX({
    super.key,
    required this.child,
    this.dragWithMouse = false,
  });

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
        dragDevices: dragWithMouse
            ? {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
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
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

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
  final Widget child;
  final bool dragWithMouse;

  const ClampingScrollWrapperX({
    super.key,
    required this.child,
    this.dragWithMouse = false,
  });

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
        dragDevices: dragWithMouse
            ? {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }
            : null,
      ),
      child: child,
    );
  }
}

//   Widget get scrollOnDrag => ScrollConfiguration(
//         behavior: MyCustomScrollBehavior().copyWith(
//           overscroll: false,
//           scrollbars: false,
//         ),
//         child: this,
//       );

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
