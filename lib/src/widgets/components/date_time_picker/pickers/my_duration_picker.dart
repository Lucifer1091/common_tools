import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../extensions/context/theme.dart';
import '../../../../extensions/context/typography.dart';
import '../../../../extensions/widget.dart';
import '../../../../themes/my_typography.dart';
import '../../../packages/gap/src/widgets/gap.dart';
import '../../button/my_button.dart';
import '../../dialog/my_dialog_config.dart';
import '../../dialog/my_dialog_widget.dart';

const _kDialAnimateDuration = Duration(milliseconds: 200);

const _kTwoPi = 2 * math.pi; // 360 degrees in radians
const _kPiByTwo = math.pi / 2; // 90 degrees in radians

const _kCircleTop = _kPiByTwo;

/// Units for the DurationPicker.
enum BaseUnit { millisecond, second, minute, hour }

/// --- Painter ---

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.context,
    required this.labels,
    required this.backgroundColor,
    required this.innerCircleColor,
    required this.accentColor,
    required this.theta,
    required this.textDirection,
    required this.selectedValue,
    required this.baseUnitMultiplier,
    required this.baseUnitHand,
    required this.baseUnit,
  });

  final List<TextPainter> labels;
  final Color backgroundColor, innerCircleColor;
  final Color accentColor;
  final double theta;
  final TextDirection textDirection;
  final int? selectedValue;
  final BuildContext context;

  /// e.g. hours if baseUnit == minute, days if baseUnit == hour, etc.
  final int baseUnitMultiplier;

  /// e.g. minutes 0..59 if baseUnit == minute (the hand within current revolution)
  final int baseUnitHand;

  final BaseUnit baseUnit;

  @override
  void paint(Canvas canvas, Size size) {
    const epsilon = .001;
    const sweep = _kTwoPi - epsilon;
    const startAngle = -math.pi / 2.0;

    final radius = size.shortestSide / 2.0;
    final center = Offset(size.width / 2.0, size.height / 2.0);

    final pctTheta = (0.25 - (theta % _kTwoPi) / _kTwoPi) % 1.0;

    // Outer ring
    canvas.drawCircle(center, radius, Paint()..color = backgroundColor);

    // Secondary unit translucent rings
    for (var i = 0; i < baseUnitMultiplier; i++) {
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = accentColor.withValues(alpha: i == 0 ? 0.30 : 0.10),
      );
    }

    // Inner disc
    canvas.drawCircle(center, radius * 0.88, Paint()..color = innerCircleColor);

    Offset offsetFor(double t, double r) =>
        center + Offset(r * math.cos(t), -r * math.sin(t));

    // Handle
    canvas.drawCircle(
      offsetFor(theta, radius - 6.5),
      16,
      Paint()..color = accentColor,
    );

    // Unit labels shown in the center
    String baseUnitLabel() {
      switch (baseUnit) {
        case BaseUnit.millisecond:
          return 'ms.';
        case BaseUnit.second:
          return 'sec.';
        case BaseUnit.minute:
          return 'min.';
        case BaseUnit.hour:
          return 'hr.';
      }
    }

    String secondaryUnitLabel() {
      switch (baseUnit) {
        case BaseUnit.millisecond:
          return 's';
        case BaseUnit.second:
          return 'm';
        case BaseUnit.minute:
          return 'h';
        case BaseUnit.hour:
          return 'd';
      }
    }

    final secondaryUnitsText = (baseUnitMultiplier == 0)
        ? ''
        : '$baseUnitMultiplier${secondaryUnitLabel()} ';

    final baseUnitsText = '$baseUnitHand';

    final centerValue = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '$secondaryUnitsText$baseUnitsText',
        style: context.textTheme.displayMedium.copyWith(
          fontSize: size.shortestSide * 0.15,
          color: context.colorScheme.foreground,
        ),
      ),
    )..layout();

    centerValue.paint(
      canvas,
      Offset(
        center.dx - centerValue.width / 2,
        -2.5 + center.dy - centerValue.height / 2,
      ),
    );

    final baseUnitPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: baseUnitLabel(),
        style: context.textTheme.bodyMedium.copyWith(
          color: context.colorScheme.foreground,
        ),
      ),
    )..layout();

    baseUnitPainter.paint(
      canvas,
      Offset(
        center.dx - baseUnitPainter.width / 2,
        2.5 + center.dy + (centerValue.height / 2) - baseUnitPainter.height / 2,
      ),
    );

    // Elapsed arc
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = accentColor.withValues(alpha: 0.3)
      ..isAntiAlias = true
      ..strokeWidth = radius * 0.12;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - radius * 0.12 / 2),
      startAngle,
      sweep * pctTheta,
      false,
      arc,
    );

    // Tick labels
    if (labels.isNotEmpty) {
      final step = -_kTwoPi / labels.length;
      var labelTheta = _kPiByTwo;
      for (final label in labels) {
        final o = Offset(-label.width / 2, -label.height / 2);
        label.paint(canvas, offsetFor(labelTheta, radius - 40.0) + o);
        labelTheta += step;
      }
    }
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.labels != labels ||
      old.backgroundColor != backgroundColor ||
      old.innerCircleColor != innerCircleColor ||
      old.accentColor != accentColor ||
      old.theta != theta;
}

