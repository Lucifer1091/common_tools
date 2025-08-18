import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../index.dart';

enum MyButtonSize { large, medium, small, extraSmall }

enum MyButtonType { fill, outline, text, ghost }

enum MyButtonShape { rectangle, round, square, circle, filled }

enum MyButtonTheme { defaults, primary, danger, light }

enum MyButtonState { defaults, focused, hovered, pressed, disabled }

enum MyButtonIconPosition { left, right }

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    this.text,
    this.size = MyButtonSize.medium,
    this.type = MyButtonType.fill,
    this.shape = MyButtonShape.rectangle,
    this.theme,
    this.child,
    this.enabled = true,
    this.isBlock = false,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
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
    this.iconPosition = MyButtonIconPosition.left,
  });

  final Widget? child;

  final String? text;

  final bool enabled;

  final double? width;

  final double? height;

  final MyButtonSize size;

  final MyButtonType type;

  final MyButtonShape shape;

  final MyButtonTheme? theme;

  final MyButtonStyle? style;

  final MyButtonStyle? activeStyle;

  final MyButtonStyle? disableStyle;

  final TextStyle? textStyle;

  final TextStyle? disableTextStyle;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final IconData? icon;

  final Widget? iconWidget;

  final double? iconTextSpacing;

  final MyButtonIconPosition? iconPosition;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final bool isBlock;

  final bool autofocus;

  final FocusNode? focusNode;

  final ValueChanged<bool>? onFocusChange;

  @override
  State<StatefulWidget> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  MyButtonState _state = MyButtonState.defaults;
  MyButtonStyle? _innerDefaultStyle;
  MyButtonStyle? _innerActiveStyle;
  MyButtonStyle? _innerDisableStyle;
  double? _width;
  double? _height;
  EdgeInsetsGeometry? _margin;
  Alignment? _alignment;
  TextStyle? _textStyle;
  double? _iconSize;

  void _updateParams() {
    _state = !widget.enabled ? MyButtonState.disabled : MyButtonState.defaults;
    _innerDefaultStyle = widget.style;
    _innerActiveStyle = widget.activeStyle;
    _innerDisableStyle = widget.disableStyle;
    _width = _getWidth();
    _height = _getHeight();
    _margin = _getMargin();
    _alignment =
        widget.shape == MyButtonShape.filled || widget.isBlock
            ? Alignment.center
            : null;
    if (widget.text != null) {
      _textStyle = !widget.enabled ? widget.disableTextStyle : widget.textStyle;
    }

    if (widget.icon != null) _iconSize = _getIconSize();
  }

  MyButtonStyle get style {
    return switch (_state) {
      MyButtonState.defaults => _defaultStyle,
      MyButtonState.pressed => _activeStyle,
      MyButtonState.disabled => _disableStyle,
    };
  }

  MouseCursor _cursor() {
    return widget.enabled ? SystemMouseCursors.click : MouseCursor.defer;
  }

  @override
  void initState() {
    super.initState();
    _updateParams();
  }

  void onTap() => widget.onTap?.call();

  bool get enabled => widget.enabled;

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

    if (!widget.enabled) return display;

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.enter): onTap},
      child: MyFocusable(
        canRequestFocus: enabled,
        autofocus: widget.autofocus,
        focusNode: focusNode,
        onFocusChange: widget.onFocusChange,
        builder:
            (_, focused, child) =>
                MyFocusOutline(focused: focused, child: child),
        child: MyGestureDetector(
          behavior: HitTestBehavior.opaque,
          cursor: _cursor(),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onHover: (bool value) {
            if (value) {
              setState(() => _state = MyButtonState.hovered);
            } else {
              setState(() => _state = MyButtonState.defaults);
            }
          },
          onTapDown: (TapDownDetails details) {
            if (!widget.enabled) return;

            setState(() => _state = MyButtonState.pressed);
          },
          onTapUp: (TapUpDetails details) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted && widget.enabled) {
                setState(() => _state = MyButtonState.defaults);
              }
            });
          },
          onTapCancel: () {
            if (!widget.enabled) return;

            setState(() => _state = MyButtonState.defaults);
          },
          child: display,
        ),
      ),
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

    if (icon != null && widget.iconPosition == MyButtonIconPosition.left) {
      children.add(icon);
    }

    if (widget.text != null) {
      final text = TDText(widget.text, style: _textStyle ?? _getTextStyle());
      children.add(text);
    }

    if (icon != null && widget.iconPosition == MyButtonIconPosition.right) {
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
      MyButtonSize.large => context.bodyLarge,
      MyButtonSize.medium => context.bodyLarge,
      MyButtonSize.small => context.bodyMedium,
      MyButtonSize.extraSmall => context.bodyMedium,
    }.copyWith(color: style.textColor ?? context.colorScheme.primaryForeground);
  }

  double? _getWidth() {
    if (widget.width != null) return widget.width;

    if (!widget.isBlock &&
        (widget.shape == MyButtonShape.square ||
            widget.shape == MyButtonShape.circle)) {
      return switch (widget.size) {
        MyButtonSize.large => 48,
        MyButtonSize.medium => 40,
        MyButtonSize.small => 32,
        MyButtonSize.extraSmall => 28,
      };
    }
    return null;
  }

  double _getHeight() {
    if (widget.height != null) return widget.height!;

    return switch (widget.size) {
      MyButtonSize.large => 48,
      MyButtonSize.medium => 40,
      MyButtonSize.small => 32,
      MyButtonSize.extraSmall => 28,
    };
  }

  double _getIconSize() {
    return switch (widget.size) {
      MyButtonSize.large => 24,
      MyButtonSize.medium => 20,
      MyButtonSize.small => 18,
      MyButtonSize.extraSmall => 14,
    };
  }

  EdgeInsetsGeometry? _getMargin() {
    if (widget.margin != null) return widget.margin;

    return widget.isBlock ? const EdgeInsets.only(left: 16, right: 16) : null;
  }

  EdgeInsetsGeometry? _getPadding() {
    if (widget.padding != null) return widget.padding;

    final equalSide =
        widget.shape == MyButtonShape.square ||
        widget.shape == MyButtonShape.circle;

    double horizontalPadding;
    double verticalPadding;

    switch (widget.size) {
      case MyButtonSize.large:
        horizontalPadding = equalSide ? 12 : 20;
        verticalPadding = 12;
      case MyButtonSize.medium:
        horizontalPadding = equalSide ? 10 : 16;
        verticalPadding = equalSide ? 10 : 8;
      case MyButtonSize.small:
        horizontalPadding = equalSide ? 7 : 12;
        verticalPadding = equalSide ? 7 : 5;
      case MyButtonSize.extraSmall:
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
  void didUpdateWidget(covariant MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateParams();
  }

  MyButtonStyle _generateInnerStyle() {
    switch (widget.type) {
      case MyButtonType.fill:
        return MyButtonStyle.fill(context, widget.theme, _state);
      case MyButtonType.outline:
        return MyButtonStyle.outline(context, widget.theme, _state);
      case MyButtonType.text:
        return MyButtonStyle.text(context, widget.theme, _state);
      case MyButtonType.ghost:
        return MyButtonStyle.ghost(context, widget.theme, _state);
    }
  }

  Radius _getRadius() {
    switch (widget.shape) {
      case MyButtonShape.rectangle:
      case MyButtonShape.square:
        return Radius.circular(6);
      case MyButtonShape.round:
      case MyButtonShape.circle:
        return Radius.circular(9999);
      case MyButtonShape.filled:
        return Radius.zero;
    }
  }

  MyButtonStyle get _defaultStyle {
    if (_innerDefaultStyle != null) return _innerDefaultStyle!;

    _innerDefaultStyle = widget.style ?? _generateInnerStyle();
    return _innerDefaultStyle!;
  }

  MyButtonStyle get _activeStyle {
    if (_innerActiveStyle != null) return _innerActiveStyle!;

    _innerActiveStyle = widget.style ?? _generateInnerStyle();
    return _innerActiveStyle!;
  }

  MyButtonStyle get _disableStyle {
    if (_innerDisableStyle != null) return _innerDisableStyle!;

    _innerDisableStyle = widget.style ?? _generateInnerStyle();
    return _innerDisableStyle!;
  }
}
