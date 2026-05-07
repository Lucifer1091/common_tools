import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../../index.dart';

enum MyButtonSize { extraLarge, large, medium, small, extraSmall }

enum MyButtonType {
  primary,
  secondary,
  destructive,
  outline,
  ghost,
  text,
  link,
}

enum MyButtonShape { rectangle, round, square, circle, filled }

enum MyButtonIconPosition { left, right }

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    this.text,
    this.child,
    this.enabled = true,
    this.isExpanded = false,
    this.isFloating = false,
    this.size = MyButtonSize.medium,
    this.type = MyButtonType.primary,
    this.shape = MyButtonShape.rectangle,
    this.style,
    this.textStyle,
    this.gradient,
    this.shadows,
    this.focus = const MyFocusableParams(),
    this.onTap,
    this.onLongPress,
    this.icon,
    this.iconWidget,
    this.iconTextSpacing,
    this.iconPosition = MyButtonIconPosition.left,
    this.width,
    this.height,
    this.margin,
    this.padding,
  });

  final bool enabled;
  final Widget? child;
  final String? text;
  final double? width;
  final double? height;
  final MyButtonSize size;
  final MyButtonType type;
  final MyButtonShape shape;
  final Transformer<Set<WidgetState>, MyButtonStyle>? style;
  final TextStyle? textStyle;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final IconData? icon;
  final Widget? iconWidget;
  final double? iconTextSpacing;
  final MyButtonIconPosition? iconPosition;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isExpanded;
  final bool isFloating;
  final MyFocusableParams focus;

  @override
  State<StatefulWidget> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  late WidgetStatesController _state;
  FocusNode? _focusNode;

  FocusNode get focusNode => widget.focus.focusNode ?? _focusNode!;

  @override
  void initState() {
    super.initState();
    _state = WidgetStatesController();
    if (widget.focus.focusNode == null) _focusNode = FocusNode();
    _state.update(WidgetState.disabled, !widget.enabled);
    focusNode.addListener(onFocusChange);
    _updateParams();
  }

  @override
  void didUpdateWidget(covariant MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled) {
      _state.update(WidgetState.disabled, !widget.enabled);
    }

    if (oldWidget.focus.focusNode != null && widget.focus.focusNode == null) {
      oldWidget.focus.focusNode!.removeListener(onFocusChange);
      _focusNode?.dispose();
      _focusNode = null;
      _focusNode = FocusNode();
      focusNode.addListener(onFocusChange);
    }
    _updateParams();
  }

  @override
  void dispose() {
    _state.dispose();
    focusNode.removeListener(onFocusChange);
    _focusNode?.dispose();
    _focusNode = null;
    super.dispose();
  }

  void onFocusChange() {
    _state.update(WidgetState.focused, focusNode.hasFocus);
  }

  static Future<void> feedbackForTap(BuildContext context) async {
    context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
    if (MyPlatform.isMobile) {
      return SystemSound.play(SystemSoundType.click);
    }
    return Future<void>.value();
  }

  double? _width;
  double? _height;
  EdgeInsetsGeometry? _margin;
  Alignment? _alignment;
  double? _iconSize;

  void _updateParams() {
    _width = _getWidth();
    _height = _getHeight();
    _margin = _getMargin();

    _alignment =
        widget.shape == MyButtonShape.filled || widget.isExpanded
            ? Alignment.center
            : null;

    if (widget.icon != null) _iconSize = _getIconSize();
  }

  void _onTap() {
    if (!widget.enabled) return;
    widget.onTap?.call();
    if (widget.focus.enableFeedback) unawaited(feedbackForTap(context));
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.enter): _onTap},
      child: ValueListenableBuilder(
        valueListenable: _state,
        builder: (context, states, _) {
          final enabled = !states.contains(WidgetState.disabled);

          final MyButtonStyle style =
              widget.style?.call(states) ?? _generateInnerStyle(states);

          final Widget display = Container(
            width: _width,
            height: _height,
            alignment: _alignment,
            padding: _getPadding(style),
            decoration: BoxDecoration(
              color: style.backgroundColor,
              border: _getBorder(context, style),
              borderRadius: style.radius ?? _getRadius(style),
              gradient: widget.gradient,
              boxShadow:
                  widget.shadows ??
                  (widget.isFloating ? MyBoxShadows.all : null),
            ),
            child: widget.child ?? _getChild(style),
          );

          if (!widget.enabled) return display;

          return Semantics(
            button: true,
            container: true,
            focusable: enabled,
            enabled: enabled,
            child: MyGestureDetector(
              behavior: HitTestBehavior.opaque,
              cursor: _getCursor(states),
              onTap: widget.onTap != null ? _onTap : null,
              onLongPress: widget.onLongPress,
              onHover: (bool value) {
                _state.update(WidgetState.hovered, value);
              },
              onTapDown: (TapDownDetails details) {
                _state.update(WidgetState.pressed, true);
              },
              onTapUp: (TapUpDetails details) {
                _state.update(WidgetState.pressed, false);
              },
              onTapCancel: () {
                _state.update(WidgetState.pressed, false);
              },
              child: Padding(
                padding: _margin ?? EdgeInsets.zero,
                child: MyFocusable(
                  params: widget.focus.copyWith(focusNode: focusNode),
                  builder:
                      (_, focused, child) => MyDecorator(
                        focused: focused,
                        radius: _getRadius(style),
                        child: child,
                      ),
                  child: display,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Border? _getBorder(BuildContext context, MyButtonStyle style) {
    if (style.borderWidth != null && style.borderWidth != 0) {
      return Border.all(
        color: style.borderColor ?? context.colorScheme.border,
        width: style.borderWidth!,
      );
    }
    return null;
  }

  Widget _getChild(MyButtonStyle style) {
    final icon = getIcon(style);

    if (widget.text == null && icon == null) return const SizedBox.shrink();

    final children = <Widget>[];

    if (icon != null && widget.iconPosition == MyButtonIconPosition.left) {
      children.add(icon);
    }

    if (widget.text != null) {
      final text = MyText(
        widget.text,
        style: widget.textStyle ?? _getTextStyle(style),
      );
      children.add(text);
    }

    if (icon != null && widget.iconPosition == MyButtonIconPosition.right) {
      children.add(icon);
    }

    if (children.length == 2) {
      children.insert(1, Gap(widget.iconTextSpacing ?? 8));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget? getIcon(MyButtonStyle style) {
    if (widget.iconWidget != null) {
      return widget.iconWidget;
    }
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

  MouseCursor _getCursor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.forbidden;
    }
    if (states.contains(WidgetState.pressed)) {
      return SystemMouseCursors.click;
    }
    if (states.contains(WidgetState.hovered)) {
      return SystemMouseCursors.click;
    }
    return SystemMouseCursors.basic;
  }

  TextStyle _getTextStyle(MyButtonStyle style) {
    return switch (widget.size) {
      MyButtonSize.extraLarge => context.bodyLarge,
      MyButtonSize.large => context.bodyLarge,
      MyButtonSize.medium => context.bodyMedium,
      MyButtonSize.small => context.bodyMedium,
      MyButtonSize.extraSmall => context.bodySmall,
    }.copyWith(
      color: style.textColor ?? context.colorScheme.foreground,
      decoration: style.decoration,
      decorationColor: style.textColor ?? context.colorScheme.foreground,
    );
  }

  double? _getWidth() {
    if (widget.width != null) return widget.width;

    if (!widget.isExpanded &&
        (widget.shape == MyButtonShape.square ||
            widget.shape == MyButtonShape.circle)) {
      return switch (widget.size) {
        MyButtonSize.extraLarge => 48,
        MyButtonSize.large => 40,
        MyButtonSize.medium => 36,
        MyButtonSize.small => 32,
        MyButtonSize.extraSmall => 28,
      };
    }
    return null;
  }

  double _getHeight() {
    if (widget.height != null) return widget.height!;

    return switch (widget.size) {
      MyButtonSize.extraLarge => 48,
      MyButtonSize.large => 40,
      MyButtonSize.medium => 36,
      MyButtonSize.small => 32,
      MyButtonSize.extraSmall => 28,
    };
  }

  double _getIconSize() {
    return switch (widget.size) {
      MyButtonSize.extraLarge => 24,
      MyButtonSize.large => 20,
      MyButtonSize.medium => 18,
      MyButtonSize.small => 18,
      MyButtonSize.extraSmall => 14,
    };
  }

  EdgeInsetsGeometry? _getMargin() {
    if (widget.margin != null) return widget.margin;

    return widget.isExpanded
        ? const EdgeInsets.only(left: 16, right: 16)
        : null;
  }

  EdgeInsetsGeometry? _getPadding(MyButtonStyle style) {
    if (widget.padding != null) return widget.padding;

    final equalSide =
        widget.shape == MyButtonShape.square ||
        widget.shape == MyButtonShape.circle;

    double horizontalPadding;
    double verticalPadding;

    switch (widget.size) {
      case MyButtonSize.extraLarge:
        horizontalPadding = equalSide ? 12 : 20;
        verticalPadding = 12;
      case MyButtonSize.large:
        horizontalPadding = equalSide ? 10 : 16;
        verticalPadding = equalSide ? 10 : 8;
      case MyButtonSize.medium:
        horizontalPadding = equalSide ? 8 : 14;
        verticalPadding = equalSide ? 8 : 6;
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

  BorderRadius _getRadius(MyButtonStyle style) {
    return style.radius ??
        switch (widget.shape) {
          MyButtonShape.rectangle ||
          MyButtonShape.square => MyBorderRadius.medium,
          MyButtonShape.round || MyButtonShape.circle => MyBorderRadius.round,
          MyButtonShape.filled => BorderRadius.zero,
        };
  }

  MyButtonStyle _generateInnerStyle(Set<WidgetState> states) {
    switch (widget.type) {
      case MyButtonType.primary:
        return MyButtonStyle.primary(context, states);
      case MyButtonType.secondary:
        return MyButtonStyle.secondary(context, states);
      case MyButtonType.destructive:
        return MyButtonStyle.destructive(context, states);
      case MyButtonType.outline:
        return MyButtonStyle.outline(context, states);
      case MyButtonType.ghost:
        return MyButtonStyle.ghost(context, states);
      case MyButtonType.text:
        return MyButtonStyle.text(context, states);
      case MyButtonType.link:
        return MyButtonStyle.link(context, states);
    }
  }
}
