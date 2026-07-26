import 'dart:collection' show Queue;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../extensions/context/typography.dart';
import '../../../extensions/widget.dart';
import '../../../overlays/my_overlay_scope.dart';
import '../../../themes/my_colors.dart';
import '../../../utilities/guid.dart';
import '../text/my_text.dart';
import './enums/toast_position.dart';
import './models/sliding_toast_setting.dart';
import './models/toast_controller.dart';
import './models/toast_style.dart';
import './views/toast_slider.dart';

part 'my_toast_impl.dart';

/// App-root-scoped owner for toast configuration and overlay entries.
class MyToastController {
  MyToastController({
    this._setting = MyToast.defaultSetting,
    this._style = MyToast.defaultStyle,
  });

  SlidingToastSetting _setting;
  ToastStyle _style;
  final Set<ToastController> _ownedToasts = <ToastController>{};
  bool _disposed = false;

  SlidingToastSetting get setting => _setting;
  ToastStyle get style => _style;

  void configure({SlidingToastSetting? setting, ToastStyle? style}) {
    if (_disposed) return;
    _setting = setting ?? _setting;
    _style = style ?? _style;
  }

  ToastController show({
    required BuildContext context,
    required Widget title,
    OverlayState? overlayState,
    Widget? leading,
    Widget? trailing,
    SlidingToastSetting? toastSetting,
    ToastStyle? toastStyle,
    VoidCallback? onDisposed,
    VoidCallback? onTapped,
  }) {
    if (_disposed) return ToastController.empty();

    late final ToastController controller;
    controller = _MyToastImpl.slide(
      title: title,
      context: context,
      overlayState: overlayState,
      leading: leading,
      trailing: trailing,
      toastSetting: toastSetting ?? _setting,
      toastStyle: toastStyle ?? _style,
      onDisposed: () {
        _ownedToasts.remove(controller);
        onDisposed?.call();
      },
      onTapped: onTapped,
    );
    if (controller.id.isNotEmpty) _ownedToasts.add(controller);
    return controller;
  }

  void closeAll() {
    for (final toast in _ownedToasts.toList(growable: false)) {
      toast.close();
    }
    _ownedToasts.clear();
  }

  void dispose() {
    if (_disposed) return;
    closeAll();
    _disposed = true;
  }
}

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
    final scopedController = context == null
        ? null
        : MyOverlayScope.maybeOf(context)?.toast;
    if (scopedController != null) {
      return scopedController.show(
        context: context!,
        title: title,
        overlayState: overlayState,
        leading: leading,
        trailing: trailing,
        toastSetting: toastSetting,
        toastStyle: toastStyle,
        onDisposed: onDisposed,
        onTapped: onTapped,
      );
    }

    return _MyToastImpl.slide(
      title: title,
      context: context,
      overlayState: overlayState,
      leading: leading,
      trailing: trailing,
      toastSetting: toastSetting ?? defaultSetting,
      toastStyle: toastStyle ?? defaultStyle,
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
    final controller = context == null
        ? null
        : MyOverlayScope.maybeOf(context)?.toast;
    final setting = controller?.setting ?? defaultSetting;
    final style = controller?.style ?? defaultStyle;
    show(
      context: context,
      leading: icon != null ? Icon(icon, color: color).padding(right: 8) : null,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) MyText(title, style: context?.titleSmall),
          if (subtitle != null) MyText(subtitle, style: context?.bodySmall),
        ],
      ),
      trailing: action,
      toastSetting: setting.copyWith(
        displayDuration: duration,
        showProgressBar: showProgressBar,
        toastAlignment: toastAlignment,
        toastStartPosition: _getStartPosition(toastAlignment),
      ),
      toastStyle: style.copyWith(progressBarColor: color),
    );
  }

  static void closeAll(BuildContext context) {
    MyOverlayScope.of(context).toast.closeAll();
  }

  static const SlidingToastSetting defaultSetting = SlidingToastSetting(
    toastAlignment: Alignment.topCenter,
    toastStartPosition: ToastPosition.top,
  );
  static const ToastStyle defaultStyle = ToastStyle();

  static void init({
    required BuildContext context,
    SlidingToastSetting? setting,
    ToastStyle? style,
  }) {
    MyOverlayScope.of(context).toast.configure(setting: setting, style: style);
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
