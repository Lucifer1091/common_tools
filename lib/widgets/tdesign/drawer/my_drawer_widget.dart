import 'package:flutter/material.dart';

import '../../../index.dart';

typedef OnTapMyDrawerItem = void Function(int index, MyDrawerItem item);

/// Drawer content component
/// Can be used for drawer properties in Scaffold
class MyDrawerWidget extends StatelessWidget {
  const MyDrawerWidget({
    super.key,
    this.footer,
    this.items,
    this.content,
    this.title,
    this.titleWidget,
    this.onItemTap,
    this.width = 280,
    this.style,
    this.hover = true,
    this.backgroundColor,
    this.bordered = true,
    this.showLastBorder = true,
  });

  final Widget? footer;

  final List<MyDrawerItem>? items;

  /// Custom content, with higher priority than [items]/[footer]/[title]
  final Widget? content;

  final String? title;

  final Widget? titleWidget;

  final OnTapMyDrawerItem? onItemTap;

  final double? width;

  final MyCellStyle? style;

  final bool hover;

  final Color? backgroundColor;

  final bool? bordered;

  /// Whether to display the last line separator
  final bool? showLastBorder;

  @override
  Widget build(BuildContext context) {
    var content = this.content;

    if (content == null) {
      var cellStyle = style;
      cellStyle ??= MyCellStyle.style(context)
        ..leftIconColor = context.colorScheme.foreground;

      final cells =
          items
              ?.asMap()
              .map(
                (index, item) => MapEntry(
                  index,
                  MyCell(
                    title: item.title,
                    titleWidget: item.content,
                    leftIconWidget: item.icon,
                    hover: hover,
                    bordered: bordered,
                    onTap: (cell) {
                      onItemTap?.call(index, items![index]);
                    },
                  ),
                ),
              )
              .values
              .toList();

      content = MyColumn(
        children: [
          Expanded(
            child: MyCellGroup(
              title: title,
              titleWidget: titleWidget,
              style: cellStyle,
              scrollable: true,
              showLastBorder: showLastBorder,
              cells: cells ?? [],
            ),
          ),
          if (footer != null)
            Padding(padding: const EdgeInsets.all(16), child: footer),
        ],
      );
    }

    return Container(
      width: width ?? 280,
      height: double.infinity,
      color: backgroundColor ?? context.colorScheme.background,
      child: content,
    );
  }
}

class MyDrawerItem {
  MyDrawerItem({this.title, this.icon, this.content});

  final String? title;

  final Widget? icon;

  final Widget? content;
}
