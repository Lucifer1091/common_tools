import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDDatePickerPage extends StatefulWidget {
  const TDDatePickerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDDatePickerPageState();
}

class _TDDatePickerPageState extends State<TDDatePickerPage> {
  String selected_1 = '';
  String selected_2 = '';
  String selected_3 = '';
  String selected_4 = '';
  String selected_5 = '';
  String selected_6 = '';
  String selected_7 = '';
  String selected_8 = '';
  String selected_9 = '';

  var weekDayList = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于选择一个时间点或者一个时间段。',
      exampleCodeGroup: 'datetimePicker',
      children: [],
      test: [],
    );
  }
}
