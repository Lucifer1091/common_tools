import 'package:flutter/material.dart';

import '../../../index.dart';

enum TDRadioStyle { circle, square, check, hollowCircle }

/// Radio button, inherited from TDCheckbox, the field meaning is consistent with the parent class
class TDRadio extends MyCheckbox {
  const TDRadio({
    super.id,
    super.key,
    super.title,
    super.enabled,
    super.titleStyle,
    super.subTitle,
    super.subTitleStyle,
    int super.subTitleMaxLine,
    int super.titleMaxLine = 1,
    super.selectedColor,
    super.customContentBuilder,
    super.spacing,
    bool? cardMode,
    bool? showDivider,
    super.size,
    this.radioStyle = TDRadioStyle.circle,
    super.contentDirection,
    super.customIconBuilder,
    super.titleColor,
    super.subTitleColor,
    super.backgroundColor,
    super.checkBoxLeftSpace,
  }) : super(cardMode: cardMode ?? false, showDivider: showDivider ?? true);

  final TDRadioStyle radioStyle;

  @override
  Widget buildDefaultIcon(
    BuildContext context,
    MyCheckboxGroupState? groupState,
    bool? isSelected,
  ) {
    if (cardMode) return const NoWidget();

    TDRadioStyle? style;
    if (groupState is TDRadioGroupState) {
      style = (groupState.widget as TDRadioGroup).radioCheckStyle;
    }

    style = style ?? radioStyle;

    final size = 24.0;

    final selected = isSelected ?? false;

    if (style == TDRadioStyle.hollowCircle) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: HollowCircle(
            !enabled
                ? (selected
                    ? ThemeColors.blue.shade200
                    : ThemeColors.neutral.shade300)
                : selected
                ? selectedColor ?? ThemeColors.blue.shade600
                : ThemeColors.neutral.shade300,
          ),
        ),
      );
    }

    IconData? iconData;

    switch (style) {
      case TDRadioStyle.check:
        iconData = selected ? Icons.check : null;
      case TDRadioStyle.square:
        iconData =
            selected
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded;
      case TDRadioStyle.circle:
      case TDRadioStyle.hollowCircle:
        iconData = selected ? Icons.check_circle : Icons.circle_outlined;
    }

    if (iconData != null) {
      return Icon(
        iconData,
        size: size,
        // color:
            // !enabled
            //     ? (selected
            //         ? (disabledColor ?? ThemeColors.blue.shade200)
            //         : ThemeColors.neutral.shade300)
            //     : selected
            //     ? selectedColor ?? ThemeColors.blue.shade600
            //     : ThemeColors.neutral.shade300,
      );
    } else {
      return SizedBox(width: size, height: size);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return TDRadioState();
  }
}

class TDRadioState extends MyCheckboxState {
  @override
  Widget build(BuildContext context) {
    // Check if it is contained in TDCheckboxGroup, if so, the state is managed by the Group
    final groupState = MyCheckboxGroupInherited.of(context)?.state;
    if (groupState is TDRadioGroupState) {
      final strictMode = (groupState.widget as TDRadioGroup).strictMode;
      // In strict mode, you cannot cancel the option, you can only switch it
      if (strictMode) canNotCancel = true;
    }
    return super.build(context);
  }
}

