import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../../../index.dart';

const Duration _kDialAnimateDuration = Duration(milliseconds: 200);
const double _kTwoPi = 2 * math.pi;
const Duration _kVibrateCommitDelay = Duration(milliseconds: 100);

const double _kTimePickerInnerDialOffset = 28;
const double _kTimePickerDialMinRadius = 50;
const double _kTimePickerDialPadding = 28;

// Whether the dial-mode time picker is currently selecting the hour or the
// minute.
enum _HourMinuteMode { hour, minute }

// Aspects of _TimePickerModel that can be depended upon.
enum _TimePickerAspect {
  use24HourFormat,
  hourMinuteMode,
  onHourMinuteModeChanged,
  hourDialType,
  selectedTime,
  onSelectedTimeChanged,
  theme,
  defaultTheme,
}

class _TimePickerModel extends InheritedModel<_TimePickerAspect> {
  const _TimePickerModel({
    required this.hourMinuteMode,
    required this.onHourMinuteModeChanged,
    required this.selectedTime,
    required this.onSelectedTimeChanged,
    required this.use24HourFormat,
    required this.hourDialType,
    required this.theme,
    required this.defaultTheme,
    required super.child,
  });

  final _HourMinuteMode hourMinuteMode;
  final ValueChanged<_HourMinuteMode> onHourMinuteModeChanged;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onSelectedTimeChanged;
  final bool use24HourFormat;
  final _HourDialType hourDialType;
  final TimePickerThemeData theme;
  final _TimePickerDefaults defaultTheme;

  static _TimePickerModel of(
    BuildContext context, [
    _TimePickerAspect? aspect,
  ]) => InheritedModel.inheritFrom<_TimePickerModel>(context, aspect: aspect)!;
  static _HourMinuteMode hourMinuteModeOf(BuildContext context) =>
      of(context, _TimePickerAspect.hourMinuteMode).hourMinuteMode;
  static TimeOfDay selectedTimeOf(BuildContext context) =>
      of(context, _TimePickerAspect.selectedTime).selectedTime;
  static bool use24HourFormatOf(BuildContext context) =>
      of(context, _TimePickerAspect.use24HourFormat).use24HourFormat;
  static _HourDialType hourDialTypeOf(BuildContext context) =>
      of(context, _TimePickerAspect.hourDialType).hourDialType;
  static TimePickerThemeData themeOf(BuildContext context) =>
      of(context, _TimePickerAspect.theme).theme;
  static _TimePickerDefaults defaultThemeOf(BuildContext context) =>
      of(context, _TimePickerAspect.defaultTheme).defaultTheme;

  static void setSelectedTime(BuildContext context, TimeOfDay value) => of(
    context,
    _TimePickerAspect.onSelectedTimeChanged,
  ).onSelectedTimeChanged(value);
  static void setHourMinuteMode(BuildContext context, _HourMinuteMode value) =>
      of(
        context,
        _TimePickerAspect.onHourMinuteModeChanged,
      ).onHourMinuteModeChanged(value);

  @override
  bool updateShouldNotifyDependent(
    _TimePickerModel oldWidget,
    Set<_TimePickerAspect> dependencies,
  ) {
    if (use24HourFormat != oldWidget.use24HourFormat &&
        dependencies.contains(_TimePickerAspect.use24HourFormat)) {
      return true;
    }
    if (hourMinuteMode != oldWidget.hourMinuteMode &&
        dependencies.contains(_TimePickerAspect.hourMinuteMode)) {
      return true;
    }
    if (onHourMinuteModeChanged != oldWidget.onHourMinuteModeChanged &&
        dependencies.contains(_TimePickerAspect.onHourMinuteModeChanged)) {
      return true;
    }
    if (hourDialType != oldWidget.hourDialType &&
        dependencies.contains(_TimePickerAspect.hourDialType)) {
      return true;
    }
    if (selectedTime != oldWidget.selectedTime &&
        dependencies.contains(_TimePickerAspect.selectedTime)) {
      return true;
    }
    if (onSelectedTimeChanged != oldWidget.onSelectedTimeChanged &&
        dependencies.contains(_TimePickerAspect.onSelectedTimeChanged)) {
      return true;
    }
    if (theme != oldWidget.theme &&
        dependencies.contains(_TimePickerAspect.theme)) {
      return true;
    }
    if (defaultTheme != oldWidget.defaultTheme &&
        dependencies.contains(_TimePickerAspect.defaultTheme)) {
      return true;
    }
    return false;
  }

  @override
  bool updateShouldNotify(_TimePickerModel oldWidget) {
    return use24HourFormat != oldWidget.use24HourFormat ||
        hourMinuteMode != oldWidget.hourMinuteMode ||
        onHourMinuteModeChanged != oldWidget.onHourMinuteModeChanged ||
        hourDialType != oldWidget.hourDialType ||
        selectedTime != oldWidget.selectedTime ||
        onSelectedTimeChanged != oldWidget.onSelectedTimeChanged ||
        theme != oldWidget.theme ||
        defaultTheme != oldWidget.defaultTheme;
  }
}

class _TimePickerHeader extends StatelessWidget {
  const _TimePickerHeader({required this.helpText});

  final String helpText;

  @override
  Widget build(BuildContext context) {
    final TimeOfDayFormat timeOfDayFormat = MaterialLocalizations.of(
      context,
    ).timeOfDayFormat(
      alwaysUse24HourFormat: _TimePickerModel.use24HourFormatOf(context),
    );

    final _HourDialType hourDialType = _TimePickerModel.hourDialTypeOf(context);
    final RenderObjectWidget orientationSpecificHeader = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: 20),
          child: Text(
            helpText,
            style:
                _TimePickerModel.themeOf(context).helpTextStyle ??
                _TimePickerModel.defaultThemeOf(context).helpTextStyle,
          ),
        ),
        Row(
          textDirection:
              timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          spacing: 12,
          children: <Widget>[
            Expanded(
              child: Row(
                // Hour/minutes should not change positions in RTL locales.
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  const Expanded(child: _HourControl()),
                  _TimeSelectorSeparator(timeOfDayFormat: timeOfDayFormat),
                  const Expanded(child: _MinuteControl()),
                ],
              ),
            ),
            if (hourDialType == _HourDialType.twelveHour)
              const _DayPeriodControl(),
          ],
        ),
      ],
    );

    return Semantics(
      label: MaterialLocalizations.of(context).formatTimeOfDay(
        _TimePickerModel.selectedTimeOf(context),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      ),
      child: orientationSpecificHeader,
    );
  }
}

