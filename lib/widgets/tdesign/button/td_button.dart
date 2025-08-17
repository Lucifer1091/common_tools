import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';

enum TDButtonSize { large, medium, small, extraSmall }

enum TDButtonType { fill, outline, text, ghost }

enum TDButtonShape { rectangle, round, square, circle, filled }

enum TDButtonTheme { defaults, primary, danger, light }

enum TDButtonStatus { defaults, active, disable }

enum TDButtonIconPosition { left, right }

class TDButton extends StatefulWidget {
  const TDButton({
    super.key,
    this.text,
    this.size = TDButtonSize.medium,
    this.type = TDButtonType.fill,
    this.shape = TDButtonShape.rectangle,
    this.theme,
    this.child,
    this.disabled = false,
    this.isBlock = false,
    this.style,
    this.activeStyle,
    this.disableStyle,
    this.textStyle,
    this.disableTextStyle,
    this.width,
    this.height,
    this.onTap,
    this.icon,
    this.iconWidget,
    this.iconTextSpacing,
    this.onLongPress,
    this.margin,
    this.padding,
    this.iconPosition = TDButtonIconPosition.left,
  });

  final Widget? child;

  final String? text;

  final bool disabled;

  final double? width;

  final double? height;

  final TDButtonSize size;

  final TDButtonType type;

  final TDButtonShape shape;

  final TDButtonTheme? theme;

  final TDButtonStyle? style;

  final TDButtonStyle? activeStyle;

  final TDButtonStyle? disableStyle;

  final TextStyle? textStyle;

  final TextStyle? disableTextStyle;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final IconData? icon;

  final Widget? iconWidget;

  final double? iconTextSpacing;

  final TDButtonIconPosition? iconPosition;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final bool isBlock;

  @override
  State<StatefulWidget> createState() => _TDButtonState();
}

class _TDButtonState extends State<TDButton> {
  TDButtonStatus _buttonStatus = TDButtonStatus.defaults;
  TDButtonStyle? _innerDefaultStyle;
  TDButtonStyle? _innerActiveStyle;
  TDButtonStyle? _innerDisableStyle;
  double? _width;
  double? _height;
  EdgeInsetsGeometry? _margin;
  Alignment? _alignment;
  TextStyle? _textStyle;
  double? _iconSize;

  Future<void> _updateParams() async {
    _buttonStatus =
        widget.disabled ? TDButtonStatus.disable : TDButtonStatus.defaults;
    _innerDefaultStyle = widget.style;
    _innerActiveStyle = widget.activeStyle;
    _innerDisableStyle = widget.disableStyle;
    _width = _getWidth();
    _height = _getHeight();
    _margin = _getMargin();
    _alignment =
        widget.shape == TDButtonShape.filled || widget.isBlock
            ? Alignment.center
            : null;
    if (widget.text != null) {
      _textStyle = widget.disabled ? widget.disableTextStyle : widget.textStyle;
    }
    if (widget.icon != null) {
      _iconSize = _getIconSize();
    }
  }

  TDButtonStyle get style {
    return switch (_buttonStatus) {
      TDButtonStatus.defaults => _defaultStyle,
      TDButtonStatus.active => _activeStyle,
      TDButtonStatus.disable => _disableStyle,
    };
  }

  @override
  void initState() {
    super.initState();
    unawaited(_updateParams());
  }

  @override
  Widget build(BuildContext context) {
    final Widget display = Container(
      width: _width,
      height: _height,
      alignment: _alignment,
      padding: _getPadding(),
      margin: _margin,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: _getBorder(context),
        borderRadius: style.radius ?? BorderRadius.all(_getRadius()),
      ),
      child: widget.child ?? _getChild(),
    );

