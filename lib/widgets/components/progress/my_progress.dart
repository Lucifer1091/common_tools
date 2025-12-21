import 'dart:async';

import 'package:flutter/material.dart';
import '../../../index.dart';

enum MyProgressType { linear, circular, micro }

enum MyProgressLabelPosition { inside, left, right }

enum MyProgressStatus { primary, warning, danger, success }

mixin MyLabelWidget on Widget {}

class MyTextLabel extends MyText with MyLabelWidget {
  const MyTextLabel(super.text, {super.key, super.style});
}

class MyIconLabel extends Icon with MyLabelWidget {
  const MyIconLabel(IconData super.icon, {super.key, super.size, super.color});
}

class MyProgress extends StatelessWidget {
  MyProgress({
    required this.type,
    super.key,
    double? value,
    this.label,
    this.progressStatus = MyProgressStatus.primary,
    this.progressLabelPosition = MyProgressLabelPosition.inside,
    double? strokeWidth,
    this.color,
    this.backgroundColor,
    this.linearBorderRadius,
    double? circleRadius,
    this.showLabel = true,
    this.customProgressLabel,
    this.labelWidgetWidth,
    this.labelWidgetAlignment,
    this.onTap,
    this.onLongPress,
    int animationDuration = 300,
  }) : value = _validateProgress(value),
       strokeWidth = _validatePositiveDouble(strokeWidth),
       circleRadius = _validatePositiveDouble(circleRadius),
       animationDuration = _validatePositiveInt(animationDuration);

  final MyProgressType type;

  /// Progress value (positive number between 0.0 and 1.0)
  final double? value;
  final MyLabelWidget? label;
  final MyProgressStatus progressStatus;
  final MyProgressLabelPosition progressLabelPosition;

  /// Progress bar thickness (positive number)
  final double? strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadiusGeometry? linearBorderRadius;
  final double? circleRadius;
  final bool showLabel;
  final Widget? customProgressLabel;
  final double? labelWidgetWidth;
  final Alignment? labelWidgetAlignment;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final int? animationDuration;

  static double? _validateProgress(double? value) =>
      value == null ? 0 : value.clamp(0.0, 1.0);

  static double? _validatePositiveDouble(double? value) =>
      value == null
          ? null
          : value <= 0
          ? 0
          : value;

  static int _validatePositiveInt(int? value) =>
      value == null || value <= 0 ? 0 : value;

  @override
  Widget build(BuildContext context) {
    final defaultValues = _getDefaultValues(context, type);

    return ProgressIndicator(
      value: value,
      label: label,
      progressStatus: progressStatus,
      progressLabelPosition: progressLabelPosition,
      strokeWidth: strokeWidth ?? defaultValues.strokeWidth,
      color: color,
      backgroundColor: backgroundColor ?? defaultValues.backgroundColor,
      linearBorderRadius:
          linearBorderRadius ?? defaultValues.linearBorderRadius,
      circleRadius: circleRadius ?? defaultValues.circleRadius,
      showLabel: showLabel,
      customProgressLabel: customProgressLabel,
      labelWidgetWidth: labelWidgetWidth,
      labelWidgetAlignment: labelWidgetAlignment,
      onTap: onTap,
      onLongPress: onLongPress,
      type: type,
      context: context,
      animationDuration: animationDuration ?? 300,
    );
  }

  _DefaultValues _getDefaultValues(BuildContext context, MyProgressType type) {
    switch (type) {
      case MyProgressType.linear:
        return _DefaultValues(
          strokeWidth: 20,
          backgroundColor: context.colorScheme.secondary,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 0,
        );
      case MyProgressType.circular:
        return _DefaultValues(
          strokeWidth: 5,
          backgroundColor: context.colorScheme.secondary,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 100,
        );
      case MyProgressType.micro:
        return _DefaultValues(
          strokeWidth: 2,
          backgroundColor: context.colorScheme.secondary,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 25,
        );
    }
  }
}

class _DefaultValues {
  _DefaultValues({
    required this.strokeWidth,
    required this.backgroundColor,
    required this.linearBorderRadius,
    required this.circleRadius,
  });

  final double strokeWidth;
  final Color backgroundColor;
  final BorderRadiusGeometry linearBorderRadius;
  final double circleRadius;
}