class _HourMinuteControl extends StatelessWidget {
  const _HourMinuteControl({
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  final String text;
  final GestureTapCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final TimePickerThemeData timePickerTheme = _TimePickerModel.themeOf(
      context,
    );
    final _TimePickerDefaults defaultTheme = _TimePickerModel.defaultThemeOf(
      context,
    );
    final Color backgroundColor =
        timePickerTheme.hourMinuteColor ?? defaultTheme.hourMinuteColor;
    final ShapeBorder shape =
        timePickerTheme.hourMinuteShape ?? defaultTheme.hourMinuteShape;

    final Set<WidgetState> states = <WidgetState>{
      if (isSelected) WidgetState.selected,
    };
    final Color effectiveTextColor = WidgetStateProperty.resolveAs<Color>(
      _TimePickerModel.themeOf(context).hourMinuteTextColor ??
          _TimePickerModel.defaultThemeOf(context).hourMinuteTextColor,
      states,
    );
    final TextStyle effectiveStyle = WidgetStateProperty.resolveAs<TextStyle>(
      timePickerTheme.hourMinuteTextStyle ?? defaultTheme.hourMinuteTextStyle,
      states,
    ).copyWith(color: effectiveTextColor);

    final double height = defaultTheme.hourMinuteSize.height;

    return SizedBox(
      height: height,
      child: Material(
        color: WidgetStateProperty.resolveAs(backgroundColor, states),
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: MyGestureDetector(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: effectiveStyle,
              textScaler: TextScaler.noScaling,
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays the hour fragment.
///
/// When tapped changes time picker dial mode to [_HourMinuteMode.hour].
class _HourControl extends StatelessWidget {
  const _HourControl();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), '');
    final bool alwaysUse24HourFormat = MediaQuery.alwaysUse24HourFormatOf(
      context,
    );
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final String formattedHour = localizations.formatHour(
      selectedTime,
      alwaysUse24HourFormat: _TimePickerModel.use24HourFormatOf(context),
    );

    TimeOfDay hoursFromSelected(int hoursToAdd) {
      switch (_TimePickerModel.hourDialTypeOf(context)) {
        case _HourDialType.twentyFourHour:
        case _HourDialType.twentyFourHourDoubleRing:
          final int selectedHour = selectedTime.hour;
          return selectedTime.replacing(
            hour: (selectedHour + hoursToAdd) % TimeOfDay.hoursPerDay,
          );
        case _HourDialType.twelveHour:
          // Cycle 1 through 12 without changing day period.
          final int periodOffset = selectedTime.periodOffset;
          final int hours = selectedTime.hourOfPeriod;
          return selectedTime.replacing(
            hour:
                periodOffset + (hours + hoursToAdd) % TimeOfDay.hoursPerPeriod,
          );
      }
    }

    final TimeOfDay nextHour = hoursFromSelected(1);
    final String formattedNextHour = localizations.formatHour(
      nextHour,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );
    final TimeOfDay previousHour = hoursFromSelected(-1);
    final String formattedPreviousHour = localizations.formatHour(
      previousHour,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );

    return Semantics(
      value: '${localizations.timePickerHourModeAnnouncement} $formattedHour',
      excludeSemantics: true,
      increasedValue: formattedNextHour,
      onIncrease: () {
        _TimePickerModel.setSelectedTime(context, nextHour);
      },
      decreasedValue: formattedPreviousHour,
      onDecrease: () {
        _TimePickerModel.setSelectedTime(context, previousHour);
      },
      child: _HourMinuteControl(
        isSelected:
            _TimePickerModel.hourMinuteModeOf(context) == _HourMinuteMode.hour,
        text: formattedHour,
        onTap:
            () => _TimePickerModel.setHourMinuteMode(
              context,
              _HourMinuteMode.hour,
            ),
      ),
    );
  }
}

/// A passive fragment showing a string value.
///
/// Used to display the appropriate separator between the input fields.
class _TimeSelectorSeparator extends StatelessWidget {
  const _TimeSelectorSeparator({required this.timeOfDayFormat});

  final TimeOfDayFormat timeOfDayFormat;

  String _timeSelectorSeparatorValue(TimeOfDayFormat timeOfDayFormat) {
    switch (timeOfDayFormat) {
      case TimeOfDayFormat.h_colon_mm_space_a:
      case TimeOfDayFormat.a_space_h_colon_mm:
      case TimeOfDayFormat.H_colon_mm:
      case TimeOfDayFormat.HH_colon_mm:
        return ':';
      case TimeOfDayFormat.HH_dot_mm:
        return '.';
      case TimeOfDayFormat.frenchCanadian:
        return 'h';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(context);
    final Set<WidgetState> states = <WidgetState>{};

    final Color effectiveTextColor = WidgetStateProperty.resolveAs<Color>(
      timePickerTheme.timeSelectorSeparatorColor?.resolve(states) ??
          timePickerTheme.hourMinuteTextColor ??
          defaultTheme.timeSelectorSeparatorColor?.resolve(states) ??
          defaultTheme.hourMinuteTextColor,
      states,
    );
    final TextStyle effectiveStyle = WidgetStateProperty.resolveAs<TextStyle>(
      timePickerTheme.timeSelectorSeparatorTextStyle?.resolve(states) ??
          timePickerTheme.hourMinuteTextStyle ??
          defaultTheme.timeSelectorSeparatorTextStyle?.resolve(states) ??
          defaultTheme.hourMinuteTextStyle,
      states,
    ).copyWith(color: effectiveTextColor, height: 1);

    final double height = defaultTheme.hourMinuteSize.height;

    return ExcludeSemantics(
      child: SizedBox(
        width: timeOfDayFormat == TimeOfDayFormat.frenchCanadian ? 36 : 24,
        height: height,
        child: Center(
          child: Text(
            _timeSelectorSeparatorValue(timeOfDayFormat),
            style: effectiveStyle,
            textScaler: TextScaler.noScaling,
          ),
        ),
      ),
    );
  }
}

/// Displays the minute fragment.
///
/// When tapped changes time picker dial mode to [_HourMinuteMode.minute].
class _MinuteControl extends StatelessWidget {
  const _MinuteControl();

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final String formattedMinute = localizations.formatMinute(selectedTime);
    final TimeOfDay nextMinute = selectedTime.replacing(
      minute: (selectedTime.minute + 1) % TimeOfDay.minutesPerHour,
    );
    final String formattedNextMinute = localizations.formatMinute(nextMinute);
    final TimeOfDay previousMinute = selectedTime.replacing(
      minute: (selectedTime.minute - 1) % TimeOfDay.minutesPerHour,
    );
    final String formattedPreviousMinute = localizations.formatMinute(
      previousMinute,
    );

    return Semantics(
      excludeSemantics: true,
      value:
          '${localizations.timePickerMinuteModeAnnouncement} $formattedMinute',
      increasedValue: formattedNextMinute,
      onIncrease: () {
        _TimePickerModel.setSelectedTime(context, nextMinute);
      },
      decreasedValue: formattedPreviousMinute,
      onDecrease: () {
        _TimePickerModel.setSelectedTime(context, previousMinute);
      },
      child: _HourMinuteControl(
        isSelected:
            _TimePickerModel.hourMinuteModeOf(context) ==
            _HourMinuteMode.minute,
        text: formattedMinute,
        onTap:
            () => _TimePickerModel.setHourMinuteMode(
              context,
              _HourMinuteMode.minute,
            ),
      ),
    );
  }
}

/// Displays the am/pm fragment and provides controls for switching between am
/// and pm.
class _DayPeriodControl extends StatelessWidget {
  const _DayPeriodControl();

  void _togglePeriod(BuildContext context) {
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final int newHour =
        (selectedTime.hour + TimeOfDay.hoursPerPeriod) % TimeOfDay.hoursPerDay;
    final TimeOfDay newTime = selectedTime.replacing(hour: newHour);
    _TimePickerModel.setSelectedTime(context, newTime);
  }

  void _setAm(BuildContext context) {
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    if (selectedTime.period == DayPeriod.am) {
      return;
    }
    _togglePeriod(context);
  }

  void _setPm(BuildContext context) {
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    if (selectedTime.period == DayPeriod.pm) {
      return;
    }
    _togglePeriod(context);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);
    final TimePickerThemeData timePickerTheme = _TimePickerModel.themeOf(
      context,
    );
    final _TimePickerDefaults defaultTheme = _TimePickerModel.defaultThemeOf(
      context,
    );
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final bool amSelected = selectedTime.period == DayPeriod.am;
    final bool pmSelected = !amSelected;
    final BorderSide resolvedSide =
        timePickerTheme.dayPeriodBorderSide ?? defaultTheme.dayPeriodBorderSide;
    final OutlinedBorder resolvedShape = (timePickerTheme.dayPeriodShape ??
            defaultTheme.dayPeriodShape)
        .copyWith(side: resolvedSide);

    final Widget amButton = _AmPmButton(
      selected: amSelected,
      onPressed: () => _setAm(context),
      label: materialLocalizations.anteMeridiemAbbreviation,
    );

    final Widget pmButton = _AmPmButton(
      selected: pmSelected,
      onPressed: () => _setPm(context),
      label: materialLocalizations.postMeridiemAbbreviation,
    );

    final Size dayPeriodSize = defaultTheme.dayPeriodPortraitSize;

    final Widget result = _DayPeriodInputPadding(
      minSize: dayPeriodSize,
      orientation: Orientation.portrait,
      child: SizedBox.fromSize(
        size: dayPeriodSize,
        child: Material(
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          shape: resolvedShape,
          child: Column(
            children: <Widget>[
              Expanded(child: amButton),
              Container(
                decoration: BoxDecoration(border: Border(top: resolvedSide)),
                height: 1,
              ),
              Expanded(child: pmButton),
            ],
          ),
        ),
      ),
    );

    return result;
  }
}

class _AmPmButton extends StatelessWidget {
  const _AmPmButton({
    required this.onPressed,
    required this.selected,
    required this.label,
  });

  final bool selected;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Set<WidgetState> states = <WidgetState>{
      if (selected) WidgetState.selected,
    };
    final TimePickerThemeData timePickerTheme = _TimePickerModel.themeOf(
      context,
    );
    final _TimePickerDefaults defaultTheme = _TimePickerModel.defaultThemeOf(
      context,
    );
    final Color resolvedBackgroundColor = WidgetStateProperty.resolveAs<Color>(
      timePickerTheme.dayPeriodColor ?? defaultTheme.dayPeriodColor,
      states,
    );
    final Color resolvedTextColor = WidgetStateProperty.resolveAs<Color>(
      timePickerTheme.dayPeriodTextColor ?? defaultTheme.dayPeriodTextColor,
      states,
    );
    final TextStyle? resolvedTextStyle =
        WidgetStateProperty.resolveAs<TextStyle?>(
          timePickerTheme.dayPeriodTextStyle ?? defaultTheme.dayPeriodTextStyle,
          states,
        )?.copyWith(color: resolvedTextColor);
    final TextScaler buttonTextScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: 2);

    return Material(
      color: resolvedBackgroundColor,
      child: InkWell(
        onTap: onPressed,
        child: Semantics(
          checked: selected,
          inMutuallyExclusiveGroup: true,
          button: true,
          child: Center(
            child: Text(
              label,
              style: resolvedTextStyle,
              textScaler: buttonTextScaler,
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget to pad the area around the [_DayPeriodControl]'s inner [Material].
class _DayPeriodInputPadding extends SingleChildRenderObjectWidget {
  const _DayPeriodInputPadding({
    required Widget super.child,
    required this.minSize,
    required this.orientation,
  });

  final Size minSize;
  final Orientation orientation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize, orientation);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderInputPadding renderObject,
  ) {
    renderObject
      ..minSize = minSize
      ..orientation = orientation;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, this._orientation, [RenderBox? child])
    : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  Orientation get orientation => _orientation;
  Orientation _orientation;
  set orientation(Orientation value) {
    if (_orientation == value) return;

    _orientation = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  Size _computeSize({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double width = math.max(childSize.width, minSize.width);
      final double height = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(width, height));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final double? result = child.getDryBaseline(constraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(constraints);
    return result +
        Alignment.center
            .alongOffset(getDryLayout(constraints) - childSize as Offset)
            .dy;
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    if (child != null) {
      (child!.parentData! as BoxParentData)
        .offset = Alignment.center.alongOffset(size - child!.size as Offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }

    if (position.dx < 0 ||
        position.dx > math.max(child!.size.width, minSize.width) ||
        position.dy < 0 ||
        position.dy > math.max(child!.size.height, minSize.height)) {
      return false;
    }

    Offset newPosition = child!.size.center(Offset.zero);
    newPosition += switch (orientation) {
      Orientation.portrait when position.dy > newPosition.dy => const Offset(
        0,
        1,
      ),
      Orientation.landscape when position.dx > newPosition.dx => const Offset(
        1,
        0,
      ),
      Orientation.portrait => const Offset(0, -1),
      Orientation.landscape => const Offset(-1, 0),
    };

    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(newPosition),
      position: newPosition,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == newPosition, '');
        return child!.hitTest(result, position: newPosition);
      },
    );
  }
}

class _TappableLabel {
  _TappableLabel({
    required this.value,
    required this.inner,
    required this.painter,
    required this.onTap,
  });

  /// The value this label is displaying.
  final int value;

  /// This value is part of the "inner" ring of values on the dial, used for 24
  /// hour input.
  final bool inner;

  /// Paints the text of the label.
  final TextPainter painter;

  /// Called when a tap gesture is detected on the label.
  final VoidCallback onTap;
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.primaryLabels,
    required this.selectedLabels,
    required this.backgroundColor,
    required this.handColor,
    required this.handWidth,
    required this.dotColor,
    required this.dotRadius,
    required this.centerRadius,
    required this.theta,
    required this.radius,
    required this.textDirection,
    required this.selectedValue,
  }) : super(repaint: PaintingBinding.instance.systemFonts) {
    assert(debugMaybeDispatchCreated('material', '_DialPainter', this), '');
  }

  final List<_TappableLabel> primaryLabels;
  final List<_TappableLabel> selectedLabels;
  final Color backgroundColor;
  final Color handColor;
  final double handWidth;
  final Color dotColor;
  final double dotRadius;
  final double centerRadius;
  final double theta;
  final double radius;
  final TextDirection textDirection;
  final int selectedValue;

  void dispose() {
    assert(debugMaybeDispatchDisposed(this), '');
    for (final _TappableLabel label in primaryLabels) {
      label.painter.dispose();
    }
    for (final _TappableLabel label in selectedLabels) {
      label.painter.dispose();
    }
    primaryLabels.clear();
    selectedLabels.clear();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double dialRadius = clampDouble(
      size.shortestSide / 2,
      _kTimePickerDialMinRadius + dotRadius,
      double.infinity,
    );
    final double labelRadius = clampDouble(
      dialRadius - _kTimePickerDialPadding,
      _kTimePickerDialMinRadius,
      double.infinity,
    );
    final double innerLabelRadius = clampDouble(
      labelRadius - _kTimePickerInnerDialOffset,
      0,
      double.infinity,
    );
    final double handleRadius = clampDouble(
      labelRadius - (radius < 0.5 ? 1 : 0) * (labelRadius - innerLabelRadius),
      _kTimePickerDialMinRadius,
      double.infinity,
    );
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset centerPoint = center;
    canvas.drawCircle(
      centerPoint,
      dialRadius,
      Paint()..color = backgroundColor,
    );

    Offset getOffsetForTheta(double theta, double radius) {
      return center +
          Offset(radius * math.cos(theta), -radius * math.sin(theta));
    }

    void paintLabels(List<_TappableLabel> labels, double radius) {
      if (labels.isEmpty) {
        return;
      }
      final double labelThetaIncrement = -_kTwoPi / labels.length;
      double labelTheta = math.pi / 2;

      for (final _TappableLabel label in labels) {
        final TextPainter labelPainter = label.painter;
        final Offset labelOffset = Offset(
          -labelPainter.width / 2,
          -labelPainter.height / 2,
        );
        labelPainter.paint(
          canvas,
          getOffsetForTheta(labelTheta, radius) + labelOffset,
        );
        labelTheta += labelThetaIncrement;
      }
    }

    void paintInnerOuterLabels(List<_TappableLabel>? labels) {
      if (labels == null) {
        return;
      }

      paintLabels(
        labels.where((_TappableLabel label) => !label.inner).toList(),
        labelRadius,
      );
      paintLabels(
        labels.where((_TappableLabel label) => label.inner).toList(),
        innerLabelRadius,
      );
    }

    paintInnerOuterLabels(primaryLabels);

    final Paint selectorPaint = Paint()..color = handColor;
    final Offset focusedPoint = getOffsetForTheta(theta, handleRadius);
    canvas
      ..drawCircle(centerPoint, centerRadius, selectorPaint)
      ..drawCircle(focusedPoint, dotRadius, selectorPaint);
    selectorPaint.strokeWidth = handWidth;
    canvas.drawLine(centerPoint, focusedPoint, selectorPaint);

    // Add a dot inside the selector but only when it isn't over the labels.
    // This checks that the selector's theta is between two labels. A remainder
    // between 0.1 and 0.45 indicates that the selector is roughly not above any
    // labels. The values were derived by manually testing the dial.
    final double labelThetaIncrement = -_kTwoPi / primaryLabels.length;
    if (theta % labelThetaIncrement > 0.1 &&
        theta % labelThetaIncrement < 0.45) {
      canvas.drawCircle(focusedPoint, 2, selectorPaint..color = dotColor);
    }

    final Rect focusedRect = Rect.fromCircle(
      center: focusedPoint,
      radius: dotRadius,
    );
    canvas
      ..save()
      ..clipPath(Path()..addOval(focusedRect));
    paintInnerOuterLabels(selectedLabels);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DialPainter oldPainter) {
    return oldPainter.primaryLabels != primaryLabels ||
        oldPainter.selectedLabels != selectedLabels ||
        oldPainter.backgroundColor != backgroundColor ||
        oldPainter.handColor != handColor ||
        oldPainter.theta != theta;
  }
}

// Which kind of hour dial being presented.
enum _HourDialType { twentyFourHour, twentyFourHourDoubleRing, twelveHour }

class _Dial extends StatefulWidget {
  const _Dial({
    required this.selectedTime,
    required this.hourMinuteMode,
    required this.hourDialType,
    required this.onChanged,
    required this.onHourSelected,
  });

  final TimeOfDay selectedTime;
  final _HourMinuteMode hourMinuteMode;
  final _HourDialType hourDialType;
  final ValueChanged<TimeOfDay>? onChanged;
  final VoidCallback? onHourSelected;

  @override
  _DialState createState() => _DialState();
}

class _DialState extends State<_Dial> with SingleTickerProviderStateMixin {
  late ThemeData themeData;
  late MaterialLocalizations localizations;
  _DialPainter? painter;
  late AnimationController _animationController;
  late Tween<double> _thetaTween;
  late Animation<double> _theta;
  late Tween<double> _radiusTween;
  late Animation<double> _radius;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _kDialAnimateDuration,
      vsync: this,
    );
    _thetaTween = Tween<double>(begin: _getThetaForTime(widget.selectedTime));
    _radiusTween = Tween<double>(begin: _getRadiusForTime(widget.selectedTime));
    _theta = _animationController
      .drive(CurveTween(curve: Easing.legacy))
      .drive(_thetaTween)..addListener(() => setState(() {}));
    _radius = _animationController
      .drive(CurveTween(curve: Easing.legacy))
      .drive(_radiusTween)..addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMediaQuery(context), '');
    themeData = Theme.of(context);
    localizations = MaterialLocalizations.of(context);
  }

