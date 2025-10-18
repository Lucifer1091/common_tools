import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../../../../../../index.dart';

String _formatRangeStartDate(
  MaterialLocalizations localizations,
  DateTime? startDate,
  DateTime? endDate,
) {
  return startDate == null
      ? localizations.dateRangeStartLabel
      : (endDate == null || startDate.year == endDate.year)
      ? localizations.formatShortMonthDay(startDate)
      : localizations.formatShortDate(startDate);
}

String _formatRangeEndDate(
  MaterialLocalizations localizations,
  DateTime? startDate,
  DateTime? endDate,
  DateTime currentDate,
) {
  return endDate == null
      ? localizations.dateRangeEndLabel
      : (startDate != null &&
          startDate.year == endDate.year &&
          startDate.year == currentDate.year)
      ? localizations.formatShortMonthDay(endDate)
      : localizations.formatShortDate(endDate);
}

class MyDateRangePickerDialog extends StatefulWidget {
  const MyDateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.initialDateRange,
    this.currentDate,
    this.selectableDayPredicate,
    this.restorationId,
    this.showQuickSelector,
  });

  final DateTimeRange? initialDateRange;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? currentDate;
  final String? restorationId;
  final SelectableDayForRangePredicate? selectableDayPredicate;
  final bool? showQuickSelector;

  @override
  State<MyDateRangePickerDialog> createState() =>
      _MyDateRangePickerDialogState();
}

class _MyDateRangePickerDialogState extends State<MyDateRangePickerDialog>
    with RestorationMixin {
  late final RestorableDateTimeN _selectedStart = RestorableDateTimeN(
    widget.initialDateRange?.start,
  );
  late final RestorableDateTimeN _selectedEnd = RestorableDateTimeN(
    widget.initialDateRange?.end,
  );
  final RestorableBool _autoValidate = RestorableBool(false);
  final GlobalKey _calendarPickerKey = GlobalKey();

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedStart, 'selected_start');
    registerForRestoration(_selectedEnd, 'selected_end');
    registerForRestoration(_autoValidate, 'autovalidate');
  }

  @override
  void dispose() {
    _selectedStart.dispose();
    _selectedEnd.dispose();
    _autoValidate.dispose();
    super.dispose();
  }

  void _handleOk() {
    final DateTimeRange? selectedRange =
        _hasSelectedDateRange
            ? DateTimeRange(
              start: _selectedStart.value!,
              end: _selectedEnd.value!,
            )
            : null;

    Navigator.pop(context, selectedRange);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleStartDateChanged(DateTime? date) {
    setState(() => _selectedStart.value = date);
  }

  void _handleEndDateChanged(DateTime? date) {
    setState(() => _selectedEnd.value = date);
  }

  void _handleDateRangeChanged(DateTimeRange? range) {
    setState(() {
      _selectedStart.value = range?.start;
      _selectedEnd.value = range?.end;
    });
  }

  bool get _hasSelectedDateRange =>
      _selectedStart.value != null && _selectedEnd.value != null;

  @override
  Widget build(BuildContext context) {
    final Widget contents = _CalendarRangePickerDialog(
      showQuickSelector: widget.showQuickSelector,
      key: _calendarPickerKey,
      selectedStartDate: _selectedStart.value,
      selectedEndDate: _selectedEnd.value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      selectableDayPredicate: widget.selectableDayPredicate,
      currentDate: widget.currentDate,
      onStartDateChanged: _handleStartDateChanged,
      onEndDateChanged: _handleEndDateChanged,
      onRangeChanged: _handleDateRangeChanged,
      onConfirm: _hasSelectedDateRange ? _handleOk : null,
      onCancel: _handleCancel,
    );

    return MyDialogScaffold(
      width: double.maxFinite,
      margin: EdgeInsets.zero,
      radius: BorderRadius.zero,
      body: contents,
    );
  }
}

