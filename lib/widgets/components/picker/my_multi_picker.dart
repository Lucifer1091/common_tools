import 'dart:math';

import 'package:flutter/material.dart';

import '../../../index.dart';

typedef MultiPickerCallback<T> = void Function(List<T> selected);

class MyMultiPicker<T> extends StatelessWidget {
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
    this.leftTextStyle,
    this.rightTextStyle,
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
  final MultiPickerCallback<T>? onConfirm;
  final MultiPickerCallback<T>? onCancel;
  final List<List<String>> data;
  final double pickerHeight;
  final int pickerItemCount;
  final Widget? customSelectWidget;
  final String? rightText;
  final String? leftText;
  final TextStyle? leftTextStyle;
  final TextStyle? rightTextStyle;
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
  final ItemBuilderType? itemBuilder;
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
          buildTitle(context, controllers),
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
                        color: ThemeColors.neutral.shade900,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
              ),
              // 列表
              Container(
                padding: const EdgeInsets.only(left: 32, right: 32),
                height: pickerHeight,
                width: maxWidth,
                child: Row(
                  children: [
                    for (var i = 0; i < data.length; i++)
                      Expanded(child: buildList(context, i, controllers)),
                  ],
                ),
              ),
              // 蒙层
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
                          Colors.white,
                          Colors.white.withValues(alpha: 0),
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
                          Colors.white,
                          Colors.white.withValues(alpha: 0),
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

  Widget buildTitle(
    BuildContext context,
    List<FixedExtentScrollController> controllers,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: leftPadding ?? 16,
        right: rightPadding ?? 16,
        top: topPadding ?? 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: titleDividerColor ?? Colors.transparent,
          ),
        ),
      ),
      height: getTitleHeight(),
      child: Row(
        children: [
          // 左边按钮
          GestureDetector(
            onTap: () {
              if (onCancel != null) {
                onCancel!([
                  for (var i = 0; i < controllers.length; i++)
                    controllers[i].selectedItem as T,
                ]);
              } else {
                Navigator.of(context).pop();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: MyText(
              leftText ?? 'Cancel',
              style:
                  leftTextStyle ??
                  context.bodyLarge.copyWith(
                    color: ThemeColors.neutral.shade800,
                  ),
            ),
          ),

          // 中间title
          Expanded(
            child:
                title == null
                    ? Container()
                    : Center(
                      child: MyText(
                        title,
                        style:
                            centerTextStyle ??
                            context.titleLarge.copyWith(
                              color: ThemeColors.neutral.shade900,
                            ),
                      ),
                    ),
          ),

          GestureDetector(
            onTap: () {
              onConfirm?.call([
                for (var i = 0; i < controllers.length; i++)
                  controllers[i].selectedItem as T,
              ]);
            },
            behavior: HitTestBehavior.opaque,
            child: MyText(
              rightText ?? 'Confirm',
              style:
                  rightTextStyle ??
                  context.bodyLarge.copyWith(color: ThemeColors.blue.shade600),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => titleHeight ?? _pickerTitleHeight;

  Widget buildList(
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
                child: TDItemWidget(
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
    this.leftTextStyle,
    this.rightTextStyle,
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

  final TextStyle? leftTextStyle;

  final TextStyle? rightTextStyle;

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

  final ItemBuilderType? itemBuilder;

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
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topRadius ?? 12),
          topRight: Radius.circular(widget.topRadius ?? 12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(context),
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
                          color: ThemeColors.neutral.shade50,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                ),

                // 列表
                Container(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  height: pickerHeight,
                  width: maxWidth,
                  child: Row(
                    children: [
                      for (var i = 0; i < widget.columnNum; i++)
                        Expanded(child: buildList(context, i)),
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
                            Colors.white,
                            Colors.white.withValues(alpha: 0),
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
                            Colors.white,
                            Colors.white.withValues(alpha: 0),
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

  Widget buildList(BuildContext context, int position) {
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
                child: TDItemWidget(
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

  Widget buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: widget.leftPadding ?? 16,
        right: widget.rightPadding ?? 16,
        top: widget.topPadding ?? 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: widget.titleDividerColor ?? Colors.transparent,
          ),
        ),
      ),
      height: getTitleHeight() - 0.5,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.onCancel != null) {
                widget.onCancel!(model.selectedData);
              } else {
                Navigator.of(context).pop();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: MyText(
              widget.leftText ?? 'Cancel',
              style:
                  widget.leftTextStyle ??
                  context.bodyLarge.copyWith(
                    color: ThemeColors.neutral.shade800,
                  ),
            ),
          ),

          Expanded(
            child:
                widget.title == null
                    ? const NoWidget()
                    : Center(
                      child: MyText(
                        widget.title,
                        style:
                            widget.centerTextStyle ??
                            context.titleLarge.copyWith(
                              color: ThemeColors.neutral.shade900,
                            ),
                      ),
                    ),
          ),
          GestureDetector(
            onTap: () {
              widget.onConfirm?.call(model.selectedData);
            },
            behavior: HitTestBehavior.opaque,
            child: MyText(
              widget.rightText ?? 'Confirm',
              style:
                  widget.rightTextStyle ??
                  context.bodyLarge.copyWith(color: ThemeColors.blue.shade600),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => widget.titleHeight ?? _pickerTitleHeight;
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
