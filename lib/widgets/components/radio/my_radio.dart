import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyRadioStyle { circle, square }

/// Radio button, inherited from TDCheckbox, the field meaning is consistent with the parent class
class MyRadio extends MyCheckbox {
  const MyRadio({
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
    this.radioStyle = MyRadioStyle.circle,
    super.contentDirection,
    super.customIconBuilder,
    super.titleColor,
    super.subTitleColor,
    super.backgroundColor,
    super.checkBoxLeftSpace,
  }) : super(cardMode: cardMode ?? false, showDivider: showDivider ?? true);

  final MyRadioStyle radioStyle;

  @override
  Widget buildDefaultIcon(
    BuildContext context,
    MyCheckboxGroupState? groupState,
    bool? isSelected,
  ) {
    if (cardMode) return const NoWidget();

    MyRadioStyle? style;
    if (groupState is MyRadioGroupState) {
      style = (groupState.widget as MyRadioGroup).radioCheckStyle;
    }

    style = style ?? radioStyle;
    final size = this.size == MyCheckboxSize.small ? 20.0 : 24.0;
    final selected = isSelected ?? false;

    return _MyRadioIcon(
      value: selected,
      size: size,
      style: style,
      fillColor: selectedColor,
      checkColor: checkColor,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return MyRadioState();
  }
}

class MyRadioState extends MyCheckboxState {
  @override
  Widget build(BuildContext context) {
    // Check if it is contained in MyCheckboxGroup, if so, the state is managed by the Group
    final groupState = MyCheckboxGroupInherited.of(context)?.state;
    if (groupState is MyRadioGroupState) {
      final strictMode = (groupState.widget as MyRadioGroup).strictMode;
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

/// RadioGroup grouping object, inherited from MyCheckboxGroup, the field
/// meaning is consistent with the parent class
/// RadioGroup should be nested in [MyRadioGroup], and only one RadioButton in
/// RadioGroup can be selected
///
/// cardMode: Use the card style, need to be used with direction and directionalTdRadios,
/// Combine into horizontal and vertical cards, and set the cardMode parameter on each TDRadio.
class MyRadioGroup extends MyCheckboxGroup {
  MyRadioGroup({
    super.key,
    Widget? child, // Do not set direction if using child
    Axis? direction, // Direction applies to directionalTdRadios
    List<MyRadio>? directionalTdRadios,
    String? selectId, // Default selected item ID
    bool?
    passThrough, // Non-throughout radio selection style. For use with child or direction == Axis.vertical
    bool cardMode = false,
    this.strictMode = false,
    this.radioCheckStyle,
    super.titleMaxLine, // Number of item lines
    super.customIconBuilder,
    super.customContentBuilder,
    super.spacing, // Distance between icon and text
    this.rowCount = 1,
    super.contentDirection,
    OnRadioGroupChange? onRadioGroupChange, // Toggle listener
    this.showDivider = false,
    this.divider,
  }) : assert(() {
         // Using the direction property requires directionalTdRadios; the child field is invalid
         if (direction != null && directionalTdRadios == null) {
           throw FlutterError(
             '[MyRadioGroup] direction and directionalTdRadios must set at the same time',
           );
         }
         // If direction is not used, child must be set
         if (direction == null && child == null) {
           throw FlutterError(
             '[MyRadioGroup] direction means use child as the exact one, but child is null',
           );
         }
         // Horizontal radio buttons. Each option has a character limit.
         if (direction == Axis.horizontal && directionalTdRadios != null) {
           for (final element in directionalTdRadios) {
             if (element.subTitle != null) {
               throw FlutterError(
                 'Horizontal radio style should not have subTitle, '
                 'because there is no room for it',
               );
             }
           }
         }
         // Card mode requires that each TDRadio must have the cardMode property
         // set to true and cannot have a subTitle (insufficient space)
         if (cardMode) {
           assert(direction != null && directionalTdRadios != null, '');
           for (final element in directionalTdRadios!) {
             // if use cardMode at MyRadioGroup, then every TDRadio should
             // set it's own carMode to true.
             if (!element.cardMode) {
               throw FlutterError(
                 'if use cardMode at MyRadioGroup, then every '
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
                   ? BoxDecoration(borderRadius: MyBorderRadius.large)
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
  final MyRadioStyle? radioCheckStyle;
  final bool showDivider;
  final Widget? divider;
  final int rowCount;

  @override
  State<StatefulWidget> createState() {
    return MyRadioGroupState();
  }
}

class MyRadioGroupState extends MyCheckboxGroupState {
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

class _MyRadioIcon extends StatelessWidget {
  const _MyRadioIcon({
    required this.size,
    required this.style,
    this.value,
    this.fillColor,
    this.checkColor,
  });

  final bool? value;
  final double size;
  final MyRadioStyle style;
  final Color? fillColor, checkColor;

  @override
  Widget build(BuildContext context) {
    final fill =
        (value ?? true
            ? fillColor ?? context.colorScheme.primary
            : Colors.transparent);

    final border = (value ?? true) ? fill : context.colorScheme.border;

    final radius = style == MyRadioStyle.circle ? null : MyBorderRadius.medium;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: border, width: 2),
        shape:
            style == MyRadioStyle.circle ? BoxShape.circle : BoxShape.rectangle,
      ),
      alignment: Alignment.center,
      child: Container(
        height: size * 0.5,
        width: size * 0.5,
        decoration: BoxDecoration(
          borderRadius:
              style == MyRadioStyle.circle ? null : MyBorderRadius.small,
          shape:
              style == MyRadioStyle.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
          color: switch (value) {
            true => fill,
            _ => null,
          },
        ),
      ),
    );
  }
}