class _CalendarRangePickerDialog extends StatelessWidget {
  const _CalendarRangePickerDialog({
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onRangeChanged,
    required this.onConfirm,
    required this.onCancel,
    required this.selectableDayPredicate,
    super.key,
    this.showQuickSelector,
  });

  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayForRangePredicate? selectableDayPredicate;
  final DateTime? currentDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final ValueChanged<DateTimeRange?> onRangeChanged;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool? showQuickSelector;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );

    final Color headerForeground = context.colorScheme.foreground;

    final Color headerDisabledForeground = headerForeground.withValues(
      alpha: 0.38,
    );

    final TextStyle headlineStyle = context.textTheme.headlineSmall;

    final String startDateText = _formatRangeStartDate(
      localizations,
      selectedStartDate,
      selectedEndDate,
    );

    final String endDateText = _formatRangeEndDate(
      localizations,
      selectedStartDate,
      selectedEndDate,
      Date.now(),
    );

    final TextStyle startDateStyle = headlineStyle.apply(
      color:
          selectedStartDate != null
              ? headerForeground
              : headerDisabledForeground,
    );

    final TextStyle endDateStyle = headlineStyle.apply(
      color:
          selectedEndDate != null ? headerForeground : headerDisabledForeground,
    );

    final left = MyDialogButtonOptions(
      title: 'Cancel',
      type: MyButtonType.outline,
      action: onCancel,
    );

    final right = MyDialogButtonOptions(
      title: 'OK',
      titleColor: context.colorScheme.primaryForeground,
      action: onConfirm,
    );

    return Column(
      children: [
        Expanded(
          child: MyDialogInfoWidget(
            fullscreen: true,
            titleAlignment: Alignment.centerLeft,
            title: 'Select Range',
            contentWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Gap(8),
                    Row(
                      children: <Widget>[
                        MyText(
                          startDateText,
                          style: startDateStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        MyText(' – ', style: startDateStyle),
                        Flexible(
                          child: MyText(
                            endDateText,
                            style: endDateStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                  ],
                ),
                Expanded(
                  child: _CalendarDateRangePicker(
                    initialStartDate: selectedStartDate,
                    initialEndDate: selectedEndDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    currentDate: currentDate,
                    onStartDateChanged: onStartDateChanged,
                    onEndDateChanged: onEndDateChanged,
                    onRangeChanged: onRangeChanged,
                    selectableDayPredicate: selectableDayPredicate,
                    showQuickSelector: showQuickSelector,
                  ),
                ),
              ],
            ),
          ),
        ),
        MyDialogShrinkButtons(leftBtn: left, rightBtn: right),
      ],
    );
  }
}

class _QuickSelectorWidget extends StatelessWidget {
  const _QuickSelectorWidget({
    required this.child,
    required this.selected,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.showQuickSelector,
  });

  final Widget child;
  final DateTimeRange? selected;
  final bool? showQuickSelector;
  final ValueChanged<DateTimeRange?> onChanged;

  // NEW: bounds from the calendar so we can filter presets safely.
  final DateTime firstDate;
  final DateTime lastDate;