class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    required this.strokeWidth,
    required this.linearBorderRadius,
    required this.circleRadius,
    required this.backgroundColor,
    required this.type,
    super.key,
    this.value,
    this.label,
    this.progressLabelPosition = MyProgressLabelPosition.inside,
    this.color,
    this.progressStatus = MyProgressStatus.primary,
    this.showLabel = true,
    this.customProgressLabel,
    this.labelWidgetWidth,
    this.labelWidgetAlignment,
    this.onTap,
    this.onLongPress,
    this.animationDuration = 300,
    this.context,
  });

  final double? value;
  final MyLabelWidget? label;
  final MyProgressLabelPosition progressLabelPosition;
  final double strokeWidth;
  final double circleRadius;
  final BorderRadiusGeometry linearBorderRadius;
  final Color? color;
  final Color backgroundColor;
  final MyProgressType type;
  final MyProgressStatus progressStatus;
  final bool showLabel;
  final Widget? customProgressLabel;
  final double? labelWidgetWidth;
  final Alignment? labelWidgetAlignment;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final int animationDuration;
  final BuildContext? context;

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Color _effectiveColor;
  late Widget _effectiveLabel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );
    _updateAnimation();
    _updateEffectiveLabel();
  }

  @override
  void didUpdateWidget(ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateAnimation(oldWidgetValue: oldWidget.value);
    }
    if (oldWidget.label != widget.label ||
        oldWidget.progressStatus != widget.progressStatus) {
      _updateEffectiveLabel();
    }
  }

  void _updateEffectiveColor() {
    _effectiveColor =
        widget.color ?? _getColorFromStatus(widget.progressStatus);
  }

  void _updateEffectiveLabel() {
    _effectiveLabel =
        widget.label ?? _getDefaultLabelFromStatus(widget.progressStatus);
  }

  void _updateAnimation({double? oldWidgetValue}) {
    _animation = Tween<double>(
      begin: oldWidgetValue ?? _animationController.value,
      end: widget.value,
    ).animate(_animationController);
    unawaited(_animationController.forward(from: 0));
  }

  Widget _getDefaultLabelFromStatus(MyProgressStatus status) {
    final showAutoText = widget.value != null;

    final showInsideLabel =
        widget.progressLabelPosition == MyProgressLabelPosition.inside &&
        widget.type != MyProgressType.circular;

    final showIconBorder = widget.type == MyProgressType.linear;

    Widget getAutoText() =>
        showAutoText && widget.type != MyProgressType.micro
            ? Text('${(widget.value! * 100).round()}%')
            : const Text('');

    final statusWidgets = {
      MyProgressStatus.primary: getAutoText(),
      MyProgressStatus.warning:
          showInsideLabel
              ? getAutoText()
              : showIconBorder
              ? const Icon(Icons.error_rounded)
              : const Icon(Icons.priority_high_rounded),
      MyProgressStatus.danger:
          showInsideLabel
              ? getAutoText()
              : showIconBorder
              ? const Icon(Icons.cancel_rounded)
              : const Icon(Icons.close_rounded),
      MyProgressStatus.success:
          showInsideLabel
              ? getAutoText()
              : showIconBorder
              ? const Icon(Icons.check_circle_rounded)
              : const Icon(Icons.check_rounded),
    };

    return statusWidgets[status] ?? getAutoText();
  }

  Color _getColorFromStatus(MyProgressStatus status) {
    switch (status) {
      case MyProgressStatus.primary:
        return context.colorScheme.primary;
      case MyProgressStatus.warning:
        return ThemeColors.warning;
      case MyProgressStatus.danger:
        return context.colorScheme.destructive;
      case MyProgressStatus.success:
        return ThemeColors.success.shade600;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateEffectiveColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.type == MyProgressType.linear)
          _buildLinearProgress()
        else if (widget.type == MyProgressType.circular)
          _buildCircularProgress()
        else if (widget.type == MyProgressType.micro)
          _buildMicroProgress(),
      ],
    );
  }

  Widget _buildLinearProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (widget.value != null &&
            widget.progressLabelPosition == MyProgressLabelPosition.inside) {
          return _buildInsideLabel(maxWidth);
        } else {
          return _buildOutsideLabel(maxWidth);
        }
      },
    );
  }

  Widget _buildInsideLabel(double maxWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progressWidth = _animation.value * maxWidth;
        return Stack(
          children: [
            _buildBackgroundContainer(),
            if (widget.value! > 0.1)
              _buildProgressContainerWithLabel(progressWidth)
            else
              _buildProgressContainerWithLabelOutside(progressWidth),
          ],
        );
      },
    );
  }

  Widget _buildOutsideLabel(double maxWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progressWidth = _animation.value * maxWidth;
        return Row(
          children: [
            if (widget.progressLabelPosition == MyProgressLabelPosition.left)
              Container(
                padding: const EdgeInsets.only(right: 8),
                alignment: widget.labelWidgetAlignment ?? Alignment.centerRight,
                constraints: BoxConstraints(
                  minWidth:
                      widget.labelWidgetWidth ??
                      (maxWidth * 0.1 > 70 ? maxWidth * 0.04 : maxWidth * 0.1),
                ),
                child:
                    widget.customProgressLabel ??
                    _buildLabelWidget(context.colorScheme.foreground),
              ),
            Expanded(
              child: Stack(
                children: [
                  _buildBackgroundContainer(),
                  Container(
                    height: widget.strokeWidth,
                    width: progressWidth,
                    decoration: BoxDecoration(
                      color: _effectiveColor,
                      borderRadius: widget.linearBorderRadius,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.progressLabelPosition == MyProgressLabelPosition.right)
              Container(
                padding: const EdgeInsets.only(left: 8),
                alignment: widget.labelWidgetAlignment ?? Alignment.centerLeft,
                constraints: BoxConstraints(
                  minWidth:
                      widget.labelWidgetWidth ??
                      (maxWidth * 0.1 > 70 ? maxWidth * 0.04 : maxWidth * 0.1),
                ),
                child:
                    widget.customProgressLabel ??
                    _buildLabelWidget(context.colorScheme.foreground),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundContainer() {
    return Container(
      height: widget.strokeWidth,
      decoration: BoxDecoration(
        borderRadius: widget.linearBorderRadius,
        color: widget.backgroundColor,
      ),
    );
  }

  Widget _buildProgressContainerWithLabel(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        color: _effectiveColor,
        borderRadius: widget.linearBorderRadius,
      ),
      child:
          widget.showLabel
              ? Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildLabelWidget(
                    context.colorScheme.primaryForeground,
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildProgressContainerWithLabelOutside(double progressWidth) {
    return Row(
      children: [
        Container(
          height: widget.strokeWidth,
          width: progressWidth,
          decoration: BoxDecoration(
            color: _effectiveColor,
            borderRadius: BorderRadius.only(
              topLeft:
                  widget.linearBorderRadius.resolve(TextDirection.ltr).topLeft,
              bottomLeft:
                  widget.linearBorderRadius
                      .resolve(TextDirection.ltr)
                      .bottomLeft,
              topRight: Radius.circular(
                widget.linearBorderRadius
                        .resolve(TextDirection.ltr)
                        .topRight
                        .x /
                    2,
              ),
              bottomRight: Radius.circular(
                widget.linearBorderRadius
                        .resolve(TextDirection.ltr)
                        .bottomRight
                        .x /
                    2,
              ),
            ),
          ),
        ),
        if (widget.showLabel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildLabelWidget(ThemeColors.neutral.shade900),
          ),
      ],
    );
  }

  Widget _buildLabelWidget(Color labelColor) {
    late double iconSize;
    late double fontSize;
    late FontWeight fontWeight;

    switch (widget.type) {
      case MyProgressType.linear:
        if (widget.progressLabelPosition != MyProgressLabelPosition.inside) {
          fontSize = widget.strokeWidth > 14 ? widget.strokeWidth : 14;
          iconSize = widget.strokeWidth > 20 ? widget.strokeWidth : 20;
        } else {
          fontSize = widget.strokeWidth * 0.6;
          iconSize = widget.strokeWidth;
        }
        fontWeight =
            _animation.value <= 0.1 ? FontWeight.bold : FontWeight.normal;
      case MyProgressType.circular:
        iconSize = widget.circleRadius * 0.4;
        fontSize = widget.circleRadius * 0.15;
        fontWeight = FontWeight.bold;
      case MyProgressType.micro:
        iconSize = widget.circleRadius * 0.5;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.normal;
    }

    return IconTheme(
      data: IconThemeData(color: _effectiveColor, size: iconSize),
      child: DefaultTextStyle(
        style: context.bodyMedium.copyWith(
          color: labelColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        child: _effectiveLabel,
      ),
    );
  }

  Widget _buildCircularProgress() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: widget.circleRadius,
              width: widget.circleRadius,
              child: Padding(
                padding: EdgeInsets.all(widget.strokeWidth / 2),
                child: MyProgressCircular(
                  strokeWidth: widget.strokeWidth,
                  circleRadius: widget.circleRadius,
                  value: _animation.value,
                  backgroundColor: widget.backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
                ),
              ),
            ),
            if (widget.showLabel)
              _buildLabelWidget(context.colorScheme.foreground),
          ],
        );
      },
    );
  }

  Widget _buildMicroProgress() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildMicroOutline(),
              if (widget.showLabel)
                _buildLabelWidget(context.colorScheme.foreground),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMicroOutline() {
    return SizedBox(
      height: widget.circleRadius,
      width: widget.circleRadius,
      child: Padding(
        padding: EdgeInsets.all(widget.strokeWidth / 2),
        child: MyProgressCircular(
          strokeWidth: widget.strokeWidth,
          circleRadius: widget.circleRadius,
          value: _animation.value,
          backgroundColor: widget.backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
        ),
      ),
    );
  }
}
