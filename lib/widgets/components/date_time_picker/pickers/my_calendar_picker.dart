import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../index.dart';

/// Theme configuration for calendar widgets.
class CalendarTheme {
  const CalendarTheme({this.arrowIconColor});

  /// Color of navigation arrow icons.
  final Color? arrowIconColor;

  CalendarTheme copyWith({ValueGetter<Color?>? arrowIconColor}) {
    return CalendarTheme(
      arrowIconColor:
          arrowIconColor == null ? this.arrowIconColor : arrowIconColor(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarTheme && other.arrowIconColor == arrowIconColor;
  }

  @override
  int get hashCode => arrowIconColor.hashCode;
}

enum CalendarViewType { date, month, year }

enum DateState { disabled, enabled }

typedef DateStateBuilder = DateState Function(DateTime date);

class MyCalendarPickerDialog extends StatefulWidget {
  const MyCalendarPickerDialog({
    required this.viewType,
    required this.selectionMode,
    super.key,
    this.viewMode,
    this.initial,
    this.onChanged,
    this.stateBuilder,
  });

  final CalendarViewType viewType;
  final CalendarSelectionMode selectionMode;
  final CalendarSelectionMode? viewMode;
  final CalendarValue? initial;
  final ValueChanged<CalendarValue?>? onChanged;
  final DateStateBuilder? stateBuilder;

  @override
  State<MyCalendarPickerDialog> createState() => _MyCalendarPickerDialogState();
}

class _MyCalendarPickerDialogState extends State<MyCalendarPickerDialog> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate =
        widget.initial?.view != null
            ? DateTime(widget.initial!.view.year, widget.initial!.view.month)
            : null;
  }

  void _handleDateChanged(CalendarValue? value) {
    if (value != null && value is SingleCalendarValue) {
      setState(() => _selectedDate = value.date);
    }
  }

  void _handleCancel() => Navigator.pop(context);
  void _handleOk() => Navigator.pop(context, _selectedDate);

  @override
  Widget build(BuildContext context) {
    final picker = Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _DatePickerDialog(
        initialViewType: widget.viewType,
        selectionMode: widget.selectionMode,
        initialValue: widget.initial,
        initialView: widget.initial?.view,
        stateBuilder: widget.stateBuilder,
        viewMode: widget.viewMode,
        onChanged: _handleDateChanged,
      ),
    );