/// --- Dial logic ---

class _Dial extends StatefulWidget {
  const _Dial({
    required this.duration,
    required this.onChanged,
    this.baseUnit = BaseUnit.minute,
    this.upperBound,
    this.lowerBound,
    this.snapTo, // generic snapping step in the selected base unit
  });

  final Duration duration;
  final ValueChanged<Duration> onChanged;
  final BaseUnit baseUnit;
  final Duration? upperBound;
  final Duration? lowerBound;

  /// Generic snapping step in the selected base unit.
  /// Example:
  /// - baseUnit: minute, snapTo: 5 => snap to 5 minutes
  /// - baseUnit: second, snapTo: 10 => snap to 10 seconds
  /// - baseUnit: hour,   snapTo: 2 => snap to 2 hours
  /// - baseUnit: millisecond, snapTo: 50 => snap to 50 ms
  final int? snapTo;

  @override
  State<_Dial> createState() => _DialState();
}

class _DialState extends State<_Dial> with SingleTickerProviderStateMixin {
  late final AnimationController _thetaController;
  late final Tween<double> _thetaTween;
  late Animation<double> _theta;

  // Cumulative angle (math coordinates). Can exceed a single turn.
  double _turningAngle = 0;

  // Cached values for center text
  int _secondaryUnitValue = 0;
  int _baseUnitValue = 0;

  Offset? _position, _center;
  bool _dragging = false;

  late final double? _upperBoundAngle;
  late final double? _lowerBoundAngle;

