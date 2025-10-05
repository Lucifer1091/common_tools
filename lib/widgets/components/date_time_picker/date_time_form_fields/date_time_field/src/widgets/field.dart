import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../index.dart';
import '../components/date_pickers.dart';
import '../constants.dart';

part 'form_field.dart';

const double _kDenseButtonHeight = 24;

typedef OnDateTimeSelect = void Function(DateTime? dateTime, TimeOfDay? time);

enum DateTimeFieldPickerMode {
  date,
  time,
  dateTime,
  month,
  year,
  monthYear;

  DateFormat format() => switch (this) {
    DateTimeFieldPickerMode.date => DateFormat('MMM dd, yyyy'),
    DateTimeFieldPickerMode.time => DateFormat('hh:mm a'),
    DateTimeFieldPickerMode.dateTime => DateFormat('MMM dd, yyyy hh:mm a'),
    DateTimeFieldPickerMode.month => DateFormat('MMMM'),
    DateTimeFieldPickerMode.year => DateFormat('yyyy'),
    DateTimeFieldPickerMode.monthYear => DateFormat('MMMM, yyyy'),
  };
}

/// [DateTimeField]
///
/// Shows an [_InputDropdown] that'll trigger [DateTimeField._handleTap] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateTimeField extends StatefulWidget {
  DateTimeField({
    this.onChanged,
    super.key,
    this.value,
    this.onTap,
    this.enabled,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.padding,
    this.hideDefaultSuffixIcon = false,
    this.decoration,
    this.initialPickerDateTime,
    this.mode = DateTimeFieldPickerMode.dateTime,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.initialDatePickerMode,
  }) : dateFormat = dateFormat ?? mode.format(),
       firstDate = firstDate ?? kDefaultFirstSelectableDate,
       lastDate = lastDate ?? kDefaultLastSelectableDate;

  factory DateTimeField.time({
    required OnDateTimeSelect? onChanged,
    Key? key,
    DateTime? value,
    bool? enabled,
    InputDecoration? decoration,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialPickerDateTime,
    TextStyle? style,
    bool autofocus = false,
    DateFormat? dateFormat,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    FocusNode? focusNode,
    bool hideDefaultSuffixIcon = false,
    bool enableFeedback = true,
  }) => DateTimeField(
    key: key,
    mode: DateTimeFieldPickerMode.time,
    firstDate: firstDate ?? DateTime(2000, 1, 1, 0, 0),
    lastDate: lastDate ?? DateTime(2000, 1, 1, 23, 59),
    onChanged: onChanged,
    value: value,
    decoration: decoration,
    initialPickerDateTime: initialPickerDateTime,
    style: style,
    autofocus: autofocus,
    enabled: enabled,
    dateFormat: dateFormat,
    padding: padding,
    onTap: onTap,
    focusNode: focusNode,
    hideDefaultSuffixIcon: hideDefaultSuffixIcon,
    enableFeedback: enableFeedback,
  );

  DateTimeField._formField({
    required this.onChanged,
    this.value,
    this.enabled,
    this.onTap,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.padding,
    this.decoration,
    this.mode = DateTimeFieldPickerMode.dateTime,
    this.initialPickerDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.hideDefaultSuffixIcon = false,
    this.initialDatePickerMode,
  }) : dateFormat = dateFormat ?? mode.format(),
       firstDate = firstDate ?? kDefaultFirstSelectableDate,
       lastDate = lastDate ?? kDefaultLastSelectableDate;

  /// The [DateTime] that represents the currently selected date.
  final DateTime? value;

  /// A callback that gets executed when the user changes the [DateTime] in the [DateTimeField].
  final OnDateTimeSelect? onChanged;

  /// Whether the [DateTimeField] is enabled or not, if null uses [InputDecoration.enabled],
  /// if null defaults to true.
  final bool? enabled;

  /// A callback that gets executed when the user taps on the [DateTimeField] and before the
  /// pickers are shown.
  final VoidCallback? onTap;

  /// The text style to use for text in the [DateTimeField].
  ///
  /// Defaults to the [TextTheme.titleMedium] value of the current
  /// [ThemeData.textTheme] of the current [Theme].
  final TextStyle? style;

  /// See [Focus.autofocus].
  final FocusNode? focusNode;

  /// See [Focus.autofocus].
  final bool autofocus;

  /// Padding around the visible portion of the [DateTimeField] widget.
  ///
  /// As the padding increases, the size of the [DropdownButton] will also
  /// increase. The padding is included in the clickable area of the dropdown
  /// widget, so this can make the widget easier to click.
  final EdgeInsetsGeometry? padding;

  /// See [InkWell.enableFeedback].
  final bool enableFeedback;

  /// The first [DateTime] the user can select.
  ///
  /// Defaults to [_kDefaultFirstSelectableDate].
  final DateTime firstDate;

  /// The last [DateTime] the user can select.
  ///
  /// Defaults to [_kDefaultLastSelectableDate].
  final DateTime lastDate;

  /// The initial [DateTime] in the pickers, when no [DateTime] is selected.
  final DateTime? initialPickerDateTime;

  /// The decoration to show around the formatted [DateTime].
  ///
  /// By default [InputDecoration.suffixIcon] will be [Icons.event_note] when not defined and
  /// [hideDefaultSuffixIcon] equals false.
  final InputDecoration? decoration;

  /// Hides the default suffix icon.
  ///
  /// Defaults to false.
  final bool hideDefaultSuffixIcon;

  /// The format of the shown [DateTime].
  ///
  /// Depending on the [mod e] the [dateFormat] defaults to:
  /// - [DateTimeFieldPickerMode.date] => [DateFormat('MMM dd, yyyy')]
  /// - [DateTimeFieldPickerMode.time] => [DateFormat('h:mm a')]
  /// - [DateTimeFieldPickerMode.dateTime] => [DateFormat('MMM dd, yyyy h:mm a')]
  /// - [DateTimeFieldPickerMode.month] => [DateFormat('MMMM')]
  /// - [DateTimeFieldPickerMode.year] => [DateFormat('yyyy')]
  /// - [DateTimeFieldPickerMode.monthYear] => [DateFormat("MMMM, yyyy")]
  final DateFormat dateFormat;

  /// The mode of the [DateTimeField].
  ///
  /// Depending on the mode, [DateTimeField] will show:
  /// - [TargetPlatform.iOS] or [TargetPlatform.macOS] => a CupertinoDatePicker with the according
  ///   [CupertinoDatePickerMode].
  /// - Else => a [MaterialDatePicker], a [MaterialTimePicker] or both.
  final DateTimeFieldPickerMode mode;

  final DatePickerMode? initialDatePickerMode;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  FocusNode? _internalNode;
  late Map<Type, Action<Intent>> _actionMap;
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _handleTap(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _handleTap(),
      ),
    };
  }

  @override
  void dispose() {
    _internalNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DateTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode == null) _internalNode ??= _createFocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final InputDecoration decoration = _getEffectiveDecoration(context);

    final bool isDense = decoration.isDense ?? false;

    Widget result = DefaultTextStyle(
      style: _textStyle!,
      child: SizedBox(
        height: isDense ? _denseButtonHeight : null,
        child:
            widget.value != null
                ? Text(widget.dateFormat.format(widget.value!))
                : const Text(''),
      ),
    );

    final MouseCursor effectiveMouseCursor =
        WidgetStateProperty.resolveAs<MouseCursor>(
          WidgetStateMouseCursor.clickable,
          <WidgetState>{if (!_enabled) WidgetState.disabled},
        );

    final bool isFocused = Focus.maybeOf(context)?.hasFocus ?? false;

    result = InputDecorator(
      decoration: decoration,
      isEmpty: widget.value == null,
      isFocused: isFocused || _isSelecting,
      child: result,
    );

    return Semantics(
      button: true,
      child: Actions(
        actions: _actionMap,
        child: InkWell(
          mouseCursor: effectiveMouseCursor,
          onTap: _enabled ? _handleTap : null,
          customBorder: decoration.border,
          canRequestFocus: _enabled,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          focusColor: decoration.focusColor,
          enableFeedback: widget.enableFeedback,
          child:
              widget.padding == null
                  ? result
                  : Padding(padding: widget.padding!, child: result),
        ),
      ),
    );
  }

  InputDecoration _getEffectiveDecoration(BuildContext context) {
    InputDecoration decoration = widget.decoration ?? const InputDecoration();

    decoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );

    if (!widget.hideDefaultSuffixIcon && decoration.suffixIcon == null) {
      decoration = decoration.copyWith(
        suffixIcon:
            widget.mode == DateTimeFieldPickerMode.time
                ? const Icon(Icons.access_time)
                : const Icon(Icons.event_note),
      );
    }

    if (!_enabled) {
      decoration = decoration.copyWith(enabled: false);
    }

    return decoration;
  }

  Future<void> _handleTap() async {
    _isSelecting = true;
    _focusNode?.requestFocus();
    widget.onTap?.call();

    // DateTime? selected;
    final DateTime? selected = await DatePickers.show(
      context: context,
      mode: widget.mode,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      initialDate: widget.value ?? widget.initialPickerDateTime,
      onDateTimeSelect: widget.onChanged,
      initialDatePickerMode: widget.initialDatePickerMode,
    );

    if (mounted) {
      _isSelecting = false;
    }

    if (selected != null) {
      widget.onChanged?.call(selected, TimeOfDay.fromDateTime(selected));
    }
  }

  double get _denseButtonHeight {
    final double fontSize =
        _textStyle!.fontSize ??
        Theme.of(context).textTheme.titleMedium!.fontSize!;
    final double scaledFontSize = MediaQuery.textScalerOf(
      context,
    ).scale(fontSize);
    return math.max(scaledFontSize, _kDenseButtonHeight);
  }

  bool get _enabled => widget.enabled ?? widget.decoration?.enabled ?? true;

  TextStyle? get _textStyle =>
      widget.style ?? Theme.of(context).textTheme.titleMedium;

  FocusNode? get _focusNode => widget.focusNode ?? _internalNode;

  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }
}