  static final List<MyQuickDateRange> _ranges = [
    const MyQuickDateRange(label: 'Clear', range: null),
    MyQuickDateRange(
      label: 'Last 3 days',
      range: DateTimeRange(
        start: Date.now().subtractDays(3).truncateTime(),
        end: Date.yesterday().truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last 7 days',
      range: DateTimeRange(
        start: Date.now().subtractDays(7).truncateTime(),
        end: Date.yesterday().truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last 15 days',
      range: DateTimeRange(
        start: Date.now().subtractDays(15).truncateTime(),
        end: Date.yesterday().truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last 30 days',
      range: DateTimeRange(
        start: Date.now().subtractDays(30).truncateTime(),
        end: Date.yesterday().truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'This Month',
      range: DateTimeRange(
        start: Date.now().startOfMonth.truncateTime(),
        end: Date.now().truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last Month',
      range: DateTimeRange(
        start: Date.now().previousMonth.startOfMonth.truncateTime(),
        end: Date.now().startOfMonth.subtractDays(1).truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last 3 Months',
      range: DateTimeRange(
        start: Date.now().subtractMonths(3).startOfMonth.truncateTime(),
        end:
            Date.now().startOfMonth
                .subtract(const Duration(days: 1))
                .truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last 6 Months',
      range: DateTimeRange(
        start: Date.now().subtractMonths(6).startOfMonth.truncateTime(),
        end: Date.now().startOfMonth.subtractDays(1).truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'This Year',
      range: DateTimeRange(
        start: Date.now().startOfYear.truncateTime(),
        end: Date.now().truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last Year',
      range: DateTimeRange(
        start: Date.now().previousYear.startOfYear.truncateTime(),
        end: Date.now().previousYear.endOfYear.truncateTime(),
      ),
    ),
  ];

  List<MyQuickDateRange> get _filteredRanges {
    final DateTime min = DateUtils.dateOnly(firstDate);
    final DateTime max = DateUtils.dateOnly(lastDate);

    bool inBounds(DateTimeRange r) {
      final start = DateUtils.dateOnly(r.start);
      final end = DateUtils.dateOnly(r.end);
      // inclusive bounds
      return !start.isBefore(min) && !end.isAfter(max);
    }

    return _ranges
        .where((q) {
          if (q.range == null) return true; // "Clear" is always allowed
          return inBounds(q.range!);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return buildTablet(context);
    // return Responsive(
    //   mobile: (context) => buildMobile(),
    //   tabletSmall: (context) => buildTablet(context),
    //   tablet: (context) => buildTablet(context),
    // );
    // return buildMobile();
    // return Responsive(
    //   mobile: (context) => buildMobile(),
    //   tabletSmall: (context) => buildTablet(context),
    //   tablet: (context) => buildTablet(context),
    // );
  }

  Row buildTablet(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showQuickSelector ?? true) ...[
          Container(
            width: 145,
            padding: const EdgeInsets.only(right: 16),
            child: MyQuickSelectorWidget(
              selected: selected,
              ranges: _filteredRanges,
              onChanged: onChanged,
            ),
          ),
          Container(
            width: 2,
            color: context.colorScheme.border,
            height: double.infinity,
            margin: const EdgeInsets.only(right: 16),
          ),
        ],
        child.expanded(),
      ],
    );
  }

  Column buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showQuickSelector ?? true) ...[
          Padding(
            padding: const EdgeInsets.all(12).except(bottom: 4),
            child: MyQuickSelectorWidget(
              selected: selected,
              ranges: _filteredRanges,
              onChanged: onChanged,
              showChips: true,
            ),
          ),
        ],
        child.expanded(),
      ],
    );
  }
}

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _monthItemHeaderHeight = 58;
const double _monthItemFooterHeight = 12;
const double _monthItemRowHeight = 42;
const double _monthItemSpaceBetweenRows = 8;
const double _horizontalPadding = 8;
const double _maxCalendarWidthLandscape = 384;
const double _maxCalendarWidthPortrait = 480;

class _CalendarDateRangePicker extends StatefulWidget {
  _CalendarDateRangePicker({
    required DateTime firstDate,
    required DateTime lastDate,
    required this.selectableDayPredicate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onRangeChanged,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? currentDate,
    this.showQuickSelector,
  }) : initialStartDate =
           initialStartDate != null
               ? DateUtils.dateOnly(initialStartDate)
               : null,
       initialEndDate =
           initialEndDate != null ? DateUtils.dateOnly(initialEndDate) : null,
       firstDate = DateUtils.dateOnly(firstDate),
       lastDate = DateUtils.dateOnly(lastDate),
       currentDate = DateUtils.dateOnly(currentDate ?? Date.now()) {
    assert(
      this.initialStartDate == null ||
          this.initialEndDate == null ||
          !this.initialStartDate!.isAfter(initialEndDate!),
      'initialStartDate must be on or before initialEndDate.',
    );
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'firstDate must be on or before lastDate.',
    );
  }

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayForRangePredicate? selectableDayPredicate;
  final DateTime currentDate;
  final ValueChanged<DateTime>? onStartDateChanged;
  final ValueChanged<DateTime?>? onEndDateChanged;
  final ValueChanged<DateTimeRange?> onRangeChanged;
  final bool? showQuickSelector;

  @override
  State<_CalendarDateRangePicker> createState() =>
      _CalendarDateRangePickerState();
}

class _CalendarDateRangePickerState extends State<_CalendarDateRangePicker> {
  final GlobalKey _scrollViewKey = GlobalKey();
  DateTime? _startDate;
  DateTime? _endDate;
  int _initialMonthIndex = 0;
  late ScrollController _controller;
  late bool _showWeekBottomDivider;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    final DateTime initialDate = widget.initialStartDate ?? widget.currentDate;
    if (!initialDate.isBefore(widget.firstDate) &&
        !initialDate.isAfter(widget.lastDate)) {
      _initialMonthIndex = DateUtils.monthDelta(widget.firstDate, initialDate);
    }

    _showWeekBottomDivider = _initialMonthIndex != 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent) {
      setState(() {
        _showWeekBottomDivider = false;
      });
    } else if (!_showWeekBottomDivider) {
      setState(() {
        _showWeekBottomDivider = true;
      });
    }
  }

  int get _numberOfMonths =>
      DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1;

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        unawaited(HapticFeedback.vibrate());
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  void _updateSelection(DateTime date) {
    _vibrate();
    setState(() {
      if (_startDate != null &&
          _endDate == null &&
          !date.isBefore(_startDate!)) {
        _endDate = date;
        widget.onEndDateChanged?.call(_endDate);
      } else {
        _startDate = date;
        widget.onStartDateChanged?.call(_startDate!);
        if (_endDate != null) {
          _endDate = null;
          widget.onEndDateChanged?.call(_endDate);
        }
      }
    });
  }

  Widget _buildMonthItem(
    BuildContext context,
    int index,
    bool beforeInitialMonth,
    //    [
    //   int columns = 1,
    // ]
  ) {
    // final col = index % columns;
    // final row = index ~/ columns;

    // final src = row * columns + (columns - 1 - col);

    // final int monthIndex =
    //     beforeInitialMonth
    //         ? _initialMonthIndex - src - 1
    //         : _initialMonthIndex + index;

    final int monthIndex =
        beforeInitialMonth
            ? _initialMonthIndex - index - 1
            : _initialMonthIndex + index;

    final DateTime month = DateUtils.addMonthsToMonthDate(
      widget.firstDate,
      monthIndex,
    );

    return _MonthItem(
      selectedDateStart: _startDate,
      selectedDateEnd: _endDate,
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      onChanged: _updateSelection,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  // int _columnsForWidth(BuildContext context) {
  //   final double w = MediaQuery.sizeOf(context).width;
  //   // simple breakpoints: desktop ≥1024 → 3, tablet ≥600 → 2, else 1
  //   if (w >= 1024) return 3;
  //   if (w >= 600) return 2;
  //   return 1;
  // }

  @override
  Widget build(BuildContext context) {
    const Key sliverAfterKey = Key('sliverAfterKey');
    // final int columns = _columnsForWidth(context);

    // final delegate = SliverGridDelegateWithFixedCrossAxisCount(
    //   crossAxisCount: columns,
    //   mainAxisSpacing: 16,
    //   crossAxisSpacing: 16,
    //   mainAxisExtent: 362,
    // );

    return _QuickSelectorWidget(
      showQuickSelector: widget.showQuickSelector,
      selected:
          _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : null,
      onChanged: (range) {
        setState(() {
          _startDate = range?.start;
          _endDate = range?.end;
        });
        widget.onRangeChanged(range);
      },
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _DayHeaders(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: List.generate(columns, (_) => const _DayHeaders()),
          // ),
          if (_showWeekBottomDivider)
            Container(
              width: double.infinity,
              color: context.colorScheme.border,
              height: 2,
            ),
          // Expanded(
          //   child: _CalendarKeyboardNavigator(
          //     firstDate: widget.firstDate,
          //     lastDate: widget.lastDate,
          //     initialFocusedDay:
          //         _startDate ?? widget.initialStartDate ?? widget.currentDate,
          //     child: CustomScrollView(
          //       key: _scrollViewKey,
          //       controller: _controller,
          //       center: sliverAfterKey,
          //       slivers: <Widget>[
          //         SliverGrid(
          //           gridDelegate: delegate,
          //           delegate: SliverChildBuilderDelegate((context, index) {
          //             return _buildMonthItem(context, index, true, columns);
          //           }, childCount: _initialMonthIndex),
          //         ),
          //         SliverGrid(
          //           key: sliverAfterKey,
          //           gridDelegate: delegate,
          //           delegate: SliverChildBuilderDelegate((context, index) {
          //             return _buildMonthItem(context, index, false);
          //           }, childCount: _numberOfMonths - _initialMonthIndex),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: _CalendarKeyboardNavigator(
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              initialFocusedDay:
                  _startDate ?? widget.initialStartDate ?? widget.currentDate,
              child: CustomScrollView(
                key: _scrollViewKey,
                controller: _controller,
                center: sliverAfterKey,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) =>
                          _buildMonthItem(context, index, true),
                      childCount: _initialMonthIndex,
                    ),
                  ),
                  SliverList(
                    key: sliverAfterKey,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) =>
                          _buildMonthItem(context, index, false),
                      childCount: _numberOfMonths - _initialMonthIndex,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarKeyboardNavigator extends StatefulWidget {
  const _CalendarKeyboardNavigator({
    required this.child,
    required this.firstDate,
    required this.lastDate,
    required this.initialFocusedDay,
  });

  final Widget child;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialFocusedDay;

  @override
  _CalendarKeyboardNavigatorState createState() =>
      _CalendarKeyboardNavigatorState();
}

class _CalendarKeyboardNavigatorState
    extends State<_CalendarKeyboardNavigator> {
  final Map<ShortcutActivator, Intent> _shortcutMap =
      const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(
          TraversalDirection.left,
        ),
        SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(
          TraversalDirection.right,
        ),
        SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
          TraversalDirection.down,
        ),
        SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
          TraversalDirection.up,
        ),
      };
  late Map<Type, Action<Intent>> _actionMap;
  late FocusNode _dayGridFocus;
  TraversalDirection? _dayTraversalDirection;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();

    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent: CallbackAction<NextFocusIntent>(
        onInvoke: _handleGridNextFocus,
      ),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
        onInvoke: _handleGridPreviousFocus,
      ),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
        onInvoke: _handleDirectionFocus,
      ),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void dispose() {
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _focusedDay ??= widget.initialFocusedDay;
      }
    });
  }

  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus
      ..requestFocus()
      ..nextFocus();
  }

  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus
      ..requestFocus()
      ..previousFocus();
  }

  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    assert(_focusedDay != null, '');
    setState(() {
      final DateTime? nextDate = _nextDateInDirection(
        _focusedDay!,
        intent.direction,
      );
      if (nextDate != null) {
        _focusedDay = nextDate;
        _dayTraversalDirection = intent.direction;
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
        TraversalDirection.up: -DateTime.daysPerWeek,
        TraversalDirection.right: 1,
        TraversalDirection.down: DateTime.daysPerWeek,
        TraversalDirection.left: -1,
      };

  int _dayDirectionOffset(
    TraversalDirection traversalDirection,
    TextDirection textDirection,
  ) {
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    final DateTime nextDate = DateUtils.addDaysToDate(
      date,
      _dayDirectionOffset(direction, textDirection),
    );
    if (!nextDate.isBefore(widget.firstDate) &&
        !nextDate.isAfter(widget.lastDate)) {
      return nextDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: _shortcutMap,
      actions: _actionMap,
      focusNode: _dayGridFocus,
      onFocusChange: _handleGridFocusChange,
      child: _FocusedDate(
        date: _dayGridFocus.hasFocus ? _focusedDay : null,
        scrollDirection: _dayGridFocus.hasFocus ? _dayTraversalDirection : null,
        child: widget.child,
      ),
    );
  }
}

class _FocusedDate extends InheritedWidget {
  const _FocusedDate({required super.child, this.date, this.scrollDirection});

  final DateTime? date;
  final TraversalDirection? scrollDirection;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) {
    return !DateUtils.isSameDay(date, oldWidget.date) ||
        scrollDirection != oldWidget.scrollDirection;
  }

  static _FocusedDate? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FocusedDate>();
  }
}

