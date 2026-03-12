import 'package:flutter/material.dart';
import '../../../index.dart';

class MyActionSheetGrid extends StatefulWidget {
  const MyActionSheetGrid({
    required this.items,
    super.key,
    this.description,
    this.align = MyActionSheetAlign.center,
    this.count = 8,
    this.rows = 2,
    this.cancelText = 'Cancel',
    this.showCancel = true,
    this.showPagination = false,
    this.scrollable = false,
    this.onCancel,
    this.onSelected,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.useSafeArea = true,
  });

  final List<ActionSheetItem> items;
  final String? description;
  final MyActionSheetAlign align;
  final int count;
  final int rows;
  final String cancelText;
  final bool showCancel;
  final bool showPagination;
  final bool scrollable;
  final VoidCallback? onCancel;
  final MyActionSheetItemCallback? onSelected;
  final double itemHeight;
  final double itemMinWidth;
  final bool useSafeArea;

  @override
  _MyActionSheetGridState createState() => _MyActionSheetGridState();
}

class _MyActionSheetGridState extends State<MyActionSheetGrid> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(30);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        color: context.colorScheme.background,
      ),
      clipBehavior: Clip.antiAlias,
      padding:
          widget.useSafeArea
              ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
              : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(8),
          if (widget.description != null) _buildDescription(context),
          if (widget.showPagination) ...[
            _buildPaginationGrid(context),
            _buildPaginationDots(context),
          ] else if (widget.scrollable)
            _buildScrollGrid(context)
          else
            _buildGrid(context),
          if (widget.showCancel)
            buildCancelButton(
              context,
              widget.showPagination,
              widget.cancelText,
              widget.onCancel,
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 4),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(widget.align),
        children: [
          MyText(
            widget.description,
            fontSize: context.bodyMedium.fontSize,
            textColor:
                context.bodyMedium.color ?? context.colorScheme.mutedForeground,
          ),
        ],
      ),
    );
  }

  Widget _gridWrap(Widget child) {
    return SizedBox(height: widget.rows * widget.itemHeight, child: child);
  }

  Widget _buildPaginationGrid(BuildContext context) {
    return _gridWrap(
      PageView.builder(
        itemCount: (widget.items.length / widget.count).ceil(),
        onPageChanged:
            widget.showPagination
                ? (index) {
                  setState(() {
                    currentPage = index;
                  });
                }
                : null,
        itemBuilder: (context, pageIndex) {
          final pageItems =
              widget.items
                  .skip(pageIndex * widget.count)
                  .take(widget.count)
                  .toList();
          return _buildGrid(context, items: pageItems, pageIndex: pageIndex);
        },
      ),
    );
  }

  Widget _buildScrollGrid(BuildContext context) {
    final chunks =
        widget.items
            .chunks((widget.items.length / widget.rows).ceil())
            .toList();
    final itemCount = chunks[0].length;

    return _gridWrap(
      ListView.builder(
        itemCount: itemCount,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, col) {
          return Column(
            children: List.generate(chunks.length, (row) {
              final index = itemCount * row + col;
              return SizedBox(
                width: widget.itemMinWidth,
                height: widget.itemHeight,
                child: MyActionSheetItemWidget(
                  item: chunks[row].getOrNull(col),
                  index: index,
                  onSelected: widget.onSelected,
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context, {
    List<ActionSheetItem>? items,
    int pageIndex = 0,
  }) {
    final itemsPerRow = widget.count ~/ widget.rows;
    final screenWidth = MediaQuery.of(context).size.width;
    final childAspectRatio = screenWidth / itemsPerRow / widget.itemHeight;

    return _gridWrap(
      GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: (items ?? widget.items).length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemsPerRow,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          final item = (items ?? widget.items)[index];
          return MyActionSheetItemWidget(
            item: item,
            index: pageIndex * widget.count + index,
            onSelected: widget.onSelected,
          );
        },
      ),
    );
  }

  Widget _buildPaginationDots(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate((widget.items.length / widget.count).ceil(), (
        index,
      ) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                currentPage == index
                    ? context.colorScheme.primary
                    : context.colorScheme.mutedForeground,
          ),
        );
      }),
    );
  }
}