  @override
  void didUpdateWidget(_Dial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hourMinuteMode != oldWidget.hourMinuteMode ||
        widget.selectedTime != oldWidget.selectedTime) {
      if (!_dragging) {
        _animateTo(
          _getThetaForTime(widget.selectedTime),
          _getRadiusForTime(widget.selectedTime),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    painter?.dispose();
    super.dispose();
  }

  static double _nearest(double target, double a, double b) {
    return ((target - a).abs() < (target - b).abs()) ? a : b;
  }

  void _animateTo(double targetTheta, double targetRadius) {
    void animateToValue({
      required double target,
      required Animation<double> animation,
      required Tween<double> tween,
      required AnimationController controller,
      required double min,
      required double max,
    }) {
      double beginValue = _nearest(target, animation.value, max);
      beginValue = _nearest(target, beginValue, min);
      tween
        ..begin = beginValue
        ..end = target;
      controller.value = 0;
      unawaited(controller.forward());
    }

    animateToValue(
      target: targetTheta,
      animation: _theta,
      tween: _thetaTween,
      controller: _animationController,
      min: _theta.value - _kTwoPi,
      max: _theta.value + _kTwoPi,
    );
    animateToValue(
      target: targetRadius,
      animation: _radius,
      tween: _radiusTween,
      controller: _animationController,
      min: 0,
      max: 1,
    );
  }

  double _getRadiusForTime(TimeOfDay time) {
    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        return switch (widget.hourDialType) {
          _HourDialType.twentyFourHourDoubleRing => time.hour >= 12 ? 0 : 1,
          _HourDialType.twentyFourHour || _HourDialType.twelveHour => 1,
        };
      case _HourMinuteMode.minute:
        return 1;
    }
  }

  double _getThetaForTime(TimeOfDay time) {
    final int hoursFactor = switch (widget.hourDialType) {
      _HourDialType.twentyFourHour => TimeOfDay.hoursPerDay,
      _HourDialType.twentyFourHourDoubleRing => TimeOfDay.hoursPerPeriod,
      _HourDialType.twelveHour => TimeOfDay.hoursPerPeriod,
    };
    final double fraction = switch (widget.hourMinuteMode) {
      _HourMinuteMode.hour => (time.hour / hoursFactor) % hoursFactor,
      _HourMinuteMode.minute =>
        (time.minute / TimeOfDay.minutesPerHour) % TimeOfDay.minutesPerHour,
    };
    return (math.pi / 2 - fraction * _kTwoPi) % _kTwoPi;
  }

  TimeOfDay _getTimeForTheta(
    double theta, {
    required double radius,
    bool roundMinutes = false,
  }) {
    final double fraction = (0.25 - (theta % _kTwoPi) / _kTwoPi) % 1;
    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        int newHour;
        switch (widget.hourDialType) {
          case _HourDialType.twentyFourHour:
            newHour =
                (fraction * TimeOfDay.hoursPerDay).round() %
                TimeOfDay.hoursPerDay;
          case _HourDialType.twentyFourHourDoubleRing:
            newHour =
                (fraction * TimeOfDay.hoursPerPeriod).round() %
                TimeOfDay.hoursPerPeriod;
            if (radius < 0.5) {
              newHour = newHour + TimeOfDay.hoursPerPeriod;
            }
          case _HourDialType.twelveHour:
            newHour =
                (fraction * TimeOfDay.hoursPerPeriod).round() %
                TimeOfDay.hoursPerPeriod;
            newHour = newHour + widget.selectedTime.periodOffset;
        }
        return widget.selectedTime.replacing(hour: newHour);
      case _HourMinuteMode.minute:
        int minute =
            (fraction * TimeOfDay.minutesPerHour).round() %
            TimeOfDay.minutesPerHour;
        if (roundMinutes) {
          // Round the minutes to nearest 5 minute interval.
          minute = ((minute + 2) ~/ 5) * 5 % TimeOfDay.minutesPerHour;
        }
        return widget.selectedTime.replacing(minute: minute);
    }
  }

