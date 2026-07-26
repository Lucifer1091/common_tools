// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../extensions/date/converters.dart';
import '../../../extensions/date/time.dart';
import '../../form/focusable.dart';
import '../../form/input_decorator.dart';
import '../../packages/gap/src/widgets/gap.dart';
import '../button/my_button.dart';
import '../text/my_text.dart';
import './date_picker.dart';

typedef OnDateTimeSelect = void Function(DateTime? dateTime, TimeOfDay? time);

enum DateTimeFieldPickerMode {
  date,
  time,
  dateTime,
  month,
  year,
  monthYear,
  range;

  DateFormat format() => switch (this) {
    DateTimeFieldPickerMode.date => DateFormat('MMM dd, yyyy'),
    DateTimeFieldPickerMode.time => DateFormat('hh:mm a'),
    DateTimeFieldPickerMode.dateTime => DateFormat('MMM dd, yyyy hh:mm a'),
    DateTimeFieldPickerMode.month => DateFormat('MMMM'),
    DateTimeFieldPickerMode.year => DateFormat('yyyy'),
    DateTimeFieldPickerMode.monthYear => DateFormat('MMMM, yyyy'),
    _ => DateFormat(),
  };
}

/// A customizable date picker widget with a button and popover calendar.
///
/// The [MyDateField] widget combines a button with a popover calendar,
/// allowing users to select a single date or a date range.
class MyDateField extends StatefulWidget {
  /// Creates a single-date picker widget with a button and popover calendar.
  const MyDateField({
    super.key,
    this.mode = DateTimeFieldPickerMode.date,
    this.placeholder,
    this.selected,
    this.selectedRange,
    this.formatDate,
    this.formatDateRange,
    this.onChanged,
    this.onRangeChanged,
    this.showOutsideDays,
    this.firstDate,
    this.lastDate,
    this.min,
    this.max,
    this.selectableDayPredicate,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.child,
    this.type,
    this.size,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.autofocus = false,
    this.focusNode,
    this.shadows,
    this.gradient,
    this.enabled = true,
    this.gap,
    this.mainAxisAlignment,
    this.shape,
    this.onFocusChange,
    this.expands,
    this.textStyle,
  });

  /// {@template MyDateField.variant}
  /// The variant of the date picker.
  /// {@endtemplate}
  final DateTimeFieldPickerMode mode;

  /// {@template MyDateField.placeholder}
  /// The placeholder of the date picker, shown when no date is selected.
  /// {@endtemplate}
  final String? placeholder;

  /// {@template MyDateField.selected}
  /// The selected date, defaults to `null`.
  /// {@endtemplate}
  final DateTime? selected;

  /// {@template MyDateField.selectedRange}
  /// The selected range, defaults to `null`.
  /// {@endtemplate}
  final DateTimeRange? selectedRange;

  /// {@template MyDateField.formatDate}
  /// A function that formats the selected date.
  /// {@endtemplate}
  final String Function(DateTime)? formatDate;

  /// {@template MyDateField.formatDateRange}
  /// A function that formats the selected date range.
  /// {@endtemplate}
  final String Function(DateTimeRange)? formatDateRange;

  /// {@macro ShadCalendar.onChanged}
  final ValueChanged<DateTime?>? onChanged;

  /// {@macro ShadCalendar.onRangeChanged}
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  /// {@macro ShadCalendar.showOutsideDays}
  final bool? showOutsideDays;

  /// The first [DateTime] the user can select.
  final DateTime? firstDate;

  /// The last [DateTime] the user can select.
  final DateTime? lastDate;

  /// {@macro ShadCalendar.min}
  final int? min;

  /// {@macro ShadCalendar.max}
  final int? max;

  /// {@macro ShadCalendar.selectableDayPredicate}
  final bool Function(DateTime day)? selectableDayPredicate;

  // ---
  // BUTTON
  // ---

  /// {@macro ShadButton.onPressed}
  final VoidCallback? onTap;

  /// {@macro ShadButton.onLongPress}
  final VoidCallback? onLongPress;

  /// {@template MyInput.leading}
  /// The widget displayed before the date field.
  /// Typically an icon or small graphic.
  /// {@endtemplate}
  final Widget? leading;

  /// {@template MyInput.trailing}
  /// The widget displayed after the date field.
  /// Typically an icon or small graphic.
  /// {@endtemplate}
  final Widget? trailing;

  /// {@macro ShadButton.child}
  final Widget? child;

  final MyButtonShape? shape;

  final MyButtonType? type;

  /// {@macro ShadButton.size}
  final MyButtonSize? size;

  /// {@macro ShadButton.width}
  final double? width;

  /// {@macro ShadButton.height}
  final double? height;

  /// {@macro ShadButton.padding}
  final EdgeInsetsGeometry? margin;

  /// {@macro ShadButton.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadButton.autofocus}
  final bool autofocus;

  /// {@macro ShadButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro ShadButton.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadButton.gradient}
  final Gradient? gradient;

  /// {@macro ShadButton.enabled}
  final bool enabled;

  /// {@macro ShadButton.gap}
  final double? gap;

