import 'package:flutter/material.dart';

import '../../../index.dart';

class MyStepsHorizontal extends StatelessWidget {
  const MyStepsHorizontal({
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    super.key,
  });

  final List<MyStepItem> steps;
  final int activeIndex;
  final MyStepsStatus status;
  final bool simple;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;

    final List<Widget> stepsHorizontalItem =
        steps.asMap().entries.map((item) {
          return Expanded(
            child: MyStepsHorizontalItem(
              index: item.key,
              data: item.value,
              stepsCount: stepsCount,
              activeIndex: activeIndex,
              status: status,
              simple: simple,
              readOnly: readOnly,
            ),
          );
        }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }
}

class MyStepsHorizontalItem extends StatelessWidget {
  const MyStepsHorizontalItem({
    required this.data,
    required this.index,
    required this.stepsCount,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    super.key,
  });

  final MyStepItem data;
  final int index;
  final int stepsCount;
  final int activeIndex;
  final MyStepsStatus status;
  final bool simple;
  final bool readOnly;

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
      Icons.close_rounded,
      color: context.colorScheme.destructive,
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
      style: context.bodyMedium.copyWith(color: stepsNumberTextColor),
    );

    if (completeIconWidget != null) stepsIconWidget = completeIconWidget;

    if (data.successIcon != null) {
      stepsIconWidget = Icon(data.successIcon, color: stepsIconColor, size: 22);

      shouldSetIconWidgetDecoration = false;
    }

    /// The status is an error status, the activation index is the current
    /// index, and only the current activation index needs to be displayed
    if (status == MyStepsStatus.error && activeIndex == index) {
      stepsNumberBgColor = ThemeColors.error.shade50;
      stepsTitleColor = context.colorScheme.destructive;

      stepsIconWidget = errorIconWidget;
      if (data.errorIcon != null) {
        stepsIconWidget = Icon(
          data.errorIcon,
          color: context.colorScheme.destructive,
          size: 22,
        );
      }

      shouldSetIconWidgetDecoration = data.errorIcon == null;

      if (simple) simpleStepsIconColor = context.colorScheme.destructive;
    }

    BoxDecoration? iconWidgetDecoration =
        shouldSetIconWidgetDecoration
            ? BoxDecoration(color: stepsNumberBgColor, shape: BoxShape.circle)
            : null;

    double iconContainerSize = 22;

    if (simple || readOnly) {
      if (readOnly) {
        simpleStepsIconColor = context.colorScheme.primary;
        stepsTitleColor = ThemeColors.neutral.shade900;
      }
      iconContainerSize = 8;
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Opacity(
                opacity: index == 0 ? 0 : 1,
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color:
                      (activeIndex >= index || readOnly)
                          ? context.colorScheme.primary
                          : context.colorScheme.border,
                ),
              ),
            ),
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 8, right: 8),
              decoration: iconWidgetDecoration,
              child: stepsIconWidget,
            ),
            Expanded(
              child: Opacity(
                opacity: index == stepsCount - 1 ? 0 : 1,
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color:
                      (activeIndex > index || readOnly)
                          ? context.colorScheme.primary
                          : context.colorScheme.border,
                ),
              ),
            ),
          ],
        ),
        if (data.customTitle != null)
          data.customTitle!
        else if (data.title != null && data.title!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            alignment: Alignment.center,
            child: MyText(
              data.title,
              style: context.bodyMedium.copyWith(
                fontWeight:
                    (activeIndex == index && !readOnly)
                        ? FontWeight.w600
                        : FontWeight.w400,
                color: stepsTitleColor,
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          alignment: Alignment.center,
          child:
              data.customContent ??
              MyText(
                data.content ?? '',
                style: context.bodySmall.copyWith(
                  color: context.colorScheme.mutedForeground,
                ),
              ),
        ),
      ],
    );
  }
}