  TimeOfDay _notifyOnChangedIfNeeded({bool roundMinutes = false}) {
    final TimeOfDay current = _getTimeForTheta(
      _theta.value,
      roundMinutes: roundMinutes,
      radius: _radius.value,
    );
    if (widget.onChanged == null) {
      return current;
    }
    if (current != widget.selectedTime) {
      widget.onChanged!(current);
    }
    return current;
  }

  void _updateThetaForPan({bool roundMinutes = false}) {
    setState(() {
      final Offset offset = _position! - _center!;
      final double labelRadius =
          _dialSize!.shortestSide / 2 - _kTimePickerDialPadding;
      final double innerRadius = labelRadius - _kTimePickerInnerDialOffset;
      double angle = (math.atan2(offset.dx, offset.dy) - math.pi / 2) % _kTwoPi;
      final double radius = clampDouble(
        (offset.distance - innerRadius) / _kTimePickerInnerDialOffset,
        0,
        1,
      );
      if (roundMinutes) {
        angle = _getThetaForTime(
          _getTimeForTheta(angle, roundMinutes: roundMinutes, radius: radius),
        );
      }
      // The controller doesn't animate during the pan gesture.
      _thetaTween
        ..begin = angle
        ..end = angle;
      _radiusTween
        ..begin = radius
        ..end = radius;
    });
  }

