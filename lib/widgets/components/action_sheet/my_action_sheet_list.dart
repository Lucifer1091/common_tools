import 'dart:async';

import 'package:flutter/material.dart';
import '../../../index.dart';

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
        color: ThemeColors.neutral.shade100,
      ),
      clipBehavior: Clip.antiAlias,
      padding:
          useSafeArea
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

  /// 构建描述文本
  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ThemeColors.neutral.shade300,
        border: Border(
          bottom: BorderSide(color: ThemeColors.neutral.shade100, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(align),
        children: [
          MyText(
            description!,
            fontSize: context.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade500,
          ),
        ],
      ),
    );
  }

  /// 构建Options列表
  Widget _buildOptionsList(BuildContext context) {
    return ColoredBox(
      color: ThemeColors.neutral.shade300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap:
                item.disabled
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
                    color: ThemeColors.neutral.shade100,
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
                        color:
                            item.disabled
                                ? ThemeColors.neutral.shade400
                                : (item.textStyle?.color ??
                                    ThemeColors.neutral.shade100),
                        size: item.textStyle?.fontSize,
                      ),
                      child: SizedBox(
                        width: item.iconSize ?? 24,
                        height: item.iconSize ?? 24,
                        child: item.icon!,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  MyText(
                    item.label,
                    fontSize: context.bodyLarge.fontSize,
                    textColor:
                        item.disabled
                            ? ThemeColors.neutral.shade400
                            : (item.textStyle?.color ??
                                ThemeColors.neutral.shade100),
                    style: item.textStyle,
                  ),
                  if (item.badge != null) ...[SizedBox(width: 8), item.badge!],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建取消按钮
  Widget _buildCancelButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            onCancel?.call();
            unawaited(Navigator.maybePop(context));
          },
          child: Container(
            color: ThemeColors.neutral.shade300,
            height: 48,
            child: Center(
              child: MyText(
                cancelText,
                fontSize: context.bodyLarge.fontSize,
                textColor: ThemeColors.neutral.shade900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
