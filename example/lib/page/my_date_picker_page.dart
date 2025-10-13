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
      title: tdTitle(),
      desc: 'A widget that lets users select dates and date ranges.',
      exampleCodeGroup: 'datetimePicker',
      children: [
        ExampleModule(
          title: 'Default Pickers',
          children: [
            ExampleItem(
              padding: EdgeInsets.only(top: 16),
              builder: (context) {
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
                        showDateRangePicker(
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
                      text: 'Duration Picker',
                      onTap: () {
                        MyDatePicker.duration(context: context);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Custom Pickers',
          children: [
            ExampleItem(
              padding: EdgeInsets.only(top: 16),
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    MyButton(
                      text: 'Date Picker',
                      onTap: () {
                        DatePickers.show(
                          context: context,
                          mode: DateTimeFieldPickerMode.date,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2099),
                        );
                      },
                    ),
                    MyButton(
                      text: 'Time Picker',
                      onTap: () {
                        DatePickers.show(
                          context: context,
                          mode: DateTimeFieldPickerMode.time,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2099),
                        );
                      },
                    ),
                    MyButton(
                      text: 'Date & time Picker',
                      onTap: () {
                        DatePickers.show(
                          context: context,
                          mode: DateTimeFieldPickerMode.dateTime,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2099),
                        );
                      },
                    ),
                    MyButton(
                      text: 'Month Picker',
                      onTap: () {
                        DatePickers.show(
                          context: context,
                          mode: DateTimeFieldPickerMode.month,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2099),
                        );
                      },
                    ),
                    MyButton(
                      text: 'Year Picker',
                      onTap: () {
                        DatePickers.show(
                          context: context,
                          mode: DateTimeFieldPickerMode.year,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2099),
                        );
                      },
                    ),
                    MyButton(
                      text: 'Month / Year Picker',
                      onTap: () {
                        DatePickers.show(
                          context: context,
                          mode: DateTimeFieldPickerMode.monthYear,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2099),
                        );
                      },
                    ),
                    MyButton(
                      text: 'Range Picker',
                      onTap: () {
                        DatePickers.getDateRange(
                          context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2099),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
