import 'package:common_tools/index.dart';
import 'package:common_tools/widgets/components/index.dart';
import 'package:flutter/material.dart';

import '../../base/example_widget.dart';

class MyDatePickerPage extends StatefulWidget {
  const MyDatePickerPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyDatePickerPageState();
}

class _MyDatePickerPageState extends State<MyDatePickerPage> {
  @override
  void initState() {
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
            ExampleItem(desc: 'Date Time Field', builder: _dateField),
            ExampleItem(desc: 'Date Time Form Field', builder: _dateFormField),
            ExampleItem(desc: 'Date Range Field', builder: _dateRangeField),
            ExampleItem(
              desc: 'Date Range Form Field',
              builder: _dateRangeFormField,
            ),
            ExampleItem(desc: 'Time Field', builder: _timeField),
          ],
        ),
      ],
    );
  }

  Widget _dateField(BuildContext context) {
    return MyDateField(margin: EdgeInsets.symmetric(horizontal: 16));
  }

  Widget _dateFormField(BuildContext context) {
    return MyDateField(margin: EdgeInsets.symmetric(horizontal: 16));
  }

  Widget _dateRangeField(BuildContext context) {
    return MyDateField(
      margin: EdgeInsets.symmetric(horizontal: 16),
      variant: DateTimeFieldPickerMode.range,
    );
  }

  Widget _dateRangeFormField(BuildContext context) {
    return MyDateField(
      margin: EdgeInsets.symmetric(horizontal: 16),
      variant: DateTimeFieldPickerMode.range,
    );
  }

  Widget _timeField(BuildContext context) {
    return MyDateField(
      margin: EdgeInsets.symmetric(horizontal: 16),
      variant: DateTimeFieldPickerMode.time,
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
