import 'package:flutter/material.dart';

import '../../../index.dart';

class MyPicker {
  MyPicker._();

  static Future<T?> showMultiPicker<T>(
    BuildContext context, {
    required MultiPickerCallback? onConfirm,
    required List<List<String>> data,
    String? title,
    MultiPickerCallback? onCancel,
    List<int>? initialIndexes,
    Duration duration = const Duration(milliseconds: 100),
    Color? barrierColor,
    double pickerHeight = 200,
    String? rightText,
    String? leftText,
    TextStyle? leftTextStyle,
    TextStyle? centerTextStyle,
    TextStyle? rightTextStyle,
    Color? titleDividerColor,
    double? topPadding,
    int pickerItemCount = 5,
    Widget? customSelectWidget,
    ItemBuilderType? itemBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor:
          barrierColor ?? ThemeColors.neutral.shade800.withValues(alpha: 0.6),
      builder: (context) {
        return MyMultiPicker(
          title: title,
          onConfirm: onConfirm,
          onCancel: onCancel,
          data: data,
          rightText: rightText,
          leftText: leftText,
          leftTextStyle: leftTextStyle,
          centerTextStyle: centerTextStyle,
          rightTextStyle: rightTextStyle,
          initialIndexes: initialIndexes,
          pickerHeight: pickerHeight,
          pickerItemCount: pickerItemCount,
          titleDividerColor: titleDividerColor,
          topPadding: topPadding,
          itemBuilder: itemBuilder,
          customSelectWidget: customSelectWidget,
        );
      },
    );
  }

  static Future<void> showMultiLinkedPicker<T>(
    BuildContext context, {
    required MultiPickerCallback? onConfirm,
    required Map data,
    required int columnNum,
    required List initialData,
    String? title,
    MultiPickerCallback? onCancel,
    Duration duration = const Duration(milliseconds: 100),
    Color? barrierColor,
    String? rightText,
    String? leftText,
    TextStyle? leftTextStyle,
    TextStyle? centerTextStyle,
    TextStyle? rightTextStyle,
    double pickerHeight = 200,
    Color? titleDividerColor,
    Widget? customSelectWidget,
    double? topPadding,
    int pickerItemCount = 5,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor:
          barrierColor ?? ThemeColors.neutral.shade800.withValues(alpha: 0.6),
      builder: (context) {
        return MyMultiLinkedPicker(
          title: title,
          onConfirm: onConfirm,
          onCancel: onCancel,
          data: data,
          rightText: rightText,
          leftText: leftText,
          leftTextStyle: leftTextStyle,
          centerTextStyle: centerTextStyle,
          rightTextStyle: rightTextStyle,
          pickerHeight: pickerHeight,
          pickerItemCount: pickerItemCount,
          columnNum: columnNum,
          selectedData: initialData,
          titleDividerColor: titleDividerColor,
          topPadding: topPadding,
          customSelectWidget: customSelectWidget,
        );
      },
    );
  }
}
