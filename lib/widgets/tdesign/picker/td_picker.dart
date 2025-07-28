import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDPicker {
  TDPicker._();

  /// 显示多级选择器
  static void showMultiPicker(
    context, {
    String? title,
    required MultiPickerCallback? onConfirm,
    MultiPickerCallback? onCancel,
    required List<List<String>> data,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor:
          barrierColor ?? TDTheme.of(context).fontGyColor2.withOpacity(0.6),
      builder: (context) {
        return TDMultiPicker(
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

  /// 显示多级联动选择器
  static void showMultiLinkedPicker(
    context, {
    String? title,
    required MultiPickerCallback? onConfirm,
    MultiPickerCallback? onCancel,
    required Map data,
    required int columnNum,
    required List initialData,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor:
          barrierColor ?? TDTheme.of(context).fontGyColor2.withOpacity(0.6),
      builder: (context) {
        return TDMultiLinkedPicker(
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
