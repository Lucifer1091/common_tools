import 'package:flutter/material.dart';

import '../../../index.dart';
import '../cell/td_cell.dart';
import '../cell/td_cell_group.dart';
import '../cell/td_cell_style.dart';

typedef TDDrawerItemClickCallback = void Function(int index, TDDrawerItem item);

/// Drawer content component
/// Can be used for drawer properties in Scaffold
class TDDrawerWidget extends StatelessWidget {
  const TDDrawerWidget({
    super.key,
    this.footer,
    this.items,
    this.contentWidget,
    this.title,
    this.titleWidget,
    this.onItemClick,
    this.width = 280,
    this.style,
    this.hover = true,
    this.backgroundColor,
    this.bordered = true,
    this.isShowLastBordered = true,
  });

  final Widget? footer;

  final List<TDDrawerItem>? items;

  /// Custom content, with higher priority than [items]/[footer]/[title]
  final Widget? contentWidget;

  final String? title;

  final Widget? titleWidget;

  final TDDrawerItemClickCallback? onItemClick;

  final double? width;

  final TDCellStyle? style;

  final bool? hover;

  final Color? backgroundColor;

  final bool? bordered;

  /// Whether to display the last line separator
  final bool? isShowLastBordered;

  @override
  Widget build(BuildContext context) {
    var content = contentWidget;

    if (content == null) {
      var cellStyle = style;
      cellStyle ??= TDCellStyle.cellStyle(context)
        ..leftIconColor = ThemeColors.neutral.shade900;

      final cells =
          items
              ?.asMap()
              .map(
                (index, item) => MapEntry(
                  index,
                  TDCell(
                    titleWidget: item.content,
                    title: item.title,
                    leftIconWidget: item.icon,
                    hover: hover,
                    bordered: bordered,
                    onClick: (cell) {
                      if (onItemClick == null) {
                        return;
                      }
                      onItemClick!(index, items![index]);
                    },
                  ),
                ),
              )
              .values
              .toList();

      content = Column(
        children: [
          Expanded(
            child: TDCellGroup(
              title: title,
              titleWidget: titleWidget,
              style: cellStyle,
              scrollable: true,
              isShowLastBordered: isShowLastBordered,
              cells: cells ?? [],
            ),
          ),
          if (footer != null)
            Container(padding: const EdgeInsets.all(16), child: footer),
        ],
      );
    }

    return Container(
      color: backgroundColor ?? Colors.white,
      width: width ?? 280,
      height: double.infinity,
      child: content,
    );
  }
}

class TDDrawerItem {
  TDDrawerItem({this.title, this.icon, this.content});

  final String? title;

  final Widget? icon;

  final Widget? content;
}
