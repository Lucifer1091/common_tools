// ignore_for_file: strict_raw_type

import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../themes/my_colors.dart';
import './my_multi_picker.dart';
import './my_picker_item.dart';

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
    TextStyle? centerTextStyle,
    Color? titleDividerColor,
    double? topPadding,
    int pickerItemCount = 5,
    Widget? customSelectWidget,
    MyPickerItemBuilder? itemBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor:
          barrierColor ??
          context.themed(MyColors.lightScrim, MyColors.darkScrim),
      builder: (context) {
        return MyMultiPicker(
          title: title,
          onConfirm: onConfirm,
          onCancel: onCancel,
          data: data,
          rightText: rightText,
          leftText: leftText,
          centerTextStyle: centerTextStyle,
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

  static Future<void> showMultiLinkedPicker(
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
    TextStyle? centerTextStyle,
    double pickerHeight = 200,
    Color? titleDividerColor,
    Widget? customSelectWidget,
    double? topPadding,
    int pickerItemCount = 5,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor:
          barrierColor ??
          context.themed(MyColors.lightScrim, MyColors.darkScrim),
      builder: (context) {
        return MyMultiLinkedPicker(
          title: title,
          onConfirm: onConfirm,
          onCancel: onCancel,
          data: data,
          rightText: rightText,
          leftText: leftText,
          centerTextStyle: centerTextStyle,
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
