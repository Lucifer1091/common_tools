part of 'my_steps.dart';

class _MyStepsItems extends StatelessWidget {
  const _MyStepsItems({
    required this.data,
    required this.index,
    required this.stepsCount,
    required this.current,
    required this.state,
    required this.type,
    required this.size,
    required this.readOnly,
    required this.onTap,
    required this.direction,
  });

  final MyStepItem data;
  final int index;
  final int stepsCount;
  final int current;
  final MyStepState? state;
  final MyStepType type;
  final MyStepSize size;
  final bool readOnly;
  final void Function(int index)? onTap;
  final Axis direction;

  // --- Size helpers ---
  double get stepSize => switch (size) {
    MyStepSize.large => 36,
    MyStepSize.medium => 30,
    MyStepSize.small => 26,
    MyStepSize.extraSmall => 22,
  };

  double get iconSize => switch (size) {
    MyStepSize.large => 32,
    MyStepSize.medium => 26,
    MyStepSize.small => 24,
    MyStepSize.extraSmall => 20,
  };

  double get borderWidth => switch (size) {
    MyStepSize.large => 2,
    MyStepSize.medium => 1.5,
    MyStepSize.small => 1,
    MyStepSize.extraSmall => 1,
  };

  double get simpleIconSize => switch (size) {
    MyStepSize.large => 11,
    MyStepSize.medium => 10,
    MyStepSize.small => 9,
    MyStepSize.extraSmall => 8,
  };

  double get timelineSize => switch (size) {
    MyStepSize.large => 18,
    MyStepSize.medium => 16,
    MyStepSize.small => 14,
    MyStepSize.extraSmall => 12,
  };

  double get iconMargin => switch (size) {
    MyStepSize.large => 10,
    MyStepSize.medium => 8,
    MyStepSize.small => 8,
    MyStepSize.extraSmall => 8,
  };

  double get boxConstraints => switch (size) {
    MyStepSize.large => 120,
    MyStepSize.medium => 110,
    MyStepSize.small => 110,
    MyStepSize.extraSmall => 100,
  };

  double get lineHeight => switch (size) {
    MyStepSize.large => 6,
    MyStepSize.medium => 5,
    MyStepSize.small => 4,
    MyStepSize.extraSmall => 4,
  };

  TextStyle indexStyle(BuildContext context) => switch (size) {
    MyStepSize.large => context.bodyLarge,
    MyStepSize.medium => context.bodyLarge,
    MyStepSize.small => context.bodyMedium.copyWith(fontSize: 15),
    MyStepSize.extraSmall => context.bodyMedium,
  };

  TextStyle titleStyle(BuildContext context, Color color) => switch (size) {
    MyStepSize.large => context.bodyLarge,
    MyStepSize.medium => context.bodyLarge,
    MyStepSize.small => context.bodyMedium.copyWith(fontSize: 15),
    MyStepSize.extraSmall => context.bodyMedium,
  }.copyWith(
    fontWeight:
        type == MyStepType.steps || type == MyStepType.timeline
            ? FontWeight.w600
            : (current == index && !readOnly)
            ? FontWeight.w600
            : FontWeight.w400,
    color: type != MyStepType.timeline ? color : null,
  );

  TextStyle contentStyle(BuildContext context, Color color) => switch (size) {
    MyStepSize.large => context.bodySmall.copyWith(fontSize: 13),
    MyStepSize.medium => context.bodySmall.copyWith(fontSize: 13),
    MyStepSize.small => context.bodySmall,
    MyStepSize.extraSmall => context.bodySmall,
  }.copyWith(color: color);

  double get minHeight => switch (size) {
    MyStepSize.large => 80,
    MyStepSize.medium => 75,
    MyStepSize.small => 70,
    MyStepSize.extraSmall => 62,
  };

