import 'package:flutter/material.dart';

import '../../../index.dart';

typedef MyCellBuilder =
    Widget Function(BuildContext context, MyCell cell, int index);

enum MyCellGroupTheme { defaults, card }

class MyCellGroup extends StatefulWidget {
  const MyCellGroup({
    required this.cells,
    super.key,
    this.bordered = false,
    this.theme = MyCellGroupTheme.defaults,
    this.title,
    this.builder,
    this.style,
    this.titleWidget,
    this.scrollable = false,
    this.showLastBorder = false,
  });

  final bool? bordered;
  final MyCellGroupTheme? theme;
  final String? title;
  final Widget? titleWidget;
  final List<MyCell> cells;
  final MyCellBuilder? builder;
  final MyCellStyle? style;
  final bool? scrollable;
  final bool? showLastBorder;

  @override
  _MyCellGroupState createState() => _MyCellGroupState();
}

class _MyCellGroupState extends State<MyCellGroup> {
  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? MyCellStyle.style(context);
    final itemCount = widget.cells.length;
    final radius = _getBorderRadius(style);

    return MyCellInherited(
      style: style,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null || widget.titleWidget != null)
            Container(
              width: double.infinity,
              color: style.titleBackgroundColor,
              padding: style.titlePadding,
              child:
                  widget.titleWidget ??
                  MyText(widget.title, style: style.groupTitleStyle),
            ),
          Flexible(
            child: Container(
              padding:
                  widget.theme == MyCellGroupTheme.card
                      ? style.cardPadding
                      : EdgeInsets.zero,
              decoration: BoxDecoration(
                border: _getBordered(style),
                borderRadius: radius,
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: widget.scrollable == false,
                  physics:
                      widget.scrollable == false
                          ? const NeverScrollableScrollPhysics()
                          : null,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    final item = widget.cells[index];
                    final cell =
                        widget.builder == null
                            ? item
                            : widget.builder!(context, item, index);
                    if (itemCount - 1 == index &&
                        (widget.showLastBorder ?? false)) {
                      return Column(children: [cell, _borderWidget(style)]);
                    }
                    return cell;
                  },
                  separatorBuilder: (context, index) {
                    if (!(widget.cells[index].bordered ?? true)) {
                      return const NoWidget();
                    }
                    return _borderWidget(style);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxBorder? _getBordered(MyCellStyle style) {
    if (!(widget.bordered ?? false)) return null;

    final color = style.groupBorderedColor ?? context.colorScheme.border;
    return Border.all(color: color);
  }

  BorderRadiusGeometry _getBorderRadius(MyCellStyle style) {
    if (widget.theme == MyCellGroupTheme.card) {
      return style.cardBorderRadius ?? BorderRadius.zero;
    }
    return BorderRadius.zero;
  }

  Widget _borderWidget(MyCellStyle style) {
    return Row(
      children: [
        Container(height: 0.5, width: 16, color: style.backgroundColor),
        Expanded(
          child: Container(
            height: 0.5,
            color: style.borderedColor ?? context.colorScheme.border,
          ),
        ),
      ],
    );
  }
}
