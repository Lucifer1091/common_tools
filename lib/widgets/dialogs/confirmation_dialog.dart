import 'dart:math';

import 'package:flutter/material.dart';

import '../../common_tools.dart';
import '../buttons/app_button.dart';
import '../layout/spaces.dart';
import 'center_loading.dart';

/// Enum for Dialog Type
enum DialogType { CONFIRMATION, ACCEPT, DELETE, UPDATE, ADD, RETRY }

/// Enum for Dialog Animation
enum DialogAnimation {
  DEFAULT,
  ROTATE,
  SLIDE_TOP_BOTTOM,
  SLIDE_BOTTOM_TOP,
  SLIDE_LEFT_RIGHT,
  SLIDE_RIGHT_LEFT,
  SCALE,
}

/// dialog primary color
Color getDialogPrimaryColor(
  BuildContext context,
  DialogType dialogType,
  Color? primaryColor,
) {
  if (primaryColor != null) return primaryColor;

  return switch (dialogType) {
    DialogType.DELETE => Colors.red,
    DialogType.UPDATE => Colors.amber,
    DialogType.CONFIRMATION ||
    DialogType.ADD ||
    DialogType.RETRY => Colors.blue,
    DialogType.ACCEPT => Colors.green,
  };
}

/// build positive text for dialog
String getPositiveText(DialogType dialogType) {
  return switch (dialogType) {
    DialogType.CONFIRMATION => 'Yes',
    DialogType.DELETE => 'Delete',
    DialogType.UPDATE => 'Update',
    DialogType.ADD => 'Add',
    DialogType.ACCEPT => 'Accept',
    DialogType.RETRY => 'Retry',
  };
}

/// Build title
String getTitle(DialogType dialogType) {
  return switch (dialogType) {
    DialogType.CONFIRMATION => 'Are you sure want to perform this action?',
    DialogType.DELETE => 'Do you want to delete?',
    DialogType.UPDATE => 'Do you want to update?',
    DialogType.ADD => 'Do you want to add?',
    DialogType.ACCEPT => 'Do you want to accept?',
    DialogType.RETRY => 'Click to retry',
  };
}

/// get icon for dialog
Widget getIcon(DialogType dialogType, {double? size}) {
  return switch (dialogType) {
    DialogType.CONFIRMATION || DialogType.RETRY || DialogType.ACCEPT => Icon(
      Icons.done,
      size: size ?? 20,
      color: Colors.white,
    ),
    DialogType.DELETE => Icon(
      Icons.delete_forever_outlined,
      size: size ?? 20,
      color: Colors.white,
    ),
    DialogType.UPDATE => Icon(
      Icons.edit,
      size: size ?? 20,
      color: Colors.white,
    ),
    DialogType.ADD => Icon(Icons.add, size: size ?? 20, color: Colors.white),
  };
}

