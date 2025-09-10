import 'package:flutter/material.dart';
import '../../../index.dart';

class MyLoadingController {
  MyLoadingController._();

  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

  static void show(
    BuildContext context, {
    Widget? child,
    MyLoaderSize size = MyLoaderSize.medium,
    MyLoaderIcon? icon = MyLoaderIcon.circle,
    Color? iconColor,
    String? text,
    Widget? refreshWidget,
    Color? textColor,
    Axis axis = Axis.vertical,
    Widget? customIcon,
    int duration = 2000,
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
                customIcon: customIcon,
                text: text ?? 'Loading',
                textColor: textColor,
                refreshWidget: refreshWidget,
                duration: duration,
                iconColor: iconColor,
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
