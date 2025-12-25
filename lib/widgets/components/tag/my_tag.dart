import 'package:flutter/material.dart';
import '../../../index.dart';

/// Display label component, only display, internal state cannot be changed
/// Supported styles: square/rounded/semicircle/with close icon
///
class MyTag extends StatelessWidget {
  const MyTag(
    this.text, {
    this.theme,
    this.icon,
    this.iconWidget,
    this.textColor,
    this.backgroundColor,
    this.textStyle,
    this.fontWeight,
    this.style,
    this.size = MyTagSize.medium,
    this.padding,
    this.isOutline = false,
    this.shape = MyTagShape.square,
    this.disable = false,
    this.needCloseIcon = false,
    this.onCloseTap,
    this.overflow,
    this.fixedWidth,
    super.key,
  });

  final String text;
  final MyTagTheme? theme;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? textColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final FontWeight? fontWeight;
  final MyTagStyle? style;
  final MyTagSize size;
  final EdgeInsets? padding;
  final bool isOutline;
  final MyTagShape shape;
  final bool disable;
  final bool needCloseIcon;
  final TextOverflow? overflow;
  final GestureTapCallback? onCloseTap;
  final double? fixedWidth;

  @override
  Widget build(BuildContext context) {
    final innerStyle = _getInnerStyle(context);

    Widget child = MyText(
      text,
      overflow: overflow ?? TextOverflow.ellipsis,
      textColor: textColor ?? innerStyle.getTextColor,
      style: textStyle ?? innerStyle.style ?? _getFont(context),
      fontWeight: fontWeight ?? innerStyle.fontWeight,
    );

    final innerIcon = getIcon(innerStyle);

    if (innerIcon != null || needCloseIcon) {
      final children = <Widget>[];
      if (innerIcon != null) {
        children.add(
          Container(
            margin: const EdgeInsets.only(right: 4),
            width: 14,
            height: 14,
            child: innerIcon,
          ),
        );
      }
      children.add(child);
      if (needCloseIcon) {
        children.add(
          MyGestureDetector(
            onTap: onCloseTap,
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.close_rounded,
                color: _getInnerStyle(context).textColor,
                size: 14,
              ),
            ),
          ),
        );
      }
      child = Row(mainAxisSize: MainAxisSize.min, children: children);
    }

    return Container(
      width: fixedWidth,
      padding: padding ?? _getPadding(innerStyle.border),
      decoration: BoxDecoration(
        color: backgroundColor ?? innerStyle.getBackgroundColor,
        border: Border.all(
          width: innerStyle.border,
          color: innerStyle.getBorderColor,
        ),
        borderRadius: innerStyle.getBorderRadius,
      ),
      child: Align(widthFactor: 1, child: child),
    );
  }

  Widget? getIcon(MyTagStyle innerStyle) {
    if (iconWidget != null) return iconWidget;

    if (icon != null) {
      return RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color: innerStyle.textColor,
            height: 1,
            fontSize: _getIconSize(),
            fontFamily: icon!.fontFamily,
            package: icon!.fontPackage,
          ),
        ),
      );
    }
    return null;
  }

  MyTagStyle _getInnerStyle(BuildContext context) {
    if (style != null) return style!;

    if (disable) {
      return MyTagStyle.generateDisableSelectStyle(context, isOutline, shape);
    }

    return isOutline
        ? MyTagStyle.generateOutlineStyleByTheme(context, theme, shape)
        : MyTagStyle.generateFillStyleByTheme(context, theme, shape);
  }

  TextStyle? _getFont(BuildContext context) {
    switch (size) {
      case MyTagSize.extraLarge:
        return context.bodyMedium;
      case MyTagSize.large:
        return context.bodyMedium;
      case MyTagSize.small:
        return context.labelMedium;
      case MyTagSize.medium:
      case MyTagSize.custom:
        return context.bodySmall;
    }
  }

  EdgeInsets _getPadding(double border) {
    var hPadding = 0.0;
    var vPadding = 0.0;
    switch (size) {
      case MyTagSize.extraLarge:
        hPadding = 16;
        vPadding = 9;
      case MyTagSize.large:
        hPadding = 8;
        vPadding = 3;
      case MyTagSize.medium:
        hPadding = 8;
        vPadding = 2;
      case MyTagSize.small:
        hPadding = 6;
        vPadding = 2;
      case MyTagSize.custom:
        return EdgeInsets.zero;
    }

    if (hPadding >= border) {
      hPadding = hPadding - border;
    } else {
      hPadding = 0;
    }

    if (vPadding >= border) {
      vPadding = vPadding - border;
    } else {
      vPadding = 0;
    }

    return EdgeInsets.only(
      left: hPadding,
      right: hPadding,
      top: vPadding,
      bottom: vPadding,
    );
  }

  double _getIconSize() {
    switch (size) {
      case MyTagSize.extraLarge:
        return 16;
      case MyTagSize.large:
        return 16;
      case MyTagSize.medium:
        return 14;
      case MyTagSize.small:
        return 12;
      case MyTagSize.custom:
        return 14;
    }
  }
}
