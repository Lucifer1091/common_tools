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

  static void simple({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
    Alignment? toastAlignment,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      showProgressBar: false,
      toastAlignment: toastAlignment,
    );
  }

  static void success({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
    Alignment? toastAlignment,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.circleCheckBig,
      color: MyColors.success,
      toastAlignment: toastAlignment,
    );
  }

  static void info({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
    Alignment? toastAlignment,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.info,
      color: MyColors.blue,
      toastAlignment: toastAlignment,
    );
  }

  static void warning({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
    Alignment? toastAlignment,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.triangleAlert,
      color: MyColors.warning,
      toastAlignment: toastAlignment,
    );
  }

  static void error({
    BuildContext? context,
    String? title,
    String? subtitle,
    Duration? duration,
    Widget? action,
    Alignment? toastAlignment,
  }) {
    _default(
      context: context,
      title: title,
      subtitle: subtitle,
      duration: duration,
      action: action,
      icon: LucideIcons.circleX,
      color: MyColors.error,
      toastAlignment: toastAlignment,
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
    bool showProgressBar = true,
    Alignment? toastAlignment,
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
      toastSetting: _setting.copyWith(
        displayDuration: duration,
        showProgressBar: showProgressBar,
        toastAlignment: toastAlignment,
        toastStartPosition: _getStartPosition(toastAlignment),
      ),
      toastStyle: _style.copyWith(progressBarColor: color),
    );
  }

  static void closeAll() {
    _MyToastImpl.closeAll();
  }

  // Global settings
  static SlidingToastSetting _setting = const SlidingToastSetting(
    toastAlignment: Alignment.topCenter,
    toastStartPosition: ToastPosition.top,
  );
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

  static ToastPosition _getStartPosition(Alignment? align) {
    return switch (align) {
      Alignment.bottomLeft ||
      Alignment.bottomRight ||
      Alignment.bottomCenter => ToastPosition.bottom,
      Alignment.topLeft ||
      Alignment.topRight ||
      Alignment.topCenter => ToastPosition.top,
      Alignment.centerLeft => ToastPosition.left,
      Alignment.centerRight => ToastPosition.right,
      _ => ToastPosition.top,
    };
  }
}
