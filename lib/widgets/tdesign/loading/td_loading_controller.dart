import 'package:flutter/material.dart';
import 'td_loading.dart';

class TDLoadingController {
  TDLoadingController._();

  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

  static void show(
    BuildContext context, {
    Widget? child,
    TDLoadingSize size = TDLoadingSize.medium,
    TDLoadingIcon? icon = TDLoadingIcon.circle,
    Color? iconColor,
    String? text,
    Widget? refreshWidget,
    Color textColor = Colors.black,
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
              TDLoading(
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
