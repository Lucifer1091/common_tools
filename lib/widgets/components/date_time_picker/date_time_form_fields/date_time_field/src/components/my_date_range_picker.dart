import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../../../../../../index.dart';

const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);

// The max scale factor for the date range pickers.
const double _kMaxRangeTextScaleFactor = 1.3;

// A restorable [DatePickerEntryMode] value.
//
// This serializes each entry as a unique `int` value.
class _RestorableDatePickerEntryMode
    extends RestorableValue<DatePickerEntryMode> {
  _RestorableDatePickerEntryMode(DatePickerEntryMode defaultValue)
    : _defaultValue = defaultValue;

  final DatePickerEntryMode _defaultValue;

  @override
  DatePickerEntryMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(DatePickerEntryMode? oldValue) {
    assert(debugIsSerializableForRestoration(value.index), '');
    notifyListeners();
  }

  @override
  DatePickerEntryMode fromPrimitives(Object? data) =>
      DatePickerEntryMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

/// Shows a full screen modal dialog containing a Material Design date range
/// picker.
///
/// The returned [Future] resolves to the [DateTimeRange] selected by the user
/// when the user saves their selection. If the user cancels the dialog, null is
/// returned.
///
/// If [initialDateRange] is non-null, then it will be used as the initially
/// selected date range. If it is provided, `initialDateRange.start` must be
/// before or on `initialDateRange.end`.
///
/// The [firstDate] is the earliest allowable date. The [lastDate] is the latest
/// allowable date.
///
/// If an initial date range is provided, `initialDateRange.start`
/// and `initialDateRange.end` must both fall between or on [firstDate] and
/// [lastDate]. For all of these [DateTime] values, only their dates are
/// considered. Their time fields are ignored.
///
/// The [currentDate] represents the current day (i.e. today). This
/// date will be highlighted in the day grid. If null, the date of
/// `Date.now()` will be used.
///
/// An optional [initialEntryMode] argument can be used to display the date
/// picker in the [DatePickerEntryMode.calendar] (a scrollable calendar month
/// grid) or [DatePickerEntryMode.input] (two text input fields) mode.
/// It defaults to [DatePickerEntryMode.calendar].
///
/// {@macro flutter.material.date_picker.switchToInputEntryModeIcon}
///
/// {@macro flutter.material.date_picker.switchToCalendarEntryModeIcon}
///
/// The following optional string parameters allow you to override the default
/// text used for various parts of the dialog:
///
///   * [helpText], the label displayed at the top of the dialog.
///   * [cancelText], the label on the cancel button for the text input mode.
///   * [confirmText],the label on the ok button for the text input mode.
///   * [saveText], the label on the save button for the fullscreen calendar
///     mode.
///   * [errorFormatText], the message used when an input text isn't in a proper
///     date format.
///   * [errorInvalidText], the message used when an input text isn't a
///     selectable date.
///   * [errorInvalidRangeText], the message used when the date range is
///     invalid (e.g. start date is after end date).
///   * [fieldStartHintText], the text used to prompt the user when no text has
///     been entered in the start field.
///   * [fieldEndHintText], the text used to prompt the user when no text has
///     been entered in the end field.
///   * [fieldStartLabelText], the label for the start date text input field.
///   * [fieldEndLabelText], the label for the end date text input field.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// ([TextDirection.ltr] or [TextDirection.rtl]) for the date picker. It
/// defaults to the ambient text direction provided by [Directionality]. If both
/// [locale] and [textDirection] are non-null, [textDirection] overrides the
/// direction chosen for the [locale].
///
/// The [context], [barrierDismissible], [barrierColor], [barrierLabel],
/// [useRootNavigator] and [routeSettings] arguments are passed to [showDialog],
/// the documentation for which discusses how it is used.
///
/// The [builder] parameter can be used to wrap the dialog widget
/// to add inherited widgets like [Theme].
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// ### State Restoration
///
/// Using this method will not enable state restoration for the date range picker.
/// In order to enable state restoration for a date range picker, use
/// [Navigator.restorablePush] or [Navigator.restorablePushNamed] with
/// [MyDateRangePickerDialog].
///
/// For more information about state restoration, see [RestorationManager].
///
/// {@macro flutter.widgets.RestorationManager}
///
/// {@tool dartpad}
/// This sample demonstrates how to create a restorable Material date range picker.
/// This is accomplished by enabling state restoration by specifying
/// [MaterialApp.restorationScopeId] and using [Navigator.restorablePush] to
/// push [MyDateRangePickerDialog] when the button is tapped.
///
/// ** See code in examples/api/lib/material/date_picker/show_date_range_picker.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [showDatePicker], which shows a Material Design date picker used to
///    select a single date.
///  * [DateTimeRange], which is used to describe a date range.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
/// Adds min/max range-length constraints to the fancy date range picker.
/// - minRangeDays: minimum number of days in the selection (inclusive). Example: 1 = same-day OK.
/// - maxRangeDays: maximum number of days in the selection (inclusive).
Future<DateTimeRange?> showFancyDateRangePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? saveText,
  String? errorFormatText,
  String? errorInvalidText,
  String? errorInvalidRangeText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? fieldStartLabelText,
  String? fieldEndLabelText,
  Locale? locale,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  Offset? anchorPoint,
  SelectableDayForRangePredicate? selectableDayPredicate,
  bool? showQuickSelector,
  int? minRangeDays,
  int? maxRangeDays,
}) async {
  // --- normalize dates ---
  initialDateRange =
      initialDateRange == null ? null : DateUtils.datesOnly(initialDateRange);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);

  // --- sanity checks for inputs ---
  assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    minRangeDays == null || minRangeDays >= 1,
    'minRangeDays must be null or >= 1',
  );
  assert(
    maxRangeDays == null || maxRangeDays >= 1,
    'maxRangeDays must be null or >= 1',
  );
  assert(
    minRangeDays == null ||
        maxRangeDays == null ||
        minRangeDays <= maxRangeDays,
    'minRangeDays cannot be greater than maxRangeDays',
  );

  // initial range basic bounds
  assert(
    initialDateRange == null || !initialDateRange.start.isBefore(firstDate),
    "initialDateRange's start date must be on or after firstDate $firstDate.",
  );
  assert(
    initialDateRange == null || !initialDateRange.end.isBefore(firstDate),
    "initialDateRange's end date must be on or after firstDate $firstDate.",
  );
  assert(
    initialDateRange == null || !initialDateRange.start.isAfter(lastDate),
    "initialDateRange's start date must be on or before lastDate $lastDate.",
  );
  assert(
    initialDateRange == null || !initialDateRange.end.isAfter(lastDate),
    "initialDateRange's end date must be on or before lastDate $lastDate.",
  );

  // initial range min/max length validation (inclusive length)
  if (initialDateRange != null) {
    final int initLen =
        initialDateRange.end.difference(initialDateRange.start).inDays + 1;
    assert(
      minRangeDays == null || initLen >= minRangeDays,
      "initialDateRange's length ($initLen) is smaller than minRangeDays ($minRangeDays).",
    );
    assert(
      maxRangeDays == null || initLen <= maxRangeDays,
      "initialDateRange's length ($initLen) exceeds maxRangeDays ($maxRangeDays).",
    );
  }

  // original predicate must accept the start/end if provided
  assert(
    initialDateRange == null ||
        selectableDayPredicate == null ||
        selectableDayPredicate(
          initialDateRange.start,
          initialDateRange.start,
          initialDateRange.end,
        ),
    "initialDateRange's start date must be selectable.",
  );
  assert(
    initialDateRange == null ||
        selectableDayPredicate == null ||
        selectableDayPredicate(
          initialDateRange.end,
          initialDateRange.start,
          initialDateRange.end,
        ),
    "initialDateRange's end date must be selectable.",
  );

  currentDate = DateUtils.dateOnly(currentDate ?? Date.now());
  assert(debugCheckHasMaterialLocalizations(context), '');

  // --- compose a predicate that enforces min/max range while selecting ---
  // Your SelectableDayForRangePredicate signature: (day, start, end) => bool
  // Behavior:
  //  - When only start is chosen (end == null), only allow end-candidates that satisfy:
  //        start + (minRangeDays-1) <= day <= start + (maxRangeDays-1)
  //    (when min/max are provided). If min is null, no lower bound; if max is null, no upper bound.
  //  - Always AND with the user-provided predicate, if any.
  SelectableDayForRangePredicate? combinedSelectable;
  if (selectableDayPredicate != null ||
      minRangeDays != null ||
      maxRangeDays != null) {
    combinedSelectable = (DateTime day, DateTime? start, DateTime? end) {
      // Run user predicate first
      final bool baseOk = selectableDayPredicate?.call(day, start, end) ?? true;
      if (!baseOk) return false;

      // Enforce min/max only when picking the second date (end is null and start is set).
      if (start != null && end == null && !DateUtils.isSameDay(day, start)) {
        if (minRangeDays != null) {
          final earliestAllowedEnd = start.add(
            Duration(days: minRangeDays - 1),
          );
          if (day.isBefore(earliestAllowedEnd)) return false;
        }
        if (maxRangeDays != null) {
          final latestAllowedEnd = start.add(Duration(days: maxRangeDays - 1));
          if (day.isAfter(latestAllowedEnd)) return false;
        }
      }

      // If both start and end are already chosen, defer to base predicate (picker will handle completion).
      return true;
    };
  }

  Widget dialog = MyDateRangePickerDialog(
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    selectableDayPredicate: combinedSelectable ?? selectableDayPredicate,
    initialEntryMode: initialEntryMode,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    saveText: saveText,
    errorInvalidRangeText: errorInvalidRangeText,
    showQuickSelector: showQuickSelector,
  );

  if (textDirection != null) {
    dialog = Directionality(textDirection: textDirection, child: dialog);
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  final DateTimeRange? picked = await showDialog<DateTimeRange>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    useSafeArea: false,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );

  // Final safety check (in case the dialog allows confirming outside the predicate)
  if (picked != null && (minRangeDays != null || maxRangeDays != null)) {
    final selLen = picked.end.difference(picked.start).inDays + 1;
    if ((minRangeDays != null && selLen < minRangeDays) ||
        (maxRangeDays != null && selLen > maxRangeDays)) {
      // You can choose to return null or throw an assertion in debug.
      assert(
        false,
        'Selected range length ($selLen) is outside [$minRangeDays, $maxRangeDays].',
      );
      return null;
    }
  }

  return picked;
}

