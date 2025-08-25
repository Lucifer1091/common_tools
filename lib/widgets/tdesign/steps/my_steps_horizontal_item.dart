import 'package:flutter/material.dart';

import '../../../index.dart';
import '../text/my_text.dart';
import 'my_steps.dart';

class TDStepsHorizontalItem extends StatelessWidget {
  const TDStepsHorizontalItem({
    required this.data,
    required this.index,
    required this.stepsCount,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    super.key,
  });

  final TDStepsItemData data;
  final int index;
  final int stepsCount;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    var stepsNumberBgColor = ThemeColors.blue.shade600;

    var stepsNumberTextColor = Colors.white;

    var stepsTitleColor = ThemeColors.blue.shade600;

    var stepsIconColor = ThemeColors.blue.shade600;

    var simpleStepsIconColor = ThemeColors.blue.shade600;

    bool shouldSetIconWidgetDecoration = true;

    Widget? completeIconWidget;

    final Widget errorIconWidget = Icon(
      Icons.close_rounded,
      color: ThemeColors.error.shade500,
      size: 16,
    );

    if (activeIndex > index) {
      stepsNumberBgColor = ThemeColors.blue.shade50;
      stepsNumberTextColor = ThemeColors.blue.shade600;
      stepsTitleColor = ThemeColors.neutral.shade900;

      completeIconWidget = Icon(
        Icons.check_rounded,
        color: ThemeColors.blue.shade600,
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

    if (completeIconWidget != null) stepsIconWidget = completeIconWidget;

    if (data.successIcon != null) {
      stepsIconWidget = Icon(data.successIcon, color: stepsIconColor, size: 22);

      shouldSetIconWidgetDecoration = false;
    }

    /// The status is an error status, the activation index is the current
    /// index, and only the current activation index needs to be displayed
    if (status == TDStepsStatus.error && activeIndex == index) {
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

    BoxDecoration? iconWidgetDecoration =
        shouldSetIconWidgetDecoration
            ? BoxDecoration(color: stepsNumberBgColor, shape: BoxShape.circle)
            : null;

    double iconContainerSize = 22;

    if (simple || readOnly) {
      if (readOnly) {
        simpleStepsIconColor = ThemeColors.blue.shade600;
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
                          ? ThemeColors.blue.shade600
                          : ThemeColors.neutral.shade300,
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
                          ? ThemeColors.blue.shade600
                          : ThemeColors.neutral.shade300,
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
              data.title!,
              style: TextStyle(
                fontWeight:
                    (activeIndex == index && !readOnly)
                        ? FontWeight.w600
                        : FontWeight.w400,
                color: stepsTitleColor,
                fontSize: 14,
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
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: ThemeColors.neutral.shade700,
                  fontSize: 12,
                ),
              ),
        ),
      ],
    );
  }
}
