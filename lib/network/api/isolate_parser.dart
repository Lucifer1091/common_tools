import 'dart:isolate';

import 'package:back_office/exports/index.dart';

class VoidIsolateParser<T> {
  VoidCallback? run;

  VoidIsolateParser({this.run});

  Future<T> parseInBackground() async {
    final port = ReceivePort();
    await Isolate.spawn(_parseListOfJson, port.sendPort);

    final result = await port.first;
    return result as T;
  }

  Future<void> _parseListOfJson(SendPort sendPort) async {
    run?.call();
    Isolate.exit(sendPort, '');
  }
}