  @override
  void initState() {
    super.initState();
    _thetaController = AnimationController(
      vsync: this,
      duration: _kDialAnimateDuration,
    );
    _thetaTween = Tween<double>(
      begin: _getThetaForDuration(widget.duration, widget.baseUnit),
      end: 0,
    );
    _theta = _thetaTween.animate(
      CurvedAnimation(parent: _thetaController, curve: Curves.fastOutSlowIn),
    )..addListener(() => setState(() {}));

    _thetaController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _secondaryUnitValue = _secondaryUnitHand();
        _baseUnitValue = _baseUnitHand();
        setState(() {});
      }
    });

    _turningAngle = _kPiByTwo - _turningAngleFactor(null) * _kTwoPi;
    _secondaryUnitValue = _secondaryUnitHand();
    _baseUnitValue = _baseUnitHand();

    _upperBoundAngle = widget.upperBound != null
        ? _kPiByTwo - _turningAngleFactor(widget.upperBound) * _kTwoPi
        : null;
    _lowerBoundAngle = widget.lowerBound != null
        ? _kPiByTwo - _turningAngleFactor(widget.lowerBound) * _kTwoPi
        : null;
  }

  @override
  void dispose() {
    _thetaController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _Dial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.baseUnit != widget.baseUnit) {
      _animateTo(_getThetaForDuration(widget.duration, widget.baseUnit));
      _secondaryUnitValue = _secondaryUnitHand();
      _baseUnitValue = _baseUnitHand();
    }
  }

  // ===== Helpers: unit math =====

  int _inBaseUnits(Duration d, BaseUnit u) {
    switch (u) {
      case BaseUnit.millisecond:
        return d.inMilliseconds;
      case BaseUnit.second:
        return d.inSeconds;
      case BaseUnit.minute:
        return d.inMinutes;
      case BaseUnit.hour:
        return d.inHours;
    }
  }

  int _inSecondaryUnits(Duration d, BaseUnit u) {
    switch (u) {
      case BaseUnit.millisecond:
        return d.inSeconds;
      case BaseUnit.second:
        return d.inMinutes;
      case BaseUnit.minute:
        return d.inHours;
      case BaseUnit.hour:
        return d.inDays;
    }
  }

  int _baseToSecondaryFactor(BaseUnit u) {
    switch (u) {
      case BaseUnit.millisecond:
        return Duration.millisecondsPerSecond; // 1000
      case BaseUnit.second:
        return Duration.secondsPerMinute; // 60
      case BaseUnit.minute:
        return Duration.minutesPerHour; // 60
      case BaseUnit.hour:
        return Duration.hoursPerDay; // 24
    }
  }

  // Generic snapping in the selected base unit (applies across all revolutions).
  double _applySnapping(double baseUnitValue) {
    final step = widget.snapTo;
    if (step == null || step <= 1) return baseUnitValue;

    final factor = _baseToSecondaryFactor(widget.baseUnit);
    // clamp within a sensible range per revolution but applied cumulatively
    final clampedStep = step.clamp(1, factor);
    final s = clampedStep.toDouble();
    return (baseUnitValue / s).round() * s;
  }

  double _getThetaForDuration(Duration d, BaseUnit u) {
    final baseUnits = _inBaseUnits(d, u);
    final factor = _baseToSecondaryFactor(u);
    return (_kPiByTwo - (baseUnits % factor) / factor.toDouble() * _kTwoPi) %
        _kTwoPi;
  }

  double _turningAngleFactor(Duration? d) =>
      _inBaseUnits(d ?? widget.duration, widget.baseUnit) /
      _baseToSecondaryFactor(widget.baseUnit);

  // Convert angle -> base-unit count (cumulative)
  double _angleToBaseUnit(double angle) {
    final dialAngle = _kPiByTwo - angle; // convert to dial coords
    return dialAngle / _kTwoPi * _baseToSecondaryFactor(widget.baseUnit);
  }

  Duration _baseUnitToDuration(double baseUnitValue) {
    final factor = _baseToSecondaryFactor(widget.baseUnit);
    final major = baseUnitValue ~/ factor; // secondary units
    final minor = (baseUnitValue % factor.toDouble()).toInt();

    switch (widget.baseUnit) {
      case BaseUnit.millisecond:
        return Duration(seconds: major, milliseconds: minor);
      case BaseUnit.second:
        return Duration(minutes: major, seconds: minor);
      case BaseUnit.minute:
        return Duration(hours: major, minutes: minor);
      case BaseUnit.hour:
        return Duration(days: major, hours: minor);
    }
  }

  Duration _angleToDuration(double angle) {
    final raw = _angleToBaseUnit(angle);
    final snapped = _applySnapping(raw);
    return _baseUnitToDuration(snapped);
  }

  int _secondaryUnitHand() =>
      _inSecondaryUnits(widget.duration, widget.baseUnit);
  int _baseUnitHand() =>
      _inBaseUnits(widget.duration, widget.baseUnit) %
      _baseToSecondaryFactor(widget.baseUnit);

  // ===== Gestures & animation =====

  static double _nearest(double target, double a, double b) =>
      ((target - a).abs() < (target - b).abs()) ? a : b;

  void _animateTo(double targetTheta) {
    final current = _theta.value;
    var begin = _nearest(targetTheta, current, current + _kTwoPi);
    begin = _nearest(targetTheta, begin, current - _kTwoPi);
    _thetaTween
      ..begin = begin
      ..end = targetTheta;
    _thetaController.value = 0.0;
    unawaited(_thetaController.forward());
  }

  void _updateThetaForPan() {
    setState(() {
      final offset = _position! - _center!;
      final angle = (math.atan2(offset.dx, offset.dy) - _kPiByTwo) % _kTwoPi;

      // Prevent accidental jump at 12 o’clock when starting from 0.
      if (angle >= _kCircleTop &&
          _theta.value <= _kCircleTop &&
          _theta.value >= 0.1 &&
          _inSecondaryUnits(widget.duration, widget.baseUnit) == 0) {
        return;
      }
      _thetaTween
        ..begin = angle
        ..end = angle; // set theta to this angle
    });
  }

  void _updateTurningAngle(double oldTheta, double newTheta) {
    // Continuity across wrap
    if (newTheta > 1.5 * math.pi && oldTheta < 0.5 * math.pi) {
      _turningAngle -= (_kTwoPi - newTheta) + oldTheta;
    } else if (newTheta < 0.5 * math.pi && oldTheta > 1.5 * math.pi) {
      _turningAngle += (_kTwoPi - oldTheta) + newTheta;
    } else {
      _turningAngle += newTheta - oldTheta;
    }

    // Enforce optional bounds (in angle space; keeps behavior consistent with original)
    if (_upperBoundAngle != null && _turningAngle < _upperBoundAngle) {
      _turningAngle = _upperBoundAngle;
    } else if (_lowerBoundAngle != null && _turningAngle > _lowerBoundAngle) {
      _turningAngle = _lowerBoundAngle;
    }
  }

  Duration _notifyOnChangedIfNeeded() {
    // Use snapped duration so UI text equals callback
    final snapped = _angleToDuration(_turningAngle);
    _secondaryUnitValue = _inSecondaryUnits(snapped, widget.baseUnit);
    _baseUnitValue =
        _inBaseUnits(snapped, widget.baseUnit) %
        _baseToSecondaryFactor(widget.baseUnit);

    widget.onChanged(snapped);
    return snapped;
  }

  void _handlePanStart(DragStartDetails d) {
    assert(!_dragging, '');
    _dragging = true;
    final box = context.findRenderObject() as RenderBox?;
    _position = box?.globalToLocal(d.globalPosition);
    _center = box?.size.center(Offset.zero);
    _notifyOnChangedIfNeeded();
  }

  void _handlePanUpdate(DragUpdateDetails d) {
    final oldTheta = _theta.value;
    _position = _position! + d.delta;
    _updateThetaForPan();
    final newTheta = _theta.value;

    _updateTurningAngle(oldTheta, newTheta);
    _notifyOnChangedIfNeeded();
  }

  void _handlePanEnd(DragEndDetails _) {
    assert(_dragging, '');
    _dragging = false;
    _position = null;
    _center = null;

    // Animate hand to the snapped theta for the current snapped duration
    final snapped = _angleToDuration(_turningAngle);
    _animateTo(_getThetaForDuration(snapped, widget.baseUnit));
  }

  void _handleTapUp(TapUpDetails d) {
    final box = context.findRenderObject() as RenderBox?;
    _position = box?.globalToLocal(d.globalPosition);
    _center = box?.size.center(Offset.zero);
    _updateThetaForPan();

    final snapped = _notifyOnChangedIfNeeded();
    _animateTo(_getThetaForDuration(snapped, widget.baseUnit));

    _dragging = false;
    _position = null;
    _center = null;
  }

  String _durationToBaseUnitString(Duration duration) {
    switch (widget.baseUnit) {
      case BaseUnit.millisecond:
        return duration.inMilliseconds.toString();
      case BaseUnit.second:
        return duration.inSeconds.toString();
      case BaseUnit.minute:
        return duration.inMinutes.toString();
      case BaseUnit.hour:
        return duration.inHours.toString();
    }
  }

  // pick tick interval; align with snapTo when it divides the per-revolution factor
  int _tickInterval(int defaultInterval) {
    final factor = _baseToSecondaryFactor(widget.baseUnit);
    final s = widget.snapTo;
    if (s != null && s > 1 && factor % s == 0) {
      return s;
    }
    return defaultInterval;
  }

  List<TextPainter> _buildBaseUnitLabels(MyTypography textTheme) {
    final style = textTheme.titleMedium.copyWith(
      color: context.colorScheme.foreground,
    );
    late final List<Duration> ticks;

    switch (widget.baseUnit) {
      case BaseUnit.millisecond:
        final intervalMs = _tickInterval(100);
        const factorMs = Duration.millisecondsPerSecond; // 1000
        ticks = List.generate(
          factorMs ~/ intervalMs,
          (i) => Duration(milliseconds: i * intervalMs),
        );
      case BaseUnit.second:
        final intervalS = _tickInterval(5);
        const factorS = Duration.secondsPerMinute; // 60
        ticks = List.generate(
          factorS ~/ intervalS,
          (i) => Duration(seconds: i * intervalS),
        );
      case BaseUnit.minute:
        final intervalM = _tickInterval(5);
        const factorM = Duration.minutesPerHour; // 60
        ticks = List.generate(
          factorM ~/ intervalM,
          (i) => Duration(minutes: i * intervalM),
        );
      case BaseUnit.hour:
        final intervalH = _tickInterval(3); // default 3h
        const factorH = Duration.hoursPerDay; // 24
        ticks = List.generate(
          factorH ~/ intervalH,
          (i) => Duration(hours: i * intervalH),
        );
    }

    return ticks
        .map(
          (d) => TextPainter(
            text: TextSpan(style: style, text: _durationToBaseUnitString(d)),
            textDirection: TextDirection.ltr,
          )..layout(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Draw from the currently snapped duration so painter shows the snapped value.
    final current = _angleToDuration(_turningAngle);
    _secondaryUnitValue = _inSecondaryUnits(current, widget.baseUnit);
    _baseUnitValue =
        _inBaseUnits(current, widget.baseUnit) %
        _baseToSecondaryFactor(widget.baseUnit);

    return GestureDetector(
      excludeFromSemantics: true,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onTapUp: _handleTapUp,
      child: CustomPaint(
        painter: _DialPainter(
          baseUnitMultiplier: _secondaryUnitValue,
          baseUnitHand: _baseUnitValue,
          baseUnit: widget.baseUnit,
          context: context,
          selectedValue: null,
          labels: _buildBaseUnitLabels(context.textTheme),
          backgroundColor: context.colorScheme.border,
          innerCircleColor: context.colorScheme.background,
          accentColor: context.colorScheme.primary,
          theta: _getThetaForDuration(current, widget.baseUnit),
          textDirection: Directionality.of(context),
        ),
      ),
    );
  }
}

class MyDurationPickerDialog extends StatefulWidget {
  const MyDurationPickerDialog({
    required this.initialTime,
    super.key,
    this.baseUnit = BaseUnit.minute,
    this.decoration,
    this.upperBound,
    this.lowerBound,
    this.snapTo,
  });

  final Duration initialTime;
  final BaseUnit baseUnit;
  final BoxDecoration? decoration;
  final Duration? upperBound;
  final Duration? lowerBound;

  /// Generic snapping step in selected base unit (see _Dial.snapTo).
  final int? snapTo;

  @override
  State<MyDurationPickerDialog> createState() => _MyDurationPickerDialogState();
}

class _MyDurationPickerDialogState extends State<MyDurationPickerDialog> {
  late Duration _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialTime;
  }

  void _handleTimeChanged(Duration value) {
    setState(() => _selectedDuration = value);
  }

  void _handleCancel() => Navigator.pop(context);
  void _handleOk() => Navigator.pop(context, _selectedDuration);

  @override
  Widget build(BuildContext context) {
    final picker = Padding(
      padding: const EdgeInsets.all(16).except(top: 24),
      child: AspectRatio(
        aspectRatio: 1,
        child: _Dial(
          duration: _selectedDuration,
          onChanged: _handleTimeChanged,
          baseUnit: widget.baseUnit,
          upperBound: widget.upperBound,
          lowerBound: widget.lowerBound,
          snapTo: widget.snapTo,
        ),
      ),
    );

    return MyDialogScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDialogInfoWidget(
            title: 'Select Duration',
            titleAlignment: Alignment.centerLeft,
            contentWidget: picker,
          ),
          const Gap(16),
          _horizontalButtons(context),
        ],
      ),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
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

    return MyDialogShrinkButtons(leftBtn: left, rightBtn: right);
  }
}
