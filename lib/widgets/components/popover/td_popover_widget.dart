import 'package:flutter/material.dart';

import '../../../index.dart';

enum TDPopoverTheme { dark, light, info, success, warning, error }

enum TDPopoverPlacement {
  topLeft,
  top,
  topRight,
  rightTop,
  right,
  rightBottom,
  bottomRight,
  bottom,
  bottomLeft,
  leftBottom,
  left,
  leftTop,
}

class TDPopoverWidget extends StatefulWidget {
  const TDPopoverWidget({
    required this.context,
    super.key,
    this.content,
    this.contentWidget,
    this.offset = 4,
    this.theme,
    this.placement,
    this.showArrow = true,
    this.arrowSize = 8,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.onLongTap,
  });

  final BuildContext context;

  final String? content;

  final Widget? contentWidget;

  final double offset;

  final TDPopoverTheme? theme;

  final TDPopoverPlacement? placement;

  final bool? showArrow;

  final double arrowSize;

  final EdgeInsetsGeometry? padding;

  /// Content width (including padding, actual height: height - paddingLeft - paddingRight)
  final double? width;

  /// Content height (including padding, actual height: height - paddingTop - paddingBottom)
  final double? height;

  final ValueChanged<String?>? onTap;

  final ValueChanged<String?>? onLongTap;

  @override
  State<TDPopoverWidget> createState() => _TDPopoverWidgetState();
}