  Offset? _position;
  Offset? _center;
  Size? _dialSize;

  void _handlePanStart(DragStartDetails details) {
    assert(!_dragging, '');
    _dragging = true;
    final RenderBox box = context.findRenderObject()! as RenderBox;
    _position = box.globalToLocal(details.globalPosition);
    _dialSize = box.size;
    _center = _dialSize!.center(Offset.zero);
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _position = _position! + details.delta;
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanEnd(DragEndDetails details) {
    assert(_dragging, '');
    _dragging = false;
    _position = null;
    _center = null;
    _dialSize = null;
    _animateTo(
      _getThetaForTime(widget.selectedTime),
      _getRadiusForTime(widget.selectedTime),
    );
    if (widget.hourMinuteMode == _HourMinuteMode.hour) {
      widget.onHourSelected?.call();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    _position = box.globalToLocal(details.globalPosition);
    _center = box.size.center(Offset.zero);
    _dialSize = box.size;
    _updateThetaForPan(roundMinutes: true);
    _notifyOnChangedIfNeeded(roundMinutes: true);
    if (widget.hourMinuteMode == _HourMinuteMode.hour) {
      widget.onHourSelected?.call();
    }
    final TimeOfDay time = _getTimeForTheta(
      _theta.value,
      roundMinutes: true,
      radius: _radius.value,
    );
    _animateTo(_getThetaForTime(time), _getRadiusForTime(time));
    _dragging = false;
    _position = null;
    _center = null;
    _dialSize = null;
  }

  void _selectHour(int hour) {
    final TimeOfDay time;

    TimeOfDay getAmPmTime() {
      return switch (widget.selectedTime.period) {
        DayPeriod.am => TimeOfDay(
          hour: hour,
          minute: widget.selectedTime.minute,
        ),
        DayPeriod.pm => TimeOfDay(
          hour: hour + TimeOfDay.hoursPerPeriod,
          minute: widget.selectedTime.minute,
        ),
      };
    }

    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        switch (widget.hourDialType) {
          case _HourDialType.twentyFourHour:
          case _HourDialType.twentyFourHourDoubleRing:
            time = TimeOfDay(hour: hour, minute: widget.selectedTime.minute);
          case _HourDialType.twelveHour:
            time = getAmPmTime();
        }
      case _HourMinuteMode.minute:
        time = getAmPmTime();
    }
    final double angle = _getThetaForTime(time);
    _thetaTween
      ..begin = angle
      ..end = angle;
    _notifyOnChangedIfNeeded();
  }

  void _selectMinute(int minute) {
    final TimeOfDay time = TimeOfDay(
      hour: widget.selectedTime.hour,
      minute: minute,
    );
    final double angle = _getThetaForTime(time);
    _thetaTween
      ..begin = angle
      ..end = angle;
    _notifyOnChangedIfNeeded();
  }

  static const List<TimeOfDay> _amHours = <TimeOfDay>[
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 1, minute: 0),
    TimeOfDay(hour: 2, minute: 0),
    TimeOfDay(hour: 3, minute: 0),
    TimeOfDay(hour: 4, minute: 0),
    TimeOfDay(hour: 5, minute: 0),
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
  ];