class _DayHeaders extends StatelessWidget {
  const _DayHeaders();

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  ///     ┌ Sunday is the first day of week in the US (en_US)
  ///     |
  ///     S M T W T F S  ← the returned list contains these widgets
  ///     _ _ _ _ _ 1 2
  ///     3 4 5 6 7 8 9
  ///
  ///     ┌ But it's Monday in the UK (en_GB)
  ///     |
  ///     M T W T F S S  ← the returned list contains these widgets
  ///     _ _ _ _ 1 2 3
  ///     4 5 6 7 8 9 10
  ///
  List<Widget> _getDayHeaders(
    TextStyle headerStyle,
    MaterialLocalizations localizations,
  ) {
    final List<Widget> result = <Widget>[];
    for (
      int i = localizations.firstDayOfWeekIndex;
      result.length < DateTime.daysPerWeek;
      i = (i + 1) % DateTime.daysPerWeek
    ) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(
        ExcludeSemantics(
          child: Center(child: MyText(weekday, style: headerStyle)),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = context.titleSmall.copyWith(
      color: context.colorScheme.foreground,
    );
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final List<Widget> labels =
        _getDayHeaders(textStyle, localizations)
          // Add leading and trailing boxes for edges of the custom grid layout.
          ..insert(0, const SizedBox.shrink())
          ..add(const SizedBox.shrink());

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.orientationOf(context) == Orientation.landscape
                ? _maxCalendarWidthLandscape
                : _maxCalendarWidthPortrait,
        maxHeight: _monthItemRowHeight,
      ),
      child: GridView.custom(
        shrinkWrap: true,
        gridDelegate: _monthItemGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          labels,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _MonthItemGridDelegate extends SliverGridDelegate {
  const _MonthItemGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth =
        (constraints.crossAxisExtent - 2 * _horizontalPadding) /
        DateTime.daysPerWeek;
    return _MonthSliverGridLayout(
      crossAxisCount: DateTime.daysPerWeek + 2,
      dayChildWidth: tileWidth,
      edgeChildWidth: _horizontalPadding,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthItemGridDelegate oldDelegate) => false;
}

const _MonthItemGridDelegate _monthItemGridDelegate = _MonthItemGridDelegate();

class _MonthSliverGridLayout extends SliverGridLayout {
  const _MonthSliverGridLayout({
    required this.crossAxisCount,
    required this.dayChildWidth,
    required this.edgeChildWidth,
    required this.reverseCrossAxis,
  }) : assert(crossAxisCount > 0, ''),
       assert(dayChildWidth >= 0, ''),
       assert(edgeChildWidth >= 0, '');

  final int crossAxisCount;
  final double dayChildWidth;
  final double edgeChildWidth;
  final bool reverseCrossAxis;

  double get _rowHeight {
    return _monthItemRowHeight + _monthItemSpaceBetweenRows;
  }

  double get _childHeight {
    return _monthItemRowHeight;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return crossAxisCount * (scrollOffset ~/ _rowHeight);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int mainAxisCount = (scrollOffset / _rowHeight).ceil();
    return math.max(0, crossAxisCount * mainAxisCount - 1);
  }

  double _getCrossAxisOffset(double crossAxisStart, bool isPadding) {
    if (reverseCrossAxis) {
      return ((crossAxisCount - 2) * dayChildWidth + 2 * edgeChildWidth) -
          crossAxisStart -
          (isPadding ? edgeChildWidth : dayChildWidth);
    }
    return crossAxisStart;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int adjustedIndex = index % crossAxisCount;
    final bool isEdge =
        adjustedIndex == 0 || adjustedIndex == crossAxisCount - 1;
    final double crossAxisStart = math.max(
      0,
      (adjustedIndex - 1) * dayChildWidth + edgeChildWidth,
    );

    return SliverGridGeometry(
      scrollOffset: (index ~/ crossAxisCount) * _rowHeight,
      crossAxisOffset: _getCrossAxisOffset(crossAxisStart, isEdge),
      mainAxisExtent: _childHeight,
      crossAxisExtent: isEdge ? edgeChildWidth : dayChildWidth,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    assert(childCount >= 0, '');
    final int mainAxisCount = ((childCount - 1) ~/ crossAxisCount) + 1;
    final double mainAxisSpacing = _rowHeight - _childHeight;
    return _rowHeight * mainAxisCount - mainAxisSpacing;
  }
}

class _MonthItem extends StatefulWidget {
  _MonthItem({
    required this.selectedDateStart,
    required this.selectedDateEnd,
    required this.currentDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.displayedMonth,
    required this.selectableDayPredicate,
  }) : assert(!firstDate.isAfter(lastDate), ''),
       assert(
         selectedDateStart == null || !selectedDateStart.isBefore(firstDate),
         '',
       ),
       assert(
         selectedDateEnd == null || !selectedDateEnd.isBefore(firstDate),
         '',
       ),
       assert(
         selectedDateStart == null || !selectedDateStart.isAfter(lastDate),
         '',
       ),
       assert(
         selectedDateEnd == null || !selectedDateEnd.isAfter(lastDate),
         '',
       ),
       assert(
         selectedDateStart == null ||
             selectedDateEnd == null ||
             !selectedDateStart.isAfter(selectedDateEnd),
         '',
       );

  final DateTime? selectedDateStart;
  final DateTime? selectedDateEnd;
  final DateTime currentDate;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime displayedMonth;
  final SelectableDayForRangePredicate? selectableDayPredicate;

  @override
  _MonthItemState createState() => _MonthItemState();
}

class _MonthItemState extends State<_MonthItem> {
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(
      widget.displayedMonth.year,
      widget.displayedMonth.month,
    );
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (int index) =>
          FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DateTime? focusedDate = _FocusedDate.maybeOf(context)?.date;
    if (focusedDate != null &&
        DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Color _highlightColor(BuildContext context) {
    return context.colorScheme.secondary;
  }

  void _dayFocusChanged(bool focused) {
    if (focused) {
      final TraversalDirection? focusDirection =
          _FocusedDate.maybeOf(context)?.scrollDirection;
      if (focusDirection != null) {
        ScrollPositionAlignmentPolicy policy =
            ScrollPositionAlignmentPolicy.explicit;
        switch (focusDirection) {
          case TraversalDirection.up:
          case TraversalDirection.left:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtStart;
          case TraversalDirection.right:
          case TraversalDirection.down:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtEnd;
        }
        unawaited(
          Scrollable.ensureVisible(
            primaryFocus!.context!,
            duration: _monthScrollDuration,
            alignmentPolicy: policy,
          ),
        );
      }
    }
  }

  Widget _buildDayItem(
    BuildContext context,
    DateTime dayToBuild,
    int firstDayOffset,
    int daysInMonth,
  ) {
    final int day = dayToBuild.day;

    final bool isDisabled =
        dayToBuild.isAfter(widget.lastDate) ||
        dayToBuild.isBefore(widget.firstDate) ||
        (widget.selectableDayPredicate != null &&
            !widget.selectableDayPredicate!(
              dayToBuild,
              widget.selectedDateStart,
              widget.selectedDateEnd,
            ));
    final bool isRangeSelected =
        widget.selectedDateStart != null && widget.selectedDateEnd != null;
    final bool isSelectedDayStart =
        widget.selectedDateStart != null &&
        dayToBuild.isAtSameMomentAs(widget.selectedDateStart!);
    final bool isSelectedDayEnd =
        widget.selectedDateEnd != null &&
        dayToBuild.isAtSameMomentAs(widget.selectedDateEnd!);
    final bool isInRange =
        isRangeSelected &&
        dayToBuild.isAfter(widget.selectedDateStart!) &&
        dayToBuild.isBefore(widget.selectedDateEnd!);
    final bool isOneDayRange =
        isRangeSelected && widget.selectedDateStart == widget.selectedDateEnd;
    final bool isToday = DateUtils.isSameDay(widget.currentDate, dayToBuild);

    return _DayItem(
      day: dayToBuild,
      focusNode: _dayFocusNodes[day - 1],
      onChanged: widget.onChanged,
      onFocusChange: _dayFocusChanged,
      highlightColor: _highlightColor(context),
      isDisabled: isDisabled,
      isRangeSelected: isRangeSelected,
      isSelectedDayStart: isSelectedDayStart,
      isSelectedDayEnd: isSelectedDayEnd,
      isInRange: isInRange,
      isOneDayRange: isOneDayRange,
      isToday: isToday,
    );
  }

  Widget _buildEdgeBox(BuildContext context, bool isHighlighted) {
    const Widget empty = LimitedBox(
      maxWidth: 0,
      maxHeight: 0,
      child: SizedBox.expand(),
    );
    return isHighlighted
        ? ColoredBox(color: _highlightColor(context), child: empty)
        : empty;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);
    final int weeks = ((daysInMonth + dayOffset) / DateTime.daysPerWeek).ceil();
    final double gridHeight =
        weeks * _monthItemRowHeight + (weeks - 1) * _monthItemSpaceBetweenRows;
    final List<Widget> dayItems = <Widget>[];

    for (int day = 0 - dayOffset + 1; day <= daysInMonth; day += 1) {
      if (day < 1) {
        dayItems.add(
          const LimitedBox(maxWidth: 0, maxHeight: 0, child: SizedBox.expand()),
        );
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final Widget dayItem = _buildDayItem(
          context,
          dayToBuild,
          dayOffset,
          daysInMonth,
        );
        dayItems.add(dayItem);
      }
    }

    final List<Widget> paddedDayItems = <Widget>[];
    for (int i = 0; i < weeks; i++) {
      final int start = i * DateTime.daysPerWeek;
      final int end = math.min(start + DateTime.daysPerWeek, dayItems.length);
      final List<Widget> weekList = dayItems.sublist(start, end);

      final DateTime dateAfterLeadingPadding = DateTime(
        year,
        month,
        start - dayOffset + 1,
      );
      final bool isLeadingInRange =
          !(dayOffset > 0 && i == 0) &&
          widget.selectedDateStart != null &&
          widget.selectedDateEnd != null &&
          dateAfterLeadingPadding.isAfter(widget.selectedDateStart!) &&
          !dateAfterLeadingPadding.isAfter(widget.selectedDateEnd!);
      weekList.insert(0, _buildEdgeBox(context, isLeadingInRange));

      if (end < dayItems.length ||
          (end == dayItems.length &&
              dayItems.length % DateTime.daysPerWeek == 0)) {
        final DateTime dateBeforeTrailingPadding = DateTime(
          year,
          month,
          end - dayOffset,
        );
        final bool isTrailingInRange =
            widget.selectedDateStart != null &&
            widget.selectedDateEnd != null &&
            !dateBeforeTrailingPadding.isBefore(widget.selectedDateStart!) &&
            dateBeforeTrailingPadding.isBefore(widget.selectedDateEnd!);
        weekList.add(_buildEdgeBox(context, isTrailingInRange));
      }

      paddedDayItems.addAll(weekList);
    }

    final double maxWidth =
        MediaQuery.orientationOf(context) == Orientation.landscape
            ? _maxCalendarWidthLandscape
            : _maxCalendarWidthPortrait;

    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ).tighten(height: _monthItemHeaderHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: ExcludeSemantics(
                child: MyText(
                  localizations.formatMonthYear(widget.displayedMonth),
                  style: context.bodyMedium.apply(
                    color: context.colorScheme.foreground,
                  ),
                ),
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: gridHeight,
          ),
          child: GridView.custom(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: _monthItemGridDelegate,
            childrenDelegate: SliverChildListDelegate(
              paddedDayItems,
              addRepaintBoundaries: false,
            ),
          ),
        ),
        const SizedBox(height: _monthItemFooterHeight),
      ],
    );
  }
}

class _DayItem extends StatefulWidget {
  const _DayItem({
    required this.day,
    required this.focusNode,
    required this.onChanged,
    required this.onFocusChange,
    required this.highlightColor,
    required this.isDisabled,
    required this.isRangeSelected,
    required this.isSelectedDayStart,
    required this.isSelectedDayEnd,
    required this.isInRange,
    required this.isOneDayRange,
    required this.isToday,
  });

  final DateTime day;
  final FocusNode focusNode;
  final ValueChanged<DateTime> onChanged;
  final ValueChanged<bool> onFocusChange;
  final Color highlightColor;
  final bool isDisabled;
  final bool isRangeSelected;
  final bool isSelectedDayStart;
  final bool isSelectedDayEnd;
  final bool isInRange;
  final bool isOneDayRange;
  final bool isToday;

  @override
  State<_DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<_DayItem> {
  final WidgetStatesController _statesController = WidgetStatesController();

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyThemeData theme = MyTheme.of(context);
    final MyColorScheme colorScheme = theme.colorScheme;
    final MyTypography textTheme = theme.typography;
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final TextDirection textDirection = Directionality.of(context);
    final Color highlightColor = widget.highlightColor;

    BoxDecoration? decoration;
    TextStyle? itemStyle = textTheme.bodyMedium;

    T? effectiveValue<T>(T? Function(DatePickerThemeData? theme) getProperty) {
      return getProperty(datePickerTheme) ?? getProperty(defaults);
    }

    final Set<WidgetState> states = <WidgetState>{
      if (widget.isDisabled) WidgetState.disabled,
      if (widget.isSelectedDayStart || widget.isSelectedDayEnd)
        WidgetState.selected,
    };

    _statesController.value = states;

    final Color dayForegroundColor = colorScheme.primaryForeground;
    final Color dayBackgroundColor = colorScheme.primary;

    final WidgetStateProperty<Color?> dayOverlayColor =
        WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => effectiveValue(
            (DatePickerThemeData? theme) =>
                widget.isInRange
                    ? theme?.rangeSelectionOverlayColor?.resolve(states)
                    : theme?.dayOverlayColor?.resolve(states),
          ),
        );

    _HighlightPainter? highlightPainter;

    if (widget.isSelectedDayStart || widget.isSelectedDayEnd) {
      // The selected start and end dates gets a circle background
      // highlight, and a contrasting text color.
      itemStyle = itemStyle.apply(color: dayForegroundColor);
      decoration = BoxDecoration(
        color: dayBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: widget.isSelectedDayStart ? MyRadi.medium : Radius.zero,
          bottomLeft: widget.isSelectedDayStart ? MyRadi.medium : Radius.zero,
          topRight: widget.isSelectedDayEnd ? MyRadi.medium : Radius.zero,
          bottomRight: widget.isSelectedDayEnd ? MyRadi.medium : Radius.zero,
        ),
      );

      if (widget.isRangeSelected && !widget.isOneDayRange) {
        final _HighlightPainterStyle style =
            widget.isSelectedDayStart
                ? _HighlightPainterStyle.highlightTrailing
                : _HighlightPainterStyle.highlightLeading;
        highlightPainter = _HighlightPainter(
          color: highlightColor,
          style: style,
          textDirection: textDirection,
        );
      }
    } else if (widget.isInRange) {
      // The days within the range get a light background highlight.
      highlightPainter = _HighlightPainter(
        color: highlightColor,
        style: _HighlightPainterStyle.highlightAll,
        textDirection: textDirection,
      );
      if (widget.isDisabled) {
        itemStyle = itemStyle.apply(
          color: colorScheme.mutedForeground.withValues(alpha: 0.5),
        );
      }
    } else if (widget.isDisabled) {
      itemStyle = itemStyle.apply(
        color: colorScheme.mutedForeground.withValues(alpha: 0.5),
      );
    } else if (widget.isToday) {
      // The current day gets a different text color and a circle stroke
      // border.
      itemStyle = itemStyle.apply(color: colorScheme.primary);
      decoration = BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        borderRadius: MyBorderRadius.medium,
      );
    }

