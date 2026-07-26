import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../localization/my_translations.dart';
import '../../../overlays/my_overlay_scope.dart';
import './indicators/my_loader_icon.dart';
import './indicators/my_loader_options.dart';
import './my_loader.dart';

/// App-root-scoped controller for loading overlays.
class MyLoadingController {
  OverlayEntry? _entry;
  bool _disposed = false;

  bool get isShowing => _entry?.mounted ?? false;

  void show(
    BuildContext context, {
    Widget? child,
    MyLoaderSize size = MyLoaderSize.medium,
    MyLoaderIcon? icon,
    String? text,
    Widget? refreshWidget,
    Color? textColor,
    Axis axis = Axis.vertical,
    bool blurBackground = true,
    double opacity = 0.3,
    Color opacityColor = Colors.black,
  }) {
    if (_disposed || isShowing) return;

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      throw FlutterError(
        'MyLoadingController.show requires an Overlay above the context.',
      );
    }

    final translations = MyTranslations.of(context);
    _entry = OverlayEntry(
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: blurBackground
                      ? ImageFilter.blur(sigmaX: 1, sigmaY: 1)
                      : ImageFilter.blur(),
                  child: ColoredBox(
                    color: opacityColor.withValues(alpha: opacity),
                  ),
                ),
              ),
              Center(
                child:
                    child ??
                    MyLoader(
                      size: size,
                      icon: icon,
                      text: text ?? translations.loading,
                      textColor: textColor,
                      refreshWidget: refreshWidget,
                      axis: axis,
                    ),
              ),
            ],
          ),
        );
      },
    );
    overlay.insert(_entry!);
  }

  void dismiss() {
    final entry = _entry;
    _entry = null;
    if (entry?.mounted ?? false) {
      entry!
        ..remove()
        ..dispose();
    }
  }

  Future<T?> run<T>(
    BuildContext context, {
    required Future<T> Function() future,
    bool enabled = true,
    Widget? child,
    MyLoaderSize size = MyLoaderSize.medium,
    MyLoaderIcon? icon,
    String? text,
    Widget? refreshWidget,
    Color? textColor,
    Axis axis = Axis.vertical,
    bool blurBackground = true,
    double opacity = 0.3,
    Color opacityColor = Colors.black,
  }) async {
    if (enabled) {
      show(
        context,
        child: child,
        axis: axis,
        icon: icon,
        refreshWidget: refreshWidget,
        size: size,
        text: text,
        textColor: textColor,
        opacity: opacity,
        opacityColor: opacityColor,
        blurBackground: blurBackground,
      );
    }

    try {
      return await future();
    } finally {
      if (enabled) dismiss();
    }
  }

  void dispose() {
    if (_disposed) return;
    dismiss();
    _disposed = true;
  }
}

/// Backwards-friendly facade that resolves the app-scoped controller.
abstract final class MyLoadingOverlay {
  static MyLoadingController _controller(BuildContext context) {
    return MyOverlayScope.of(context).loading;
  }

  static void show(
    BuildContext context, {
    Widget? child,
    MyLoaderSize size = MyLoaderSize.medium,
    MyLoaderIcon? icon,
    String? text,
    Widget? refreshWidget,
    Color? textColor,
    Axis axis = Axis.vertical,
    bool blurBackground = true,
    double opacity = 0.3,
    Color opacityColor = Colors.black,
  }) {
    _controller(context).show(
      context,
      child: child,
      size: size,
      icon: icon,
      text: text,
      refreshWidget: refreshWidget,
      textColor: textColor,
      axis: axis,
      blurBackground: blurBackground,
      opacity: opacity,
      opacityColor: opacityColor,
    );
  }

  static void dismiss(BuildContext context) {
    _controller(context).dismiss();
  }

  static Future<T?> async<T>(
    BuildContext context, {
    required Future<T> Function() future,
    bool enabled = true,
    Widget? child,
    MyLoaderSize size = MyLoaderSize.medium,
    MyLoaderIcon? icon,
    String? text,
    Widget? refreshWidget,
    Color? textColor,
    Axis axis = Axis.vertical,
    bool blurBackground = true,
    double opacity = 0.3,
    Color opacityColor = Colors.black,
  }) {
    return _controller(context).run(
      context,
      future: future,
      enabled: enabled,
      child: child,
      size: size,
      icon: icon,
      text: text,
      refreshWidget: refreshWidget,
      textColor: textColor,
      axis: axis,
      blurBackground: blurBackground,
      opacity: opacity,
      opacityColor: opacityColor,
    );
  }
}
