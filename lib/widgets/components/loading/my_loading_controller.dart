import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../index.dart';

class LoadingOverlay {
  LoadingOverlay._();

  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext context, {
    Widget? loadingWidget,
    bool blurBackground = false,
    double opacity = 0.3,
    Color opacityColor = Colors.black,
  }) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Background
            Positioned.fill(
              child: BackdropFilter(
                filter:
                    blurBackground
                        ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                        : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  color: opacityColor.withValues(alpha: opacity),
                ),
              ),
            ),

            // Center Loader
            Center(
              child:
                  loadingWidget ??
                  const CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  /// Hide overlay
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Run async function with overlay
  static Future<T?> during<T>(
    BuildContext context,
    Future<T> Function() future, {
    Widget? loadingWidget,
    bool blurBackground = false,
  }) async {
    show(context, loadingWidget: loadingWidget, blurBackground: blurBackground);

    T? result;
    try {
      result = await future();
    } catch (e, s) {
      debugPrint('LoadingOverlay error: $e\n$s');
    } finally {
      hide();
    }

    return result;
  }
}

class MyLoadingController {
  MyLoadingController._();

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
  }) {
    if (_isShowing) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Center(
          child:
              child ??
              MyLoader(
                size: size,
                icon: icon,
                text: text ?? 'Loading...',
                textColor: textColor,
                refreshWidget: refreshWidget,
                axis: axis,
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
}