    final String dayText = localizations.formatDecimal(widget.day.day);

    // We want the day of month to be spoken first irrespective of the
    // locale-specific preferences or TextDirection. This is because
    // an accessibility user is more likely to be interested in the
    // day of month before the rest of the date, as they are looking
    // for the day of month. To do that we prepend day of month to the
    // formatted full date.
    final String semanticLabelSuffix =
        widget.isToday ? ', ${localizations.currentDateLabel}' : '';
    String semanticLabel =
        '$dayText, ${localizations.formatFullDate(widget.day)}$semanticLabelSuffix';
    if (widget.isSelectedDayStart) {
      semanticLabel = localizations.dateRangeStartDateSemanticLabel(
        semanticLabel,
      );
    } else if (widget.isSelectedDayEnd) {
      semanticLabel = localizations.dateRangeEndDateSemanticLabel(
        semanticLabel,
      );
    }

    Widget dayWidget = Container(
      decoration: decoration,
      alignment: Alignment.center,
      child: Semantics(
        label: semanticLabel,
        selected: widget.isSelectedDayStart || widget.isSelectedDayEnd,
        child: ExcludeSemantics(child: MyText(dayText, style: itemStyle)),
      ),
    );

    if (highlightPainter != null) {
      dayWidget = CustomPaint(painter: highlightPainter, child: dayWidget);
    }

