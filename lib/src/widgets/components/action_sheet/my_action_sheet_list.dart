import 'dart:async';

import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../extensions/misc/color.dart';
import '../../common/my_gesture_detector.dart';
import '../../packages/gap/src/widgets/gap.dart';
import '../text/my_text.dart';
import './my_action_sheet.dart';
import './my_action_sheet_item_widget.dart';

class MyActionSheetList extends StatelessWidget {
  const MyActionSheetList({
    required this.items,
    super.key,
    this.align = MyActionSheetAlign.center,
    this.cancelText = 'Cancel',
    this.description,
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
    this.useSafeArea = true,
    this.radius = 32,
  });

  final List<ActionSheetItem> items;
  final MyActionSheetAlign align;
  final String cancelText;
  final String? description;
  final bool showCancel;
  final VoidCallback? onCancel;
  final MyActionSheetItemCallback? onSelected;
  final bool useSafeArea;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        color: context.colorScheme.secondary,
      ),
      clipBehavior: Clip.antiAlias,
      padding: useSafeArea
          ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
          : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (description != null) _buildDescription(context),
          _buildOptionsList(context),
          if (showCancel) _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        border: Border(
          bottom: BorderSide(color: context.colorScheme.border, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(align),
        children: [
          MyText(
            description,
            fontSize: context.bodyMedium.fontSize,
            textColor: context.colorScheme.mutedForeground,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.background,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final item = items[index];
          return MyGestureDetector(
            onTap: item.disabled
                ? null
                : () {
                    onSelected?.call(item, index);
                    unawaited(Navigator.maybePop(context));
                  },
            child: Container(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.border,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: getMainAxisAlignment(align),
                children: [
                  if (item.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: item.disabled
                            ? context.colorScheme.mutedForeground.scaleAlpha(
                                0.8,
                              )
                            : (item.textStyle?.color ??
                                  context.colorScheme.foreground),
                        size: item.textStyle?.fontSize,
                      ),
                      child: SizedBox(
                        width: item.iconSize ?? 24,
                        height: item.iconSize ?? 24,
                        child: item.icon,
                      ),
                    ),
                    const Gap(8),
                  ],
                  MyText(
                    item.label,
                    fontSize: context.bodyLarge.fontSize,
                    textColor: item.disabled
                        ? context.colorScheme.mutedForeground.scaleAlpha(0.8)
                        : (item.textStyle?.color ??
                              context.colorScheme.foreground),
                    style: item.textStyle,
                  ),
                  if (item.badge != null) ...[const Gap(8), item.badge!],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Column(
      children: [
        const Gap(8),
        MyGestureDetector(
          onTap: () {
            onCancel?.call();
            unawaited(Navigator.maybePop(context));
          },
          child: Container(
            color: context.colorScheme.background,
            height: 48,
            child: Center(
              child: MyText(
                cancelText,
                fontSize: context.bodyLarge.fontSize,
                textColor: context.colorScheme.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
