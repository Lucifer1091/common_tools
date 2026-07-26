// ignore_for_file: strict_raw_type, avoid_dynamic_calls

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../button/my_button.dart';
import '../text/my_text.dart';
import './my_picker_item.dart';
import './no_wave_behavior.dart';

typedef MultiPickerCallback = void Function(List selected);

class MyMultiPicker extends StatelessWidget {
  const MyMultiPicker({
    required this.title,
    required this.onConfirm,
    required this.data,
    required this.pickerHeight,
    required this.pickerItemCount,
    this.onCancel,
    this.initialIndexes,
    this.rightText,
    this.leftText,
    this.centerTextStyle,
    this.titleHeight,
    this.topPadding,
    this.leftPadding,
    this.rightPadding,
    this.titleDividerColor,
    this.backgroundColor,
    this.topRadius,
    this.padding,
    this.itemDistanceCalculator,
    this.customSelectWidget,
    this.itemBuilder,
    super.key,
  });

  final String? title;
  final MultiPickerCallback? onConfirm;
  final MultiPickerCallback? onCancel;
  final List<List<String>> data;
  final double pickerHeight;
  final int pickerItemCount;
  final Widget? customSelectWidget;
  final String? rightText;
  final String? leftText;
  final TextStyle? centerTextStyle;
  final double? titleHeight;
  final double? topPadding;
  final double? leftPadding;
  final double? rightPadding;
  final Color? titleDividerColor;
  final Color? backgroundColor;
  final double? topRadius;
  final ItemDistanceCalculator? itemDistanceCalculator;
  final EdgeInsets? padding;
  final List<int>? initialIndexes;
  final MyPickerItemBuilder? itemBuilder;
  static const _pickerTitleHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final lines = data.length;
    final indexes = initialIndexes ?? [for (var i = 0; i < lines; i++) 0];
    final controllers = <FixedExtentScrollController>[
      for (var i = 0; i < lines; i++)
        FixedExtentScrollController(initialItem: indexes[i]),
    ];
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      width: maxWidth,
      padding:
          padding ??
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.popover,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius ?? 12),
          topRight: Radius.circular(topRadius ?? 12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, controllers),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child:
                    customSelectWidget ??
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondary,
                        borderRadius: MyBorderRadius.medium,
                      ),
                    ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 32, right: 32),
                height: pickerHeight,
                width: maxWidth,
                child: Row(
                  children: [
                    for (var i = 0; i < data.length; i++)
                      Expanded(child: _buildList(context, i, controllers)),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: IgnorePointer(
                  child: Container(
                    height: _pickerTitleHeight,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.colorScheme.popover,
                          context.colorScheme.popover.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    height: _pickerTitleHeight,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          context.colorScheme.popover,
                          context.colorScheme.popover.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<FixedExtentScrollController> controllers,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: leftPadding ?? 12,
        right: rightPadding ?? 12,
        top: topPadding ?? 0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: titleDividerColor ?? context.colorScheme.border,
          ),
        ),
      ),
      height: _getTitleHeight(),
      child: Row(
        children: [
          MyButton(
            type: MyButtonType.ghost,
            text: leftText ?? 'Cancel',
            onTap: () {
              if (onCancel != null) {
                onCancel!([
                  for (var i = 0; i < controllers.length; i++)
                    controllers[i].selectedItem,
                ]);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          Expanded(
            child: title == null
                ? const SizedBox.shrink()
                : Center(
                    child: MyText(
                      title,
                      style: centerTextStyle ?? context.titleMedium,
                    ),
                  ),
          ),
          MyButton(
            type: MyButtonType.ghost,
            text: rightText ?? 'Confirm',
            textStyle: context.titleSmall.copyWith(
              color: context.colorScheme.primary,
            ),
            onTap: () {
              onConfirm?.call([
                for (var i = 0; i < controllers.length; i++)
                  controllers[i].selectedItem,
              ]);
            },
          ),
        ],
      ),
    );
  }

  double _getTitleHeight() => titleHeight ?? _pickerTitleHeight;

  Widget _buildList(
    BuildContext context,
    int position,
    List<FixedExtentScrollController> controllers,
  ) {
    final maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: NoWaveBehavior(),
        child: ListWheelScrollView.useDelegate(
          itemExtent: pickerHeight / pickerItemCount,
          diameterRatio: 100,
          controller: controllers[position],
          physics: const FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: data[position].length,
            builder: (context, index) {
              return Container(
                key: UniqueKey(),
                alignment: Alignment.center,
                height: pickerHeight / pickerItemCount,
                width: maxWidth,
                child: MyPickerItem(
                  colIndex: position,
                  index: index,
                  key: UniqueKey(),
                  itemHeight: pickerHeight / pickerItemCount,
                  content: data[position][index],
                  itemDistanceCalculator: itemDistanceCalculator,
                  fixedExtentScrollController: controllers[position],
                  itemBuilder: itemBuilder,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyMultiLinkedPicker extends StatefulWidget {
  const MyMultiLinkedPicker({
    required this.onConfirm,
    required this.selectedData,
    required this.data,
    required this.columnNum,
    this.title,
    this.onCancel,
    this.pickerHeight = 200,
    this.pickerItemCount = 5,
    this.customSelectWidget,
    this.rightText,
    this.leftText,
    this.centerTextStyle,
    this.titleHeight,
    this.topPadding,
    this.leftPadding,
    this.rightPadding,
    this.titleDividerColor,
    this.backgroundColor,
    this.topRadius,
    this.padding,
    this.itemDistanceCalculator,
    this.itemBuilder,
    super.key,
  });

  final String? title;
  final MultiPickerCallback? onConfirm;
  final MultiPickerCallback? onCancel;
  final List selectedData;
  final Map data;
  final int columnNum;
  final double pickerHeight;
  final int pickerItemCount;
  final Widget? customSelectWidget;
  final String? rightText;
  final String? leftText;
  final TextStyle? centerTextStyle;
  final EdgeInsets? padding;
  final double? titleHeight;
  final double? topPadding;
  final double? leftPadding;
  final double? rightPadding;
  final Color? titleDividerColor;
  final Color? backgroundColor;
  final double? topRadius;
  final ItemDistanceCalculator? itemDistanceCalculator;
  final MyPickerItemBuilder? itemBuilder;

  @override
  State<StatefulWidget> createState() => _MyMultiLinkedPickerState();
}

class _MyMultiLinkedPickerState extends State<MyMultiLinkedPicker> {
  late MultiLinkedPickerModel model;

  double pickerHeight = 0;

  static const _pickerTitleHeight = 56.0;

  @override
  void initState() {
    super.initState();
    pickerHeight = widget.pickerHeight;
    model = MultiLinkedPickerModel(
      data: widget.data,
      columnNum: widget.columnNum,
      initialData: widget.selectedData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      width: maxWidth,
      padding:
          widget.padding ??
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.colorScheme.popover,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topRadius ?? 12),
          topRight: Radius.circular(widget.topRadius ?? 12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(
            height: widget.pickerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child:
                      widget.customSelectWidget ??
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.colorScheme.secondary,
                          borderRadius: MyBorderRadius.medium,
                        ),
                      ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  height: pickerHeight,
                  width: maxWidth,
                  child: Row(
                    children: [
                      for (var i = 0; i < widget.columnNum; i++)
                        Expanded(child: _buildList(context, i)),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: _pickerTitleHeight,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            context.colorScheme.popover,
                            context.colorScheme.popover.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: _pickerTitleHeight,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            context.colorScheme.popover,
                            context.colorScheme.popover.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, int position) {
    final maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: NoWaveBehavior(),
        child: ListWheelScrollView.useDelegate(
          itemExtent: pickerHeight / widget.pickerItemCount,
          diameterRatio: 100,
          controller: model.controllers[position],
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            setState(() {
              // The position parameter indicates the column number
              model.refreshPresentDataAndController(position, index, false);

              // Use dynamic height to force the list component's state to
              // refresh to display updated data. See the link below for details.
              // FIX:https://github.com/flutter/flutter/issues/22999
              pickerHeight = pickerHeight - Random().nextDouble() / 100000000;
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: model.presentData[position].length,
            builder: (context, index) {
              return Container(
                alignment: Alignment.center,
                height: pickerHeight / widget.pickerItemCount,
                width: maxWidth,
                child: MyPickerItem(
                  colIndex: position,
                  index: index,
                  itemHeight: pickerHeight / widget.pickerItemCount,
                  content: model.presentData[position][index].toString(),
                  fixedExtentScrollController: model.controllers[position],
                  itemDistanceCalculator: widget.itemDistanceCalculator,
                  itemBuilder: widget.itemBuilder,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: widget.leftPadding ?? 12,
        right: widget.rightPadding ?? 12,
        top: widget.topPadding ?? 0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: widget.titleDividerColor ?? context.colorScheme.border,
          ),
        ),
      ),
      height: _getTitleHeight() - 0.5,
      child: Row(
        children: [
          MyButton(
            type: MyButtonType.ghost,
            text: widget.leftText ?? 'Cancel',
            onTap: () {
              if (widget.onCancel != null) {
                widget.onCancel!(model.selectedData);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          Expanded(
            child: widget.title == null
                ? const SizedBox.shrink()
                : Center(
                    child: MyText(
                      widget.title,
                      style: widget.centerTextStyle ?? context.titleMedium,
                    ),
                  ),
          ),
          MyButton(
            type: MyButtonType.ghost,
            text: widget.rightText ?? 'Confirm',
            textStyle: context.titleSmall.copyWith(
              color: context.colorScheme.primary,
            ),
            onTap: () {
              widget.onConfirm?.call(model.selectedData);
            },
          ),
        ],
      ),
    );
  }

  double _getTitleHeight() => widget.titleHeight ?? _pickerTitleHeight;
}

class MultiLinkedPickerModel {
  MultiLinkedPickerModel({
    required this.data,
    required this.columnNum,
    required List initialData,
  }) {
    selectedData = [];
    selectedIndexes = [];
    for (var i = 0; i < columnNum; ++i) {
      if (i >= initialData.length) {
        selectedData.add('');
      } else {
        selectedData.add(initialData[i]);
      }
      selectedIndexes.add(0);
    }
    _init(initialData);
  }

  static const placeData = '';
  late Map data;
  late List<int> selectedIndexes;
  late int columnNum;
  late List selectedData;
  late List<FixedExtentScrollController> controllers = [];
  late List<List> presentData = [];

  void _init(List initialData) {
    int pIndex;
    controllers.clear();
    presentData.clear();
    for (var i = 0; i < columnNum; ++i) {
      pIndex = 0;
      if (i == 0) {
        pIndex = data.keys.toList().indexOf(selectedData[i]);
        if (pIndex < 0) {
          selectedData[i] = data.keys.first;
          pIndex = 0;
        }
        selectedIndexes[i] = pIndex;
        presentData.add(data.keys.toList());
      } else {
        final dynamic date = findNextData(i);
        if (date is Map) {
          pIndex = date.keys.toList().indexOf(selectedData[i]);
          if (pIndex < 0) {
            selectedData[i] = date.keys.first;
            pIndex = 0;
          }
          presentData.add(date.keys.toList());
        } else if (date is List) {
          pIndex = date.indexOf(selectedData[i]);
          if (pIndex < 0) {
            selectedData[i] = date.first;
            pIndex = 0;
          }
          presentData.add(date);
        } else {
          selectedData[i] = date;
          pIndex = 0;
          presentData.add([date]);
        }
        selectedIndexes[i] = pIndex;
      }
      controllers.add(FixedExtentScrollController(initialItem: pIndex));
    }
  }

  dynamic findNextData(int position) {
    dynamic nextData;
    for (var i = 0; i < position; i++) {
      if (i == 0) {
        nextData = data[selectedData[0]];
      } else {
        final dynamic data = nextData[selectedData[i]];
        if (data is Map) {
          nextData = data;
        } else if (data is List) {
          nextData = data;
        } else {
          nextData = [data];
        }
      }
      if (nextData is! Map && (i < position - 1)) {
        return [placeData];
      }
    }
    return nextData;
  }

  /// [position] The column to change
  /// [selectedIndex] The corresponding selected index
  /// [jump] Whether to jump to the item
  void refreshPresentDataAndController(
    int position,
    int selectedIndex,
    bool jump,
  ) {
    final selectValue = presentData[position][selectedIndex];
    selectedData[position] = selectValue;
    selectedIndexes[position] = selectedIndex;
    if (jump) {
      controllers[position].jumpToItem(selectedIndex);
    }
    if (position < columnNum - 1) {
      if (presentData[position].length == 1 &&
          presentData[position].first == placeData) {
        presentData[position + 1] = [placeData];
      } else {
        presentData[position + 1] = findColumnData(position + 1);
      }
      refreshPresentDataAndController(position + 1, 0, true);
    }
  }

  List findColumnData(int position) {
    dynamic nextData;
    for (var i = 0; i < position; i++) {
      if (i == 0) {
        nextData = data[selectedData[0]];
      } else {
        final dynamic data = nextData[selectedData[i]];
        if (data is Map) {
          nextData = data;
        } else if (data is List) {
          nextData = data;
        } else {
          nextData = [data];
        }
      }

      if ((nextData is Map) && (i == position - 1)) {
        return nextData.keys.toList();
      }

      if (nextData is! Map && (i < position - 1)) {
        return [placeData];
      }
    }

    return nextData as List;
  }
}