    if (widget.disabled) {
      return display;
    }

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (TapDownDetails details) {
        if (widget.disabled) return;

        setState(() => _buttonStatus = TDButtonStatus.active);
      },
      onTapUp: (TapUpDetails details) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !widget.disabled) {
            setState(() => _buttonStatus = TDButtonStatus.defaults);
          }
        });
      },
      onTapCancel: () {
        if (widget.disabled) return;

        setState(() => _buttonStatus = TDButtonStatus.defaults);
      },
      child: display,
    );
  }

  Border? _getBorder(BuildContext context) {
    if (style.borderWidth != null && style.borderWidth != 0) {
      return Border.all(
        color: style.borderColor ?? ThemeColors.neutral.shade200,
        width: style.borderWidth!,
      );
    }
    return null;
  }

  Widget _getChild() {
    final icon = getIcon();

    if (widget.text == null && icon == null) return const NoWidget();

    final children = <Widget>[];

    if (icon != null && widget.iconPosition == TDButtonIconPosition.left) {
      children.add(icon);
    }

    if (widget.text != null) {
      final text = TDText(widget.text, style: _textStyle ?? _getTextStyle());
      children.add(text);
    }

    if (icon != null && widget.iconPosition == TDButtonIconPosition.right) {
      children.add(icon);
    }

    if (children.length == 2) {
      children.insert(1, SizedBox(width: widget.iconTextSpacing ?? 8));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget? getIcon() {
    if (widget.iconWidget != null) return widget.iconWidget;

    if (widget.icon != null) {
      return RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(widget.icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color: style.textColor,
            height: 1,
            fontSize: _iconSize,
            fontFamily: widget.icon!.fontFamily,
            package: widget.icon!.fontPackage,
          ),
        ),
      );
    }
    return null;
  }

  TextStyle _getTextStyle() {
    return switch (widget.size) {
      TDButtonSize.large =>
        context.bodyLarge ?? TextStyle(fontSize: 16, height: 24),
      TDButtonSize.medium =>
        context.bodyLarge ?? TextStyle(fontSize: 16, height: 24),
      TDButtonSize.small =>
        context.bodyMedium ?? TextStyle(fontSize: 14, height: 22),
      TDButtonSize.extraSmall =>
        context.bodyMedium ?? TextStyle(fontSize: 14, height: 22),
    }.copyWith(color: style.textColor ?? ThemeColors.neutral.shade900);
  }

  double? _getWidth() {
    if (widget.width != null) return widget.width;

    if (!widget.isBlock &&
        (widget.shape == TDButtonShape.square ||
            widget.shape == TDButtonShape.circle)) {
      return switch (widget.size) {
        TDButtonSize.large => 48,
        TDButtonSize.medium => 40,
        TDButtonSize.small => 32,
        TDButtonSize.extraSmall => 28,
      };
    }
    return null;
  }

  double _getHeight() {
    if (widget.height != null) return widget.height!;

    return switch (widget.size) {
      TDButtonSize.large => 48,
      TDButtonSize.medium => 40,
      TDButtonSize.small => 32,
      TDButtonSize.extraSmall => 28,
    };
  }

  double _getIconSize() {
    return switch (widget.size) {
      TDButtonSize.large => 24,
      TDButtonSize.medium => 20,
      TDButtonSize.small => 18,
      TDButtonSize.extraSmall => 14,
    };
  }

  EdgeInsetsGeometry? _getMargin() {
    if (widget.margin != null) return widget.margin;

    return widget.isBlock ? const EdgeInsets.only(left: 16, right: 16) : null;
  }

  EdgeInsetsGeometry? _getPadding() {
    if (widget.padding != null) return widget.padding;

    final equalSide =
        widget.shape == TDButtonShape.square ||
        widget.shape == TDButtonShape.circle;

    double horizontalPadding;
    double verticalPadding;

    switch (widget.size) {
      case TDButtonSize.large:
        horizontalPadding = equalSide ? 12 : 20;
        verticalPadding = 12;
      case TDButtonSize.medium:
        horizontalPadding = equalSide ? 10 : 16;
        verticalPadding = equalSide ? 10 : 8;
      case TDButtonSize.small:
        horizontalPadding = equalSide ? 7 : 12;
        verticalPadding = equalSide ? 7 : 5;
      case TDButtonSize.extraSmall:
        horizontalPadding = equalSide ? 5 : 8;
        verticalPadding = equalSide ? 5 : 3;
    }

    if (style.borderWidth != null && style.borderWidth != 0) {
      horizontalPadding = horizontalPadding - style.borderWidth!;
      verticalPadding = verticalPadding - style.borderWidth!;

      if (horizontalPadding < 0) horizontalPadding = 0;

      if (verticalPadding < 0) verticalPadding = 0;
    }

    return EdgeInsets.only(
      left: horizontalPadding,
      right: horizontalPadding,
      bottom: verticalPadding,
      top: verticalPadding,
    );
  }

  @override
  void didUpdateWidget(covariant TDButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    unawaited(_updateParams());
  }

  TDButtonStyle _generateInnerStyle() {
    switch (widget.type) {
      case TDButtonType.fill:
        return TDButtonStyle.fill(context, widget.theme, _buttonStatus);
      case TDButtonType.outline:
        return TDButtonStyle.outline(context, widget.theme, _buttonStatus);
      case TDButtonType.text:
        return TDButtonStyle.text(context, widget.theme, _buttonStatus);
      case TDButtonType.ghost:
        return TDButtonStyle.ghost(context, widget.theme, _buttonStatus);
    }
  }

  Radius _getRadius() {
    switch (widget.shape) {
      case TDButtonShape.rectangle:
      case TDButtonShape.square:
        return Radius.circular(6);
      case TDButtonShape.round:
      case TDButtonShape.circle:
        return Radius.circular(9999);
      case TDButtonShape.filled:
        return Radius.zero;
    }
  }

  TDButtonStyle get _defaultStyle {
    if (_innerDefaultStyle != null) return _innerDefaultStyle!;

    _innerDefaultStyle = widget.style ?? _generateInnerStyle();
    return _innerDefaultStyle!;
  }

  TDButtonStyle get _activeStyle {
    if (_innerActiveStyle != null) return _innerActiveStyle!;

    _innerActiveStyle = widget.style ?? _generateInnerStyle();
    return _innerActiveStyle!;
  }

  TDButtonStyle get _disableStyle {
    if (_innerDisableStyle != null) return _innerDisableStyle!;

    _innerDisableStyle = widget.style ?? _generateInnerStyle();
    return _innerDisableStyle!;
  }
}