  // On M2, there's no inner ring of numbers.
  static const List<TimeOfDay> _twentyFourHoursM2 = <TimeOfDay>[
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 2, minute: 0),
    TimeOfDay(hour: 4, minute: 0),
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
    TimeOfDay(hour: 22, minute: 0),
  ];

  static const List<TimeOfDay> _twentyFourHours = <TimeOfDay>[
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 1, minute: 0),
    TimeOfDay(hour: 2, minute: 0),
    TimeOfDay(hour: 3, minute: 0),
    TimeOfDay(hour: 4, minute: 0),
    TimeOfDay(hour: 5, minute: 0),
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
    TimeOfDay(hour: 21, minute: 0),
    TimeOfDay(hour: 22, minute: 0),
    TimeOfDay(hour: 23, minute: 0),
  ];

  _TappableLabel _buildTappableLabel({
    required TextStyle? textStyle,
    required int selectedValue,
    required int value,
    required bool inner,
    required String label,
    required VoidCallback onTap,
  }) {
    return _TappableLabel(
      value: value,
      inner: inner,
      painter: TextPainter(
        text: TextSpan(style: textStyle, text: label),
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 2),
      )..layout(),
      onTap: onTap,
    );
  }

  List<_TappableLabel> _build24HourRing({
    required TextStyle? textStyle,
    required int selectedValue,
  }) {
    return <_TappableLabel>[
      if (themeData.useMaterial3)
        for (final TimeOfDay timeOfDay in _twentyFourHours)
          _buildTappableLabel(
            textStyle: textStyle,
            selectedValue: selectedValue,
            inner: timeOfDay.hour >= 12,
            value: timeOfDay.hour,
            label:
                // The M3 specs for 24-hour ring show 0 hour as 00, but for 1-9,
                // the specs show single digit.
                timeOfDay.hour != 0
                    ? localizations.formatDecimal(timeOfDay.hour)
                    : localizations.formatHour(
                      timeOfDay,
                      alwaysUse24HourFormat: true,
                    ),
            onTap: () {
              _selectHour(timeOfDay.hour);
            },
          ),
      if (!themeData.useMaterial3)
        for (final TimeOfDay timeOfDay in _twentyFourHoursM2)
          _buildTappableLabel(
            textStyle: textStyle,
            selectedValue: selectedValue,
            inner: false,
            value: timeOfDay.hour,
            label: localizations.formatHour(
              timeOfDay,
              alwaysUse24HourFormat: true,
            ),
            onTap: () {
              _selectHour(timeOfDay.hour);
            },
          ),
    ];
  }

  List<_TappableLabel> _build12HourRing({
    required TextStyle? textStyle,
    required int selectedValue,
  }) {
    return <_TappableLabel>[
      for (final TimeOfDay timeOfDay in _amHours)
        _buildTappableLabel(
          textStyle: textStyle,
          selectedValue: selectedValue,
          inner: false,
          value: timeOfDay.hour,
          label: localizations.formatHour(
            timeOfDay,
            alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
          ),
          onTap: () {
            _selectHour(timeOfDay.hour);
          },
        ),
    ];
  }

  List<_TappableLabel> _buildMinutes({
    required TextStyle? textStyle,
    required int selectedValue,
  }) {
    const List<TimeOfDay> minuteMarkerValues = <TimeOfDay>[
      TimeOfDay(hour: 0, minute: 0),
      TimeOfDay(hour: 0, minute: 5),
      TimeOfDay(hour: 0, minute: 10),
      TimeOfDay(hour: 0, minute: 15),
      TimeOfDay(hour: 0, minute: 20),
      TimeOfDay(hour: 0, minute: 25),
      TimeOfDay(hour: 0, minute: 30),
      TimeOfDay(hour: 0, minute: 35),
      TimeOfDay(hour: 0, minute: 40),
      TimeOfDay(hour: 0, minute: 45),
      TimeOfDay(hour: 0, minute: 50),
      TimeOfDay(hour: 0, minute: 55),
    ];

    return <_TappableLabel>[
      for (final TimeOfDay timeOfDay in minuteMarkerValues)
        _buildTappableLabel(
          textStyle: textStyle,
          selectedValue: selectedValue,
          inner: false,
          value: timeOfDay.minute,
          label: localizations.formatMinute(timeOfDay),
          onTap: () {
            _selectMinute(timeOfDay.minute);
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(context);
    final Color backgroundColor =
        timePickerTheme.dialBackgroundColor ?? defaultTheme.dialBackgroundColor;
    final Color dialHandColor =
        timePickerTheme.dialHandColor ?? defaultTheme.dialHandColor;
    final TextStyle labelStyle =
        timePickerTheme.dialTextStyle ?? defaultTheme.dialTextStyle;
    final Color dialTextUnselectedColor = WidgetStateProperty.resolveAs<Color>(
      timePickerTheme.dialTextColor ?? defaultTheme.dialTextColor,
      <WidgetState>{},
    );
    final Color dialTextSelectedColor = WidgetStateProperty.resolveAs<Color>(
      timePickerTheme.dialTextColor ?? defaultTheme.dialTextColor,
      <WidgetState>{WidgetState.selected},
    );
    final TextStyle resolvedUnselectedLabelStyle = labelStyle.copyWith(
      color: dialTextUnselectedColor,
    );
    final TextStyle resolvedSelectedLabelStyle = labelStyle.copyWith(
      color: dialTextSelectedColor,
    );
    final Color dotColor = dialTextSelectedColor;

    List<_TappableLabel> primaryLabels;
    List<_TappableLabel> selectedLabels;
    final int selectedDialValue;
    final double radiusValue;
    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        switch (widget.hourDialType) {
          case _HourDialType.twentyFourHour:
          case _HourDialType.twentyFourHourDoubleRing:
            selectedDialValue = widget.selectedTime.hour;
            primaryLabels = _build24HourRing(
              textStyle: resolvedUnselectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            selectedLabels = _build24HourRing(
              textStyle: resolvedSelectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            radiusValue = theme.useMaterial3 ? _radius.value : 1;
          case _HourDialType.twelveHour:
            selectedDialValue = widget.selectedTime.hourOfPeriod;
            primaryLabels = _build12HourRing(
              textStyle: resolvedUnselectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            selectedLabels = _build12HourRing(
              textStyle: resolvedSelectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            radiusValue = 1;
        }
      case _HourMinuteMode.minute:
        selectedDialValue = widget.selectedTime.minute;
        primaryLabels = _buildMinutes(
          textStyle: resolvedUnselectedLabelStyle,
          selectedValue: selectedDialValue,
        );
        selectedLabels = _buildMinutes(
          textStyle: resolvedSelectedLabelStyle,
          selectedValue: selectedDialValue,
        );
        radiusValue = 1;
    }
    painter?.dispose();
    painter = _DialPainter(
      selectedValue: selectedDialValue,
      primaryLabels: primaryLabels,
      selectedLabels: selectedLabels,
      backgroundColor: backgroundColor,
      handColor: dialHandColor,
      handWidth: defaultTheme.handWidth,
      dotColor: dotColor,
      dotRadius: defaultTheme.dotRadius,
      centerRadius: defaultTheme.centerRadius,
      theta: _theta.value,
      radius: radiusValue,
      textDirection: Directionality.of(context),
    );

    return GestureDetector(
      excludeFromSemantics: true,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onTapUp: _handleTapUp,
      child: CustomPaint(painter: painter),
    );
  }
}

/// A Material Design time picker designed to appear inside a popup dialog.
///
/// Pass this widget to [showDialog]. The value returned by [showDialog] is the
/// selected [TimeOfDay] if the user taps the "OK" button, or null if the user
/// taps the "CANCEL" button. The selected time is reported by calling
/// [Navigator.pop].
///
/// Use [showTimePicker] to show a dialog already containing a [MyTimePickerDialog].
class MyTimePickerDialog extends StatefulWidget {
  /// Creates a Material Design time picker.
  const MyTimePickerDialog({
    required this.initialTime,
    super.key,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.restorationId,
  });

  /// The time initially selected when the dialog is shown.
  final TimeOfDay initialTime;

  /// Optionally provide your own text for the cancel button.
  ///
  /// If null, the button uses [MaterialLocalizations.cancelButtonLabel].
  final String? cancelText;

  /// Optionally provide your own text for the confirm button.
  ///
  /// If null, the button uses [MaterialLocalizations.okButtonLabel].
  final String? confirmText;

  /// Optionally provide your own help text to the header of the time picker.
  final String? helpText;

  /// Optionally provide your own validation error text.
  final String? errorInvalidText;

  /// Optionally provide your own hour label text.
  final String? hourLabelText;

  /// Optionally provide your own minute label text.
  final String? minuteLabelText;

  /// Restoration ID to save and restore the state of the [MyTimePickerDialog].
  ///
  /// If it is non-null, the time picker will persist and restore the
  /// dialog's state.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  @override
  State<MyTimePickerDialog> createState() => _MyTimePickerDialogState();
}

class _MyTimePickerDialogState extends State<MyTimePickerDialog>
    with RestorationMixin {
  late final RestorableTimeOfDay _selectedTime = RestorableTimeOfDay(
    widget.initialTime,
  );
  final RestorableEnum<AutovalidateMode> _autovalidateMode =
      RestorableEnum<AutovalidateMode>(
        AutovalidateMode.disabled,
        values: AutovalidateMode.values,
      );

  @override
  void dispose() {
    _selectedTime.dispose();
    _autovalidateMode.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(_autovalidateMode, 'autovalidate_mode');
  }

  void _handleTimeChanged(TimeOfDay value) {
    if (value != _selectedTime.value) {
      setState(() {
        _selectedTime.value = value;
      });
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    Navigator.pop(context, _selectedTime.value);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), '');

    final left = MyDialogButtonOptions(
      title: 'Cancel',
      type: MyButtonType.outline,
      action: _handleCancel,
    );

    final right = MyDialogButtonOptions(
      title: 'OK',
      titleColor: context.colorScheme.primaryForeground,
      action: _handleOk,
    );

    return MyDialogScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _TimePicker(
            time: widget.initialTime,
            onTimeChanged: _handleTimeChanged,
            helpText: widget.helpText,
            cancelText: widget.cancelText,
            confirmText: widget.confirmText,
            restorationId: 'time_picker',
          ),
          const Gap(24),
          MyDialogShrinkButtons(leftBtn: left, rightBtn: right),
        ],
      ),
    );
  }
}

// The _TimePicker widget is constructed so that in the future we could expose
// this as a public API for embedding time pickers into other non-dialog
// widgets, once we're sure we want to support that.

/// A Time Picker widget that can be embedded into another widget.
class _TimePicker extends StatefulWidget {
  /// Creates a const Material Design time picker.
  const _TimePicker({
    required this.time,
    required this.onTimeChanged,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.restorationId,
  });

  final String? helpText;

  /// Optionally provide your own text for the cancel button.
  ///
  /// If null, the button uses [MaterialLocalizations.cancelButtonLabel].
  final String? cancelText;

  /// Optionally provide your own text for the confirm button.
  ///
  /// If null, the button uses [MaterialLocalizations.okButtonLabel].
  final String? confirmText;

  /// Restoration ID to save and restore the state of the [MyTimePickerDialog].
  ///
  /// If it is non-null, the time picker will persist and restore the
  /// dialog's state.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  /// The currently selected time of day.
  final TimeOfDay time;

  final ValueChanged<TimeOfDay>? onTimeChanged;

  @override
  State<_TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> with RestorationMixin {
  Timer? _vibrateTimer;
  late MaterialLocalizations localizations;
  final RestorableEnum<_HourMinuteMode> _hourMinuteMode =
      RestorableEnum<_HourMinuteMode>(
        _HourMinuteMode.hour,
        values: _HourMinuteMode.values,
      );
  final RestorableEnumN<_HourMinuteMode> _lastModeAnnounced =
      RestorableEnumN<_HourMinuteMode>(null, values: _HourMinuteMode.values);
  final RestorableBoolN _autofocusHour = RestorableBoolN(null);
  final RestorableBoolN _autofocusMinute = RestorableBoolN(null);

  RestorableTimeOfDay get selectedTime => _selectedTime;
  late final RestorableTimeOfDay _selectedTime = RestorableTimeOfDay(
    widget.time,
  );

  @override
  void dispose() {
    _vibrateTimer?.cancel();
    _vibrateTimer = null;
    _selectedTime.dispose();
    _hourMinuteMode.dispose();
    _lastModeAnnounced.dispose();
    _autofocusHour.dispose();
    _autofocusMinute.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
  }

  @override
  void didUpdateWidget(_TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.time != widget.time) {
      _selectedTime.value = widget.time;
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_hourMinuteMode, 'hour_minute_mode');
    registerForRestoration(_lastModeAnnounced, 'last_mode_announced');
    registerForRestoration(_autofocusHour, 'autofocus_hour');
    registerForRestoration(_autofocusMinute, 'autofocus_minute');
    registerForRestoration(_selectedTime, 'selected_time');
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _vibrateTimer?.cancel();
        _vibrateTimer = Timer(_kVibrateCommitDelay, () {
          unawaited(HapticFeedback.vibrate());
          _vibrateTimer = null;
        });
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleHourMinuteModeChanged(_HourMinuteMode mode) {
    _vibrate();
    setState(() {
      _hourMinuteMode.value = mode;
    });
  }

  void _handleTimeChanged(TimeOfDay value) {
    _vibrate();
    setState(() {
      _selectedTime.value = value;
      widget.onTimeChanged?.call(value);
    });
  }

  void _handleHourSelected() {
    setState(() {
      _hourMinuteMode.value = _HourMinuteMode.minute;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), '');
    final TimeOfDayFormat timeOfDayFormat = localizations.timeOfDayFormat(
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    final ThemeData theme = Theme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(context);
    final HourFormat timeOfDayHour = hourFormat(of: timeOfDayFormat);
    final _HourDialType hourMode = switch (timeOfDayHour) {
      HourFormat.HH || HourFormat.H when theme.useMaterial3 =>
        _HourDialType.twentyFourHourDoubleRing,
      HourFormat.HH || HourFormat.H => _HourDialType.twentyFourHour,
      HourFormat.h => _HourDialType.twelveHour,
    };

    final String helpText;
    final Widget picker;

    helpText =
        widget.helpText ??
        (theme.useMaterial3
            ? localizations.timePickerDialHelpText
            : localizations.timePickerDialHelpText.toUpperCase());

    final EdgeInsetsGeometry dialPadding = const EdgeInsets.only(
      left: 12,
      right: 12,
      top: 24,
    );

    final Widget dial = Padding(
      padding: dialPadding,
      child: Semantics(
        label: switch (_hourMinuteMode.value) {
          _HourMinuteMode.hour => localizations.timePickerHourModeAnnouncement,
          _HourMinuteMode.minute =>
            localizations.timePickerMinuteModeAnnouncement,
        },
        liveRegion: true,
        child: ExcludeSemantics(
          child: SizedBox.fromSize(
            size: defaultTheme.dialSize,
            child: AspectRatio(
              aspectRatio: 1,
              child: _Dial(
                hourMinuteMode: _hourMinuteMode.value,
                hourDialType: hourMode,
                selectedTime: _selectedTime.value,
                onChanged: _handleTimeChanged,
                onHourSelected: _handleHourSelected,
              ),
            ),
          ),
        ),
      ),
    );

    picker = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TimePickerHeader(helpText: helpText),
        ),
        dial,
      ],
    );

    return _TimePickerModel(
      selectedTime: _selectedTime.value,
      hourMinuteMode: _hourMinuteMode.value,
      onHourMinuteModeChanged: _handleHourMinuteModeChanged,
      hourDialType: hourMode,
      onSelectedTimeChanged: _handleTimeChanged,
      use24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      theme: TimePickerTheme.of(context),
      defaultTheme: defaultTheme,
      child: picker,
    );
  }
}

