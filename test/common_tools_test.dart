import 'package:common_tools/common_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Logger.configure();

  DateTime date = DateTime(2025, 1);

  log.f(date.weekday);

  log.w(date.weekNumber);
}
