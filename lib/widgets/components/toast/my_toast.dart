import 'dart:collection' show Queue;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

part 'my_toast_impl.dart';

class MyToast {
  MyToast._();

  static ToastController show({
    required Widget title,
    BuildContext? context,
    OverlayState? overlayState,
    Widget? leading,
    Widget? trailing,
    SlidingToastSetting? toastSetting,
    ToastStyle? toastStyle,
    void Function()? onDisposed,
    void Function()? onTapped,
  }) {
    return _MyToastImpl.slide(
      title: title,
      context: context,
      overlayState: overlayState,
      leading: leading,
      trailing: trailing,
      toastSetting: toastSetting ?? _setting,
      toastStyle: toastStyle ?? _style,
      onDisposed: onDisposed,
      onTapped: onTapped,
    );
  }

  static void success({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.circleCheckBig,
      color: MyColors.success,
    );
  }

  static void info({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.info,
      color: MyColors.blue,
    );
  }

  static void warning({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.triangleAlert,
      color: MyColors.warning,
    );
  }

  static void error({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.circleX,
      color: MyColors.error,
    );
  }

  static void _default({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
    IconData? icon,
    Color? color,
  }) {
    show(
      context: context,
      leading: icon != null ? Icon(icon, color: color).padding(right: 8) : null,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            MyText(
              title,
              style: (context ?? _MyToastImpl._context)?.titleSmall,
            ),
          if (subtitle != null)
            MyText(
              subtitle,
              style: (context ?? _MyToastImpl._context)?.bodySmall,
            ),
        ],
      ),
      trailing: action,
      toastSetting: _setting.copyWith(displayDuration: duration),
      toastStyle: _style.copyWith(progressBarColor: color),
    );
  }

  static void closeAll() {
    _MyToastImpl.closeAll();
  }

  // Global settings
  static SlidingToastSetting _setting = const SlidingToastSetting();
  static ToastStyle _style = const ToastStyle();

  static void init({
    BuildContext? context,
    OverlayState? overlayState,
    SlidingToastSetting? setting,
    ToastStyle? style,
  }) {
    if (context != null) _MyToastImpl.context = context;
    if (overlayState != null) _MyToastImpl.overlayState = overlayState;
    _setting = setting ?? _setting;
    _style = style ?? _style;
  }
}