/// Returns a locale-appropriate string to describe the start of a date range.
///
/// If `startDate` is null, then it defaults to 'Start Date', otherwise if it
/// is in the same year as the `endDate` then it will use the short month
/// day format (i.e. 'Jan 21'). Otherwise it will return the short date format
/// (i.e. 'Jan 21, 2020').
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

/// Returns an locale-appropriate string to describe the end of a date range.
///
/// If `endDate` is null, then it defaults to 'End Date', otherwise if it
/// is in the same year as the `startDate` and the `currentDate` then it will
/// just use the short month day format (i.e. 'Jan 21'), otherwise it will
/// include the year (i.e. 'Jan 21, 2020').
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

/// A Material-style date range picker dialog.
///
/// It is used internally by [showFancyDateRangePicker] or can be directly pushed
/// onto the [Navigator] stack to enable state restoration. See
/// [showFancyDateRangePicker] for a state restoration app example.
///
/// See also:
///
///  * [showFancyDateRangePicker], which is a way to display the date picker.
class MyDateRangePickerDialog extends StatefulWidget {
  /// A Material-style date range picker dialog.
  const MyDateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.initialDateRange,
    this.currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.saveText,
    this.errorInvalidRangeText,
    this.selectableDayPredicate,
    this.restorationId,
    this.showQuickSelector,
  });

  /// The date range that the date range picker starts with when it opens.
  ///
  /// If an initial date range is provided, `initialDateRange.start`
  /// and `initialDateRange.end` must both fall between or on [firstDate] and
  /// [lastDate]. For all of these [DateTime] values, only their dates are
  /// considered. Their time fields are ignored.
  ///
  /// If [initialDateRange] is non-null, then it will be used as the initially
  /// selected date range. If it is provided, `initialDateRange.start` must be
  /// before or on `initialDateRange.end`.
  final DateTimeRange? initialDateRange;

  /// The earliest allowable date on the date range.
  final DateTime firstDate;

  /// The latest allowable date on the date range.
  final DateTime lastDate;

  /// The [currentDate] represents the current day (i.e. today).
  ///
  /// This date will be highlighted in the day grid.
  ///
  /// If `null`, the date of `Date.now()` will be used.
  final DateTime? currentDate;

  /// The initial date range picker entry mode.
  ///
  /// The date range has two main modes: [DatePickerEntryMode.calendar] (a
  /// scrollable calendar month grid) or [DatePickerEntryMode.input] (two text
  /// input fields) mode.
  ///
  /// It defaults to [DatePickerEntryMode.calendar].
  final DatePickerEntryMode initialEntryMode;

  /// The label on the cancel button for the text input mode.
  ///
  /// If null, the localized value of
  /// [MaterialLocalizations.cancelButtonLabel] is used.
  final String? cancelText;

  /// The label on the "OK" button for the text input mode.
  ///
  /// If null, the localized value of
  /// [MaterialLocalizations.okButtonLabel] is used.
  final String? confirmText;

  /// The label on the save button for the fullscreen calendar mode.
  ///
  /// If null, the localized value of
  /// [MaterialLocalizations.saveButtonLabel] is used.
  final String? saveText;

  /// The label displayed at the top of the dialog.
  ///
  /// If null, the localized value of
  /// [MaterialLocalizations.dateRangePickerHelpText] is used.
  final String? helpText;

  /// The message used when the date range is invalid (e.g. start date is after
  /// end date).
  ///
  /// If null, the localized value of
  /// [MaterialLocalizations.invalidDateRangeLabel] is used.
  final String? errorInvalidRangeText;

  /// Restoration ID to save and restore the state of the [MyDateRangePickerDialog].
  ///
  /// If it is non-null, the date range picker will persist and restore the
  /// date range selected on the dialog.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayForRangePredicate? selectableDayPredicate;

  final bool? showQuickSelector;

  @override
  State<MyDateRangePickerDialog> createState() =>
      _MyDateRangePickerDialogState();
}

