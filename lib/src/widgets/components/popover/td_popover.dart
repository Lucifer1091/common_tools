import 'package:flutter/material.dart';

import 'td_popover_widget.dart';

class TDPopover {
  const TDPopover._();

  static Future<void> showPopover({
    required BuildContext context,
    String? content,
    Widget? contentWidget,
    double offset = 4,
    TDPopoverTheme? theme,
    bool closeOnClickOutside = true,
    TDPopoverPlacement? placement,
    bool? showArrow = true,
    double arrowSize = 8,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    Color? overlayColor = Colors.transparent,
    ValueChanged<String?>? onTap,
    ValueChanged<String?>? onLongTap,
  }) {
    return showDialog(
      barrierDismissible: closeOnClickOutside,
      barrierColor: overlayColor,
      useSafeArea: false,
      context: context,
      builder: (ctx) => TDPopoverWidget(
        context: context,
        content: content,
        contentWidget: contentWidget,
        offset: offset,
        theme: theme,
        placement: placement,
        showArrow: showArrow,
        arrowSize: arrowSize,
        padding: padding,
        width: width,
        height: height,
        onTap: onTap,
        onLongTap: onLongTap,
      ),
    );
  }
}
