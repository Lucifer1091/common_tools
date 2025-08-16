import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../index.dart';
import '../../../extensions/iterable/index.dart';
import '../text/td_text.dart';
import 'td_action_sheet.dart';
import 'td_action_sheet_item_widget.dart';

class TDActionSheetGroup extends StatelessWidget {
  const TDActionSheetGroup({
    required this.items,
    super.key,
    this.align = TDActionSheetAlign.left,
    this.cancelText = 'Cancel',
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.radius = 32.0,
    this.useSafeArea = true,
  });

  final List<ActionSheetItem> items;
  final TDActionSheetAlign align;
  final String cancelText;
  final bool showCancel;
  final VoidCallback? onCancel;
  final TDActionSheetItemCallback? onSelected;
  final double itemHeight;
  final double itemMinWidth;
  final double radius;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(radius);
    final groupItems = items.groupBy<String?, ActionSheetItem>(
      (item) => item.group,
    );
    final groupKeys = groupItems.keys.where(
      (k) => k != null && (groupItems[k]?.isNotEmpty ?? false),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      padding:
          useSafeArea
              ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
              : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...groupKeys.mapIndexed((i, k) {
            final list = groupItems[k]!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    mainAxisAlignment: getMainAxisAlignment(align),
                    children: [
                      TDText(
                        k,
                        fontSize: context.bodyMedium?.fontSize,
                        textColor: ThemeColors.neutral.shade300,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: itemHeight,
                  child: ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, row) {
                      return SizedBox(
                        width: itemMinWidth,
                        child: TDActionSheetItemWidget(
                          item: list[row],
                          onSelected: onSelected,
                          index: items.indexOf(list[row]),
                        ),
                      );
                    },
                  ),
                ),
                if (i != groupKeys.length - 1)
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.neutral.shade700,
                      border: Border(
                        top: BorderSide(
                          color: ThemeColors.neutral.shade300,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          if (showCancel)
            buildCancelButton(context, false, cancelText, onCancel),
        ],
      ),
    );
  }
}
