import 'package:flutter/material.dart';

import '../../../index.dart';

class MyStepsVertical extends StatelessWidget {
  const MyStepsVertical({
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    required this.verticalSelect,
    super.key,
  });

  final List<MyStepItem> steps;
  final int activeIndex;
  final MyStepState status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;
    final List<Widget> stepsVerticalItem =
        steps.asMap().entries.map((item) {
          return MyStepsVerticalItem(
            index: item.key,
            data: item.value,
            stepsCount: stepsCount,
            activeIndex: activeIndex,
            status: status,
            simple: simple,
            readOnly: readOnly,
            verticalSelect: verticalSelect,
          );
        }).toList();

    return Column(children: stepsVerticalItem);
  }
}

class MyStepsVerticalItem extends StatelessWidget {
  const MyStepsVerticalItem({
    required this.data,
    required this.index,
    required this.stepsCount,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    required this.verticalSelect,
    this.titleWidget,
    super.key,
  });

  final MyStepItem data;
  final int index;
  final int stepsCount;
  final int activeIndex;
  final MyStepState status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    var stepsNumberBgColor = context.colorScheme.primary;

    var stepsNumberTextColor = Colors.white;

    var stepsTitleColor = context.colorScheme.primary;

    var stepsIconColor = context.colorScheme.primary;

    var simpleStepsIconColor = context.colorScheme.primary;

    bool shouldSetIconWidgetDecoration = true;

    Widget? completeIconWidget;

    final Widget errorIconWidget = Icon(
      Icons.close,
      color: ThemeColors.error.shade500,
      size: 16,
    );

    if (activeIndex > index) {
      stepsNumberBgColor = ThemeColors.blue.shade50;
      stepsNumberTextColor = context.colorScheme.primary;
      stepsTitleColor = ThemeColors.neutral.shade900;

      completeIconWidget = Icon(
        Icons.check_rounded,
        color: context.colorScheme.primary,
        size: 16,
      );
    } else if (activeIndex < index) {
      stepsNumberBgColor = ThemeColors.neutral.shade50;
      stepsNumberTextColor = ThemeColors.neutral.shade700;
      stepsTitleColor = ThemeColors.neutral.shade700;
      stepsIconColor = ThemeColors.neutral.shade700;
      simpleStepsIconColor = ThemeColors.neutral.shade300;
    }

    Widget? stepsIconWidget = Text(
      (index + 1).toString(),
      style: TextStyle(
        color: stepsNumberTextColor,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    );

    if (completeIconWidget != null) {
      stepsIconWidget = completeIconWidget;
    }

    if (data.successIcon != null) {
      stepsIconWidget = Icon(data.successIcon, color: stepsIconColor, size: 22);

      shouldSetIconWidgetDecoration = false;
    }

    if (status == MyStepState.error && activeIndex == index) {
      stepsNumberBgColor = ThemeColors.error.shade50;
      stepsTitleColor = ThemeColors.error.shade500;

      stepsIconWidget = errorIconWidget;
      if (data.errorIcon != null) {
        stepsIconWidget = Icon(
          data.errorIcon,
          color: ThemeColors.error.shade500,
          size: 22,
        );
      }

      shouldSetIconWidgetDecoration = data.errorIcon == null;

      if (simple) simpleStepsIconColor = ThemeColors.error.shade500;
    }

    var iconWidgetDecoration =
        shouldSetIconWidgetDecoration
            ? BoxDecoration(color: stepsNumberBgColor, shape: BoxShape.circle)
            : null;

    double iconContainerSize = 22;

    double iconMarginBottom = 8;

    if (simple || readOnly) {
      if (readOnly) {
        simpleStepsIconColor = context.colorScheme.primary;
        stepsTitleColor = ThemeColors.neutral.shade900;
      }
      iconContainerSize = 8;
      iconMarginBottom = 4;
      stepsIconWidget = null;

      var simpleDecoration = BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: simpleStepsIconColor),
      );
      if (activeIndex == index && !readOnly) {
        simpleDecoration = BoxDecoration(
          color: simpleStepsIconColor,
          shape: BoxShape.circle,
        );
      }
      iconWidgetDecoration = simpleDecoration;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 22,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 62),
                child: Column(
                  children: [
                    Container(
                      width: iconContainerSize,
                      height: 22,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: iconMarginBottom),
                      decoration: iconWidgetDecoration,
                      child: stepsIconWidget,
                    ),
                    Expanded(
                      child: Opacity(
                        opacity: index == stepsCount - 1 ? 0 : 1,
                        child: Container(
                          width: 1,
                          height: double.infinity,
                          color:
                              (activeIndex > index || readOnly)
                                  ? context.colorScheme.primary
                                  : ThemeColors.neutral.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.customTitle != null)
                    data.customTitle!
                  else if (data.title != null && data.title!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MyText(
                              data.title!,
                              style: TextStyle(
                                fontWeight:
                                    (activeIndex == index && !readOnly)
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color: stepsTitleColor,
                                fontSize: 14,
                                height: 1.2,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          if (verticalSelect)
                            Icon(
                              Icons.chevron_right_rounded,
                              color: ThemeColors.neutral.shade900,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.customContent != null)
                        data.customContent!
                      else if (data.content != null && data.content!.isNotEmpty)
                        MyText(
                          data.content,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: ThemeColors.neutral.shade700,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
