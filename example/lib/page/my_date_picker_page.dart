import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyDatePickerPage extends StatefulWidget {
  const MyDatePickerPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyDatePickerPageState();
}

class _MyDatePickerPageState extends State<MyDatePickerPage> {
  late final GlobalKey<MyFormState> _formKey, _formKey1;

  @override
  void initState() {
    _formKey = GlobalKey<MyFormState>();
    _formKey1 = GlobalKey<MyFormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'A widget that lets users select dates and date ranges.',
      exampleCodeGroup: 'datetimePicker',
      children: [
        ExampleModule(
          title: 'Default Pickers',
          children: [
            ExampleItem(
              padding: EdgeInsets.only(top: 16),
              builder: _defaultPickers,
            ),
          ],
        ),
        ExampleModule(
          title: 'Date & Time Fields',
          children: [
            ExampleItem(desc: 'Date & Time Field', builder: _dateTimeField),
            ExampleItem(desc: 'Date Field', builder: _dateField),
            ExampleItem(desc: 'Date Form Field', builder: _dateFormField),
            ExampleItem(desc: 'Date Range Field', builder: _dateRangeField),
            ExampleItem(
              desc: 'Date Range Form Field',
              builder: _dateRangeFormField,
            ),
            ExampleItem(desc: 'Time Field', builder: _timeField),
            ExampleItem(desc: 'Month Field', builder: _monthField),
            ExampleItem(desc: 'Year Field', builder: _yearField),
          ],
        ),
      ],
    );
  }

  Widget _dateTimeField(BuildContext context) {
    return MyDateField(
      placeholder: 'Select Date & Time',
      margin: EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        LucideIcons.calendar,
        color: context.colorScheme.mutedForeground,
        size: 18,
      ),
      mode: DateTimeFieldPickerMode.dateTime,
    );
  }

  Widget _dateField(BuildContext context) {
    return MyDateField(
      placeholder: 'Select Date',
      margin: EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        LucideIcons.calendar,
        color: context.colorScheme.mutedForeground,
        size: 18,
      ),
      mode: DateTimeFieldPickerMode.date,
    );
  }

  Widget _dateFormField(BuildContext context) {
    return MyForm(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          MyDateFormField(
            mode: DateTimeFieldPickerMode.date,
            placeholder: 'Select Date',
            leading: Icon(
              LucideIcons.calendar,
              color: context.colorScheme.mutedForeground,
              size: 18,
            ),
            label: const Text('Date of birth'),
            description: const Text(
              'Your date of birth is used to calculate your age.',
            ),
            validator: (v) {
              if (v == null) {
                return 'A date of birth is required.';
              }
              return null;
            },
          ),
          MyButton(
            text: 'Submit',
            onTap: () {
              _formKey.currentState?.validate();
            },
          ),
        ],
      ).padding(horizontal: 16),
    );
  }

  Widget _dateRangeField(BuildContext context) {
    return MyDateField(
      mode: DateTimeFieldPickerMode.range,
      margin: EdgeInsets.symmetric(horizontal: 16),
      placeholder: 'Select From & To Date',
      leading: Icon(
        LucideIcons.calendar,
        color: context.colorScheme.mutedForeground,
        size: 18,
      ),
    );
  }

  Widget _dateRangeFormField(BuildContext context) {
    return MyForm(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          MyDateRangeFormField(
            placeholder: 'Select From & To Date',
            leading: Icon(
              LucideIcons.calendar,
              color: context.colorScheme.mutedForeground,
              size: 18,
            ),
            label: const Text('Range of dates'),
            description: const Text(
              'Select the range of dates you want to search between.',
            ),
            validator: (v) {
              if (v == null) return 'A range of dates is required.';

              return null;
            },
          ),
          MyButton(
            text: 'Submit',
            onTap: () {
              _formKey1.currentState?.validate();
            },
          ),
        ],
      ).padding(horizontal: 16),
    );
  }

  Widget _timeField(BuildContext context) {
    return MyDateField(
      margin: EdgeInsets.symmetric(horizontal: 16),
      mode: DateTimeFieldPickerMode.time,
      selected: DateTime.now(),
      leading: Icon(
        LucideIcons.clock,
        color: context.colorScheme.mutedForeground,
        size: 18,
      ),
    );
  }

  Widget _monthField(BuildContext context) {
    return MyDateField(
      margin: EdgeInsets.symmetric(horizontal: 16),
      mode: DateTimeFieldPickerMode.month,
      selected: DateTime.now(),
      leading: Icon(
        LucideIcons.clock,
        color: context.colorScheme.mutedForeground,
        size: 18,
      ),
    );
  }

  Widget _yearField(BuildContext context) {
    return MyDateField(
      margin: EdgeInsets.symmetric(horizontal: 16),
      mode: DateTimeFieldPickerMode.year,
      selected: DateTime.now(),
      leading: Icon(
        LucideIcons.clock,
        color: context.colorScheme.mutedForeground,
        size: 18,
      ),
    );
  }

  Wrap _defaultPickers(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        MyButton(
          text: 'Date Picker',
          onTap: () {
            MyDatePicker.date(context: context);
          },
        ),
        MyButton(
          text: 'Month Picker',
          onTap: () {
            MyDatePicker.month(context: context);
          },
        ),
        MyButton(
          text: 'Year Picker',
          onTap: () {
            MyDatePicker.year(context: context);
          },
        ),
        MyButton(
          text: 'Multi Dates Picker',
          onTap: () {
            MyDatePicker.dates(context: context);
          },
        ),
        MyButton(
          text: 'Date Range Picker',
          onTap: () {
            MyDatePicker.range(
              context: context,
              firstDate: DateTime(1990),
              lastDate: DateTime(2099),
            );
          },
        ),
        MyButton(
          text: 'Time Picker',
          onTap: () {
            MyDatePicker.time(context: context);
          },
        ),
        MyButton(
          text: 'Time Range Picker',
          onTap: () {
            MyDatePicker.timeRange(context: context);
          },
        ),
        MyButton(
          text: 'Date & Time Picker',
          onTap: () {
            MyDatePicker.dateTime(context: context);
          },
        ),
        MyButton(
          text: 'Duration Picker',
          onTap: () {
            MyDatePicker.duration(context: context);
          },
        ),
      ],
    );
  }
}