/// Build center image for dialog
Widget? getCenteredImage(
  BuildContext context,
  DialogType dialogType,
  Color? primaryColor,
) {
  Widget? widget;

  switch (dialogType) {
    case DialogType.CONFIRMATION:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.warning_amber_rounded,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
    case DialogType.DELETE:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.close,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
    case DialogType.UPDATE:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.edit_outlined,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
    case DialogType.ADD:
    case DialogType.ACCEPT:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.done_outline,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
    case DialogType.RETRY:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.refresh_rounded,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
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
      color: getDialogPrimaryColor(
        context,
        dialogType,
        primaryColor,
      ).withValues(alpha: 0.2),
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
            child: CenterLoading.custom(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            ),
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

void hideKeyboard(BuildContext context) =>
    FocusScope.of(context).requestFocus(FocusNode());

/// show confirm dialog box
Future<bool?> showConfirmDialogCustom(
  BuildContext context, {
  required ContextCallback onAccept,
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
  ContextCallback? onCancel,
  bool barrierDismissible = true,
  double? height,
  double? width,
  bool cancelable = true,
  Color? barrierColor,
  DialogType dialogType = DialogType.CONFIRMATION,
  DialogAnimation dialogAnimation = DialogAnimation.DEFAULT,
  Duration? transitionDuration,
  Curve curve = Curves.easeInBack,
}) async {
  hideKeyboard(context);

  return showGeneralDialog(
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
        child: AlertDialog(
          shape: shape ?? dialogShape(),
          titlePadding: EdgeInsets.zero,
          backgroundColor: context.secondary,
          elevation: defaultElevation.toDouble(),
          title: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.toDouble()),
              topRight: Radius.circular(8.toDouble()),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: buildTitleWidget(
              context,
              dialogType,
              primaryColor,
              customCenterWidget,
              height ?? customDialogHeight,
              width ?? customDialogWidth,
              centerImage,
              shape,
            ),
          ),
          content: Container(
            width: width ?? customDialogWidth,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? getTitle(dialogType),
                  style: context.bodyMedium?.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Space.h8().showIfOrEmpty(subTitle.isNotBlank),
                Text(
                  subTitle.getOrDefault(''),
                  style: context.bodySmall?.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ).showIfOrEmpty(subTitle.isNotBlank),
                Space.h16(),
                Row(
                  children: [
                    AppButton(
                      elevation: 0,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultAppButtonRadius),
                        side: BorderSide(color: Color(0xFFEAEAEA)),
                      ),
                      color: context.secondary,
                      child:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.close,
                                color: textPrimaryColorGlobal,
                                size: 20,
                              ),
                              Space.w(6),
                              Text(
                                negativeText ?? 'Cancel',
                                style: context.bodyMedium?.copyWith(
                                  color:
                                      negativeTextColor ??
                                      textPrimaryColorGlobal,
                                ),
                              ),
                            ],
                          ).fit(),
                      onTap: () {
                        if (cancelable) Navigator.of(context).pop(false);

                        onCancel?.call(context);
                      },
                    ).expanded(),
                    Space.h16(),
                    AppButton(
                      elevation: 0,
                      color: getDialogPrimaryColor(
                        context,
                        dialogType,
                        primaryColor,
                      ),
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultAppButtonRadius),
                      ),
                      child:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              getIcon(dialogType),
                              Space.w(6),
                              Text(
                                positiveText ?? getPositiveText(dialogType),
                                style: context.bodyMedium?.copyWith(
                                  color: positiveTextColor ?? Colors.white,
                                ),
                              ),
                            ],
                          ).fit(),
                      onTap: () {
                        onAccept.call(context);

                        if (cancelable) Navigator.of(context).pop(true);
                      },
                    ).expanded(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// returns Radius
BorderRadius radius([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? 8));
}

/// returns Radius
Radius radiusCircular([double? radius]) {
  return Radius.circular(radius ?? 8);
}

ShapeBorder dialogShape([double? borderRadius]) {
  return RoundedRectangleBorder(borderRadius: radius(borderRadius ?? 8));
}

/// Converts degrees to radians.
const double degrees2Radians = pi / 180.0;

/// Converts degrees to radians.
double radians(double degrees) => degrees * degrees2Radians;

