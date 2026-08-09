import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated catalogue covers lib and exposes supported imports', () {
    final catalogue =
        jsonDecode(
              File(
                '.agents/skills/common-tools-flutter/assets/catalogue.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    final files = (catalogue['files']! as List<Object?>)
        .cast<Map<String, Object?>>();
    final symbols = (catalogue['symbols']! as List<Object?>)
        .cast<Map<String, Object?>>();
    final sourceCount = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .length;

    expect(files, hasLength(sourceCount));
    expect(catalogue['fileCount'], sourceCount);
    expect(symbols, isNotEmpty);
    for (final symbol in symbols) {
      final recommendedImport = symbol['recommendedImport']! as String;
      expect(recommendedImport, startsWith('package:common_tools/'));
      expect(recommendedImport, isNot(contains('/src/')));
    }
  });
}
