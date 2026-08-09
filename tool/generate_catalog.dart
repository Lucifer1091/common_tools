import 'dart:io';

Future<void> main(List<String> arguments) async {
  final root = Directory.current.absolute;
  final runner = Directory('tool/catalog');

  final getResult = await Process.start(
    Platform.resolvedExecutable,
    const ['pub', 'get'],
    workingDirectory: runner.path,
    mode: ProcessStartMode.inheritStdio,
  );
  if (await getResult.exitCode case final code when code != 0) {
    exitCode = code;
    return;
  }

  final generateResult = await Process.start(
    Platform.resolvedExecutable,
    ['run', 'bin/generate.dart', root.path, ...arguments],
    workingDirectory: runner.path,
    mode: ProcessStartMode.inheritStdio,
  );
  exitCode = await generateResult.exitCode;
}
