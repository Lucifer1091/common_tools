import 'package:flutter/material.dart';
import '../../../common_tools.dart';
import '../text/td_text.dart';
import 'td_tag_styles.dart';

/// Display label component, only display, internal state cannot be changed
/// Supported styles: square/rounded/semicircle/with close icon
///
class TDTag extends StatelessWidget {
  const TDTag(
    this.text, {
    this.theme,
    this.icon,
    this.iconWidget,
    this.textColor,
    this.backgroundColor,
    this.textStyle,
    this.fontWeight,
    this.style,
    this.size = TDTagSize.medium,
    this.padding,
    this.isOutline = false,
    this.shape = TDTagShape.square,
    this.isLight = false,
    this.disable = false,
    this.needCloseIcon = false,
    this.onCloseTap,
    this.overflow,
    this.fixedWidth,
    super.key,
  });

  final String text;

  final TDTagTheme? theme;

  final IconData? icon;

  final Widget? iconWidget;

  final Color? textColor;

  final Color? backgroundColor;

  final TextStyle? textStyle;

  final FontWeight? fontWeight;

  final TDTagStyle? style;

  final TDTagSize size;

  final EdgeInsets? padding;

  final bool isOutline;

  final TDTagShape shape;

  final bool isLight;

  final bool disable;

  final bool needCloseIcon;

  final TextOverflow? overflow;

  final GestureTapCallback? onCloseTap;

  final double? fixedWidth;

  @override
  Widget build(BuildContext context) {
    final innerStyle = _getInnerStyle(context);

    Widget child = TDText(
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
          GestureDetector(
            onTap: onCloseTap,
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.close,
                color: ThemeColors.neutral.shade700,
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

  Widget? getIcon(TDTagStyle innerStyle) {
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

  TDTagStyle _getInnerStyle(BuildContext context) {
    if (style != null) {
      return style!;
    }
    if (disable) {
      return TDTagStyle.generateDisableSelectStyle(isOutline, shape);
    }
    return isOutline
        ? TDTagStyle.generateOutlineStyleByTheme(context, theme, isLight, shape)
        : TDTagStyle.generateFillStyleByTheme(context, theme, isLight, shape);
  }

  TextStyle? _getFont(BuildContext context) {
    switch (size) {
      case TDTagSize.extraLarge:
        return context.bodyMedium;
      case TDTagSize.large:
        return context.bodyMedium;
      case TDTagSize.small:
        return context.labelMedium;
      case TDTagSize.medium:
      case TDTagSize.custom:
        return context.bodySmall;
    }
  }

  EdgeInsets _getPadding(double border) {
    var hPadding = 0.0;
    var vPadding = 0.0;
    switch (size) {
      case TDTagSize.extraLarge:
        hPadding = 16;
        vPadding = 9;
      case TDTagSize.large:
        hPadding = 8;
        vPadding = 3;
      case TDTagSize.medium:
        hPadding = 8;
        vPadding = 2;
      case TDTagSize.small:
        hPadding = 6;
        vPadding = 2;
      case TDTagSize.custom:
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
      case TDTagSize.extraLarge:
        return 16;
      case TDTagSize.large:
        return 16;
      case TDTagSize.medium:
        return 14;
      case TDTagSize.small:
        return 12;
      case TDTagSize.custom:
        return 14;
    }
  }
}
