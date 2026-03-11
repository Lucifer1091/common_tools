import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyActionSheetItemWidget extends StatelessWidget {
  const MyActionSheetItemWidget({
    required this.index,
    super.key,
    this.item,
    this.onSelected,
  });

  final ActionSheetItem? item;
  final int index;
  final MyActionSheetItemCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    if (item == null) return const NoWidget();

    late ValueNotifier<List<double>> offsetValue;
    late GlobalKey offsetKey;

    if (item!.badge != null) {
      offsetValue = ValueNotifier(const [0.0, 0.0]);
      offsetKey = GlobalKey();
    }

    return GestureDetector(
      onTap:
          item!.disabled
              ? null
              : () {
                onSelected?.call(item!, index);
                unawaited(Navigator.maybePop(context));
              },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item!.icon != null) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: item!.iconSize ?? 40,
                  height: item!.iconSize ?? 40,
                  child: FittedBox(child: item!.icon),
                ),
                if (item!.badge != null)
                  ValueListenableBuilder(
                    valueListenable: offsetValue,
                    builder: (context, value, child) {
                      _setOffsetValue(offsetKey, offsetValue);
                      return Positioned(
                        key: offsetKey,
                        right: value[0],
                        top: value[1],
                        child: item!.badge!,
                      );
                    },
                  ),
              ],
            ),
            const Space.h8(),
          ],
          MyText(
            item!.label,
            fontSize: context.bodySmall.fontSize,
            textColor: ThemeColors.neutral.shade900,
            style: item!.textStyle,
          ),
        ],
      ),
    );
  }

  void _setOffsetValue(
    GlobalKey<State<StatefulWidget>> offsetKey,
    ValueNotifier<List<double>> offsetValue,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final renderBox =
          offsetKey.currentContext!.findRenderObject()! as RenderBox;
      final size = renderBox.size;
      final right = -size.width / 2;
      final top = -size.height / 2;
      if (offsetValue.value[0] != right || offsetValue.value[1] != top) {
        offsetValue.value = [right, top];
      }
    });
  }
}

MainAxisAlignment getMainAxisAlignment(MyActionSheetAlign align) {
  switch (align) {
    case MyActionSheetAlign.left:
      return MainAxisAlignment.start;
    case MyActionSheetAlign.right:
      return MainAxisAlignment.end;
    case MyActionSheetAlign.center:
      return MainAxisAlignment.center;
  }
}

Widget buildCancelButton(
  BuildContext context,
  bool showPagination,
  String cancelText,
  VoidCallback? onCancel,
) {
  return Padding(
    padding: EdgeInsets.only(top: showPagination ? 16 : 8),
    child: GestureDetector(
      onTap: () {
        onCancel?.call();
        unawaited(Navigator.maybePop(context));
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.neutral.shade200,
          border: Border(
            top: BorderSide(color: ThemeColors.neutral.shade400, width: 0.5),
          ),
        ),
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
  );
}
