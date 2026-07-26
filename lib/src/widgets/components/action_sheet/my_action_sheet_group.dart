import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../extensions/iterable/converters.dart';
import '../../../extensions/iterable/sanitizers.dart';
import '../text/my_text.dart';
import './my_action_sheet.dart';
import './my_action_sheet_item_widget.dart';

class MyActionSheetGroup extends StatelessWidget {
  const MyActionSheetGroup({
    required this.items,
    super.key,
    this.align = MyActionSheetAlign.left,
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
  final MyActionSheetAlign align;
  final String cancelText;
  final bool showCancel;
  final VoidCallback? onCancel;
  final MyActionSheetItemCallback? onSelected;
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
        color: context.colorScheme.background,
      ),
      clipBehavior: Clip.antiAlias,
      padding: useSafeArea
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
                      MyText(
                        k,
                        fontSize: context.bodyMedium.fontSize,
                        textColor: context.colorScheme.mutedForeground,
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
                        child: MyActionSheetItemWidget(
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
                      border: Border(
                        top: BorderSide(
                          color: context.colorScheme.border,
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