    return MyDialogScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDialogInfoWidget(
            title: getHeaderText(),
            titleAlignment: Alignment.centerLeft,
            contentWidget: picker,
          ),
          const Gap(24),
          _horizontalButtons(context),
        ],
      ),
    );
  }

  String getHeaderText() {
    if (widget.viewType == CalendarViewType.date) {
      return 'Select Date';
    }
    if (widget.viewType == CalendarViewType.month) {
      return 'Select Month';
    }
    return 'Select Year';
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

class _DatePickerDialog extends StatefulWidget {
  const _DatePickerDialog({
    required this.initialViewType,
    required this.selectionMode,
    this.initialView,
    this.viewMode,
    this.initialValue,
    this.onChanged,
    this.stateBuilder,
  });

  final CalendarViewType initialViewType;
  final CalendarView? initialView;
  final CalendarSelectionMode selectionMode;
  final CalendarSelectionMode? viewMode;
  final CalendarValue? initialValue;
  final ValueChanged<CalendarValue?>? onChanged;
  final DateStateBuilder? stateBuilder;

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
    _view =
        widget.initialView ?? widget.initialValue?.view ?? CalendarView.now();
    _value = widget.initialValue;
    _viewType = widget.initialViewType;
    // _yearSelectStart = round year every 16 years so that it can fit 4x4 grid
    _yearSelectStart = (_view.year ~/ 16) * 16;
  }

  String getHeaderText(CalendarView view, CalendarViewType viewType) {
    if (viewType == CalendarViewType.date) {
      return '${view.month.toMonth()} ${view.year}';
    }
    if (viewType == CalendarViewType.month) {
      return '${view.year}';
    }
    return '';
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
              onTap: () {
                setState(() {
                  switch (_viewType) {
                    case CalendarViewType.date:
                      _view = _view.previous;
                    case CalendarViewType.month:
                      _view = _view.previousYear;
                    case CalendarViewType.year:
                      _yearSelectStart -= 16;
                  }
                });
              },
              icon: LucideIcons.arrowLeft,
              shape: MyButtonShape.square,
            ),
            Gap(16),
            Expanded(
              child: MyButton(
                enabled: _viewType != CalendarViewType.year,
                type: MyButtonType.ghost,
                onTap: () {
                  switch (_viewType) {
                    case CalendarViewType.date:
                      setState(() {
                        _viewType = CalendarViewType.month;
                      });
                    case CalendarViewType.month:
                      setState(() {
                        _viewType = CalendarViewType.year;
                      });
                    case CalendarViewType.year:
                      break;
                  }
                },
                text: getHeaderText(_view, _viewType),
                textStyle: context.bodyLarge,
              ),
            ),
            Gap(16),
            MyButton(
              type: MyButtonType.secondary,
              onTap: () {
                setState(() {
                  switch (_viewType) {
                    case CalendarViewType.date:
                      _view = _view.next;
                    case CalendarViewType.month:
                      _view = _view.nextYear;
                    case CalendarViewType.year:
                      _yearSelectStart += 16;
                  }
                });
              },
              icon: LucideIcons.arrowRight,
              shape: MyButtonShape.square,
            ),
          ],
        ),
        Gap(16),
        _buildView(
          context,
          _yearSelectStart,
          _view,
          _viewType,
          widget.selectionMode,
          (value) {
            setState(() {
              _view = value;
              switch (_viewType) {
                case CalendarViewType.date:
                  break;
                case CalendarViewType.month:
                  // if (widget.initialViewType != CalendarViewType.month) {
                    _viewType = CalendarViewType.date;
                  // }
                case CalendarViewType.year:
                  // if (widget.initialViewType != CalendarViewType.year) {
                    _viewType = CalendarViewType.month;
                  // }
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildView(
    BuildContext context,
    int yearSelectStart,
    CalendarView view,
    CalendarViewType viewType,
    CalendarSelectionMode selectionMode,
    ValueChanged<CalendarView> onViewChanged,
  ) {
    if (viewType == CalendarViewType.year) {
      return YearCalendar(
        value: view.year,
        yearSelectStart: yearSelectStart,
        calendarValue: _value,
        stateBuilder: widget.stateBuilder,
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
        onChanged: onViewChanged,
        stateBuilder: widget.stateBuilder,
        calendarValue: _value,
      );
    }

    return Calendar(
      value: _value,
      view: view,
      stateBuilder: widget.stateBuilder,
      onChanged: (value) {
        setState(() {
          _value = value;
          widget.onChanged?.call(value);
        });
      },
      selectionMode: selectionMode,
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

DateTime _convertNecessarry(DateTime from, int year, [int? month, int? date]) {
  if (month == null) return DateTime(from.year);

  if (date == null) return DateTime(from.year, from.month);

  return DateTime(from.year, from.month, from.day);
}

class SingleCalendarValue extends CalendarValue {
  SingleCalendarValue(this.date);
  final DateTime date;

  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = _convertNecessarry(date, year, month, day);
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

class RangeCalendarValue extends CalendarValue {
  RangeCalendarValue(DateTime start, DateTime end)
    : start = start.isBefore(end) ? start : end,
      end = start.isBefore(end) ? end : start;
  final DateTime start;
  final DateTime end;

  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime start = _convertNecessarry(this.start, year, month, day);
    final DateTime end = _convertNecessarry(this.end, year, month, day);
    final DateTime current = DateTime(year, month ?? 1, day ?? 1);

    if (current.isAtSameMomentAs(start) && current.isAtSameMomentAs(end)) {
      return CalendarValueLookup.selected;
    }

    return CalendarValueLookup.none;
  }

  @override
  CalendarView get view => start.toCalendarView();

  @override
  String toString() {
    return 'RangedCalendarValue($start, $end)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeCalendarValue &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  SingleCalendarValue toSingle() {
    return CalendarValue.single(start);
  }

  @override
  MultiCalendarValue toMulti() {
    final List<DateTime> dates = [];
    for (
      DateTime date = start;
      date.isBefore(end);
      date = date.add(const Duration(days: 1))
    ) {
      dates.add(date);
    }
    dates.add(end);
    return CalendarValue.multi(dates);
  }
}

class MultiCalendarValue extends CalendarValue {
  MultiCalendarValue(this.dates);
  final List<DateTime> dates;

  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = DateTime(year, month ?? 1, day ?? 1);
    if (dates.any(
      (element) => _convertNecessarry(
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
    final DateTime now = DateTime.now();
    return CalendarView(now.year, now.month);
  }

  factory CalendarView.fromDateTime(DateTime dateTime) {
    return CalendarView(dateTime.year, dateTime.month);
  }

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
  String toString() {
    return 'CalendarView($year, $month)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarView && other.year == year && other.month == month;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  CalendarView copyWith({ValueGetter<int>? year, ValueGetter<int>? month}) {
    return CalendarView(
      year == null ? this.year : year(),
      month == null ? this.month : month(),
    );
  }
}

extension CalendarDateTime on DateTime {
  CalendarView toCalendarView() {
    return CalendarView.fromDateTime(this);
  }

  CalendarValue toCalendarValue() {
    return CalendarValue.single(this);
  }
}

enum CalendarSelectionMode { none, single, multi }

class Calendar extends StatefulWidget {
  const Calendar({
    required this.view,
    required this.selectionMode,
    super.key,
    this.now,
    this.value,
    this.onChanged,
    this.isDateEnabled,
    this.stateBuilder,
  });

  final DateTime? now;
  final CalendarValue? value;
  final CalendarView view;
  final CalendarSelectionMode selectionMode;
  final ValueChanged<CalendarValue?>? onChanged;
  final bool Function(DateTime date)? isDateEnabled;
  final DateStateBuilder? stateBuilder;

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
    );
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view.year != widget.view.year ||
        oldWidget.view.month != widget.view.month) {
      _gridData = CalendarGridData(
        month: widget.view.month,
        year: widget.view.year,
      );
    }
  }

  void _handleTap(DateTime date) {
    final calendarValue = widget.value;
    if (widget.selectionMode == CalendarSelectionMode.none) return;

    if (widget.selectionMode == CalendarSelectionMode.single) {
      if (calendarValue is SingleCalendarValue &&
          date.isAtSameMomentAs(calendarValue.date)) {
        widget.onChanged?.call(null);
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
        final multi = calendarValue.toMulti();
        multi.dates.add(date);
        widget.onChanged?.call(multi);
        return;
      } else {
        final multi = calendarValue.toMulti();
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
        final DateTime date = item.date;
        final CalendarValueLookup lookup =
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

        final Widget calendarItem = CalendarItem(
          type: type,
          indexAtRow: item.indexInRow,
          rowCount: 7,
          onTap: () => _handleTap(date),
          state: widget.stateBuilder?.call(date) ?? DateState.enabled,
          text: '${date.day}',
        );

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
  });

  final CalendarView value;
  final ValueChanged<CalendarView> onChanged;
  final DateTime? now;
  final CalendarValue? calendarValue;
  final DateStateBuilder? stateBuilder;

  @override
  Widget build(BuildContext context) {
    // same as Calendar, but instead of showing date
    // it shows month in a 4x3 grid
    final List<Widget> rows = [];
    final List<Widget> months = [];
    for (int i = 1; i <= 12; i++) {
      final DateTime date = DateTime(value.year, i);
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
      months.add(
        CalendarItem(
          key: ValueKey(date),
          type: type,
          indexAtRow: (i - 1) % 4,
          rowCount: 4,
          onTap: () => onChanged(value.copyWith(month: () => i)),
          state: stateBuilder?.call(date) ?? DateState.enabled,
          text: i.toMonth(style: Abbreviation.semi),
        ),
      );
    }
    for (int i = 0; i < months.length; i += 4) {
      rows
        ..add(Gap(8))
        ..add(Row(children: months.sublist(i, i + 4)));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

class YearCalendar extends StatelessWidget {
  const YearCalendar({
    required this.yearSelectStart,
    required this.value,
    required this.onChanged,
    super.key,
    this.now,
    this.calendarValue,
    this.stateBuilder,
  });

  final int yearSelectStart;
  final int value;
  final ValueChanged<int> onChanged;
  final DateTime? now;
  final CalendarValue? calendarValue;
  final DateStateBuilder? stateBuilder;

  @override
  Widget build(BuildContext context) {
    // same as Calendar, but instead of showing date
    // it shows year in a 4x4 grid
    final List<Widget> rows = [];
    final List<Widget> years = [];
    for (int i = yearSelectStart; i < yearSelectStart + 16; i++) {
      final DateTime date = DateTime(i);
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
      years.add(
        CalendarItem(
          key: ValueKey(date),
          type: type,
          indexAtRow: (i - yearSelectStart) % 4,
          rowCount: 4,
          onTap: () => onChanged(i),
          state: stateBuilder?.call(date) ?? DateState.enabled,
          text: '$i',
        ),
      );
    }
    for (int i = 0; i < years.length; i += 4) {
      rows
        ..add(Gap(8))
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
    final type = this.type;

    switch (type) {
      case CalendarItemType.none:
        return MyButton(
          type: MyButtonType.ghost,
          enabled: state == DateState.enabled,
          shape: MyButtonShape.square,
          onTap: onTap,
          text: text,
          width: rowCount < 5 ? 270 / rowCount : null,
        );
      case CalendarItemType.today:
        return MyButton(
          enabled: state == DateState.enabled,
          shape: MyButtonShape.square,
          onTap: onTap,
          text: text,
          width: rowCount < 5 ? 270 / rowCount : null,
        );
      case CalendarItemType.selected:
        return MyButton(
          enabled: state == DateState.enabled,
          shape: MyButtonShape.square,
          onTap: onTap,
          text: text,
          width: rowCount < 5 ? 270 / rowCount : null,
        );
    }
  }
}

class CalendarGridData {
  factory CalendarGridData({required int month, required int year}) {
    final DateTime firstDayOfMonth = DateTime(year, month);
    final int daysInMonth = DateTime(year, month == 12 ? 1 : month + 1, 0).day;

    final int prevMonthDays = firstDayOfMonth.weekday;
    final DateTime prevMonthLastDay = firstDayOfMonth.subtract(
      Duration(days: prevMonthDays),
    );

    final List<CalendarGridItem> items = [];

    int itemCount = 0;

    if (prevMonthDays < 7) {
      for (int i = 0; i < prevMonthDays; i++) {
        final int currentItemIndex = itemCount++;
        items.add(
          CalendarGridItem(
            prevMonthLastDay.add(Duration(days: i)),
            currentItemIndex % 7,
            true,
            currentItemIndex ~/ 7,
          ),
        );
      }
    }

    for (int i = 0; i < daysInMonth; i++) {
      final int currentItemIndex = itemCount++;
      final DateTime currentDay = DateTime(year, month, i + 1);
      items.add(
        CalendarGridItem(
          currentDay,
          currentItemIndex % 7,
          false,
          currentItemIndex ~/ 7,
        ),
      );
    }

    final int remainingDays = (7 - (items.length % 7)) % 7;
    final DateTime nextMonthFirstDay = DateTime(year, month + 1);

    if (remainingDays < 7) {
      for (int i = 0; i < remainingDays; i++) {
        final int currentItemIndex = itemCount++;
        items.add(
          CalendarGridItem(
            nextMonthFirstDay.add(Duration(days: i)),
            currentItemIndex % 7,
            true,
            currentItemIndex ~/ 7,
          ),
        );
      }
    }

    return CalendarGridData._(month, year, items);
  }

  CalendarGridData._(this.month, this.year, this.items);

  final int month;
  final int year;
  final List<CalendarGridItem> items;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarGridData &&
        other.month == month &&
        other.year == year &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode => Object.hash(month, year, items);
}

class CalendarGridItem {
  CalendarGridItem(
    this.date,
    this.indexInRow,
    this.fromAnotherMonth,
    this.rowIndex,
  );
  final DateTime date;
  final int indexInRow;
  final int rowIndex;
  final bool fromAnotherMonth;

  bool get isToday {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarGridItem &&
        other.date.isAtSameMomentAs(date) &&
        other.indexInRow == indexInRow &&
        other.fromAnotherMonth == fromAnotherMonth &&
        other.rowIndex == rowIndex;
  }

  @override
  int get hashCode => Object.hash(date, indexInRow, fromAnotherMonth, rowIndex);
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
    final List<Widget> rows = [];
    final List<Widget> weekDays = [];
    for (int i = 0; i < 7; i++) {
      final int weekday = ((i - 1) % 7) + 1;
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
          children: data.items.sublist(i, i + 7).map(itemBuilder).toList(),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 8, children: rows);
  }
}
