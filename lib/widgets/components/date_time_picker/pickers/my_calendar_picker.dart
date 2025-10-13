import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../index.dart';

enum CalendarViewType { date, month, year }

enum CalendarSelectionMode { none, single, multi }

enum DateState { disabled, enabled }

typedef DateStateBuilder = DateState Function(DateTime date);

class YearPickerDialog extends StatefulWidget {
  const YearPickerDialog({
    required this.initialYear,
    super.key,
    this.firstDate,
    this.lastDate,
    this.hideNavigation = false,
    this.stateBuilder,
  });

  final int initialYear;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool hideNavigation;
  final DateStateBuilder? stateBuilder;

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  late int _yearSelectStart; // 4x4 page start (multiple of 16)
  late int _focusYear;

  bool get _canPrevPage {
    if (widget.firstDate == null) return true;
    final minWindow = (widget.firstDate!.year ~/ 16) * 16;
    return _yearSelectStart > minWindow;
  }

  bool get _canNextPage {
    if (widget.lastDate == null) return true;
    final maxWindow = (widget.lastDate!.year ~/ 16) * 16;
    return _yearSelectStart < maxWindow;
  }

  @override
  void initState() {
    super.initState();
    _focusYear = widget.initialYear;
    _yearSelectStart = (_focusYear ~/ 16) * 16;
  }

  void _prev() {
    if (!_canPrevPage) return;
    setState(() => _yearSelectStart -= 16);
  }

  void _next() {
    if (!_canNextPage) return;
    setState(() => _yearSelectStart += 16);
  }