  // --- Centralized style logic ---
  _MyStepStyle getStepStyle(BuildContext context) {
    final primary = context.colorScheme.primary;
    final primaryFg = context.colorScheme.primaryForeground;
    final secondary = context.colorScheme.secondary;
    final secondaryFg = context.colorScheme.secondaryForeground;
    final border = context.colorScheme.border;
    final muted = context.colorScheme.muted;
    final mutedFg = context.colorScheme.mutedForeground;
    final destructive = context.colorScheme.destructive;
    final destructiveFg = context.colorScheme.destructiveForeground;

    // Defaults
    Color bgColor = primary;
    Color? dividerColor;
    Color textColor = context.colorScheme.foreground;
    Color titleColor = primary;
    Color contentColor = mutedFg;
    Color iconColor = primary;
    Color simpleIconColor = primary;
    BoxDecoration? iconDecoration;
    Widget? iconWidget;
    bool shouldSetIconWidgetDecoration = true;

    // Completed
    if (current > index) {
      bgColor = primary;
      textColor = primary;
      titleColor = context.colorScheme.foreground;
      iconWidget = Icon(
        Icons.check_rounded,
        color: primaryFg,
        size: iconSize - 6,
      );
    }
    // Upcoming
    else if (current < index) {
      bgColor = type == MyStepType.line ? border : secondary;
      textColor = mutedFg;
      titleColor = mutedFg;
      iconColor = mutedFg;
      simpleIconColor = mutedFg;
    }
    // Active
    else if (state != MyStepState.error && current == index) {
      textColor = primary;
      iconDecoration = BoxDecoration(
        border: Border.all(color: bgColor, width: borderWidth),
        shape: BoxShape.circle,
      );
    }

    // Success icon override
    if (data.successIcon != null) {
      iconWidget = Icon(data.successIcon, color: iconColor, size: iconSize);
      shouldSetIconWidgetDecoration = false;
    }

    // Error
    if (state == MyStepState.error && current == index) {
      bgColor = destructive;
      textColor = destructiveFg;
      titleColor = destructive;
      iconWidget = Icon(
        LucideIcons.x,
        color: destructiveFg,
        size: iconSize - 6,
      );
      if (data.errorIcon != null) {
        iconWidget = Icon(data.errorIcon, color: destructive, size: iconSize);
      }
      shouldSetIconWidgetDecoration = data.errorIcon == null;
      if (type == MyStepType.simple) simpleIconColor = destructive;
    }

    if (type == MyStepType.steps) {
      bgColor = muted;
      textColor = context.colorScheme.foreground;
      dividerColor = muted;
      titleColor = context.colorScheme.foreground;
      contentColor = context.colorScheme.foreground;
      iconColor = secondaryFg;
      iconDecoration = BoxDecoration(color: bgColor, shape: BoxShape.circle);
      if (type != MyStepType.icon) iconWidget = null;
    }

    if (type == MyStepType.simple) {
      iconWidget = null;
      iconDecoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: simpleIconColor),
      );
      if (current == index && !readOnly) {
        iconDecoration = BoxDecoration(
          color: simpleIconColor,
          shape: BoxShape.circle,
        );
      }
    }

    if (type == MyStepType.timeline) {
      bgColor = primary;
      dividerColor = primary;
      simpleIconColor = primary;
      iconWidget = null;

      iconDecoration = BoxDecoration(
        color: simpleIconColor,
        shape: BoxShape.circle,
      );
    }

    // Readonly override (applies to all types)
    if (readOnly) {
      bgColor = secondary;
      textColor = secondaryFg;
      dividerColor = secondary;
      titleColor = mutedFg;
      contentColor = mutedFg;
      iconColor = secondaryFg;
      simpleIconColor = mutedFg;
      iconDecoration = BoxDecoration(color: bgColor, shape: BoxShape.circle);
      if (type != MyStepType.icon) {
        iconWidget = null;
      } else {
        // Success icon override
        if (data.successIcon != null) {
          iconWidget = Icon(data.successIcon, color: iconColor, size: iconSize);
          shouldSetIconWidgetDecoration = false;
        }
      }
    }

    if (type != MyStepType.simple && type != MyStepType.timeline) {
      // Default icon widget if not set
      iconWidget ??= MyText(
        (index + 1).toString(),
        style: indexStyle(context).copyWith(
          color: textColor,
          fontWeight: type == MyStepType.steps ? FontWeight.w700 : null,
          fontFamily:
              type == MyStepType.steps
                  ? MyTypography.kDefaultFontFamilyMono
                  : null,
        ),
      );
    }

    // Final decoration
    if (type != MyStepType.icon) {
      iconDecoration =
          shouldSetIconWidgetDecoration
              ? iconDecoration ??
                  BoxDecoration(color: bgColor, shape: BoxShape.circle)
              : iconDecoration;
    } else {
      iconDecoration = null;
    }

    return _MyStepStyle(
      bgColor: bgColor,
      dividerColor: dividerColor,
      textColor: textColor,
      titleColor: titleColor,
      contentColor: contentColor,
      iconColor: iconColor,
      simpleIconColor: simpleIconColor,
      iconDecoration: iconDecoration,
      iconWidget: iconWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = getStepStyle(context);

    final iconContainerSize =
        type == MyStepType.timeline
            ? timelineSize
            : type == MyStepType.simple
            ? simpleIconSize
            : stepSize;

    final simpleSize =
        type == MyStepType.line
            ? lineHeight * 2
            : type == MyStepType.simple
            ? iconSize
            : iconContainerSize;

    final iconMarginBottom =
        type == MyStepType.simple ? iconMargin / 2 : iconMargin;

    final stepRightMargin = type == MyStepType.steps ? 16.0 : iconMargin;

    Widget stepContent;

    if (direction == Axis.vertical) {
      stepContent = Container(
        margin:
            type != MyStepType.timeline
                ? EdgeInsets.only(bottom: iconMargin)
                : EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (type == MyStepType.timeline) ...[
                if (data.customTime != null)
                  data.customTime!
                else if (data.time != null && data.time!.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: boxConstraints,
                      maxWidth: boxConstraints,
                    ),
                    child: Container(
                      alignment: Alignment.topRight,
                      margin:
                          type == MyStepType.timeline
                              ? EdgeInsets.only(right: iconMargin * 1.5)
                              : EdgeInsets.zero,
                      child: MyText(
                        data.time,
                        style: titleStyle(
                          context,
                          style.titleColor,
                        ).copyWith(fontWeight: FontWeight.w500),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
              ],
              Container(
                margin: EdgeInsets.only(right: stepRightMargin),
                width: simpleSize,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight),
                  child: Column(
                    children: [
                      if (type != MyStepType.line) ...[
                        Container(
                          width: iconContainerSize,
                          height: simpleSize,
                          alignment: Alignment.center,
                          margin:
                              type != MyStepType.timeline
                                  ? EdgeInsets.only(bottom: iconMarginBottom)
                                  : type == MyStepType.timeline
                                  ? EdgeInsets.only(top: iconMargin / 2)
                                  : EdgeInsets.zero,
                          decoration: style.iconDecoration,
                          child: style.iconWidget,
                        ),
                        if (index != stepsCount - 1)
                          if (type == MyStepType.timeline)
                            Expanded(
                              child: _MyTimelineDivider(
                                thickness: 1.5,
                                color:
                                    style.dividerColor ??
                                    ((current > index || readOnly)
                                        ? context.colorScheme.primary
                                        : context.colorScheme.border),
                                endIndent: -4 - iconMargin,
                              ),
                            )
                          else
                            Expanded(
                              child: Container(
                                width: 1.5,
                                color:
                                    style.dividerColor ??
                                    ((current > index || readOnly)
                                        ? context.colorScheme.primary
                                        : context.colorScheme.border),
                              ),
                            ),
                      ] else
                        Expanded(
                          child: Container(
                            width: lineHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: style.bgColor,
                              borderRadius: MyBorderRadius.medium,
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
                        margin:
                            type != MyStepType.steps
                                ? EdgeInsets.only(bottom: iconMargin / 2)
                                : EdgeInsets.zero,
                        child: MyText(
                          data.title,
                          style: titleStyle(context, style.titleColor),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data.customContent != null)
                          data.customContent!
                        else if (data.content != null &&
                            data.content!.isNotEmpty)
                          MyText(
                            data.content,
                            style: contentStyle(context, style.contentColor),
                          ),
                      ],
                    ),
                    if (type == MyStepType.timeline) Gap(iconMargin * 1.75),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      stepContent = Column(
        children: [
          if (type != MyStepType.line)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Visibility(
                    visible: index != 0,
                    child: Container(
                      width: double.infinity,
                      height: 1.5,
                      color:
                          style.dividerColor ??
                          ((current >= index || readOnly)
                              ? context.colorScheme.primary
                              : context.colorScheme.border),
                    ),
                  ),
                ),
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: iconMargin, right: iconMargin),
                  decoration: style.iconDecoration,
                  child: style.iconWidget,
                ),
                Expanded(
                  child: Visibility(
                    visible: index != stepsCount - 1,
                    child: Container(
                      width: double.infinity,
                      height: 1.5,
                      color:
                          style.dividerColor ??
                          ((current > index || readOnly)
                              ? context.colorScheme.primary
                              : context.colorScheme.border),
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              width: double.maxFinite,
              height: lineHeight,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: iconMargin * 1.5),
              decoration: BoxDecoration(
                color: style.bgColor,
                borderRadius: MyBorderRadius.medium,
              ),
            ),
          if (data.customTitle != null)
            data.customTitle!
          else if (data.title != null && data.title!.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: iconMargin),
              alignment:
                  type == MyStepType.line
                      ? Alignment.centerLeft
                      : Alignment.center,
              child: MyText(
                data.title,
                style: titleStyle(context, style.titleColor),
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: iconMargin / 2),
            alignment:
                type == MyStepType.line
                    ? Alignment.centerLeft
                    : Alignment.center,
            child:
                data.customContent ??
                MyText(
                  data.content ?? '',
                  style: contentStyle(context, style.contentColor),
                ),
          ),
        ],
      );
    }

    // Make steps clickable if not readOnly
    if (type != MyStepType.steps &&
        type != MyStepType.timeline &&
        !readOnly &&
        onTap != null) {
      stepContent =
          GestureDetector(
            onTap: () => onTap!(index),
            child: stepContent,
          ).mouseRegion;
    }

    return stepContent;
  }
}

class _MyStepStyle {
  _MyStepStyle({
    required this.bgColor,
    required this.dividerColor,
    required this.textColor,
    required this.titleColor,
    required this.contentColor,
    required this.iconColor,
    required this.simpleIconColor,
    required this.iconDecoration,
    required this.iconWidget,
  });

  final Color bgColor;
  final Color? dividerColor;
  final Color textColor;
  final Color titleColor;
  final Color contentColor;
  final Color iconColor;
  final Color simpleIconColor;
  final BoxDecoration? iconDecoration;
  final Widget? iconWidget;
}

class _MyTimelineDividerPainter extends CustomPainter {
  const _MyTimelineDividerPainter({
    required this.color,
    required this.thickness,
    required this.indent,
    required this.endIndent,
  });

  final Color color;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.square;
    final start = Offset(size.width / 2, indent);
    final end = Offset(size.width / 2, size.height - endIndent);
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant _MyTimelineDividerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.indent != indent ||
        oldDelegate.endIndent != endIndent;
  }
}

class _MyTimelineDivider extends StatelessWidget
    implements PreferredSizeWidget {
  const _MyTimelineDivider({this.color, this.thickness, this.endIndent});

  final Color? color;
  final double? thickness;
  final double? endIndent;

  @override
  Size get preferredSize => Size(1, 0);

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return CustomPaint(
      painter: _MyTimelineDividerPainter(
        color: color ?? theme.colorScheme.border,
        thickness: thickness ?? 1,
        indent: 0,
        endIndent: endIndent ?? 0,
      ),
    );
  }
}
