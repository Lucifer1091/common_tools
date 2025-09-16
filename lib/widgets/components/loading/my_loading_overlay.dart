import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyLoadingOverlay {
  MyLoadingOverlay._();

  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

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
    if (_isShowing) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Background
              Positioned.fill(
                child: BackdropFilter(
                  filter:
                      blurBackground
                          ? ImageFilter.blur(sigmaX: 1, sigmaY: 1)
                          : ImageFilter.blur(),
                  child: Container(
                    color: opacityColor.withValues(alpha: opacity),
                  ),
                ),
              ),

              // Center Loader
              Center(
                child:
                    child ??
                    MyLoader(
                      size: size,
                      icon: icon,
                      text: text,
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

    _context = context;

    if (_context == null || _overlayEntry == null) return;

    _isShowing = true;
    Overlay.of(_context!).insert(_overlayEntry!);
  }

  static void dismiss() {
    if (_isShowing) {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
      _isShowing = false;
    }
  }

  /// Run async function with overlay
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

    T? result;
    try {
      result = await future();
    } catch (e, s) {
      debugPrint('LoadingOverlay error: $e\n$s');
    } finally {
      if (enabled) dismiss();
    }

    return result;
  }
}
