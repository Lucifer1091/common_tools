part of 'my_steps.dart';

class _MyStepsHorizontal extends StatelessWidget {
  const _MyStepsHorizontal({
    required this.steps,
    required this.controller,
    required this.size,
    required this.type,
    required this.readOnly,
  });

  final List<MyStepItem> steps;
  final MyStepController controller;
  final MyStepSize size;
  final MyStepType type;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;

    final List<Widget> stepsHorizontalItem =
        steps.asMap().entries.map((item) {
          return Expanded(
            child: ValueListenableBuilder<MyStepValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                return _MyStepsHorizontalItem(
                  index: item.key,
                  data: item.value,
                  current: value.current,
                  stepsCount: stepsCount,
                  state: value.states[value.current],
                  type: type,
                  size: size,
                  readOnly: readOnly,
                );
              },
            ),
          );
        }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }
}

class _MyStepsHorizontalItem extends StatelessWidget {
  const _MyStepsHorizontalItem({
    required this.data,
    required this.index,
    required this.readOnly,
    required this.stepsCount,
    required this.current,
    required this.state,
    required this.type,
    required this.size,
  });

  final MyStepItem data;
  final int index;
  final int stepsCount;
  final int current;
  final MyStepState? state;
  final MyStepType type;
  final MyStepSize size;
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
      LucideIcons.x,
      color: context.colorScheme.destructive,
      size: 16,
    );

    BoxDecoration? iconWidgetDecoration;

    if (current > index) {
      stepsNumberBgColor = context.colorScheme.primary;
      stepsNumberTextColor = context.colorScheme.primary;
      stepsTitleColor = context.colorScheme.foreground;

      completeIconWidget = Icon(
        Icons.check_rounded,
        color: context.colorScheme.primaryForeground,
        size: 16,
      );
    } else if (current < index) {
      stepsNumberBgColor = context.colorScheme.secondary;
      stepsNumberTextColor = context.colorScheme.mutedForeground;
      stepsTitleColor = context.colorScheme.mutedForeground;
      stepsIconColor = context.colorScheme.mutedForeground;
      simpleStepsIconColor = context.colorScheme.mutedForeground;
    } else {
      stepsNumberTextColor = context.colorScheme.primary;
      iconWidgetDecoration = BoxDecoration(
        border: Border.all(color: stepsNumberBgColor),
        shape: BoxShape.circle,
      );
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
    if (state == MyStepState.error && current == index) {
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

      if (type == MyStepType.simple) {
        simpleStepsIconColor = context.colorScheme.destructive;
      }
    }

    iconWidgetDecoration =
        shouldSetIconWidgetDecoration
            ? iconWidgetDecoration ??
                BoxDecoration(color: stepsNumberBgColor, shape: BoxShape.circle)
            : null;

    double iconContainerSize = 22;

    if (type == MyStepType.simple || readOnly) {
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

      if (current == index && !readOnly) {
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
                      (current >= index || readOnly)
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
                      (current > index || readOnly)
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
                    (current == index && !readOnly)
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
