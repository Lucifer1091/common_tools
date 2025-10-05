import 'dart:math';

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyDialog {
  MyDialog._();

  static const Duration animationDuration = Duration(milliseconds: 150);

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    Duration? duration,
    Alignment? alignment,
    bool fullscreen = false,
    bool draggable = false,
    bool hideSoftKeyboard = true,
    bool barrierDismissible = true,
    MyDialogAnimation dialogAnimation = MyDialogAnimation.scale,
  }) async {
    if (hideSoftKeyboard) DismissKeyboard.hideKeyboard(context);

    return showGeneralDialog<T>(
      context: context,
      barrierLabel: 'Dismiss',
      fullscreenDialog: fullscreen,
      barrierDismissible: barrierDismissible,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      transitionDuration: duration ?? animationDuration,
      transitionBuilder: (context, animation, _, child) {
        final animate = dialogAnimatedWrapperWidget(
          animation: animation,
          dialogAnimation: dialogAnimation,
          child: child,
        );

        Align? align;

        if (!fullscreen && alignment != null) {
          align = Align(alignment: alignment, child: animate);
        }

        return FocusScope(
          canRequestFocus: animation.value == 1,
          child: align ?? animate,
        );
      },
      pageBuilder: (_, _, child) {
        var content = builder.call(context);

        if (draggable) content = MyDraggableDialog(child: content);

        return content;
      },
    );
  }

  /// Converts degrees to radians.
  static const double degrees2Radians = pi / 180.0;

  /// Converts degrees to radians.
  static double radians(double degrees) => degrees * degrees2Radians;

  /// Widget wrapper for animated dialog transitions.
  static Widget dialogAnimatedWrapperWidget({
    required Animation<double> animation,
    required Widget child,
    required MyDialogAnimation dialogAnimation,
    Curve curve = Curves.easeOut,
    Curve reverseCurve = Curves.easeIn,
  }) {
    switch (dialogAnimation) {
      // Animation for rotating the dialog.
      case MyDialogAnimation.rotate:
        return Transform.rotate(
          angle: radians(animation.value * 360),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for sliding the dialog from top to bottom.
      case MyDialogAnimation.slideTopBottom:
        final curvedValue = curve.transform(animation.value) - 1.0;

        return Transform(
          transform: Matrix4.translationValues(0, curvedValue * 300, 0),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for scaling the dialog.
      case MyDialogAnimation.scale:
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation.drive(Tween<double>(begin: 0.7, end: 1)),
            curve: curve,
            reverseCurve: reverseCurve,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );

      // Animation for sliding the dialog from bottom to top.
      case MyDialogAnimation.slideBottomTop:
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for sliding the dialog from left to right.
      case MyDialogAnimation.slideLeftRight:
        return SlideTransition(
          position: Tween(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for sliding the dialog from right to left.
      case MyDialogAnimation.slideRightLeft:
        return SlideTransition(
          position: Tween(
            begin: Offset(-1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Default fade animation.
      case MyDialogAnimation.fadeIn:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}

/// Enum for Dialog Animation
enum MyDialogAnimation {
  scale,
  fadeIn,
  rotate,
  slideTopBottom,
  slideBottomTop,
  slideLeftRight,
  slideRightLeft,
}
