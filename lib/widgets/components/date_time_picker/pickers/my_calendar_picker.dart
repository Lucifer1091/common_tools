import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../index.dart';

enum MyCalendarViewType { date, month, year }

enum MyCalendarSelectionMode { none, single, multi }

enum MyDateState { disabled, enabled }

typedef MyDateStateBuilder = MyDateState Function(DateTime date);

class MyYearPickerDialog extends StatefulWidget {
  const MyYearPickerDialog({
    required this.initialYear,
    super.key,
    this.firstDate,
    this.lastDate,
    this.stateBuilder,
  });

  final int initialYear;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final MyDateStateBuilder? stateBuilder;

  @override
  State<MyYearPickerDialog> createState() => _MyYearPickerDialogState();
}

class _MyYearPickerDialogState extends State<MyYearPickerDialog> {
  late int _yearSelectStart;
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
                    MyButton(
                      type: MyButtonType.secondary,
                      shape: MyButtonShape.square,
                      icon: LucideIcons.arrowLeft,
                      onTap: _prev,
                    ),
                    const Gap(16),
                    Expanded(
                      child: MyButton(
                        type: MyButtonType.ghost,
                        enabled: false,
                        text: '$_yearSelectStart – ${_yearSelectStart + 15}',
                      ),
                    ),
                    const Gap(16),
                    MyButton(
                      type: MyButtonType.secondary,
                      shape: MyButtonShape.square,
                      icon: LucideIcons.arrowRight,
                      onTap: _next,
                    ),
                  ],
                ),
                const Gap(16),
                _YearCalendar(
                  value: _focusYear,
                  now: DateTime.now(),
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

class MyMonthPickerDialog extends StatefulWidget {
  const MyMonthPickerDialog({
    required this.initialMonth,
    super.key,
    this.firstDate,
    this.lastDate,
    this.stateBuilder,
  });

  final DateTime initialMonth;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final MyDateStateBuilder? stateBuilder;

  @override
  State<MyMonthPickerDialog> createState() => _MyMonthPickerDialogState();
}

class _MyMonthPickerDialogState extends State<MyMonthPickerDialog> {
  late _CalendarView _view;

  bool get _atFirstYear =>
      widget.firstDate != null && _view.year <= widget.firstDate!.year;

  bool get _atLastYear =>
      widget.lastDate != null && _view.year >= widget.lastDate!.year;

  @override
  void initState() {
    super.initState();
    _view = _CalendarView(widget.initialMonth.year, widget.initialMonth.month);
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
                    MyButton(
                      type: MyButtonType.secondary,
                      shape: MyButtonShape.square,
                      icon: LucideIcons.arrowLeft,
                      onTap: _prev,
                    ),
                    const Gap(16),
                    Expanded(
                      child: MyButton(
                        type: MyButtonType.ghost,
                        enabled: false,
                        text: '${_view.year}',
                      ),
                    ),
                    const Gap(16),
                    MyButton(
                      type: MyButtonType.secondary,
                      shape: MyButtonShape.square,
                      icon: LucideIcons.arrowRight,
                      onTap: _next,
                    ),
                  ],
                ),
                const Gap(16),
                _MonthCalendar(
                  value: _view,
                  calendarValue:
                      DateTime(_view.year, _view.month).toCalendarValue(),
                  now: DateTime.now(),
                  stateBuilder: widget.stateBuilder,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onChanged: (_CalendarView nextView) {
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
  });

  final MyCalendarSelectionMode selectionMode;
  final CalendarValue? initial;
  final ValueChanged<CalendarValue?>? onChanged;
  final MyDateStateBuilder? stateBuilder;
  final int? min;
  final int? max;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showOutsideDays;

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
  });

  final CalendarValue? initialValue;
  final MyCalendarSelectionMode selectionMode;
  final ValueChanged<CalendarValue?>? onChanged;
  final MyDateStateBuilder? stateBuilder;
  final int? min;
  final int? max;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showOutsideDays;

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  late _CalendarView _view;
  late CalendarValue? _value;
  late MyCalendarViewType _viewType;
  late int _yearSelectStart;

  @override
  void initState() {
    super.initState();
    _view = widget.initialValue?.view ?? _CalendarView.now();
    _value = widget.initialValue;
    _viewType = MyCalendarViewType.date;
    _yearSelectStart = (_view.year ~/ 16) * 16; // 4x4 year pages
    // Clamp starting view within first/lastDate for sanity
    if (widget.firstDate != null &&
        _view.asDate().isBeforeMonth(widget.firstDate!)) {
      _view = _CalendarView(widget.firstDate!.year, widget.firstDate!.month);
    }
    if (widget.lastDate != null &&
        _view.asDate().isAfterMonth(widget.lastDate!)) {
      _view = _CalendarView(widget.lastDate!.year, widget.lastDate!.month);
    }
  }

  String _headerLabel(_CalendarView v, MyCalendarViewType t) => switch (t) {
    MyCalendarViewType.date => '${v.month.toMonth()} ${v.year}',
    MyCalendarViewType.month => '${v.year}',
    MyCalendarViewType.year => '',
  };

  bool get _atFirstMonth =>
      widget.firstDate != null &&
      !_CalendarView(
        widget.firstDate!.year,
        widget.firstDate!.month,
      ).isBeforeOrSameMonth(_view);

  bool get _atLastMonth =>
      widget.lastDate != null &&
      !_CalendarView(
        widget.lastDate!.year,
        widget.lastDate!.month,
      ).isAfterOrSameMonth(_view);

  void _goPrev() {
    setState(() {
      switch (_viewType) {
        case MyCalendarViewType.date:
          if (_atFirstMonth) return;
          _view = _view.previous;
        case MyCalendarViewType.month:
          if (widget.firstDate != null) {
            if (_view.year - 1 < widget.firstDate!.year) return;
          }
          _view = _view.previousYear;
        case MyCalendarViewType.year:
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
        case MyCalendarViewType.date:
          if (_atLastMonth) return;
          _view = _view.next;
        case MyCalendarViewType.month:
          if (widget.lastDate != null) {
            if (_view.year + 1 > widget.lastDate!.year) return;
          }
          _view = _view.nextYear;
        case MyCalendarViewType.year:
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
    if (_viewType == MyCalendarViewType.year) return;
    setState(() {
      _viewType =
          _viewType == MyCalendarViewType.date
              ? MyCalendarViewType.month
              : MyCalendarViewType.year;
    });
  }

  void _handleCalendarChanged(CalendarValue? value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            MyButton(
              type: MyButtonType.secondary,
              onTap: _goPrev,
              icon: LucideIcons.arrowLeft,
              shape: MyButtonShape.square,
            ),
            const Gap(16),
            Expanded(
              child: MyButton(
                enabled: _viewType != MyCalendarViewType.year,
                type: MyButtonType.ghost,
                onTap: _promoteView,
                text: _headerLabel(_view, _viewType),
                textStyle: context.bodyLarge,
              ),
            ),
            const Gap(16),
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
                case MyCalendarViewType.date:
                  break;
                case MyCalendarViewType.month:
                  _viewType = MyCalendarViewType.date;
                case MyCalendarViewType.year:
                  _viewType = MyCalendarViewType.month;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildView({
    required int yearSelectStart,
    required _CalendarView view,
    required MyCalendarViewType viewType,
    required MyCalendarSelectionMode selectionMode,
    required ValueChanged<_CalendarView> onViewChanged,
  }) {
    if (viewType == MyCalendarViewType.year) {
      return _YearCalendar(
        value: view.year,
        calendarValue: _value,
        now: DateTime.now(),
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

    if (viewType == MyCalendarViewType.month) {
      return _MonthCalendar(
        value: view,
        calendarValue: _value,
        now: DateTime.now(),
        stateBuilder: widget.stateBuilder,
        onChanged: onViewChanged,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      );
    }

    return _Calendar(
      value: _value,
      view: view,
      now: DateTime.now(),
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

  _CalendarValueLookup lookup(int year, [int? month = 1, int? day = 1]);

  static SingleCalendarValue single(DateTime date) {
    return SingleCalendarValue(date);
  }

  static MultiCalendarValue multi(List<DateTime> dates) {
    return MultiCalendarValue(dates);
  }

  SingleCalendarValue toSingle();
  MultiCalendarValue toMulti();

  _CalendarView get view;
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
  _CalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = _convertNecessary(date, year, month, day);
    if (current.isAtSameMomentAs(DateTime(year, month ?? 1, day ?? 1))) {
      return _CalendarValueLookup.selected;
    }
    return _CalendarValueLookup.none;
  }

  @override
  _CalendarView get view => date.toCalendarView();

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
  _CalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = DateTime(year, month ?? 1, day ?? 1);
    if (dates.any(
      (element) => _convertNecessary(
        element,
        year,
        month,
        day,
      ).isAtSameMomentAs(current),
    )) {
      return _CalendarValueLookup.selected;
    }
    return _CalendarValueLookup.none;
  }

  @override
  _CalendarView get view =>
      dates.firstOrNull?.toCalendarView() ?? _CalendarView.now();

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

enum _CalendarValueLookup { none, selected }

class _CalendarView {
  _CalendarView(this.year, this.month)
    : assert(month >= 1 && month <= 12, 'Month must be between 1 and 12');

  factory _CalendarView.now() {
    final now = DateTime.now();
    return _CalendarView(now.year, now.month);
  }

  factory _CalendarView.fromDateTime(DateTime date) =>
      _CalendarView(date.year, date.month);

  final int year;
  final int month;

  _CalendarView get next {
    if (month == 12) {
      return _CalendarView(year + 1, 1);
    }
    return _CalendarView(year, month + 1);
  }

  _CalendarView get previous {
    if (month == 1) {
      return _CalendarView(year - 1, 12);
    }
    return _CalendarView(year, month - 1);
  }

  _CalendarView get nextYear {
    return _CalendarView(year + 1, month);
  }

  _CalendarView get previousYear {
    return _CalendarView(year - 1, month);
  }

  @override
  String toString() => 'CalendarView($year, $month)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _CalendarView && other.year == year && other.month == month);

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  _CalendarView copyWith({ValueGetter<int>? year, ValueGetter<int>? month}) =>
      _CalendarView(
        year == null ? this.year : year(),
        month == null ? this.month : month(),
      );

  DateTime asDate() => DateTime(year, month);

  bool isBeforeOrSameMonth(_CalendarView other) {
    if (year < other.year) return true;
    if (year > other.year) return false;
    return month <= other.month;
  }

  bool isAfterOrSameMonth(_CalendarView other) {
    if (year > other.year) return true;
    if (year < other.year) return false;
    return month >= other.month;
  }
}

extension _DateHelpers on DateTime {
  _CalendarView toCalendarView() => _CalendarView.fromDateTime(this);
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

class _Calendar extends StatefulWidget {
  const _Calendar({
    required this.view,
    required this.selectionMode,
    this.value,
    this.onChanged,
    this.stateBuilder,
    this.min,
    this.max,
    this.now,
    this.firstDate,
    this.lastDate,
    this.showOutsideDays = true,
  });

  final CalendarValue? value;
  final _CalendarView view;
  final DateTime? now;
  final MyCalendarSelectionMode selectionMode;
  final ValueChanged<CalendarValue?>? onChanged;
  final MyDateStateBuilder? stateBuilder;
  final int? min;
  final int? max;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showOutsideDays;

  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  late _CalendarGridData _gridData;

  @override
  void initState() {
    super.initState();
    _gridData = _CalendarGridData(
      month: widget.view.month,
      year: widget.view.year,
      showOutsideDays: widget.showOutsideDays,
    );
  }

  @override
  void didUpdateWidget(covariant _Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view.year != widget.view.year ||
        oldWidget.view.month != widget.view.month ||
        oldWidget.showOutsideDays != widget.showOutsideDays) {
      _gridData = _CalendarGridData(
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
    final state = widget.stateBuilder?.call(date) ?? MyDateState.enabled;
    if (state == MyDateState.disabled) return false;

    // MULTI: cap logic – if at cap, only allow toggling already selected.
    if (widget.selectionMode == MyCalendarSelectionMode.multi &&
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
    if (widget.selectionMode == MyCalendarSelectionMode.none) return;

    if (widget.selectionMode == MyCalendarSelectionMode.single) {
      if (!_enabled(date)) return;

      if (calendarValue is SingleCalendarValue &&
          date.isAtSameMomentAs(calendarValue.date)) {
        if (_canDeselectSingle(date)) widget.onChanged?.call(null);
        return;
      }
      widget.onChanged?.call(CalendarValue.single(date));
      return;
    }

    if (widget.selectionMode == MyCalendarSelectionMode.multi) {
      if (calendarValue == null) {
        widget.onChanged?.call(CalendarValue.single(date));
        return;
      }

      final lookup = calendarValue.lookup(date.year, date.month, date.day);

      if (lookup == _CalendarValueLookup.none) {
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
    return _CalendarGrid(
      data: _gridData,
      itemBuilder: (item) {
        final date = item.date;

        final inBounds = _withinBounds(date);
        final lookup =
            widget.value?.lookup(date.year, date.month, date.day) ??
            _CalendarValueLookup.none;

        _CalendarItemType type = _CalendarItemType.none;
        switch (lookup) {
          case _CalendarValueLookup.none:
            if (widget.now != null &&
                DateTime(
                  widget.now!.year,
                  widget.now!.month,
                  widget.now!.day,
                ).isAtSameMomentAs(date)) {
              type = _CalendarItemType.today;
            }
          case _CalendarValueLookup.selected:
            type = _CalendarItemType.selected;
        }

        final enabled = _enabled(date) && inBounds;

        final calendarItem = _CalendarItem(
          type: type,
          indexAtRow: item.indexInRow,
          rowCount: 7,
          onTap: enabled ? () => _handleTap(date) : null,
          state: enabled ? MyDateState.enabled : MyDateState.disabled,
          text: '${date.day}',
        );

        if (item.fromAnotherMonth && !widget.showOutsideDays) {
          return const SizedBox.shrink();
        }

        if (item.fromAnotherMonth) {
          return Opacity(opacity: 0.5, child: calendarItem);
        }

        return calendarItem;
      },
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.value,
    required this.onChanged,
    this.now,
    this.calendarValue,
    this.stateBuilder,
    this.firstDate,
    this.lastDate,
  });

  final _CalendarView value;
  final ValueChanged<_CalendarView> onChanged;
  final DateTime? now;
  final CalendarValue? calendarValue;
  final MyDateStateBuilder? stateBuilder;
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
    final state = stateBuilder?.call(date) ?? MyDateState.enabled;
    if (state == MyDateState.disabled) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    final months = <Widget>[];

    for (int i = 1; i <= 12; i++) {
      final date = DateTime(value.year, i);

      _CalendarItemType type = _CalendarItemType.none;
      if (calendarValue != null) {
        final lookup = calendarValue!.lookup(date.year, date.month);
        switch (lookup) {
          case _CalendarValueLookup.none:
            if (now != null &&
                DateTime(now!.year, now!.month).isAtSameMomentAs(date)) {
              type = _CalendarItemType.today;
            }
          case _CalendarValueLookup.selected:
            type = _CalendarItemType.selected;
        }
      } else {
        if (now != null &&
            DateTime(now!.year, now!.month).isAtSameMomentAs(date)) {
          type = _CalendarItemType.today;
        }
      }

      final enabled = _enabled(date);

      months.add(
        _CalendarItem(
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
          state: enabled ? MyDateState.enabled : MyDateState.disabled,
          text: i.toMonth(style: Abbreviation.semi),
        ),
      );
    }

    for (int i = 0; i < months.length; i += 4) {
      rows
        ..add(const Gap(8))
        ..add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: months.sublist(i, i + 4),
          ),
        );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

class _YearCalendar extends StatelessWidget {
  const _YearCalendar({
    required this.value,
    required this.yearSelectStart,
    required this.onChanged,
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
  final MyDateStateBuilder? stateBuilder;
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
    final state = stateBuilder?.call(date) ?? MyDateState.enabled;
    return state != MyDateState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    final years = <Widget>[];

    for (int i = yearSelectStart; i < yearSelectStart + 16; i++) {
      final date = DateTime(i);

      _CalendarItemType type = _CalendarItemType.none;

      if (calendarValue != null) {
        final lookup = calendarValue!.lookup(date.year);
        switch (lookup) {
          case _CalendarValueLookup.none:
            if (now != null && now!.year == date.year) {
              type = _CalendarItemType.today;
            }
          case _CalendarValueLookup.selected:
            type = _CalendarItemType.selected;
        }
      } else {
        if (now != null && now!.year == date.year) {
          type = _CalendarItemType.today;
        }
      }

      final enabled = _enabled(date);

      years.add(
        _CalendarItem(
          key: ValueKey(date),
          type: type,
          indexAtRow: (i - yearSelectStart) % 4,
          rowCount: 4,
          onTap: enabled ? () => onChanged(date.year) : null,
          state: enabled ? MyDateState.enabled : MyDateState.disabled,
          text: '$i',
        ),
      );
    }

    for (int i = 0; i < years.length; i += 4) {
      rows
        ..add(const Gap(8))
        ..add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: years.sublist(i, i + 4),
          ),
        );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

enum _CalendarItemType { none, today, selected }

class _CalendarItem extends StatelessWidget {
  const _CalendarItem({
    required this.text,
    required this.type,
    required this.indexAtRow,
    required this.rowCount,
    required this.state,
    super.key,
    this.onTap,
  });

  final String text;
  final _CalendarItemType type;
  final VoidCallback? onTap;
  final int indexAtRow;
  final int rowCount;
  final MyDateState state;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      type: switch (type) {
        _CalendarItemType.none => MyButtonType.ghost,
        _CalendarItemType.selected => MyButtonType.primary,
        _CalendarItemType.today => MyButtonType.outline,
      },
      enabled: state == MyDateState.enabled,
      shape: MyButtonShape.square,
      onTap: onTap,
      text: text,
      width: rowCount < 5 ? 260 / rowCount : null,
    );
  }
}

class _CalendarGridData {
  factory _CalendarGridData({
    required int month,
    required int year,
    required bool showOutsideDays,
  }) {
    final firstDayOfMonth = DateTime(year, month);
    final daysInMonth = DateTime(year, month == 12 ? 1 : month + 1, 0).day;

    final leading = firstDayOfMonth.weekday;
    final prevMonthLastDay = firstDayOfMonth.subtract(Duration(days: leading));

    final items = <_CalendarGridItem>[];
    var itemCount = 0;

    if (showOutsideDays) {
      if (leading < 7) {
        for (int i = 0; i < leading; i++) {
          final idx = itemCount++;
          items.add(
            _CalendarGridItem(
              prevMonthLastDay.add(Duration(days: i)),
              idx % 7,
              true,
              idx ~/ 7,
            ),
          );
        }
      }
    } else {
      if (leading < 7) {
        for (int i = 0; i < leading; i++) {
          final idx = itemCount++;
          items.add(_CalendarGridItem.placeholder(idx % 7, idx ~/ 7));
        }
      }
    }

    for (int i = 0; i < daysInMonth; i++) {
      final idx = itemCount++;
      final day = DateTime(year, month, i + 1);
      items.add(_CalendarGridItem(day, idx % 7, false, idx ~/ 7));
    }

    final remaining = (7 - (items.length % 7)) % 7;
    final nextMonthFirstDay = DateTime(year, month + 1);

    if (showOutsideDays) {
      if (remaining < 7) {
        for (int i = 0; i < remaining; i++) {
          final idx = itemCount++;
          items.add(
            _CalendarGridItem(
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
          items.add(_CalendarGridItem.placeholder(idx % 7, idx ~/ 7));
        }
      }
    }

    return _CalendarGridData._(month, year, items);
  }

  _CalendarGridData._(this.month, this.year, this.items);

  final int month;
  final int year;
  final List<_CalendarGridItem> items;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _CalendarGridData &&
          other.month == month &&
          other.year == year &&
          listEquals(other.items, items));

  @override
  int get hashCode => Object.hash(month, year, items);
}

class _CalendarGridItem {
  _CalendarGridItem(
    this.date,
    this.indexInRow,
    this.fromAnotherMonth,
    this.rowIndex,
  ) : placeholder = false;

  _CalendarGridItem.placeholder(this.indexInRow, this.rowIndex)
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
      (other is _CalendarGridItem &&
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

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.data, required this.itemBuilder});

  final _CalendarGridData data;
  final Widget Function(_CalendarGridItem item) itemBuilder;

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
                        item.placeholder
                            ? SizedBox(width: 1300 / data.items.length)
                            : itemBuilder(item),
                  )
                  .toList(),
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, spacing: 8, children: rows);
  }
}
