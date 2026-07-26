import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/string/validators.dart';
import '../../common/my_gesture_detector.dart';
import '../../packages/gap/src/widgets/gap.dart';
import '../swipe_cell/td_swipe_cell_inherited.dart';
import '../text/my_text.dart';
import './my_cell_inherited.dart';
import './my_cell_style.dart';

enum MyCellAlignment { top, middle, bottom }

class MyCell extends StatefulWidget {
  const MyCell({
    super.key,
    this.align = MyCellAlignment.middle,
    this.arrow = false,
    this.bordered = true,
    this.required = false,
    this.description,
    this.descriptionWidget,
    this.hover = true,
    this.image,
    this.imageSize,
    this.imageRadius = 50,
    this.imageWidget,
    this.leftIcon,
    this.leftIconWidget,
    this.note,
    this.noteWidget,
    this.title,
    this.titleWidget,
    this.onTap,
    this.onLongPress,
    this.style,
    this.rightIcon,
    this.rightIconWidget,
    this.enabled = true,
    this.showBottomBorder = false,
    this.height,
  });

  final MyCellAlignment? align;
  final bool? arrow;
  final bool? bordered;
  final String? description;
  final Widget? descriptionWidget;
  final bool hover;
  final ImageProvider? image;
  final double? imageSize;
  final double? imageRadius;
  final Widget? imageWidget;
  final IconData? leftIcon;
  final Widget? leftIconWidget;
  final String? note;
  final Widget? noteWidget;
  final bool? required;
  final IconData? rightIcon;
  final Widget? rightIconWidget;
  final String? title;
  final Widget? titleWidget;
  final ValueChanged<MyCell>? onTap;
  final ValueChanged<MyCell>? onLongPress;
  final MyCellStyle? style;
  final bool enabled;
  final bool? showBottomBorder;
  final double? height;

  @override
  State<MyCell> createState() => _MyCellState();
}

class _MyCellState extends State<MyCell> {
  late WidgetStatesController _state;

  @override
  void initState() {
    super.initState();
    _state = WidgetStatesController();
    _state.update(WidgetState.disabled, !widget.enabled);
  }

  @override
  void didUpdateWidget(covariant MyCell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled) {
      _state.update(WidgetState.disabled, !widget.enabled);
    }
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _state,
      builder: (context, states, _) {
        final pressed = states.contains(WidgetState.pressed);
        final hovered = states.contains(WidgetState.hovered);
        final enabled = !states.contains(WidgetState.disabled);

        final canHover = widget.hover;

        final style =
            widget.style ??
            MyCellInherited.of(context)?.style ??
            MyCellStyle.style(context);

        final crossAxisAlignment = _getAlign();
        final color = !enabled
            ? context.colorScheme.muted.withValues(alpha: 0)
            : !canHover || !hovered && !pressed
            ? style.backgroundColor
            : style.hoverColor;

        Border? border;
        if (widget.showBottomBorder!) {
          border = Border(
            bottom: BorderSide(
              color: style.borderedColor ?? context.colorScheme.border,
            ),
          );
        }

        return Semantics(
          container: true,
          button: true,
          focusable: enabled,
          enabled: enabled,
          child: MyGestureDetector(
            behavior: HitTestBehavior.opaque,
            cursor: _getCursor(states),
            onTap: widget.onTap != null
                ? () {
                    if (widget.enabled) widget.onTap!(widget);
                    TDSwipeCellInherited.of(context)?.onTap();
                  }
                : null,
            onLongPress: widget.onLongPress != null
                ? () {
                    if (widget.enabled) widget.onLongPress!(widget);
                  }
                : null,
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
            child: Container(
              height: widget.height,
              padding: style.padding,
              decoration: BoxDecoration(color: color, border: border),
              child: Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  ..._getImage(),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.leftIcon != null ||
                            widget.leftIconWidget != null) ...[
                          widget.leftIconWidget ??
                              Icon(
                                widget.leftIcon,
                                size: 24,
                                color: style.leftIconColor,
                              ),
                          const Gap(12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (widget.titleWidget != null)
                                    Flexible(child: widget.titleWidget!)
                                  else if (widget.title.isNotBlank)
                                    Flexible(
                                      child: MyText(
                                        widget.title,
                                        style: style.titleStyle,
                                      ),
                                    ),
                                  if (widget.required ?? false)
                                    MyText(' *', style: style.requiredStyle),
                                ],
                              ),
                              if ((widget.titleWidget != null ||
                                      widget.title != null) &&
                                  (widget.descriptionWidget != null ||
                                      widget.description.isNotBlank))
                                const Gap(4),
                              if (widget.descriptionWidget != null)
                                widget.descriptionWidget!
                              else if (widget.description.isNotBlank)
                                MyText(
                                  widget.description,
                                  style: style.descriptionStyle,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (widget.noteWidget != null)
                        widget.noteWidget!
                      else if (widget.note.isNotBlank)
                        MyText(widget.note, style: style.noteStyle),
                      if (widget.rightIconWidget != null)
                        widget.rightIconWidget!
                      else if (widget.rightIcon != null)
                        Icon(
                          widget.rightIcon,
                          size: 24,
                          color: style.rightIconColor,
                        ),
                      if (widget.arrow ?? false)
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 24,
                          color: style.arrowColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  CrossAxisAlignment _getAlign() {
    switch (widget.align) {
      case MyCellAlignment.top:
        return CrossAxisAlignment.start;
      case MyCellAlignment.middle:
        return CrossAxisAlignment.center;
      case MyCellAlignment.bottom:
        return CrossAxisAlignment.end;
      case null:
        return CrossAxisAlignment.center;
    }
  }

  List<Widget> _getImage() {
    final imageSize = widget.imageSize ?? 48;
    final list = <Widget>[];

    if (widget.imageWidget != null) {
      list.add(widget.imageWidget!);
    } else if (widget.image != null) {
      list.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.imageRadius ?? 50),
          child: Image(
            image: widget.image!,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (list.isEmpty) return list;

    list.add(SizedBox(width: 12));
    return list;
  }
}
