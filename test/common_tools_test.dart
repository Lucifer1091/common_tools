import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:common_tools/common_tools.dart';

void main() {
  Logger.configure();

  log.f(4324324232343.getSizeWithSuffix(bytes: 4324324232343, decimals: 2));
}