class _MyDateRangePickerDialogState extends State<MyDateRangePickerDialog>
    with RestorationMixin {
  late final _RestorableDatePickerEntryMode _entryMode =
      _RestorableDatePickerEntryMode(widget.initialEntryMode);
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
    registerForRestoration(_entryMode, 'entry_mode');
    registerForRestoration(_selectedStart, 'selected_start');
    registerForRestoration(_selectedEnd, 'selected_end');
    registerForRestoration(_autoValidate, 'autovalidate');
  }

  @override
  void dispose() {
    _entryMode.dispose();
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
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);

    final Size size;
    final double? elevation;
    final Color? shadowColor;
    final Color? surfaceTintColor;
    final ShapeBorder? shape;
    final EdgeInsets insetPadding;

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

      confirmText:
          widget.saveText ??
          (useMaterial3
              ? localizations.saveButtonLabel
              : localizations.saveButtonLabel.toUpperCase()),
      helpText:
          widget.helpText ??
          (useMaterial3
              ? localizations.dateRangePickerHelpText
              : localizations.dateRangePickerHelpText.toUpperCase()),
    );
    size = MediaQuery.sizeOf(context);
    insetPadding = EdgeInsets.zero;
    elevation =
        datePickerTheme.rangePickerElevation ?? defaults.rangePickerElevation!;
    shadowColor =
        datePickerTheme.rangePickerShadowColor ??
        defaults.rangePickerShadowColor!;
    surfaceTintColor =
        datePickerTheme.rangePickerSurfaceTintColor ??
        defaults.rangePickerSurfaceTintColor!;
    shape = datePickerTheme.rangePickerShape ?? defaults.rangePickerShape;

    return Dialog(
      insetPadding: insetPadding,
      backgroundColor:
          datePickerTheme.backgroundColor ?? defaults.backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: size.width,
        height: size.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: _kMaxRangeTextScaleFactor,
          child: Builder(
            builder: (BuildContext context) {
              return contents;
            },
          ),
        ),
      ),
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
    required this.confirmText,
    required this.helpText,
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
  final String confirmText;
  final String helpText;
  final bool? showQuickSelector;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final DatePickerThemeData themeData = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final Color? dialogBackground =
        themeData.rangePickerBackgroundColor ??
        defaults.rangePickerBackgroundColor;
    final Color? headerBackground =
        themeData.rangePickerHeaderBackgroundColor ??
        defaults.rangePickerHeaderBackgroundColor;
    final Color? headerForeground =
        themeData.rangePickerHeaderForegroundColor ??
        defaults.rangePickerHeaderForegroundColor;
    final Color? headerDisabledForeground = headerForeground?.withValues(
      alpha: 0.38,
    );
    final TextStyle? headlineStyle =
        themeData.rangePickerHeaderHeadlineStyle ??
        defaults.rangePickerHeaderHeadlineStyle;
    final TextStyle? headlineHelpStyle = (themeData
                .rangePickerHeaderHelpStyle ??
            defaults.rangePickerHeaderHelpStyle)
        ?.apply(color: headerForeground);

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
    final TextStyle? startDateStyle = headlineStyle?.apply(
      color:
          selectedStartDate != null
              ? headerForeground
              : headerDisabledForeground,
    );
    final TextStyle? endDateStyle = headlineStyle?.apply(
      color:
          selectedEndDate != null ? headerForeground : headerDisabledForeground,
    );
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: headerForeground,
      disabledForegroundColor: headerDisabledForeground,
    );
    final IconThemeData iconTheme = IconThemeData(color: headerForeground);

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: iconTheme,
          actionsIconTheme: iconTheme,
          elevation: useMaterial3 ? 0 : null,
          scrolledUnderElevation: useMaterial3 ? 0 : null,
          backgroundColor: headerBackground,
          leading: CloseButton(onPressed: onCancel),
          actions: <Widget>[
            TextButton(
              style: buttonStyle,
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 64),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.sizeOf(context).width < 360 ? 42 : 72,
                ),
                Expanded(
                  child: Semantics(
                    label: '$helpText $startDateText to $endDateText',
                    excludeSemantics: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          helpText,
                          style: headlineHelpStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              startDateText,
                              style: startDateStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(' – ', style: startDateStyle),
                            Flexible(
                              child: Text(
                                endDateText,
                                style: endDateStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: dialogBackground,
        body: _CalendarDateRangePicker(
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
    );
  }
}

class _QuickSelectorWidget extends StatelessWidget {
  const _QuickSelectorWidget({
    required this.child,
    required this.selected,
    required this.onChanged,
    this.showQuickSelector,
  });

  final Widget child;
  final DateTimeRange? selected;
  final bool? showQuickSelector;
  final ValueChanged<DateTimeRange?> onChanged;

  static final List<MyQuickDateRange> _ranges = [
    const MyQuickDateRange(label: 'Clear Selection', range: null),
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
        start: Date.now().previousMonth.truncateTime(),
        end: Date.now().startOfMonth.subtractDays(1).truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last 3 Months',
      range: DateTimeRange(
        start: Date.now().subtractMonths(3).truncateTime(),
        end:
            Date.now().startOfMonth
                .subtract(const Duration(days: 1))
                .truncateTime(),
      ),
    ),
    MyQuickDateRange(
      label: 'Last 6 Months',
      range: DateTimeRange(
        start: Date.now().subtractMonths(6).truncateTime(),
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
        start: Date.now().previousYear.truncateTime(),
        end: Date.now().previousYear.endOfYear.truncateTime(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return buildTablet(context);
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
            width: 200,
            padding: const EdgeInsets.only(right: 16),
            child: MyQuickSelectorWidget(
              selected: selected,
              ranges: _ranges,
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
        const SizedBox(width: 16),
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
              ranges: _ranges,
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

/// Displays a scrollable calendar grid that allows a user to select a range
/// of dates.
class _CalendarDateRangePicker extends StatefulWidget {
  /// Creates a scrollable calendar grid for picking date ranges.
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

  /// The [DateTime] that represents the start of the initial date range selection.
  final DateTime? initialStartDate;

  /// The [DateTime] that represents the end of the initial date range selection.
  final DateTime? initialEndDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayForRangePredicate? selectableDayPredicate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Called when the user changes the start date of the selected range.
  final ValueChanged<DateTime>? onStartDateChanged;

  /// Called when the user changes the end date of the selected range.
  final ValueChanged<DateTime?>? onEndDateChanged;

  /// Called when the user selects range from left panel.
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

    // Calculate the index for the initially displayed month. This is needed to
    // divide the list of months into two `SliverList`s.
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

  // This updates the selected date range using this logic:
  //
  // * From the unselected state, selecting one date creates the start date.
  //   * If the next selection is before the start date, reset date range and
  //     set the start date to that selection.
  //   * If the next selection is on or after the start date, set the end date
  //     to that selection.
  // * After both start and end dates are selected, any subsequent selection
  //   resets the date range and sets start date to that selection.
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
  ) {
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

  @override
  Widget build(BuildContext context) {
    const Key sliverAfterKey = Key('sliverAfterKey');

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
      child: Column(
        children: <Widget>[
          const _DayHeaders(),
          if (_showWeekBottomDivider)
            Container(
              width: double.infinity,
              color: context.colorScheme.border,
              height: 2,
            ),
          Expanded(
            child: _CalendarKeyboardNavigator(
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              initialFocusedDay:
                  _startDate ?? widget.initialStartDate ?? widget.currentDate,
              // In order to prevent performance issues when displaying the
              // correct initial month, 2 `SliverList`s are used to split the
              // months. The first item in the second SliverList is the initial
              // month to be displayed.
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

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus
      ..requestFocus()
      ..nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus
      ..requestFocus()
      ..previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
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
    // Swap left and right if the text direction if RTL
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

/// InheritedWidget indicating what the current focused date is for its children.
// See also: _FocusedDate in calendar_date_picker.dart
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
          child: Center(child: Text(weekday, style: headerStyle)),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final TextStyle textStyle = themeData.textTheme.titleSmall!.apply(
      color: colorScheme.onSurface,
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
  /// Creates a layout that uses equally sized and spaced tiles for each day of
  /// the week and an additional edge tile for padding at the start and end of
  /// each row.
  ///
  /// This is necessary to facilitate the painting of the range highlight
  /// correctly.
  const _MonthSliverGridLayout({
    required this.crossAxisCount,
    required this.dayChildWidth,
    required this.edgeChildWidth,
    required this.reverseCrossAxis,
  }) : assert(crossAxisCount > 0, ''),
       assert(dayChildWidth >= 0, ''),
       assert(edgeChildWidth >= 0, '');

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The width in logical pixels of the day child widgets.
  final double dayChildWidth;

  /// The width in logical pixels of the edge child widgets.
  final double edgeChildWidth;

  /// Whether the children should be placed in the opposite order of increasing
  /// coordinates in the cross axis.
  ///
  /// For example, if the cross axis is horizontal, the children are placed from
  /// left to right when [reverseCrossAxis] is false and from right to left when
  /// [reverseCrossAxis] is true.
  ///
  /// Typically set to the return value of [axisDirectionIsReversed] applied to
  /// the [SliverConstraints.crossAxisDirection].
  final bool reverseCrossAxis;

  /// The number of logical pixels from the leading edge of one row to the
  /// leading edge of the next row.
  double get _rowHeight {
    return _monthItemRowHeight + _monthItemSpaceBetweenRows;
  }

  /// The height in logical pixels of the children widgets.
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

/// Displays the days of a given month and allows choosing a date range.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _MonthItem extends StatefulWidget {
  /// Creates a month item.
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

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDateStart;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDateEnd;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  final SelectableDayForRangePredicate? selectableDayPredicate;

  @override
  _MonthItemState createState() => _MonthItemState();
}

class _MonthItemState extends State<_MonthItem> {
  /// List of [FocusNode]s, one for each day of the month.
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
    // Check to see if the focused date is in this month, if so focus it.
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
    return DatePickerTheme.of(context).rangeSelectionBackgroundColor ??
        DatePickerTheme.defaults(context).rangeSelectionBackgroundColor!;
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
        widget.selectableDayPredicate != null &&
            !widget.selectableDayPredicate!(
              dayToBuild,
              widget.selectedDateStart,
              widget.selectedDateEnd,
            );
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
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
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

    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
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

    // Add the leading/trailing edge containers to each week in order to
    // correctly extend the range highlight.
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
      // Only color the edge container if it is after the start date and
      // on/before the end date.
      final bool isLeadingInRange =
          !(dayOffset > 0 && i == 0) &&
          widget.selectedDateStart != null &&
          widget.selectedDateEnd != null &&
          dateAfterLeadingPadding.isAfter(widget.selectedDateStart!) &&
          !dateAfterLeadingPadding.isAfter(widget.selectedDateEnd!);
      weekList.insert(0, _buildEdgeBox(context, isLeadingInRange));

      // Only add a trailing edge container if it is for a full week and not a
      // partial week.
      if (end < dayItems.length ||
          (end == dayItems.length &&
              dayItems.length % DateTime.daysPerWeek == 0)) {
        final DateTime dateBeforeTrailingPadding = DateTime(
          year,
          month,
          end - dayOffset,
        );
        // Only color the edge container if it is on/after the start date and
        // before the end date.
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
                child: Text(
                  localizations.formatMonthYear(widget.displayedMonth),
                  style: textTheme.bodyMedium!.apply(
                    color: themeData.colorScheme.onSurface,
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
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

    T? resolve<T>(
      WidgetStateProperty<T>? Function(DatePickerThemeData? theme) getProperty,
      Set<WidgetState> states,
    ) {
      return effectiveValue((DatePickerThemeData? theme) {
        return getProperty(theme)?.resolve(states);
      });
    }

    final Set<WidgetState> states = <WidgetState>{
      if (widget.isDisabled) WidgetState.disabled,
      if (widget.isSelectedDayStart || widget.isSelectedDayEnd)
        WidgetState.selected,
    };

    _statesController.value = states;

    final Color? dayForegroundColor = resolve<Color?>(
      (DatePickerThemeData? theme) => theme?.dayForegroundColor,
      states,
    );
    final Color? dayBackgroundColor = resolve<Color?>(
      (DatePickerThemeData? theme) => theme?.dayBackgroundColor,
      states,
    );
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
      itemStyle = itemStyle?.apply(color: dayForegroundColor);
      decoration = BoxDecoration(
        color: dayBackgroundColor,
        shape: BoxShape.circle,
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
        itemStyle = itemStyle?.apply(
          color: colorScheme.onSurface.withValues(alpha: 0.38),
        );
      }
    } else if (widget.isDisabled) {
      itemStyle = itemStyle?.apply(
        color: colorScheme.onSurface.withValues(alpha: 0.38),
      );
    } else if (widget.isToday) {
      // The current day gets a different text color and a circle stroke
      // border.
      itemStyle = itemStyle?.apply(color: colorScheme.primary);
      decoration = BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        shape: BoxShape.circle,
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
        child: ExcludeSemantics(child: Text(dayText, style: itemStyle)),
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
