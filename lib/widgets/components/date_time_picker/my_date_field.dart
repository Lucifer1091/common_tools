import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

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
    this.variant = DateTimeFieldPickerMode.date,
    this.placeholder,
    this.selected,
    this.selectedRange,
    this.multipleSelected,
    this.formatDate,
    this.formatDateRange,
    this.onChanged,
    this.onRangeChanged,
    this.onMultipleChanged,
    this.showOutsideDays,
    this.initialMonth,
    this.min,
    this.max,
    this.selectableDayPredicate,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.child,
    this.buttonVariant,
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
    this.icon,
    this.expands,
    this.buttonTextStyle,
  });

  /// {@template MyDateField.variant}
  /// The variant of the date picker.
  /// {@endtemplate}
  final DateTimeFieldPickerMode variant;

  /// {@template MyDateField.placeholder}
  /// The placeholder of the date picker, shown when no date is selected.
  /// {@endtemplate}
  final Widget? placeholder;

  /// {@template MyDateField.selected}
  /// The selected date, defaults to `null`.
  /// {@endtemplate}
  final DateTime? selected;

  /// {@template MyDateField.selectedRange}
  /// The selected range, defaults to `null`.
  /// {@endtemplate}
  final DateTimeRange? selectedRange;

  /// {@macro ShadCalendar.multipleSelected}
  final List<DateTime>? multipleSelected;

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

  /// {@macro ShadCalendar.onMultipleChanged}
  final ValueChanged<List<DateTime>>? onMultipleChanged;

  /// {@macro ShadCalendar.showOutsideDays}
  final bool? showOutsideDays;

  /// {@macro ShadCalendar.initialMonth}
  final DateTime? initialMonth;

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

  /// {@macro ShadButton.icon}
  final Widget? leading;

  final Widget? trailing;

  /// {@template MyDateField.iconData}
  /// The icon of the date picker button, defaults to [LucideIcons.calendar].
  /// {@endtemplate}
  final IconData? icon;

  /// {@macro ShadButton.child}
  final Widget? child;

  final MyButtonShape? shape;

  final MyButtonType? buttonVariant;

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
  final TextStyle? buttonTextStyle;

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  late DateTime? selected = widget.selected;
  late DateTimeRange? selectedRange = widget.selectedRange;

  @override
  void didUpdateWidget(covariant MyDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != null) {
      selected = widget.selected;
    }
  }

  String defaultDateFormat(DateTime date, Locale locale) {
    return widget.variant.format().format(date);
  }

  String defaultDateRangeFormat(DateTimeRange range, Locale locale) {
    if (range.start == null) return '';
    final buffer = StringBuffer();

    final start = intl.DateFormat.yMMMd(
      locale.toLanguageTag(),
    ).format(range.start!);
    buffer.write(start);

    if (range.end != null) {
      final end = intl.DateFormat.yMMMd(
        locale.toLanguageTag(),
      ).format(range.end!);
      buffer.write(' - $end');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = switch (widget.variant) {
      DateTimeFieldPickerMode.range =>
        selectedRange != null && selectedRange!.start != null,
      _ => selected != null,
    };

    final locale = Localizations.localeOf(context);

    final effectiveFormatDate =
        widget.formatDate ?? (date) => defaultDateFormat(date, locale);

    final effectiveFormatDateRange =
        widget.formatDateRange ??
        (range) => defaultDateRangeFormat(range, locale);

    final effectiveButtonTextStyle = widget.buttonTextStyle;

    var text =
        (isSelected
            ? Text(switch (widget.variant) {
              DateTimeFieldPickerMode.range => effectiveFormatDateRange(
                selectedRange!,
              ),
              _ => effectiveFormatDate(selected!),
            }, style: effectiveButtonTextStyle)
            : DefaultTextStyle(
              style: context.bodyMedium.fallback(
                color: context.colorScheme.mutedForeground,
              ),
              child: widget.placeholder ?? const Text('Select date'),
            ));

    return MyButton(
      size: widget.size ?? MyButtonSize.large,
      shape: widget.shape ?? MyButtonShape.rectangle,
      type: widget.buttonVariant ?? MyButtonType.outline,
      height: widget.height,
      width: widget.width,
      onTap:
          widget.onTap ??
          () {
            // popoverController.toggle();
          },
      onLongPress: widget.onLongPress,
      focus: MyFocusableParams(
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        onFocusChange: widget.onFocusChange,
      ),
      margin: widget.margin,
      padding: widget.padding,
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
              widget.leading ??
                  Icon(
                    widget.icon ?? LucideIcons.calendar,
                    size: 16,
                    color:
                        isSelected
                            ? context.colorScheme.foreground
                            : context.colorScheme.mutedForeground,
                  ),
              Gap(widget.gap ?? 8),
              text,
              if (widget.trailing != null) ...[
                const Spacer(),
                widget.trailing!,
              ],
            ],
          ),
    );
  }
}
