import 'package:common_tools/common_tools.dart';
import 'package:common_tools/extensions/num/converters.dart';
import 'package:common_tools/extensions/num/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Logger.configure();

  final DateTime date = DateTime(2024, 6, 30);

  final List<int> a = [];

  final int b = 5;
  //
  // // log.f(date.isLastWeek);
  // log.w(date.startOfWeek);
  // log.f(date.startOfLastWeek);

  log.i(20000.toClockFormat(showSeconds: true));
}