  @override
  Widget build(BuildContext context) {
    final showNav = !widget.hideNavigation;

    return MyDialogScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDialogInfoWidget(
            title: 'Select Year',
            titleAlignment: Alignment.centerLeft,
            contentWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(16),
                Row(
                  children: [
                    if (showNav)
                      MyButton(
                        type: MyButtonType.secondary,
                        shape: MyButtonShape.square,
                        icon: LucideIcons.arrowLeft,
                        onTap: _prev,
                      ),
                    if (showNav) const Gap(16),
                    Expanded(
                      child: MyButton(
                        type: MyButtonType.ghost,
                        enabled: false,
                        text: '$_yearSelectStart – ${_yearSelectStart + 15}',
                      ),
                    ),
                    if (showNav) const Gap(16),
                    if (showNav)
                      MyButton(
                        type: MyButtonType.secondary,
                        shape: MyButtonShape.square,
                        icon: LucideIcons.arrowRight,
                        onTap: _next,
                      ),
                  ],
                ),
                const Gap(16),
                YearCalendar(
                  value: _focusYear,
                  calendarValue: DateTime(_focusYear).toCalendarValue(),
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  yearSelectStart: _yearSelectStart,
                  stateBuilder: widget.stateBuilder,
                  onChanged: (year) {
                    setState(() => _focusYear = year);
                  },
                ),
              ],
            ),
          ),
          const Gap(24),
          MyDialogShrinkButtons(
            leftBtn: MyDialogButtonOptions(
              title: 'Cancel',
              type: MyButtonType.outline,
              action: () => Navigator.pop(context),
            ),
            rightBtn: MyDialogButtonOptions(
              title: 'OK',
              titleColor: context.colorScheme.primaryForeground,
              action: () => Navigator.pop<int?>(context, _focusYear),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthPickerDialog extends StatefulWidget {
  const MonthPickerDialog({
    required this.initialMonth,
    super.key,
    this.firstDate,
    this.lastDate,
    this.hideNavigation = false,
    this.stateBuilder,
  });

  final DateTime initialMonth;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool hideNavigation;
  final DateStateBuilder? stateBuilder;

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late CalendarView _view;

  bool get _atFirstYear =>
      widget.firstDate != null && _view.year <= widget.firstDate!.year;

  bool get _atLastYear =>
      widget.lastDate != null && _view.year >= widget.lastDate!.year;

  @override
  void initState() {
    super.initState();
    _view = CalendarView(widget.initialMonth.year, widget.initialMonth.month);
  }

  void _prev() {
    if (_atFirstYear) return;
    setState(() => _view = _view.previousYear);
  }

  void _next() {
    if (_atLastYear) return;
    setState(() => _view = _view.nextYear);
  }

  @override
  Widget build(BuildContext context) {
    final showNav = !widget.hideNavigation;

    return MyDialogScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDialogInfoWidget(
            title: 'Select Month',
            titleAlignment: Alignment.centerLeft,
            contentWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(16),
                Row(
                  children: [
                    if (showNav)
                      MyButton(
                        type: MyButtonType.secondary,
                        shape: MyButtonShape.square,
                        icon: LucideIcons.arrowLeft,
                        onTap: _prev,
                      ),
                    if (showNav) const Gap(16),
                    Expanded(
                      child: MyButton(
                        type: MyButtonType.ghost,
                        enabled: false,
                        text: '${_view.year}',
                      ),
                    ),
                    if (showNav) const Gap(16),
                    if (showNav)
                      MyButton(
                        type: MyButtonType.secondary,
                        shape: MyButtonShape.square,
                        icon: LucideIcons.arrowRight,
                        onTap: _next,
                      ),
                  ],
                ),
                const Gap(16),
                MonthCalendar(
                  value: _view,
                  // now: DateTime.now(),
                  calendarValue:
                      DateTime(_view.year, _view.month).toCalendarValue(),
                  stateBuilder: widget.stateBuilder,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onChanged: (CalendarView nextView) {
                    setState(() => _view = nextView);
                  },
                ),
              ],
            ),
          ),
          const Gap(24),
          MyDialogShrinkButtons(
            leftBtn: MyDialogButtonOptions(
              title: 'Cancel',
              type: MyButtonType.outline,
              action: () => Navigator.pop(context),
            ),
            rightBtn: MyDialogButtonOptions(
              title: 'OK',
              titleColor: context.colorScheme.primaryForeground,
              action:
                  () => Navigator.pop<DateTime?>(
                    context,
                    DateTime(_view.year, _view.month),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCalendarPickerDialog extends StatefulWidget {
  const MyCalendarPickerDialog({
    required this.selectionMode,
    super.key,
    this.initial,
    this.onChanged,
    this.stateBuilder,
    this.min,
    this.max,
    this.firstDate,
    this.lastDate,
    this.showOutsideDays = true,
    this.hideNavigation = false,
  });

  final CalendarSelectionMode selectionMode;
  final CalendarValue? initial;
  final ValueChanged<CalendarValue?>? onChanged;
  final DateStateBuilder? stateBuilder;
  final int? min;
  final int? max;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showOutsideDays;
  final bool hideNavigation;

  @override
  State<MyCalendarPickerDialog> createState() => _MyCalendarPickerDialogState();
}

class _MyCalendarPickerDialogState extends State<MyCalendarPickerDialog> {
  late CalendarValue? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
  }

  void _handleChanged(CalendarValue? value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  void _handleCancel() => Navigator.pop(context);
  void _handleOk() => Navigator.pop(context, _value);

  @override
  Widget build(BuildContext context) {
    final picker = Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _DatePickerDialog(
        selectionMode: widget.selectionMode,
        initialValue: _value,
        onChanged: _handleChanged,
        min: widget.min,
        max: widget.max,
        stateBuilder: widget.stateBuilder,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        showOutsideDays: widget.showOutsideDays,
        hideNavigation: widget.hideNavigation,
      ),
    );

    return MyDialogScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDialogInfoWidget(
            title: 'Select Date',
            titleAlignment: Alignment.centerLeft,
            contentWidget: picker,
          ),
          const Gap(24),
          _horizontalButtons(),
        ],
      ),
    );
  }

  Widget _horizontalButtons() {
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

class _DatePickerDialog extends StatefulWidget {
  const _DatePickerDialog({
    required this.selectionMode,
    this.initialValue,
    this.onChanged,
    this.stateBuilder,
    this.min,
    this.max,
    this.firstDate,
    this.lastDate,
    this.showOutsideDays = true,
    this.hideNavigation = false,
  });

  final CalendarValue? initialValue;
  final CalendarSelectionMode selectionMode;
  final ValueChanged<CalendarValue?>? onChanged;
  final DateStateBuilder? stateBuilder;
  final int? min;
  final int? max;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showOutsideDays;
  final bool hideNavigation;

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  late CalendarView _view;
  late CalendarValue? _value;
  late CalendarViewType _viewType;
  late int _yearSelectStart;

  @override
  void initState() {
    super.initState();
    _view = widget.initialValue?.view ?? CalendarView.now();
    _value = widget.initialValue;
    _viewType = CalendarViewType.date;
    _yearSelectStart = (_view.year ~/ 16) * 16; // 4x4 year pages
    // Clamp starting view within first/lastDate for sanity
    if (widget.firstDate != null &&
        _view.asDate().isBeforeMonth(widget.firstDate!)) {
      _view = CalendarView(widget.firstDate!.year, widget.firstDate!.month);
    }
    if (widget.lastDate != null &&
        _view.asDate().isAfterMonth(widget.lastDate!)) {
      _view = CalendarView(widget.lastDate!.year, widget.lastDate!.month);
    }
  }

  String _headerLabel(CalendarView v, CalendarViewType t) => switch (t) {
    CalendarViewType.date => '${v.month.toMonth()} ${v.year}',
    CalendarViewType.month => '${v.year}',
    CalendarViewType.year => '',
  };

  bool get _atFirstMonth =>
      widget.firstDate != null &&
      !CalendarView(
        widget.firstDate!.year,
        widget.firstDate!.month,
      ).isBeforeOrSameMonth(_view);

  bool get _atLastMonth =>
      widget.lastDate != null &&
      !CalendarView(
        widget.lastDate!.year,
        widget.lastDate!.month,
      ).isAfterOrSameMonth(_view);

  void _goPrev() {
    setState(() {
      switch (_viewType) {
        case CalendarViewType.date:
          if (_atFirstMonth) return;
          _view = _view.previous;
        case CalendarViewType.month:
          if (widget.firstDate != null) {
            if (_view.year - 1 < widget.firstDate!.year) return;
          }
          _view = _view.previousYear;
        case CalendarViewType.year:
          // move the 16-year window back, but respect firstDate if present
          if (widget.firstDate != null) {
            if (_yearSelectStart - 16 < (widget.firstDate!.year ~/ 16) * 16) {
              // still allow if the window would include firstDate
              if (_yearSelectStart > (widget.firstDate!.year ~/ 16) * 16) {
                _yearSelectStart = (widget.firstDate!.year ~/ 16) * 16;
              }
              return;
            }
          }
          _yearSelectStart -= 16;
      }
    });
  }

  void _goNext() {
    setState(() {
      switch (_viewType) {
        case CalendarViewType.date:
          if (_atLastMonth) return;
          _view = _view.next;
        case CalendarViewType.month:
          if (widget.lastDate != null) {
            if (_view.year + 1 > widget.lastDate!.year) return;
          }
          _view = _view.nextYear;
        case CalendarViewType.year:
          if (widget.lastDate != null) {
            if (_yearSelectStart + 16 > (widget.lastDate!.year ~/ 16) * 16) {
              if (_yearSelectStart < (widget.lastDate!.year ~/ 16) * 16) {
                _yearSelectStart = (widget.lastDate!.year ~/ 16) * 16;
              }
              return;
            }
          }
          _yearSelectStart += 16;
      }
    });
  }

  void _promoteView() {
    if (_viewType == CalendarViewType.year) return;
    setState(() {
      _viewType =
          _viewType == CalendarViewType.date
              ? CalendarViewType.month
              : CalendarViewType.year;
    });
  }

  void _handleCalendarChanged(CalendarValue? value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final showNav = !widget.hideNavigation;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (showNav)
              MyButton(
                type: MyButtonType.secondary,
                onTap: _goPrev,
                icon: LucideIcons.arrowLeft,
                shape: MyButtonShape.square,
              ),
            if (showNav) const Gap(16),
            Expanded(
              child: MyButton(
                enabled: _viewType != CalendarViewType.year,
                type: MyButtonType.ghost,
                onTap: _promoteView,
                text: _headerLabel(_view, _viewType),
                textStyle: context.bodyLarge,
              ),
            ),
            if (showNav) const Gap(16),
            if (showNav)
              MyButton(
                type: MyButtonType.secondary,
                onTap: _goNext,
                icon: LucideIcons.arrowRight,
                shape: MyButtonShape.square,
              ),
          ],
        ),
        const Gap(16),
        _buildView(
          yearSelectStart: _yearSelectStart,
          view: _view,
          viewType: _viewType,
          selectionMode: widget.selectionMode,
          onViewChanged: (value) {
            setState(() {
              _view = value;
              switch (_viewType) {
                case CalendarViewType.date:
                  break;
                case CalendarViewType.month:
                  _viewType = CalendarViewType.date;
                case CalendarViewType.year:
                  _viewType = CalendarViewType.month;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildView({
    required int yearSelectStart,
    required CalendarView view,
    required CalendarViewType viewType,
    required CalendarSelectionMode selectionMode,
    required ValueChanged<CalendarView> onViewChanged,
  }) {
    if (viewType == CalendarViewType.year) {
      return YearCalendar(
        value: view.year,
        calendarValue: _value,
        yearSelectStart: yearSelectStart,
        stateBuilder: widget.stateBuilder,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        onChanged: (value) {
          setState(() {
            onViewChanged(view.copyWith(year: () => value));
          });
        },
      );
    }

    if (viewType == CalendarViewType.month) {
      return MonthCalendar(
        value: view,
        calendarValue: _value,
        stateBuilder: widget.stateBuilder,
        onChanged: onViewChanged,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      );
    }

    return Calendar(
      value: _value,
      view: view,
      onChanged: _handleCalendarChanged,
      selectionMode: selectionMode,
      stateBuilder: widget.stateBuilder,
      min: widget.min,
      max: widget.max,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      showOutsideDays: widget.showOutsideDays,
    );
  }
}

abstract class CalendarValue {
  const CalendarValue();

  CalendarValueLookup lookup(int year, [int? month = 1, int? day = 1]);

  static SingleCalendarValue single(DateTime date) {
    return SingleCalendarValue(date);
  }

  static MultiCalendarValue multi(List<DateTime> dates) {
    return MultiCalendarValue(dates);
  }

  SingleCalendarValue toSingle();
  MultiCalendarValue toMulti();

  CalendarView get view;
}

DateTime _convertNecessary(DateTime from, int year, [int? month, int? date]) {
  if (month == null) return DateTime(from.year);

  if (date == null) return DateTime(from.year, from.month);

  return DateTime(from.year, from.month, from.day);
}

class SingleCalendarValue extends CalendarValue {
  SingleCalendarValue(this.date);
  final DateTime date;

  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = _convertNecessary(date, year, month, day);
    if (current.isAtSameMomentAs(DateTime(year, month ?? 1, day ?? 1))) {
      return CalendarValueLookup.selected;
    }
    return CalendarValueLookup.none;
  }

  @override
  CalendarView get view => date.toCalendarView();

  @override
  String toString() {
    return 'SingleCalendarValue($date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleCalendarValue && other.date == date;
  }

  @override
  int get hashCode => date.hashCode;

  @override
  SingleCalendarValue toSingle() {
    return this;
  }

  @override
  MultiCalendarValue toMulti() {
    return CalendarValue.multi([date]);
  }
}

class MultiCalendarValue extends CalendarValue {
  MultiCalendarValue(this.dates);

  final List<DateTime> dates;

  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = DateTime(year, month ?? 1, day ?? 1);
    if (dates.any(
      (element) => _convertNecessary(
        element,
        year,
        month,
        day,
      ).isAtSameMomentAs(current),
    )) {
      return CalendarValueLookup.selected;
    }
    return CalendarValueLookup.none;
  }

  @override
  CalendarView get view =>
      dates.firstOrNull?.toCalendarView() ?? CalendarView.now();

  @override
  String toString() {
    return 'MultiCalendarValue($dates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiCalendarValue && listEquals(other.dates, dates);
  }

  @override
  int get hashCode => dates.hashCode;

  @override
  SingleCalendarValue toSingle() {
    return CalendarValue.single(dates.first);
  }

  @override
  MultiCalendarValue toMulti() {
    return this;
  }
}

enum CalendarValueLookup { none, selected }

class CalendarView {
  CalendarView(this.year, this.month)
    : assert(month >= 1 && month <= 12, 'Month must be between 1 and 12');

  factory CalendarView.now() {
    final now = DateTime.now();
    return CalendarView(now.year, now.month);
  }

  factory CalendarView.fromDateTime(DateTime date) =>
      CalendarView(date.year, date.month);

  final int year;
  final int month;

  CalendarView get next {
    if (month == 12) {
      return CalendarView(year + 1, 1);
    }
    return CalendarView(year, month + 1);
  }

  CalendarView get previous {
    if (month == 1) {
      return CalendarView(year - 1, 12);
    }
    return CalendarView(year, month - 1);
  }

  CalendarView get nextYear {
    return CalendarView(year + 1, month);
  }

  CalendarView get previousYear {
    return CalendarView(year - 1, month);
  }

  @override
  String toString() => 'CalendarView($year, $month)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarView && other.year == year && other.month == month);

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  CalendarView copyWith({ValueGetter<int>? year, ValueGetter<int>? month}) =>
      CalendarView(
        year == null ? this.year : year(),
        month == null ? this.month : month(),
      );

  DateTime asDate() => DateTime(year, month);

  bool isBeforeOrSameMonth(CalendarView other) {
    if (year < other.year) return true;
    if (year > other.year) return false;
    return month <= other.month;
  }

  bool isAfterOrSameMonth(CalendarView other) {
    if (year > other.year) return true;
    if (year < other.year) return false;
    return month >= other.month;
  }
}

extension _DateHelpers on DateTime {
  CalendarView toCalendarView() => CalendarView.fromDateTime(this);
  CalendarValue toCalendarValue() => CalendarValue.single(this);

  bool isBeforeMonth(DateTime other) =>
      year < other.year || (year == other.year && month < other.month);
  bool isAfterMonth(DateTime other) =>
      year > other.year || (year == other.year && month > other.month);

  static bool monthOverlapsRange(
    DateTime monthAnchor,
    DateTime first,
    DateTime last,
  ) {
    final mStart = DateTime(monthAnchor.year, monthAnchor.month);
    final mEnd = DateTime(monthAnchor.year, monthAnchor.month + 1, 0);
    return !(mEnd.isBefore(first) || mStart.isAfter(last));
  }

  static bool yearOverlapsRange(int year, DateTime first, DateTime last) {
    final yStart = DateTime(year);
    final yEnd = DateTime(year, 12, 31);
    return !(yEnd.isBefore(first) || yStart.isAfter(last));
  }
}

class Calendar extends StatefulWidget {
  const Calendar({
    required this.view,
    required this.selectionMode,
    super.key,
    this.now,
    this.value,
    this.onChanged,
    this.stateBuilder,
    this.min,
    this.max,
    this.firstDate,
    this.lastDate,
    this.showOutsideDays = true,
  });

  final DateTime? now;
  final CalendarValue? value;
  final CalendarView view;
  final CalendarSelectionMode selectionMode;
  final ValueChanged<CalendarValue?>? onChanged;
  final DateStateBuilder? stateBuilder;
  final int? min;
  final int? max;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showOutsideDays;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CalendarGridData _gridData;

  @override
  void initState() {
    super.initState();
    _gridData = CalendarGridData(
      month: widget.view.month,
      year: widget.view.year,
      showOutsideDays: widget.showOutsideDays,
    );
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view.year != widget.view.year ||
        oldWidget.view.month != widget.view.month ||
        oldWidget.showOutsideDays != widget.showOutsideDays) {
      _gridData = CalendarGridData(
        month: widget.view.month,
        year: widget.view.year,
        showOutsideDays: widget.showOutsideDays,
      );
    }
  }

  bool _withinBounds(DateTime d) {
    if (widget.firstDate != null && d.isBefore(widget.firstDate!)) return false;
    if (widget.lastDate != null && d.isAfter(widget.lastDate!)) return false;
    return true;
  }

  bool _enabled(DateTime date) {
    if (!_withinBounds(date)) return false;
    final state = widget.stateBuilder?.call(date) ?? DateState.enabled;
    if (state == DateState.disabled) return false;
    // MULTI: cap logic – if at cap, only allow toggling already selected.
    if (widget.selectionMode == CalendarSelectionMode.multi &&
        widget.max != null &&
        widget.value is MultiCalendarValue) {
      final multi = widget.value!.toMulti();
      final atCap = multi.dates.length >= widget.max!;
      if (atCap) {
        return multi.dates.contains(date);
      }
    }
    return true;
  }

  bool _canDeselectSingle(DateTime date) {
    // min==1 prevents going to empty.
    if (widget.min != null && widget.min! >= 1) return false;
    return true;
  }

  bool _canDeselectMulti(int nextCount) {
    if (widget.min == null) return true;
    return nextCount >= widget.min!;
  }

  void _handleTap(DateTime date) {
    final calendarValue = widget.value;
    if (widget.selectionMode == CalendarSelectionMode.none) return;

    if (widget.selectionMode == CalendarSelectionMode.single) {
      if (!_enabled(date)) return;

      if (calendarValue is SingleCalendarValue &&
          date.isAtSameMomentAs(calendarValue.date)) {
        if (_canDeselectSingle(date)) widget.onChanged?.call(null);
        return;
      }
      widget.onChanged?.call(CalendarValue.single(date));
      return;
    }

    if (widget.selectionMode == CalendarSelectionMode.multi) {
      if (calendarValue == null) {
        widget.onChanged?.call(CalendarValue.single(date));
        return;
      }

      final lookup = calendarValue.lookup(date.year, date.month, date.day);

      if (lookup == CalendarValueLookup.none) {
        if (!_enabled(date)) return;

        final multi = calendarValue.toMulti();
        final nextCount = multi.dates.length - 1;
        if (!_canDeselectMulti(nextCount)) return;
        multi.dates.add(date);
        // Prevent exceeding max explicitly (safety in case _enabled path changes)
        if (widget.max != null && multi.dates.length > widget.max!) {
          multi.dates.remove(date);
          return;
        }
        widget.onChanged?.call(multi);
        return;
      } else {
        final multi = calendarValue.toMulti();

        final nextCount = multi.dates.length - 1;
        if (!_canDeselectMulti(nextCount)) return;

        multi.dates.remove(date);
        if (multi.dates.isEmpty) {
          widget.onChanged?.call(null);
          return;
        }
        widget.onChanged?.call(multi);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarGrid(
      data: _gridData,
      itemBuilder: (item) {
        final date = item.date;

        final inBounds = _withinBounds(date);
        final lookup =
            widget.value?.lookup(date.year, date.month, date.day) ??
            CalendarValueLookup.none;

        CalendarItemType type = CalendarItemType.none;
        switch (lookup) {
          case CalendarValueLookup.none:
            if (widget.now != null && widget.now!.isAtSameMomentAs(date)) {
              type = CalendarItemType.today;
            }
          case CalendarValueLookup.selected:
            type = CalendarItemType.selected;
        }

        final enabled = _enabled(date) && inBounds;

        final calendarItem = CalendarItem(
          type: type,
          indexAtRow: item.indexInRow,
          rowCount: 7,
          onTap: enabled ? () => _handleTap(date) : null,
          state: enabled ? DateState.enabled : DateState.disabled,
          text: '${date.day}',
        );

        if (item.fromAnotherMonth && !widget.showOutsideDays) {
          return const NoWidget();
        }

        if (item.fromAnotherMonth) {
          return Opacity(opacity: 0.5, child: calendarItem);
        }

        return calendarItem;
      },
    );
  }
}

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    required this.value,
    required this.onChanged,
    super.key,
    this.now,
    this.calendarValue,
    this.stateBuilder,
    this.firstDate,
    this.lastDate,
  });

  final CalendarView value;
  final ValueChanged<CalendarView> onChanged;
  final DateTime? now;
  final CalendarValue? calendarValue;
  final DateStateBuilder? stateBuilder;
  final DateTime? firstDate;
  final DateTime? lastDate;

  bool _monthWithinBounds(DateTime monthAnchor) {
    if (firstDate == null && lastDate == null) return true;
    final f = firstDate ?? DateTime(1);
    final l = lastDate ?? DateTime(9999);
    return _DateHelpers.monthOverlapsRange(monthAnchor, f, l);
  }

  bool _enabled(DateTime date) {
    if (!_monthWithinBounds(date)) return false;
    final state = stateBuilder?.call(date) ?? DateState.enabled;
    if (state == DateState.disabled) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    final months = <Widget>[];

    for (int i = 1; i <= 12; i++) {
      final date = DateTime(value.year, i);

      CalendarItemType type = CalendarItemType.none;
      if (calendarValue != null) {
        final lookup = calendarValue!.lookup(date.year, date.month);
        switch (lookup) {
          case CalendarValueLookup.none:
            if (now != null &&
                DateTime(now!.year, now!.month).isAtSameMomentAs(date)) {
              type = CalendarItemType.today;
            }
          case CalendarValueLookup.selected:
            type = CalendarItemType.selected;
        }
      } else {
        if (now != null &&
            DateTime(now!.year, now!.month).isAtSameMomentAs(date)) {
          type = CalendarItemType.today;
        }
      }

      final enabled = _enabled(date);

      months.add(
        CalendarItem(
          key: ValueKey(date),
          type: type,
          indexAtRow: (i - 1) % 4,
          rowCount: 4,
          onTap:
              enabled
                  ? () {
                    onChanged(value.copyWith(month: () => i));
                  }
                  : null,
          state: enabled ? DateState.enabled : DateState.disabled,
          text: i.toMonth(style: Abbreviation.semi),
        ),
      );
    }

    for (int i = 0; i < months.length; i += 4) {
      rows
        ..add(const Gap(8))
        ..add(Row(children: months.sublist(i, i + 4)));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

class YearCalendar extends StatelessWidget {
  const YearCalendar({
    required this.value,
    required this.yearSelectStart,
    required this.onChanged,
    super.key,
    this.now,
    this.calendarValue,
    this.stateBuilder,
    this.firstDate,
    this.lastDate,
  });

  final int yearSelectStart;
  final int value;
  final DateTime? now;
  final ValueChanged<int> onChanged;
  final CalendarValue? calendarValue;
  final DateStateBuilder? stateBuilder;
  final DateTime? firstDate;
  final DateTime? lastDate;

  bool _yearWithinBounds(int y) {
    if (firstDate == null && lastDate == null) return true;
    final f = firstDate ?? DateTime(1);
    final l = lastDate ?? DateTime(9999);
    return _DateHelpers.yearOverlapsRange(y, f, l);
  }

  bool _enabled(DateTime date) {
    if (!_yearWithinBounds(date.year)) return false;
    final state = stateBuilder?.call(date) ?? DateState.enabled;
    return state != DateState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    final years = <Widget>[];

    for (int i = yearSelectStart; i < yearSelectStart + 16; i++) {
      final date = DateTime(i);

      CalendarItemType type = CalendarItemType.none;

      if (calendarValue != null) {
        final lookup = calendarValue!.lookup(date.year);
        switch (lookup) {
          case CalendarValueLookup.none:
            if (now != null && now!.year == date.year) {
              type = CalendarItemType.today;
            }
          case CalendarValueLookup.selected:
            type = CalendarItemType.selected;
        }
      } else {
        if (now != null && now!.year == date.year) {
          type = CalendarItemType.today;
        }
      }

      final enabled = _enabled(date);

      years.add(
        CalendarItem(
          key: ValueKey(date),
          type: type,
          indexAtRow: (i - yearSelectStart) % 4,
          rowCount: 4,
          onTap: enabled ? () => onChanged(date.year) : null,
          state: enabled ? DateState.enabled : DateState.disabled,
          text: '$i',
        ),
      );
    }

    for (int i = 0; i < years.length; i += 4) {
      rows
        ..add(const Gap(8))
        ..add(Row(children: years.sublist(i, i + 4)));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

enum CalendarItemType { none, today, selected }

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    required this.text,
    required this.type,
    required this.indexAtRow,
    required this.rowCount,
    required this.state,
    super.key,
    this.onTap,
  });

  final String text;
  final CalendarItemType type;
  final VoidCallback? onTap;
  final int indexAtRow;
  final int rowCount;
  final DateState state;

  @override
  Widget build(BuildContext context) {
    final common = MyButton(
      enabled: state == DateState.enabled,
      shape: MyButtonShape.square,
      onTap: onTap,
      text: text,
      width: rowCount < 5 ? 265 / rowCount : null,
    );

    switch (type) {
      case CalendarItemType.none:
        return MyButton(
          type: MyButtonType.ghost,
          enabled: state == DateState.enabled,
          shape: MyButtonShape.square,
          onTap: onTap,
          text: text,
          width: rowCount < 5 ? 265 / rowCount : null,
        );
      case CalendarItemType.today:
        return common;
      case CalendarItemType.selected:
        return common;
    }
  }
}

class CalendarGridData {
  factory CalendarGridData({
    required int month,
    required int year,
    required bool showOutsideDays,
  }) {
    final firstDayOfMonth = DateTime(year, month);
    final daysInMonth = DateTime(year, month == 12 ? 1 : month + 1, 0).day;

    // weekday: Mon=1..Sun=7; we build leading blanks from previous month
    final leading = firstDayOfMonth.weekday; // 1..7
    final prevMonthLastDay = firstDayOfMonth.subtract(Duration(days: leading));

    final items = <CalendarGridItem>[];
    var itemCount = 0;

    if (showOutsideDays) {
      if (leading < 7) {
        for (int i = 0; i < leading; i++) {
          final idx = itemCount++;
          items.add(
            CalendarGridItem(
              prevMonthLastDay.add(Duration(days: i)),
              idx % 7,
              true,
              idx ~/ 7,
            ),
          );
        }
      }
    } else {
      // If not showing outside days, insert placeholders for alignment.
      if (leading < 7) {
        for (int i = 0; i < leading; i++) {
          final idx = itemCount++;
          items.add(CalendarGridItem.placeholder(idx % 7, idx ~/ 7));
        }
      }
    }

    for (int i = 0; i < daysInMonth; i++) {
      final idx = itemCount++;
      final day = DateTime(year, month, i + 1);
      items.add(CalendarGridItem(day, idx % 7, false, idx ~/ 7));
    }

    final remaining = (7 - (items.length % 7)) % 7;
    final nextMonthFirstDay = DateTime(year, month + 1);

    if (showOutsideDays) {
      if (remaining < 7) {
        for (int i = 0; i < remaining; i++) {
          final idx = itemCount++;
          items.add(
            CalendarGridItem(
              nextMonthFirstDay.add(Duration(days: i)),
              idx % 7,
              true,
              idx ~/ 7,
            ),
          );
        }
      }
    } else {
      if (remaining < 7) {
        for (int i = 0; i < remaining; i++) {
          final idx = itemCount++;
          items.add(CalendarGridItem.placeholder(idx % 7, idx ~/ 7));
        }
      }
    }

    return CalendarGridData._(month, year, items);
  }

  CalendarGridData._(this.month, this.year, this.items);

  final int month;
  final int year;
  final List<CalendarGridItem> items;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarGridData &&
          other.month == month &&
          other.year == year &&
          listEquals(other.items, items));

  @override
  int get hashCode => Object.hash(month, year, items);
}

class CalendarGridItem {
  CalendarGridItem(
    this.date,
    this.indexInRow,
    this.fromAnotherMonth,
    this.rowIndex,
  ) : placeholder = false;

  CalendarGridItem.placeholder(this.indexInRow, this.rowIndex)
    : date = DateTime(0),
      fromAnotherMonth = true,
      placeholder = true;

  final DateTime date;
  final int indexInRow;
  final int rowIndex;
  final bool fromAnotherMonth;
  final bool placeholder;

  bool get isToday {
    final now = DateTime.now();
    return !placeholder &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarGridItem &&
          (placeholder && other.placeholder ||
              (!placeholder &&
                  !other.placeholder &&
                  other.date.isAtSameMomentAs(date))) &&
          other.indexInRow == indexInRow &&
          other.fromAnotherMonth == fromAnotherMonth &&
          other.rowIndex == rowIndex);

  @override
  int get hashCode => Object.hash(
    placeholder ? 'p' : date,
    indexInRow,
    fromAnotherMonth,
    rowIndex,
  );
}

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    required this.data,
    required this.itemBuilder,
    super.key,
  });

  final CalendarGridData data;
  final Widget Function(CalendarGridItem item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    final weekDays = <Widget>[];

    for (int i = 0; i < 7; i++) {
      final weekday = ((i - 1) % 7) + 1;
      weekDays.add(
        MyButton(
          enabled: false,
          shape: MyButtonShape.square,
          type: MyButtonType.ghost,
          padding: EdgeInsets.zero,
          text: weekday.toDay(style: Abbreviation.semi),
        ),
      );
    }

    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDays,
      ),
    );

    for (int i = 0; i < data.items.length; i += 7) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              data.items
                  .sublist(i, i + 7)
                  .map(
                    (item) =>
                        item.placeholder ? const NoWidget() : itemBuilder(item),
                  )
                  .toList(),
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, spacing: 8, children: rows);
  }
}