// An abstract base class for the M2 and M3 defaults below, so that their return
// types can be non-nullable.
abstract class _TimePickerDefaults extends TimePickerThemeData {
  @override
  Color get backgroundColor;

  @override
  ButtonStyle get cancelButtonStyle;

  @override
  ButtonStyle get confirmButtonStyle;

  @override
  BorderSide get dayPeriodBorderSide;

  @override
  Color get dayPeriodColor;

  @override
  OutlinedBorder get dayPeriodShape;

  Size get dayPeriodInputSize;
  Size get dayPeriodLandscapeSize;
  Size get dayPeriodPortraitSize;

  @override
  Color get dayPeriodTextColor;

  @override
  TextStyle get dayPeriodTextStyle;

  @override
  Color get dialBackgroundColor;

  @override
  Color get dialHandColor;

  // Sizes that are generated from the tokens, but these aren't ones we're ready
  // to expose in the theme.
  Size get dialSize;
  double get handWidth;
  double get dotRadius;
  double get centerRadius;

  @override
  Color get dialTextColor;

  @override
  TextStyle get dialTextStyle;

  @override
  double get elevation;

  @override
  TextStyle get helpTextStyle;

  @override
  Color get hourMinuteColor;

  @override
  ShapeBorder get hourMinuteShape;

  Size get hourMinuteSize;
  Size get hourMinuteSize24Hour;
  Size get hourMinuteInputSize;
  Size get hourMinuteInputSize24Hour;

  @override
  Color get hourMinuteTextColor;

  @override
  TextStyle get hourMinuteTextStyle;

  @override
  InputDecorationThemeData get inputDecorationTheme;

  @override
  EdgeInsetsGeometry get padding;

  @override
  ShapeBorder get shape;
}

class _TimePickerDefaultsM3 extends _TimePickerDefaults {
  _TimePickerDefaultsM3(this.context);

  final BuildContext context;

  late final MyColorScheme _colors = context.colorScheme;
  late final MyTypography _textTheme = context.textTheme;

  @override
  Color get backgroundColor {
    return _colors.secondary;
  }

