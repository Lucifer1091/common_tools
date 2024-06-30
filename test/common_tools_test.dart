import 'package:common_tools/common_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Logger.configure();

  DateTime date = DateTime(2024, 6, 30);

  // log.f(date.isLastWeek);
  log.w(date.startOfWeek);
  log.f(date.startOfLastWeek);
}