class _TDPopoverWidgetState extends State<TDPopoverWidget> {
  late Color _color;
  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _initTheme();
    if (widget.contentWidget != null) {
      if (widget.width == null) {
        throw FlutterError(
          'width must not be null when contentWidget is not null',
        );
      }
      if (widget.height == null) {
        throw FlutterError(
          'height must not be null when contentWidget is not null',
        );
      }
    }
  }

  Widget _drawArrow() {
    var border = Border(
      right: BorderSide(width: widget.arrowSize, color: Colors.transparent),
      bottom: BorderSide(width: widget.arrowSize, color: _backgroundColor),
      left: BorderSide(width: widget.arrowSize, color: Colors.transparent),
    );

    if (widget.placement == TDPopoverPlacement.bottom ||
        widget.placement == TDPopoverPlacement.bottomLeft ||
        widget.placement == TDPopoverPlacement.bottomRight) {
      border = Border(
        top: BorderSide(width: widget.arrowSize, color: _backgroundColor),
        right: BorderSide(width: widget.arrowSize, color: Colors.transparent),
        left: BorderSide(width: widget.arrowSize, color: Colors.transparent),
      );
    } else if (widget.placement == TDPopoverPlacement.left ||
        widget.placement == TDPopoverPlacement.leftTop ||
        widget.placement == TDPopoverPlacement.leftBottom) {
      border = Border(
        top: BorderSide(width: widget.arrowSize, color: Colors.transparent),
        bottom: BorderSide(width: widget.arrowSize, color: Colors.transparent),
        right: BorderSide(width: widget.arrowSize, color: _backgroundColor),
      );
    } else if (widget.placement == TDPopoverPlacement.right ||
        widget.placement == TDPopoverPlacement.rightTop ||
        widget.placement == TDPopoverPlacement.rightBottom) {
      border = Border(
        top: BorderSide(width: widget.arrowSize, color: Colors.transparent),
        bottom: BorderSide(width: widget.arrowSize, color: Colors.transparent),
        left: BorderSide(width: widget.arrowSize, color: _backgroundColor),
      );
    }

    return Container(
      width: 0,
      height: 0,
      decoration: BoxDecoration(border: border),
    );
  }

  void _initTheme() {
    switch (widget.theme) {
      case TDPopoverTheme.info:
        _color = ThemeColors.blue.shade600;
        _backgroundColor = ThemeColors.blue.shade50;
      case TDPopoverTheme.success:
        _color = ThemeColors.success.shade400;
        _backgroundColor = ThemeColors.success.shade50;
      case TDPopoverTheme.warning:
        _color = MyColors.warning.shade400;
        _backgroundColor = MyColors.warning.shade50;
      case TDPopoverTheme.error:
        _color = ThemeColors.error.shade500;
        _backgroundColor = ThemeColors.error.shade50;
      case TDPopoverTheme.light:
        _color = ThemeColors.neutral.shade900;
        _backgroundColor = Colors.white;
      case TDPopoverTheme.dark:
      case null:
        _color = Colors.white;
        _backgroundColor = ThemeColors.neutral.shade900;
    }
  }

  Rect? _getWidgetBounds(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return box?.semanticBounds;
  }

  Offset? _getWidgetLocalToGlobal(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return box?.localToGlobal(Offset.zero);
  }

  double _getOffsetTop(Offset? widgetLocalToGlobal) {
    final widgetBounds = _getWidgetBounds(widget.context);
    final dy = widgetLocalToGlobal?.dy ?? 0;
    final arrowSize = widget.showArrow ?? false ? widget.arrowSize : 0;
    final contentSize = _getContentSize();
    final popoverHeight =
        widget.height ??
        (widget.padding != null ? widget.padding!.vertical : 24) +
            (widget.height ?? contentSize.height);

    switch (widget.placement) {
      case TDPopoverPlacement.bottomLeft:
      case TDPopoverPlacement.bottom:
      case TDPopoverPlacement.bottomRight:
        return dy + (widgetBounds?.height ?? 0) + widget.offset;
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.leftTop:
        return dy;
      case TDPopoverPlacement.rightBottom:
      case TDPopoverPlacement.leftBottom:
        return dy - (popoverHeight - (widgetBounds?.height ?? 0));
      case TDPopoverPlacement.right:
      case TDPopoverPlacement.left:
        return dy - (popoverHeight - (widgetBounds?.height ?? 0)) / 2;
      case TDPopoverPlacement.top:
      case TDPopoverPlacement.topLeft:
      case TDPopoverPlacement.topRight:
      case null:
        return dy - popoverHeight - widget.offset - arrowSize;
    }
  }

  double _getOffsetLeft(Offset? widgetLocalToGlobal) {
    final widgetBounds = _getWidgetBounds(widget.context);
    final widgetWidth = widgetBounds?.width ?? 0;
    final contentSize = _getContentSize();
    final popoverWidth =
        widget.width ??
        (widget.padding != null ? widget.padding!.horizontal : 24) +
            contentSize.width;
    final dx = widgetLocalToGlobal?.dx ?? 0;

    switch (widget.placement) {
      case TDPopoverPlacement.topLeft:
      case TDPopoverPlacement.bottomLeft:
        return dx;
      case TDPopoverPlacement.topRight:
      case TDPopoverPlacement.bottomRight:
        return dx + widgetWidth - popoverWidth;
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.right:
      case TDPopoverPlacement.rightBottom:
        return dx + widgetWidth + widget.offset + 8;
      case TDPopoverPlacement.leftTop:
      case TDPopoverPlacement.left:
      case TDPopoverPlacement.leftBottom:
        return dx - popoverWidth - widget.arrowSize - widget.offset - 8;
      case null:
      case TDPopoverPlacement.top:
      case TDPopoverPlacement.bottom:
        return dx - (popoverWidth - widgetWidth) / 2;
    }
  }

  Widget _getArrowWidget() {
    var margin = EdgeInsets.only(top: widget.arrowSize);

    switch (widget.placement) {
      case TDPopoverPlacement.topLeft:
        margin = EdgeInsets.only(
          top: widget.arrowSize,
          left: widget.arrowSize + 12,
        );
      case TDPopoverPlacement.topRight:
        margin = EdgeInsets.only(
          top: widget.arrowSize,
          right: widget.arrowSize + 12,
        );
      case TDPopoverPlacement.bottomLeft:
        margin = EdgeInsets.only(
          bottom: widget.arrowSize,
          left: widget.arrowSize + 12,
        );
      case TDPopoverPlacement.bottom:
        margin = EdgeInsets.only(bottom: widget.arrowSize);
      case TDPopoverPlacement.bottomRight:
        margin = EdgeInsets.only(
          bottom: widget.arrowSize,
          right: widget.arrowSize + 12,
        );
      case TDPopoverPlacement.rightTop:
        margin = EdgeInsets.only(
          top: widget.arrowSize + 6,
          right: widget.arrowSize,
        );
      case TDPopoverPlacement.right:
        margin = EdgeInsets.only(right: widget.arrowSize);
      case TDPopoverPlacement.rightBottom:
        margin = EdgeInsets.only(
          bottom: widget.arrowSize + 6,
          right: widget.arrowSize,
        );
      case TDPopoverPlacement.leftTop:
        margin = EdgeInsets.only(
          top: widget.arrowSize + 6,
          left: widget.arrowSize,
        );
      case TDPopoverPlacement.left:
        margin = EdgeInsets.only(left: widget.arrowSize);
      case TDPopoverPlacement.leftBottom:
        margin = EdgeInsets.only(
          bottom: widget.arrowSize + 6,
          left: widget.arrowSize,
        );
      case null:
      case TDPopoverPlacement.top:
        margin = EdgeInsets.only(top: widget.arrowSize);
    }

    return Container(margin: margin, child: _drawArrow());
  }

  Size _getContentSize() {
    if (widget.contentWidget != null) {
      return Size(widget.width!, widget.height!);
    }
    return _getTextSize();
  }

  Size _getTextSize() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.content,
        style: TextStyle(
          color: _color,
          letterSpacing: 0,
          fontSize: 16,
          height: 1.5,
        ),
      ),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
    )..layout(
      maxWidth:
          (widget.width ?? 300) -
          (widget.padding != null ? widget.padding!.horizontal : 24),
    );
    return textPainter.size;
  }

  Widget _getChild() {
    var children = [
      Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: _backgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0d000000),
              offset: Offset(0, 6),
              blurRadius: 30,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Color(0x0a000000),
              offset: Offset(0, 16),
              blurRadius: 24,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 8),
              blurRadius: 10,
              spreadRadius: -5,
            ),
          ],
        ),
        child:
            widget.contentWidget != null
                ? widget.contentWidget!
                : MyText(
                  widget.content,
                  style: TextStyle(
                    color: _color,
                    letterSpacing: 0,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
      ),
      Visibility(visible: widget.showArrow ?? false, child: _getArrowWidget()),
    ];

    var axis = CrossAxisAlignment.center;
    var direction = VerticalDirection.down;

    /// Set the vertical arrangement order of child widgets
    switch (widget.placement) {
      case TDPopoverPlacement.bottom:
      case TDPopoverPlacement.bottomLeft:
      case TDPopoverPlacement.bottomRight:
        direction = VerticalDirection.up;
      case TDPopoverPlacement.right:
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.rightBottom:

        /// Invert content and arrows
        children = [
          Visibility(
            visible: widget.showArrow ?? false,
            child: Container(child: _getArrowWidget()),
          ),
          Container(
            padding: widget.padding ?? const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: _backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.neutral.shade600,
                  offset: const Offset(6, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child:
                widget.contentWidget != null
                    ? widget.contentWidget!
                    : MyText(
                      widget.content,
                      style: TextStyle(
                        color: _color,
                        letterSpacing: 0,
                        fontSize: 16,
                        height: 1.5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
          ),
        ];
      case TDPopoverPlacement.topLeft:
      case TDPopoverPlacement.top:
      case TDPopoverPlacement.topRight:
      case TDPopoverPlacement.leftBottom:
      case TDPopoverPlacement.left:
      case TDPopoverPlacement.leftTop:
      case null:
        direction = VerticalDirection.down;
    }

    /// Change the cross-axis alignment of Row and Column to achieve the arrow position
    switch (widget.placement) {
      case TDPopoverPlacement.topLeft:
      case TDPopoverPlacement.bottomLeft:
        axis = CrossAxisAlignment.start;
      case TDPopoverPlacement.topRight:
      case TDPopoverPlacement.bottomRight:
        axis = CrossAxisAlignment.end;
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.leftTop:
        axis = CrossAxisAlignment.start;
      case TDPopoverPlacement.rightBottom:
      case TDPopoverPlacement.leftBottom:
        axis = CrossAxisAlignment.end;
      case null:
      case TDPopoverPlacement.top:
      case TDPopoverPlacement.right:
      case TDPopoverPlacement.bottom:
      case TDPopoverPlacement.left:
        axis = CrossAxisAlignment.center;
    }

    /// Horizontal layout
    if (widget.placement == TDPopoverPlacement.right ||
        widget.placement == TDPopoverPlacement.rightTop ||
        widget.placement == TDPopoverPlacement.rightBottom ||
        widget.placement == TDPopoverPlacement.left ||
        widget.placement == TDPopoverPlacement.leftBottom ||
        widget.placement == TDPopoverPlacement.leftTop) {
      return Row(crossAxisAlignment: axis, children: children);
    }

    /// Vertical Layout
    return Column(
      crossAxisAlignment: axis,
      verticalDirection: direction,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final widgetLocalToGlobal = _getWidgetLocalToGlobal(widget.context);
    final top = _getOffsetTop(widgetLocalToGlobal);
    final left = _getOffsetLeft(widgetLocalToGlobal);

    return Stack(
      children: [Positioned(top: top, left: left, child: _getChild())],
    );
  }
}