  @override
  ButtonStyle get cancelButtonStyle {
    return TextButton.styleFrom();
  }

  @override
  ButtonStyle get confirmButtonStyle {
    return TextButton.styleFrom();
  }

  @override
  BorderSide get dayPeriodBorderSide {
    return BorderSide(color: _colors.border);
  }

  @override
  Color get dayPeriodColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.foreground;
      }
      // The unselected day period should match the overall picker dialog color.
      // Making it transparent enables that without being redundant and allows
      // the optional elevation overlay for dark mode to be visible.
      return Colors.transparent;
    });
  }

  @override
  OutlinedBorder get dayPeriodShape {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ).copyWith(side: dayPeriodBorderSide);
  }

  @override
  Size get dayPeriodPortraitSize {
    return const Size(52, 80);
  }

  @override
  Size get dayPeriodLandscapeSize {
    return const Size(216, 38);
  }

  @override
  Size get dayPeriodInputSize {
    // Input size is eight pixels smaller than the portrait size in the spec,
    // but there's not token for it yet.
    return Size(dayPeriodPortraitSize.width, dayPeriodPortraitSize.height - 8);
  }

  @override
  Color get dayPeriodTextColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.focused)) {
          return _colors.onTertiaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onTertiaryContainer;
        }
        if (states.contains(WidgetState.pressed)) {
          return _colors.onTertiaryContainer;
        }
        return _colors.onTertiaryContainer;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurfaceVariant;
      }
      return _colors.onSurfaceVariant;
    });
  }

  @override
  TextStyle get dayPeriodTextStyle {
    return _textTheme.titleMedium!.copyWith(color: dayPeriodTextColor);
  }

  @override
  Color get dialBackgroundColor {
    return _colors.surfaceContainerHighest;
  }

  @override
  Color get dialHandColor {
    return _colors.primary;
  }

  @override
  Size get dialSize {
    return const Size.square(256);
  }

  @override
  double get handWidth {
    return const Size(2, double.infinity).width;
  }

  @override
  double get dotRadius {
    return const Size.square(48).width / 2;
  }

  @override
  double get centerRadius {
    return const Size.square(8).width / 2;
  }

  @override
  Color get dialTextColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.onPrimary;
      }
      return _colors.onSurface;
    });
  }

  @override
  TextStyle get dialTextStyle {
    return _textTheme.bodyLarge!;
  }

  @override
  double get elevation {
    return 6;
  }

  @override
  TextStyle get helpTextStyle {
    return WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
      final TextStyle textStyle = _textTheme.labelMedium!;
      return textStyle.copyWith(color: _colors.onSurfaceVariant);
    });
  }

  @override
  EdgeInsetsGeometry get padding {
    return const EdgeInsets.all(24);
  }

  @override
  Color get hourMinuteColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        Color overlayColor = _colors.primaryContainer;
        if (states.contains(WidgetState.pressed)) {
          overlayColor = _colors.onPrimaryContainer;
        } else if (states.contains(WidgetState.hovered)) {
          const double hoverOpacity = 0.08;
          overlayColor = _colors.onPrimaryContainer.withValues(
            alpha: hoverOpacity,
          );
        } else if (states.contains(WidgetState.focused)) {
          const double focusOpacity = 0.1;
          overlayColor = _colors.onPrimaryContainer.withValues(
            alpha: focusOpacity,
          );
        }
        return Color.alphaBlend(overlayColor, _colors.primaryContainer);
      } else {
        Color overlayColor = _colors.surfaceContainerHighest;
        if (states.contains(WidgetState.pressed)) {
          overlayColor = _colors.onSurface;
        } else if (states.contains(WidgetState.hovered)) {
          const double hoverOpacity = 0.08;
          overlayColor = _colors.onSurface.withValues(alpha: hoverOpacity);
        } else if (states.contains(WidgetState.focused)) {
          const double focusOpacity = 0.1;
          overlayColor = _colors.onSurface.withValues(alpha: focusOpacity);
        }
        return Color.alphaBlend(overlayColor, _colors.surfaceContainerHighest);
      }
    });
  }

  @override
  ShapeBorder get hourMinuteShape {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  @override
  Size get hourMinuteSize {
    return const Size(96, 80);
  }

  @override
  Size get hourMinuteSize24Hour {
    return Size(const Size(114, double.infinity).width, hourMinuteSize.height);
  }

  @override
  Size get hourMinuteInputSize {
    // Input size is eight pixels smaller than the regular size in the spec, but
    // there's not token for it yet.
    return Size(hourMinuteSize.width, hourMinuteSize.height - 8);
  }

  @override
  Size get hourMinuteInputSize24Hour {
    // Input size is eight pixels smaller than the regular size in the spec, but
    // there's not token for it yet.
    return Size(hourMinuteSize24Hour.width, hourMinuteSize24Hour.height - 8);
  }

  @override
  Color get hourMinuteTextColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      return _hourMinuteTextColor.resolve(states);
    });
  }

  WidgetStateProperty<Color> get _hourMinuteTextColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onPrimaryContainer;
        }
        return _colors.onPrimaryContainer;
      } else {
        // unselected
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurface;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurface;
        }
        return _colors.onSurface;
      }
    });
  }

  @override
  TextStyle get hourMinuteTextStyle {
    return WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
      // TODO(tahatesser): Update this when https://github.com/flutter/flutter/issues/131247 is fixed.
      // This is using the correct text style from Material 3 spec.
      // https://m3.material.io/components/time-pickers/specs#fd0b6939-edab-4058-82e1-93d163945215
      return _textTheme.displayLarge!.copyWith(
        color: _hourMinuteTextColor.resolve(states),
      );
    });
  }

  @override
  InputDecorationThemeData get inputDecorationTheme {
    // This is NOT correct, but there's no token for
    // 'time-input.container.shape', so this is using the radius from the shape
    // for the hour/minute selector. It's a BorderRadiusGeometry, so we have to
    // resolve it before we can use it.
    final BorderRadius selectorRadius = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ).borderRadius.resolve(Directionality.of(context));
    return InputDecorationThemeData(
      contentPadding: EdgeInsets.zero,
      filled: true,
      // This should be derived from a token, but there isn't one for 'time-input'.
      fillColor: hourMinuteColor,
      // This should be derived from a token, but there isn't one for 'time-input'.
      focusColor: _colors.primaryContainer,
      enabledBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: BorderSide(color: _colors.error, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: BorderSide(color: _colors.primary, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: BorderSide(color: _colors.error, width: 2),
      ),
      hintStyle: hourMinuteTextStyle.copyWith(
        color: _colors.onSurface.withValues(alpha: 0.36),
      ),
      // Prevent the error text from appearing.
      // TODO(rami-a): Remove this workaround once
      // https://github.com/flutter/flutter/issues/54104
      // is fixed.
      errorStyle: const TextStyle(fontSize: 0),
    );
  }

  @override
  ShapeBorder get shape {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28)),
    );
  }

  @override
  WidgetStateProperty<Color?>? get timeSelectorSeparatorColor {
    // TODO(tahatesser): Update this when tokens are available.
    // This is taken from https://m3.material.io/components/time-pickers/specs.
    return WidgetStatePropertyAll<Color>(_colors.onSurface);
  }

  @override
  WidgetStateProperty<TextStyle?>? get timeSelectorSeparatorTextStyle {
    // TODO(tahatesser): Update this when tokens are available.
    // This is taken from https://m3.material.io/components/time-pickers/specs.
    return WidgetStatePropertyAll<TextStyle?>(_textTheme.displayLarge);
  }
}
