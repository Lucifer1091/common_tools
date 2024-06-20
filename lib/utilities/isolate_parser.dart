part of 'utilities.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

class IsolateParser<T> {
  final Map<String, dynamic> json;

  ResponseConverter<T> converter;

  IsolateParser(this.json, this.converter);

  Future<T> parseInBackground() async {
    final port = ReceivePort();
    await Isolate.spawn(_parseListOfJson, port.sendPort);

    final result = await port.first;
    return result as T;
  }

  Future<void> _parseListOfJson(SendPort sendPort) async {
    final result = converter(json);
    Isolate.exit(sendPort, result);
  }
}

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