/// Widget wrapper for animated dialog transitions.
Widget dialogAnimatedWrapperWidget({
  required Animation<double> animation,
  required Widget child,
  required DialogAnimation dialogAnimation,
  required Curve curve,
}) {
  switch (dialogAnimation) {
    // Animation for rotating the dialog.
    case DialogAnimation.ROTATE:
      return Transform.rotate(
        angle: radians(animation.value * 360),
        child: Opacity(
          opacity: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );

    // Animation for sliding the dialog from top to bottom.
    case DialogAnimation.SLIDE_TOP_BOTTOM:
      final curvedValue = curve.transform(animation.value) - 1.0;

      return Transform(
        transform: Matrix4.translationValues(0, curvedValue * 300, 0),
        child: Opacity(
          opacity: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );

    // Animation for scaling the dialog.
    case DialogAnimation.SCALE:
      return Transform.scale(
        scale: animation.value,
        child: FadeTransition(opacity: animation, child: child),
      );

    // Animation for sliding the dialog from bottom to top.
    case DialogAnimation.SLIDE_BOTTOM_TOP:
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
    case DialogAnimation.SLIDE_LEFT_RIGHT:
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
    case DialogAnimation.SLIDE_RIGHT_LEFT:
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
    case DialogAnimation.DEFAULT:
      return FadeTransition(opacity: animation, child: child);
  }
}

/// Enum representing types of bottom sheet dialogs.
enum BottomSheetDialog { Dialog, BottomSheet }

/// Shows a bottom sheet or a dialog based on the specified type.
Future<dynamic> showBottomSheetOrDialog({
  required BuildContext context,
  required Widget child,
  BottomSheetDialog bottomSheetDialog = BottomSheetDialog.Dialog,
}) {
  if (bottomSheetDialog == BottomSheetDialog.BottomSheet) {
    // Show a bottom sheet.
    return showModalBottomSheet(context: context, builder: (_) => child);
  } else {
    // Show a dialog.
    return showInDialog(context, builder: (_) => child);
  }
}

/// show confirm dialog box
Future<bool?> showConfirmDialog<bool>(
  BuildContext context,
  String title, {
  String positiveText = 'Yes',
  String negativeText = 'No',
  Color? buttonColor,
  Color? barrierColor,
  bool? barrierDismissible,
  VoidCallback? onAccept,
}) async {
  return showDialog(
    context: context,
    // barrierDismissible: barrierDismissible ?? false,
    builder:
        (_) => AlertDialog(
          title: Text(title, style: context.bodyMedium),
          actions: <Widget>[
            SimpleDialogOption(
              child: Text(negativeText, style: context.bodySmall),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(true);

                onAccept?.call();
              },
              child: Text(
                positiveText.getOrDefault(''),
                style: context.bodyMedium?.copyWith(
                  color: buttonColor ?? Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
  );
}

/// show child widget in dialog
Future<T?> showInDialog<T>(
  BuildContext context, {
  Widget? title,
  @Deprecated('Use builder instead') Widget? child,
  Widget? Function(BuildContext)? builder,
  ShapeBorder? shape,
  TextStyle? titleTextStyle,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsets? insetPadding,
  // bool scrollable = false,
  Color? backgroundColor,
  DialogAnimation dialogAnimation = DialogAnimation.DEFAULT,
  double? elevation,
  Color? barrierColor,
  // EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  List<Widget>? actions,
  bool barrierDismissible = true,
  bool hideSoftKeyboard = true,
  Duration? transitionDuration,
  Curve curve = Curves.easeInBack,
}) async {
  if (hideSoftKeyboard) hideKeyboard(context);

  return showGeneralDialog<T>(
    context: context,
    barrierColor: barrierColor ?? Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    barrierLabel: '',
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration ?? 400.milliseconds,
    transitionBuilder: (_, animation, secondaryAnimation, c) {
      return dialogAnimatedWrapperWidget(
        animation: animation,
        dialogAnimation: dialogAnimation,
        curve: curve,
        child: AlertDialog(
          content: builder != null ? builder.call(context) : child,
          shape: shape ?? dialogShape(8),
          title: title,
          titleTextStyle: titleTextStyle,
          contentPadding: contentPadding ?? EdgeInsets.fromLTRB(24, 20, 24, 24),
          //scrollable: scrollable,
          backgroundColor: backgroundColor,
          insetPadding: insetPadding,
          elevation: elevation ?? defaultElevation.toDouble(),
          //insetPadding: insetPadding,
          actions: actions,
        ),
      );
    },
  );
}

var customDialogHeight = 140.0;
var customDialogWidth = 220.0;

//region Global variables - This variables can be changed.
Color textPrimaryColorGlobal = Colors.red;
Color textSecondaryColorGlobal = Colors.blue;
double textBoldSizeGlobal = 16;
double textPrimarySizeGlobal = 16;
double textSecondarySizeGlobal = 14;
String? fontFamilyBoldGlobal;
String? fontFamilyPrimaryGlobal;
String? fontFamilySecondaryGlobal;
FontWeight fontWeightBoldGlobal = FontWeight.bold;
FontWeight fontWeightPrimaryGlobal = FontWeight.normal;
FontWeight fontWeightSecondaryGlobal = FontWeight.normal;

Color appBarBackgroundColorGlobal = Colors.white;
Color appButtonBackgroundColorGlobal = Colors.white;
Color defaultAppButtonTextColorGlobal = textPrimaryColorGlobal;
double defaultAppButtonRadius = 8;
double defaultAppButtonElevation = 4;
double defaultAppButtonFocusElevation = 4;
double defaultAppButtonHighlightElevation = 4;
double defaultAppButtonHoverElevation = 4;
bool enableAppButtonScaleAnimationGlobal = true;
int? appButtonScaleAnimationDurationGlobal;
ShapeBorder? defaultAppButtonShapeBorder;

Color defaultLoaderBgColorGlobal = Colors.white;
Color? defaultLoaderAccentColorGlobal;

Color? defaultInkWellSplashColor;
Color? defaultInkWellHoverColor;
Color? defaultInkWellHighlightColor;
double? defaultInkWellRadius;

Color shadowColorGlobal = Colors.grey.withValues(alpha: 0.2);
int defaultElevation = 4;
double defaultRadius = 8;
double defaultBlurRadius = 4;
double defaultSpreadRadius = 1;
double defaultAppBarElevation = 4;

double? maxScreenWidth;

double tabletBreakpointGlobal = 600;
double desktopBreakpointGlobal = 720;

int passwordLengthGlobal = 6;

/// If forceEnableDebug if true, you will be able to see log in the logcat in release build also.
/// By default, your log will not seen in logcat in release mode.
bool forceEnableDebug = false;

bool isMaskingEnabledGlobal = true;

// Toast Config
Color defaultToastBackgroundColor = Colors.grey.shade200;
Color defaultToastTextColor = Colors.black;
