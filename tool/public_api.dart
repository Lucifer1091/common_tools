import 'dart:io';

Future<void> main(List<String> arguments) async {
  final result = await Process.start(
    Platform.resolvedExecutable,
    ['run', 'tool/generate_catalog.dart', ...arguments],
    workingDirectory: Directory.current.path,
    mode: ProcessStartMode.inheritStdio,
  );
  exitCode = await result.exitCode;
}
