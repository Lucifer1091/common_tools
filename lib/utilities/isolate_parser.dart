part of 'utilities.dart';

/// Typedef for a converter function that converts dynamic `response` to type `T`.
typedef ResponseConverter<T> = T Function(dynamic response);

/// Class that parses JSON data in a background isolate and converts it to type `T`.
///
/// This class spawns an isolate to execute the parsing and conversion process,
/// ensuring that the main UI thread remains responsive.
///
/// Example:
/// ```dart
/// void main() async {
///   // Example usage of IsolateParser
///   final jsonData = {'name': 'John Doe', 'age': 30};
///   final userFromJson = (json) => User.fromJson(json);
///   final isolateParser = IsolateParser<User>(jsonData, userFromJson);
///   final parsedUser = await isolateParser.parseInBackground();
///   print('Parsed User: $parsedUser');
/// }
/// ```
class IsolateParser<T> {
  final Map<String, dynamic> json;
  final ResponseConverter<T> converter;

  /// Constructs an `IsolateParser` with the given JSON data and converter function.
  IsolateParser(this.json, this.converter);

  /// Parses the JSON data in a background isolate and returns the result of type `T`.
  ///
  /// Returns a future that completes with the parsed result of type `T`.
  Future<T> parseInBackground() async {
    final port = ReceivePort();
    await Isolate.spawn(
      _parseJsonInBackground,
      _IsolateParams(json, converter, port.sendPort, null),
    );

    final result = await port.first;
    port.close();
    return result as T;
  }

  /// Static method running inside the isolate to perform JSON parsing and conversion.
  static void _parseJsonInBackground(_IsolateParams params) {
    final result = params.converter?.call(params.json);
    params.sendPort.send(result);
    Isolate.exit(params.sendPort, result);
  }
}

/// Class that executes a void action in a background isolate and returns a result of type `T`.
///
/// This class spawns an isolate to execute a void callback (`run`) in the background,
/// ensuring that the main UI thread remains responsive.
///
/// Example:
/// ```dart
/// void main() async {
///   // Example usage of VoidIsolateParser
///   final voidIsolateParser = VoidIsolateParser<void>(run: () {
///     print('Executing background task...');
///     // Simulating some background task
///     Future.delayed(Duration(seconds: 2), () {
///       print('Background task completed.');
///     });
///   });
///   await voidIsolateParser.parseInBackground();
///   print('Void task executed in background.');
/// }
/// ```
class VoidIsolateParser<T> {
  final VoidCallback? run;

  /// Constructs a `VoidIsolateParser` with an optional void callback `run`.
  VoidIsolateParser({this.run});

  /// Executes the void callback in a background isolate and returns the result of type `T`.
  ///
  /// Returns a future that completes after executing the `run` callback.
  Future<T> parseInBackground() async {
    final port = ReceivePort();
    await Isolate.spawn(
      _runInBackground,
      _IsolateParams(null, null, port.sendPort, run),
    );

    final result = await port.first;
    port.close();
    return result as T;
  }

  /// Static method running inside the isolate to execute the void callback (`run`).
  static void _runInBackground(_IsolateParams params) {
    params.run?.call();
    Isolate.exit(params.sendPort, '');
  }
}

/// Class representing parameters passed to an isolate.
///
/// This class encapsulates parameters (`json`, `converter`, `sendPort`, `run`)
/// passed to isolates in `IsolateParser` and `VoidIsolateParser`.
class _IsolateParams<T> {
  final Map<String, dynamic>? json;
  final ResponseConverter<T>? converter;
  final SendPort sendPort;
  final VoidCallback? run;

  /// Constructs `_IsolateParams` with the given parameters.
  _IsolateParams(this.json, this.converter, this.sendPort, this.run);
}