class HollowCircle extends CustomPainter {
  HollowCircle(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(10.5, 10.5), 10.5, paint);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(10.5, 10.5), 6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// RadioGroup grouping object, inherited from TDCheckboxGroup, the field
/// meaning is consistent with the parent class
/// RadioGroup should be nested in [TDRadioGroup], and only one RadioButton in
/// RadioGroup can be selected
///
/// cardMode: Use the card style, need to be used with direction and directionalTdRadios,
/// Combine into horizontal and vertical cards, and set the cardMode parameter on each TDRadio.
class TDRadioGroup extends MyCheckboxGroup {
  TDRadioGroup({
    super.key,
    Widget? child, // 使用child 则请勿设置direction
    Axis? direction, // direction 对 directionalTdRadios 起作用
    List<TDRadio>? directionalTdRadios,
    String? selectId, // 默认选择项的id
    bool? passThrough, // 非通栏单选样式 用于使用child 或 direction == Axis.vertical 场景
    bool cardMode = false,
    this.strictMode = true,
    this.radioCheckStyle,
    super.titleMaxLine, // item的行数
    super.customIconBuilder,
    super.customContentBuilder,
    super.spacing, // icon和文字距离
    this.rowCount = 1,
    super.contentDirection,
    OnRadioGroupChange? onRadioGroupChange, // 切换监听
    this.showDivider = false,
    this.divider,
  }) : assert(() {
         // 使用direction属性则必须配合directionalTdRadios，child字段无效
         if (direction != null && directionalTdRadios == null) {
           throw FlutterError(
             '[TDRadioGroup] direction and directionalTdRadios must set at the same time',
           );
         }
         // 未使用direction则必须设置child
         if (direction == null && child == null) {
           throw FlutterError(
             '[TDRadioGroup] direction means use child as the exact one, but child is null',
           );
         }
         // 横向单选框 每个Options有字数限制
         if (direction == Axis.horizontal && directionalTdRadios != null) {
           for (final element in directionalTdRadios) {
             if (element.subTitle != null) {
               throw FlutterError(
                 'horizontal radios style should not have subTilte, '
                 'because there left no room for it',
               );
             }
           }
           var maxWordCount = 2;
           final tips =
               '[TDRadioGroup] radio title please not exceed $maxWordCount words.\n'
               '2tabs: 7words maximum\n'
               '3tabs: 4words maximum\n'
               '4tabs: 2words maximum';
           if (directionalTdRadios.length == 2) {
             maxWordCount = 7;
           }
           if (directionalTdRadios.length == 3) {
             maxWordCount = 4;
           }
           if (directionalTdRadios.length == 4) {
             maxWordCount = 2;
           }
           for (final radio in directionalTdRadios) {
             if ((radio.title?.length ?? 0) > maxWordCount) {
               throw FlutterError(tips);
             }
           }
         }
         // 卡片模式要求每个TDRadio必须设置cardMode属性为true，且不能有子Title（空间不够）
         if (cardMode) {
           assert(direction != null && directionalTdRadios != null, '');
           for (final element in directionalTdRadios!) {
             // if use cardMode at TDRadioGroup, then every TDRadio should
             // set it's own carMode to true.
             if (!element.cardMode) {
               throw FlutterError(
                 'if use cardMode at TDRadioGroup, then every '
                 "TDRadio should set it's own carMode to true.",
               );
             }
             if (element.subTitle != null && direction == Axis.horizontal) {
               throw FlutterError(
                 'horizontal card style should not have subTilte, '
                 'because there left no room for it',
               );
             }
           }
         }
         return true;
       }(), ''),
       super(
         child: Container(
           clipBehavior:
               (passThrough ?? false) && direction != Axis.horizontal
                   ? Clip.hardEdge
                   : Clip.none,
           decoration:
               (passThrough ?? false) && direction != Axis.horizontal
                   ? BoxDecoration(borderRadius: BorderRadius.circular(10))
                   : null,
           margin:
               (passThrough ?? false) && direction != Axis.horizontal
                   ? const EdgeInsets.symmetric(horizontal: 16)
                   : null,
           child:
               direction == null
                   ? child!
                   : (direction == Axis.vertical
                       ? ListView.separated(
                         padding: EdgeInsets.zero,
                         shrinkWrap: true,
                         physics: const NeverScrollableScrollPhysics(),
                         itemBuilder: (BuildContext context, int index) {
                           return Container(
                             margin:
                                 cardMode
                                     ? const EdgeInsets.symmetric(
                                       horizontal: 16,
                                     )
                                     : null,
                             height: cardMode ? 82 : null,
                             child: directionalTdRadios[index],
                           );
                         },
                         itemCount: directionalTdRadios!.length,
                         separatorBuilder: (BuildContext context, int index) {
                           if (cardMode) {
                             return const SizedBox(height: 12);
                           }
                           return const SizedBox.shrink();
                         },
                       )
                       : Container(
                         margin:
                             cardMode
                                 ? const EdgeInsets.symmetric(horizontal: 16)
                                 : null,
                         height:
                             cardMode
                                 ? (directionalTdRadios!.length / rowCount)
                                         .ceil() *
                                     (56 + 10)
                                 : null,
                         // height: 56,
                         alignment: cardMode ? Alignment.topLeft : null,
                         child:
                             cardMode
                                 ? GridView.builder(
                                   itemCount: directionalTdRadios!.length,
                                   gridDelegate:
                                       SliverGridDelegateWithFixedCrossAxisCount(
                                         crossAxisSpacing: 10,
                                         mainAxisSpacing: 10,
                                         crossAxisCount: rowCount,
                                         mainAxisExtent: 56,
                                       ),
                                   itemBuilder: (
                                     BuildContext context,
                                     int index,
                                   ) {
                                     return SizedBox(
                                       width: 160,
                                       height: 56,
                                       child: directionalTdRadios[index],
                                     );
                                   },
                                 )
                                 : Column(
                                   children: [
                                     Row(
                                       mainAxisSize: MainAxisSize.min,
                                       children:
                                           directionalTdRadios!
                                               .map((e) => Expanded(child: e))
                                               .toList(),
                                     ),
                                     if (showDivider)
                                       divider ??
                                           const MyDivider(
                                             margin: EdgeInsets.only(left: 16),
                                           ),
                                   ],
                                 ),
                       )),
         ),
         onChangeGroup: (ids) {
           onRadioGroupChange?.call(ids.isNotEmpty ? ids[0] : null);
         },
         controller: null,
         checkedIds: selectId != null ? [selectId] : null,
         maxChecked: 1,
         shape: null,
       );

  /// In strict mode, users cannot uncheck a selection, they can only toggle the selection.
  final bool strictMode;

  final TDRadioStyle? radioCheckStyle;

  final bool showDivider;

  final Widget? divider;

  final int rowCount;

  @override
  State<StatefulWidget> createState() {
    return TDRadioGroupState();
  }
}

class TDRadioGroupState extends MyCheckboxGroupState {
  @override
  bool toggle(String id, bool? check, [bool notify = false]) {
    checkBoxStates.forEach((key, value) {
      checkBoxStates[key] = false;
    });
    return super.toggle(id, check ?? false, true);
  }
}

typedef OnRadioGroupChange = void Function(String? selectedId);

// Horizontal card radio buttons, according to the designer's requirement of
// 'maintain consistent spacing and adapt width'. The implementation method is
// to add a SizedBox with a fixed width between the two radio buttons, and
// each radio button is Expanded, so that it can divide the entire Row equally.
Iterable<Widget> horizontalChild(Widget child) sync* {
  yield Expanded(child: child);
  yield const SizedBox(width: 12);
}
