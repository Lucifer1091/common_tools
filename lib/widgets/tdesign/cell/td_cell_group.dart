import 'package:flutter/material.dart';

import '../../../index.dart';
import '../../layout/no_widget.dart';
import '../text/my_text.dart';
import 'td_cell.dart';
import 'td_cell_inherited.dart';
import 'td_cell_style.dart';

typedef CellBuilder =
    Widget Function(BuildContext context, TDCell cell, int index);

enum TDCellGroupTheme { defaultTheme, cardTheme }

class TDCellGroup extends StatefulWidget {
  const TDCellGroup({
    required this.cells,
    super.key,
    this.bordered = false,
    this.theme = TDCellGroupTheme.defaultTheme,
    this.title,
    this.builder,
    this.style,
    this.titleWidget,
    this.scrollable = false,
    this.isShowLastBordered = false,
  });

  final bool? bordered;

  final TDCellGroupTheme? theme;

  final String? title;

  final Widget? titleWidget;

  final List<TDCell> cells;

  final CellBuilder? builder;

  final MyCellStyle? style;

  final bool? scrollable;

  final bool? isShowLastBordered;

  @override
  _TDCellGroupState createState() => _TDCellGroupState();
}

class _TDCellGroupState extends State<TDCellGroup> {
  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? MyCellStyle.cellStyle(context);
    final itemCount = widget.cells.length;
    final radius = _getBorderRadius(style);

    return TDCellInherited(
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
                  widget.theme == TDCellGroupTheme.cardTheme
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
                        (widget.isShowLastBordered ?? false)) {
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

    final color = style.groupBorderedColor ?? ThemeColors.neutral.shade200;
    return Border.all(color: color);
  }

  BorderRadiusGeometry _getBorderRadius(MyCellStyle style) {
    if (widget.theme == TDCellGroupTheme.cardTheme) {
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
            color: style.borderedColor ?? ThemeColors.neutral.shade200,
          ),
        ),
      ],
    );
  }
}
