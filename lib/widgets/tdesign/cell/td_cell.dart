import 'package:flutter/material.dart';

import '../../../index.dart';
import '../swipe_cell/td_swipe_cell_inherited.dart';
import '../text/td_text.dart';
import 'td_cell_inherited.dart';
import 'td_cell_style.dart';

typedef TDCellClick = void Function(TDCell cell);

enum TDCellAlign { top, middle, bottom }

class TDCell extends StatefulWidget {
  const TDCell({
    super.key,
    this.align = TDCellAlign.middle,
    this.arrow = false,
    this.bordered = true,
    this.description,
    this.descriptionWidget,
    this.hover = true,
    this.image,
    this.imageSize,
    this.imageWidget,
    this.leftIcon,
    this.leftIconWidget,
    this.note,
    this.noteWidget,
    this.required = false,
    this.title,
    this.titleWidget,
    this.onClick,
    this.onLongPress,
    this.style,
    this.rightIcon,
    this.rightIconWidget,
    this.disabled = false,
    this.imageCircle = 50,
    this.showBottomBorder = false,
    this.height,
  });

  final TDCellAlign? align;

  final bool? arrow;

  final bool? bordered;

  final String? description;

  final Widget? descriptionWidget;

  final bool? hover;

  final ImageProvider? image;

  final double? imageSize;

  final double? imageCircle;

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

  final TDCellClick? onClick;

  final TDCellClick? onLongPress;

  final TDCellStyle? style;

  final bool? disabled;

  final bool? showBottomBorder;

  final double? height;

  @override
  _TDCellState createState() => _TDCellState();
}

class _TDCellState extends State<TDCell> {
  var _status = 'default';

  @override
  Widget build(BuildContext context) {
    final style =
        widget.style ??
        TDCellInherited.of(context)?.style ??
        TDCellStyle.cellStyle(context);
    final crossAxisAlignment = _getAlign();
    final color =
        _status == 'default'
            ? style.backgroundColor
            : style.clickBackgroundColor;

    Border? border;
    if (widget.showBottomBorder!) {
      border = Border(
        bottom: BorderSide(
          color: style.borderedColor ?? ThemeColors.neutral.shade200,
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.onClick != null && !(widget.disabled ?? false)) {
          widget.onClick!(widget);
        }
        TDSwipeCellInherited.of(context)?.cellClick();
      },
      onLongPress:
          widget.onLongPress != null
              ? () {
                if (!(widget.disabled ?? false)) {
                  widget.onLongPress!(widget);
                }
              }
              : null,
      onTapDown: (details) {
        _setStatus('active', 0);
      },
      onTapUp: (details) {
        _setStatus('default', 100);
      },
      onTapCancel: () {
        _setStatus('default', 0);
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
                    SizedBox(width: 12),
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
                                child: TDText(
                                  widget.title,
                                  style: style.titleStyle,
                                ),
                              ),
                            if (widget.required ?? false)
                              TDText(' *', style: style.requiredStyle),
                          ],
                        ),
                        if ((widget.titleWidget != null ||
                                widget.title != null) &&
                            (widget.descriptionWidget != null ||
                                widget.description.isNotBlank))
                          SizedBox(height: 4),
                        if (widget.descriptionWidget != null)
                          widget.descriptionWidget!
                        else if (widget.description.isNotBlank)
                          TDText(
                            widget.description!,
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
                  TDText(widget.note, style: style.noteStyle),
                if (widget.rightIconWidget != null)
                  widget.rightIconWidget!
                else if (widget.rightIcon != null)
                  Icon(widget.rightIcon, size: 24, color: style.rightIconColor),
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
    );
  }

  CrossAxisAlignment _getAlign() {
    switch (widget.align) {
      case TDCellAlign.top:
        return CrossAxisAlignment.start;
      case TDCellAlign.middle:
        return CrossAxisAlignment.center;
      case TDCellAlign.bottom:
        return CrossAxisAlignment.end;
      case null:
        return CrossAxisAlignment.center;
    }
  }

  void _setStatus(String status, int milliseconds) {
    if ((widget.disabled ?? false) || !(widget.hover ?? true)) return;

    if (milliseconds == 0) {
      setState(() => _status = status);
      return;
    }
    Future.delayed(Duration(milliseconds: milliseconds), () {
      setState(() => _status = status);
    });
  }

  List<Widget> _getImage() {
    final imageSize = widget.imageSize ?? 48;
    final list = <Widget>[];
    if (widget.imageWidget != null) {
      list.add(widget.imageWidget!);
    } else if (widget.image != null) {
      list.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.imageCircle ?? 50),
          child: Image(
            image: widget.image!,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    if (list.isEmpty) {
      return list;
    }
    list.add(SizedBox(width: 12));
    return list;
  }
}
