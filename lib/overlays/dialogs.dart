part of 'overlays.dart';

/// Enum for Dialog Type
enum DialogType { confirmation, accept, delete, update, add, retry }

/// Enum for Dialog Animation
enum DialogAnimation {
  defaults,
  rotate,
  slideTopBottom,
  slideBottomTop,
  slideLeftRight,
  slideRightLeft,
  scale
}

class Dialogs {
  Dialogs._();

  static Future<dynamic> show<T>(
    BuildContext context, {
    required Widget content,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return content;
      },
    );
  }

  static Future<dynamic> alert(
    BuildContext context, {
    String? title,
    String? msg,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCloseButton = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Failed'),
          content: Text(msg ?? 'Something went wrong. Please try again later.'),
          actions: [
            if (showCloseButton)
              TextButton(onPressed: onCancel, child: const Text('Cancel')),
            if (onConfirm != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm.call();
                },
                child: const Text('Confirm'),
              ),
          ],
        );
      },
    );
  }

  /// dialog primary color
  Color getDialogPrimaryColor(
    BuildContext context,
    DialogType dialogType,
    Color? primaryColor,
  ) {
    if (primaryColor != null) return primaryColor;
    Color color;

    switch (dialogType) {
      case DialogType.delete:
        color = Colors.red;
        break;
      case DialogType.update:
        color = Colors.amber;
        break;
      case DialogType.confirmation:
      case DialogType.add:
      case DialogType.retry:
        color = Colors.blue;
        break;
      case DialogType.accept:
        color = Colors.green;
        break;
    }
    return color;
  }

  /// build positive text for dialog
  String getPositiveText(DialogType dialogType) {
    String positiveText = "";

    switch (dialogType) {
      case DialogType.confirmation:
        positiveText = "Yes";
        break;
      case DialogType.delete:
        positiveText = "Delete";
        break;
      case DialogType.update:
        positiveText = "Update";
        break;
      case DialogType.add:
        positiveText = "Add";
        break;
      case DialogType.accept:
        positiveText = "Accept";
        break;
      case DialogType.retry:
        positiveText = "Retry";
        break;
    }
    return positiveText;
  }

  /// Build title
  String getTitle(DialogType dialogType) {
    String titleText = "";

    switch (dialogType) {
      case DialogType.confirmation:
        titleText = "Are you sure want to perform this action?";
        break;
      case DialogType.delete:
        titleText = "Do you want to delete?";
        break;
      case DialogType.update:
        titleText = "Do you want to update?";
        break;
      case DialogType.add:
        titleText = "Do you want to add?";
        break;
      case DialogType.accept:
        titleText = "Do you want to accept?";
        break;
      case DialogType.retry:
        titleText = "Click to retry";
        break;
    }
    return titleText;
  }

  /// get icon for dialog
  Widget getIcon(DialogType dialogType, {double? size}) {
    Icon icon;

    switch (dialogType) {
      case DialogType.confirmation:
      case DialogType.retry:
      case DialogType.accept:
        icon = Icon(Icons.done, size: size ?? 20, color: Colors.white);
        break;
      case DialogType.delete:
        icon = Icon(Icons.delete_forever_outlined,
            size: size ?? 20, color: Colors.white);
        break;
      case DialogType.update:
        icon = Icon(Icons.edit, size: size ?? 20, color: Colors.white);
        break;
      case DialogType.add:
        icon = Icon(Icons.add, size: size ?? 20, color: Colors.white);
        break;
    }
    return icon;
  }

  /// Build center image for dialog
  Widget? getCenteredImage(
    BuildContext context,
    DialogType dialogType,
    Color? primaryColor,
  ) {
    Widget? widget;

    switch (dialogType) {
      case DialogType.confirmation:
        widget = Container(
          decoration: BoxDecoration(
            color: getDialogPrimaryColor(context, dialogType, primaryColor)
                .withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.warning_amber_rounded,
            color: getDialogPrimaryColor(context, dialogType, primaryColor),
            size: 40,
          ),
        );
        break;
      case DialogType.delete:
        widget = Container(
          decoration: BoxDecoration(
            color: getDialogPrimaryColor(context, dialogType, primaryColor)
                .withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.close,
            color: getDialogPrimaryColor(context, dialogType, primaryColor),
            size: 40,
          ),
        );
        break;
      case DialogType.update:
        widget = Container(
          decoration: BoxDecoration(
            color: getDialogPrimaryColor(context, dialogType, primaryColor)
                .withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.edit_outlined,
            color: getDialogPrimaryColor(context, dialogType, primaryColor),
            size: 40,
          ),
        );
        break;
      case DialogType.add:
      case DialogType.accept:
        widget = Container(
          decoration: BoxDecoration(
            color: getDialogPrimaryColor(context, dialogType, primaryColor)
                .withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.done_outline,
            color: getDialogPrimaryColor(context, dialogType, primaryColor),
            size: 40,
          ),
        );
        break;
      case DialogType.retry:
        widget = Container(
          decoration: BoxDecoration(
            color: getDialogPrimaryColor(
              context,
              dialogType,
              primaryColor,
            ).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(Icons.refresh_rounded,
              color: getDialogPrimaryColor(
                context,
                dialogType,
                primaryColor,
              ),
              size: 40),
        );
        break;
    }
    return widget;
  }

  /// placeholder for dialog
  Widget defaultPlaceHolder(
    BuildContext context,
    DialogType dialogType,
    double? height,
    double? width,
    Color? primaryColor, {
    Widget? child,
    ShapeBorder? shape,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: getDialogPrimaryColor(context, dialogType, primaryColor)
            .withOpacity(0.2),
      ),
      alignment: Alignment.center,
      child: child ?? getCenteredImage(context, dialogType, primaryColor),
    );
  }

  /// title for dialog
  Widget buildTitleWidget(
    BuildContext context,
    DialogType dialogType,
    Color? primaryColor,
    Widget? customCenterWidget,
    double height,
    double width,
    String? centerImage,
    ShapeBorder? shape,
  ) {
    if (customCenterWidget != null) {
      return Container(
        constraints: BoxConstraints(maxHeight: height, maxWidth: width),
        child: customCenterWidget,
      );
    } else {
      if (centerImage != null) {
        return Image.network(
          centerImage,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (_, object, stack) {
            return defaultPlaceHolder(
              context,
              dialogType,
              height,
              width,
              primaryColor,
              shape: shape,
            );
          },
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return defaultPlaceHolder(
              context,
              dialogType,
              height,
              width,
              primaryColor,
              shape: shape,
              // child: Loader(
              //   value: loadingProgress.expectedTotalBytes != null
              //       ? loadingProgress.cumulativeBytesLoaded /
              //           loadingProgress.expectedTotalBytes!
              //       : null,
              // ),
            );
          },
        );
      } else {
        return defaultPlaceHolder(
          context,
          dialogType,
          height,
          width,
          primaryColor,
          shape: shape,
        );
      }
    }
  }

  /// Widget wrapper for animated dialog transitions.
  Widget dialogAnimatedWrapperWidget({
    required Animation<double> animation,
    required Widget child,
    required DialogAnimation dialogAnimation,
    required Curve curve,
  }) {
    switch (dialogAnimation) {
      // Animation for rotating the dialog.
      case DialogAnimation.rotate:
        return Transform.rotate(
          angle: (animation.value * 360).degreesToRadians() ?? 0,
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for sliding the dialog from top to bottom.
      case DialogAnimation.slideTopBottom:
        final curvedValue = curve.transform(animation.value) - 1.0;

        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 300, 0.0),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for scaling the dialog.
      case DialogAnimation.scale:
        return Transform.scale(
          scale: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        );

      // Animation for sliding the dialog from bottom to top.
      case DialogAnimation.slideBottomTop:
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .chain(CurveTween(curve: curve))
              .animate(animation),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for sliding the dialog from left to right.
      case DialogAnimation.slideLeftRight:
        return SlideTransition(
          position: Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: curve))
              .animate(animation),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Animation for sliding the dialog from right to left.
      case DialogAnimation.slideRightLeft:
        return SlideTransition(
          position: Tween(begin: const Offset(-1, 0), end: Offset.zero)
              .chain(CurveTween(curve: curve))
              .animate(animation),
          child: Opacity(
            opacity: animation.value,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      // Default fade animation.
      case DialogAnimation.defaults:
        return FadeTransition(opacity: animation, child: child);
    }
  }

  /// show confirm dialog box
  Future<bool?> showConfirmDialogCustom(
    BuildContext context, {
    required Function(BuildContext) onAccept,
    String? title,
    String? subTitle,
    String? positiveText,
    String? negativeText,
    String? centerImage,
    Widget? customCenterWidget,
    Color? primaryColor,
    Color? positiveTextColor,
    Color? negativeTextColor,
    ShapeBorder? shape,
    Function(BuildContext)? onCancel,
    bool barrierDismissible = true,
    double? height,
    double? width,
    bool cancelable = true,
    Color? barrierColor,
    DialogType dialogType = DialogType.confirmation,
    DialogAnimation dialogAnimation = DialogAnimation.defaults,
    Duration? transitionDuration,
    Curve curve = Curves.easeInBack,
  }) async {
    context.hideKeyboard();

    return await showGeneralDialog(
      context: context,
      barrierColor: barrierColor ?? Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      transitionDuration: transitionDuration ?? 400.milliseconds,
      transitionBuilder: (_, animation, secondaryAnimation, child) {
        return dialogAnimatedWrapperWidget(
          animation: animation,
          dialogAnimation: dialogAnimation,
          curve: curve,
          child: child,
          // child: AlertDialog(
          //   shape: shape ?? dialogShape(),
          //   titlePadding: EdgeInsets.zero,
          //   backgroundColor: _.cardColor,
          //   elevation: defaultElevation.toDouble(),
          //   title: buildTitleWidget(
          //     _,
          //     dialogType,
          //     primaryColor,
          //     customCenterWidget,
          //     height ?? customDialogHeight,
          //     width ?? customDialogWidth,
          //     centerImage,
          //     shape,
          //   ).cornerRadiusWithClipRRectOnly(
          //       topLeft: defaultRadius.toInt(),
          //       topRight: defaultRadius.toInt()),
          //   content: Container(
          //     width: width ?? customDialogWidth,
          //     color: Colors.transparent,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           title ?? getTitle(dialogType),
          //           style: boldTextStyle(size: 16),
          //           textAlign: TextAlign.center,
          //         ),
          //         8.height.visible(subTitle.validate().isNotEmpty),
          //         Text(
          //           subTitle.validate(),
          //           style: secondaryTextStyle(size: 16),
          //           textAlign: TextAlign.center,
          //         ).visible(subTitle.validate().isNotEmpty),
          //         16.height,
          //         Row(
          //           children: [
          //             AppButton(
          //               elevation: 0,
          //               shapeBorder: RoundedRectangleBorder(
          //                 borderRadius: radius(defaultAppButtonRadius),
          //                 side: BorderSide(color: viewLineColor),
          //               ),
          //               color: _.cardColor,
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Icon(
          //                     Icons.close,
          //                     color: textPrimaryColorGlobal,
          //                     size: 20,
          //                   ),
          //                   6.width,
          //                   Text(
          //                     negativeText ?? 'Cancel',
          //                     style: boldTextStyle(
          //                         color: negativeTextColor ??
          //                             textPrimaryColorGlobal),
          //                   ),
          //                 ],
          //               ).fit(),
          //               onTap: () {
          //                 if (cancelable) finish(_, false);
          //
          //                 onCancel?.call(_);
          //               },
          //             ).expand(),
          //             16.width,
          //             AppButton(
          //               elevation: 0,
          //               color:
          //                   getDialogPrimaryColor(_, dialogType, primaryColor),
          //               shapeBorder: RoundedRectangleBorder(
          //                 borderRadius: radius(defaultAppButtonRadius),
          //               ),
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   getIcon(dialogType),
          //                   6.width,
          //                   Text(
          //                     positiveText ?? getPositiveText(dialogType),
          //                     style: boldTextStyle(
          //                         color: positiveTextColor ?? Colors.white),
          //                   ),
          //                 ],
          //               ).fit(),
          //               onTap: () {
          //                 onAccept.call(_);
          //
          //                 if (cancelable) finish(_, true);
          //               },
          //             ).expand(),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
