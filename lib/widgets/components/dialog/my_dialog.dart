import 'dart:math';

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyDialog {
  MyDialog._();

  static const Duration animationDuration = Duration(milliseconds: 150);

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Duration? duration,
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
        Widget? animate;

        if (dialogAnimation != MyDialogAnimation.none) {
          animate = dialogAnimatedWrapperWidget(
            animation: animation,
            dialogAnimation: dialogAnimation,
            child: child,
          );
        }

        return FocusScope(
          canRequestFocus: animation.value == 1,
          child: animate ?? child,
        );
      },
      pageBuilder: (_, _, child) {
        var content = builder.call(context);

        if (draggable) content = MyDraggableDialog(child: content);

        return content;
      },
    );
  }

  // static Future<T?> responsive<T>({
  //   Duration? duration,
  //   double? width,
  //   double? height,
  //   Alignment? alignment,
  //   bool barrierDismissible = true,
  //   required Widget content,
  // }) async {
  //   return await showGeneralDialog(
  //     context: Get.context!,
  //     barrierLabel: '',
  //     barrierDismissible: barrierDismissible,
  //     transitionDuration: duration ?? animationDuration,
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return PanaraAnimations.grow(animation, secondaryAnimation, child);
  //     },
  //     pageBuilder: (animation, secondaryAnimation, child) {
  //       return _AnimatedResponsiveDialog(
  //         content: content,
  //         alignment: alignment,
  //         width: width,
  //         height: height,
  //       );
  //     },
  //   );
  // }

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
      case MyDialogAnimation.none:
        return child;
    }
  }
}

/// Enum for Dialog Animation
enum MyDialogAnimation {
  none,
  scale,
  fadeIn,
  rotate,
  slideTopBottom,
  slideBottomTop,
  slideLeftRight,
  slideRightLeft,
}

// class _AnimatedResponsiveDialog extends StatefulWidget {
//   final Widget content;
//   final Alignment? alignment;
//   final double? width;
//   final double? height;

//   const _AnimatedResponsiveDialog({
//     required this.content,
//     this.alignment,
//     this.width,
//     this.height,
//   });

//   @override
//   State<_AnimatedResponsiveDialog> createState() =>
//       _AnimatedResponsiveDialogState();
// }

// class _AnimatedResponsiveDialogState extends State<_AnimatedResponsiveDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final size = constraints.biggest;
//           final isMobile = Responsive.isMobileOrMobileLarge;

//           return Dialog(
//             insetPadding:
//                 isMobile
//                     ? EdgeInsets.zero
//                     : const EdgeInsets.symmetric(horizontal: Sizes.PADDING_16),
//             alignment: widget.alignment,
//             backgroundColor: isMobile ? Colors.transparent : AppColors.primary,
//             shape:
//                 isMobile
//                     ? null
//                     : RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(Sizes.RADIUS_32),
//                     ),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               width: isMobile ? size.width : widget.width ?? 500,
//               height: isMobile ? size.height : widget.height ?? 400,
//               margin:
//                   isMobile
//                       ? null
//                       : const EdgeInsets.only(left: Sizes.PADDING_8),
//               decoration: BoxDecoration(
//                 color: Get.context?.onSurfaceVariant,
//                 borderRadius:
//                     isMobile ? null : BorderRadius.circular(Sizes.RADIUS_30),
//               ),
//               child: ClipRRect(
//                 borderRadius:
//                     isMobile
//                         ? BorderRadiusGeometry.zero
//                         : BorderRadius.circular(Sizes.RADIUS_30),
//                 child: widget.content,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
