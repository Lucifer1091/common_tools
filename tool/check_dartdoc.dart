import 'dart:io';

const _documentedLibraries = <String>[
  'common_tools.components.actions',
  'common_tools.components.data_display',
  'common_tools.components.feedback',
  'common_tools.components.forms',
  'common_tools.components.media',
  'common_tools.components.navigation',
  'common_tools.extensions.context',
  'common_tools.extensions.date',
  'common_tools.extensions.duration',
  'common_tools.extensions.iterable',
  'common_tools.extensions.map',
  'common_tools.extensions.number',
  'common_tools.extensions.string',
  'common_tools.extensions.widget',
  'common_tools.files',
  'common_tools.layout',
  'common_tools.localization',
  'common_tools.network',
  'common_tools.services',
  'common_tools.theme',
  'common_tools.utilities',
];

Future<void> main() async {
  final root = Directory.current.absolute.path;
  final runner = Directory('tool/dartdoc');

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

  final dartdoc = await Process.start(
    Platform.resolvedExecutable,
    [
      'run',
      'dartdoc',
      '--input',
      root,
      '--no-generate-docs',
      '--exclude-packages',
      'flutter',
      '--include',
      _documentedLibraries.join(','),
    ],
    workingDirectory: runner.path,
    mode: ProcessStartMode.inheritStdio,
  );
  exitCode = await dartdoc.exitCode;
}
