part of 'my_time_picker.dart';

enum TimeRangeViewType { start, end }

class MyTimeRangeDialog extends StatefulWidget {
  const MyTimeRangeDialog({
    required this.autoAdjust,
    this.startTime,
    this.endTime,
    super.key,
  });

  final bool autoAdjust;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  @override
  State createState() => _MyTimeRangeDialogState();
}

class _MyTimeRangeDialogState extends State<MyTimeRangeDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TimeOfDay? _startDefaultTime;
  TimeOfDay? _endDefaultTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _startTime = widget.startTime;
    _endTime = widget.endTime;
    _startDefaultTime = _startTime ?? TimeOfDay.now();
    _endDefaultTime = _endTime ?? TimeOfDay.now();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyDialogScaffold(
      body: MyDialogInfoWidget(
        title: 'Select Time Range',
        titleAlignment: Alignment.centerLeft,
        contentWidget: Column(
          children: [
            MyTabBar(
              indicator: MyTabIndicator(context),
              controller: _tabController,
              tabs: [MyTab(text: 'From'), MyTab(text: 'To')],
            ).preferredSize,
            MyTabView(
              controller: _tabController,
              children: [_startTimePicker(), _endTimePicker()],
            ).sizedBox(height: 460),
          ],
        ),
      ),
    );
  }

  void _updateTime({TimeOfDay? startTime, TimeOfDay? endTime}) {
    _autoAdjustTime(startTime: startTime, endTime: endTime);
    setState(() {
      if (startTime != null) _startTime = startTime;
      if (endTime != null) _endTime = endTime;
    });
  }

  void _autoAdjustTime({TimeOfDay? startTime, TimeOfDay? endTime}) {
    if (!widget.autoAdjust) return;
    if (startTime != null) {
      _startTime = startTime;
      if (_timeToDouble(startTime) > _timeToDouble(_endTime)) {
        _endTime = _endTime?.replacing(hour: startTime.hour);
      }
    }
    if (endTime != null) {
      _endTime = endTime;
      if (_timeToDouble(_startTime) > _timeToDouble(endTime)) {
        _startTime = _startTime?.replacing(hour: endTime.hour);
      }
    }
    setState(() {});
  }

  double _timeToDouble(TimeOfDay? time) {
    if (time == null) return 0;
    return time.hour + time.minute / 60.0;
  }

  Widget _startTimePicker() {
    final left = MyDialogButtonOptions(
      title: 'Cancel',
      type: MyButtonType.outline,
      action: _handleCancel,
    );

    final right = MyDialogButtonOptions(
      title: 'Next',
      titleColor: context.colorScheme.primaryForeground,
      action: _handleNext,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TimePicker(
          time: _startTime ?? TimeOfDay.now(),
          onTimeChanged: (start) => _updateTime(startTime: start),
          restorationId: 'start_time_picker',
        ),
        const Gap(24),
        MyDialogShrinkButtons(
          leftBtn: left,
          rightBtn: right,
          padding: EdgeInsets.zero,
        ),
        const Gap(24),
      ],
    );
  }

  Widget _endTimePicker() {
    final left = MyDialogButtonOptions(
      title: 'Back',
      type: MyButtonType.outline,
      action: _handleBack,
    );

    final right = MyDialogButtonOptions(
      title: 'OK',
      titleColor: context.colorScheme.primaryForeground,
      action: _handleOk,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TimePicker(
          time: _endTime ?? TimeOfDay.now(),
          onTimeChanged: (end) => _updateTime(endTime: end),
          restorationId: 'end_time_picker',
        ),
        const Gap(24),
        MyDialogShrinkButtons(
          leftBtn: left,
          rightBtn: right,
          padding: EdgeInsets.zero,
        ),
        const Gap(24),
      ],
    );
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleBack() {
    _tabController.animateTo(0);
  }

  void _handleNext() {
    _tabController.animateTo(1);
  }

  void _handleOk() {
    Navigator.pop(
      context,
      TimeRange(
        start: _startTime ?? _startDefaultTime ?? TimeOfDay.now(),
        end: _endTime ?? _endDefaultTime ?? TimeOfDay.now(),
      ),
    );
  }
}