  /// {@macro ShadButton.mainAxisAlignment}
  final MainAxisAlignment? mainAxisAlignment;

  /// {@macro ShadButton.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro ShadButton.expands}
  final bool? expands;

  /// {@macro ShadButton.textStyle}
  final TextStyle? textStyle;

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  late DateTime? selected = widget.selected;
  late DateTimeRange? selectedRange = widget.selectedRange;

  @override
  void didUpdateWidget(covariant MyDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != null) selected = widget.selected;
  }

  String defaultDateFormat(DateTime date) {
    return widget.mode.format().format(date);
  }

  String defaultDateRangeFormat(DateTimeRange range) {
    final buffer = StringBuffer();

    final start = intl.DateFormat.yMMMd().format(range.start);
    buffer.write(start);

    final end = intl.DateFormat.yMMMd().format(range.end);
    buffer.write(' - $end');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = switch (widget.mode) {
      DateTimeFieldPickerMode.range => selectedRange != null,
      _ => selected != null,
    };

    final dateFormat = widget.formatDate ?? defaultDateFormat;

    final rangeFormat = widget.formatDateRange ?? defaultDateRangeFormat;

    final effectiveButtonTextStyle =
        widget.textStyle ??
        context.bodyMedium.copyWith(
          color: widget.enabled
              ? context.colorScheme.foreground
              : context.colorScheme.mutedForeground,
        );

    final text = (isSelected
        ? MyText(switch (widget.mode) {
            DateTimeFieldPickerMode.range => rangeFormat(selectedRange!),
            _ => dateFormat(selected!),
          }, style: effectiveButtonTextStyle)
        : DefaultTextStyle(
            style: context.bodyMedium.fallback(
              color: context.colorScheme.mutedForeground,
            ),
            child: Text(widget.placeholder ?? ''),
          ));

    return MyButton(
      size: widget.size ?? MyButtonSize.large,
      shape: widget.shape ?? MyButtonShape.rectangle,
      type: widget.type ?? MyButtonType.outline,
      height: widget.height,
      width: widget.width,
      onTap: widget.onTap ?? () => _openPicker(context),
      onLongPress: widget.onLongPress,
      focus: MyFocusableParams(
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        onFocusChange: widget.onFocusChange,
      ),
      margin: widget.margin,
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 12),
      shadows: widget.shadows,
      gradient: widget.gradient,
      enabled: widget.enabled,
      iconTextSpacing: widget.gap,
      textStyle: effectiveButtonTextStyle,
      child:
          widget.child ??
          Row(
            mainAxisAlignment:
                widget.mainAxisAlignment ?? MainAxisAlignment.start,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                Gap(widget.gap ?? 8),
              ],
              text,
              if (widget.trailing != null) ...[
                const Spacer(),
                widget.trailing!,
              ],
            ],
          ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    if (widget.mode == DateTimeFieldPickerMode.range) {
      selectedRange = await MyDatePicker.range(
        context: context,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        initialDateRange: widget.selectedRange,
        minRangeDays: widget.min,
        maxRangeDays: widget.max,
      );

      setState(() {});
      widget.onRangeChanged?.call(selectedRange);
      return;
    }

    switch (widget.mode) {
      case DateTimeFieldPickerMode.date:
        if (!mounted) return;

        final date = await MyDatePicker.date(
          context: context,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initial: widget.selected,
          showOutsideDays: widget.showOutsideDays ?? true,
        );

        if (date != null) {
          setState(() => selected = date);
          widget.onChanged?.call(selected);
        }
      case DateTimeFieldPickerMode.time:
        if (!mounted) return;

        final date = (await MyDatePicker.time(
          context: context,
          initial: widget.selected?.timeOfDay,
        )).toDateTime();

        if (date != null) {
          setState(() => selected = date);
          widget.onChanged?.call(selected);
        }

      case DateTimeFieldPickerMode.dateTime:
        if (!mounted) return;

        final date = await MyDatePicker.dateTime(
          context: context,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initial: widget.selected,
          showOutsideDays: widget.showOutsideDays ?? true,
        );
        if (date != null) {
          setState(() => selected = date);
          widget.onChanged?.call(selected);
        }
      case DateTimeFieldPickerMode.month:
        if (!mounted) return;

        final date = await MyDatePicker.month(
          context: context,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initialMonth: widget.selected,
        );

        if (date != null) {
          setState(() => selected = date);
          widget.onChanged?.call(selected);
        }
      case DateTimeFieldPickerMode.year:
        if (!mounted) return;

        final year = await MyDatePicker.year(
          context: context,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initialYear: widget.selected?.year,
        );

        if (year != null) {
          setState(() {
            selected = DateTime(year);
          });
          widget.onChanged?.call(selected);
        }

      case DateTimeFieldPickerMode.monthYear:
        if (!mounted) return;

        final date = await MyDatePicker.month(
          context: context,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initialMonth: widget.selected,
        );

        if (date != null) {
          setState(() => selected = date);
          widget.onChanged?.call(selected);
        }

      case DateTimeFieldPickerMode.range:
        break;
    }
  }
}