    if (!widget.isDisabled) {
      dayWidget = InkResponse(
        focusNode: widget.focusNode,
        onTap: () => widget.onChanged(widget.day),
        radius: _monthItemRowHeight / 2 + 4,
        statesController: _statesController,
        overlayColor: dayOverlayColor,
        onFocusChange: widget.onFocusChange,
        child: dayWidget,
      );
    }

    return dayWidget;
  }
}

/// Determines which style to use to paint the highlight.
enum _HighlightPainterStyle {
  /// Paints nothing.
  none,

  /// Paints a rectangle that occupies the leading half of the space.
  highlightLeading,

  /// Paints a rectangle that occupies the trailing half of the space.
  highlightTrailing,

  /// Paints a rectangle that occupies all available space.
  highlightAll,
}

/// This custom painter will add a background highlight to its child.
///
/// This highlight will be drawn depending on the [style], [color], and
/// [textDirection] supplied. It will either paint a rectangle on the
/// left/right, a full rectangle, or nothing at all. This logic is determined by
/// a combination of the [style] and [textDirection].
class _HighlightPainter extends CustomPainter {
  _HighlightPainter({
    required this.color,
    this.style = _HighlightPainterStyle.none,
    this.textDirection,
  });

  final Color color;
  final _HighlightPainterStyle style;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == _HighlightPainterStyle.none) {
      return;
    }

    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final bool rtl = switch (textDirection) {
      TextDirection.rtl || null => true,
      TextDirection.ltr => false,
    };

    switch (style) {
      case _HighlightPainterStyle.highlightLeading when rtl:
      case _HighlightPainterStyle.highlightTrailing when !rtl:
        canvas.drawRect(
          Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height),
          paint,
        );
      case _HighlightPainterStyle.highlightLeading:
      case _HighlightPainterStyle.highlightTrailing:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width / 2, size.height),
          paint,
        );
      case _HighlightPainterStyle.highlightAll:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      case _HighlightPainterStyle.none:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
