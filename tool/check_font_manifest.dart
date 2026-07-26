import 'dart:convert';
import 'dart:io';

const _expectedFamilies = {
  'packages/common_tools/Geist': 'lib/fonts/geist/',
  'packages/common_tools/GeistMono': 'lib/fonts/geist_mono/',
};
const _expectedWeights = {100, 200, 300, 400, 500, 600, 700, 800, 900};

void main(List<String> arguments) {
  final manifestPath = arguments.isEmpty
      ? 'example/build/web/assets/FontManifest.json'
      : arguments.single;
  final manifestFile = File(manifestPath);

  if (!manifestFile.existsSync()) {
    stderr.writeln('Font manifest not found: ${manifestFile.absolute.path}');
    exitCode = 1;
    return;
  }

  final manifest =
      (jsonDecode(manifestFile.readAsStringSync()) as List<dynamic>)
          .cast<Map<String, dynamic>>();
  final entries = {
    for (final entry in manifest) entry['family'] as String: entry,
  };
  final errors = <String>[];

  for (final family in const ['Geist', 'GeistMono']) {
    if (entries.containsKey(family)) {
      errors.add('Unexpected app-local duplicate family: $family');
    }
  }

  for (final expected in _expectedFamilies.entries) {
    final entry = entries[expected.key];
    if (entry == null) {
      errors.add('Missing package font family: ${expected.key}');
      continue;
    }

    final fonts = (entry['fonts'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final weights = fonts
        .map((font) => font['weight'] as int?)
        .whereType<int>()
        .toSet();
    if (weights.length != _expectedWeights.length ||
        !weights.containsAll(_expectedWeights)) {
      errors.add(
        '${expected.key} has weights ${weights.toList()..sort()}; '
        'expected ${_expectedWeights.toList()..sort()}',
      );
    }

    for (final font in fonts) {
      final asset = font['asset'] as String;
      final expectedPrefix = 'packages/common_tools/${expected.value}';
      if (!asset.startsWith(expectedPrefix)) {
        errors.add(
          'Unexpected asset for ${expected.key}: $asset '
          '(expected prefix $expectedPrefix)',
        );
      }
    }
  }

  if (errors.isNotEmpty) {
    for (final error in errors) {
      stderr.writeln(error);
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Verified package-owned Geist and GeistMono families with all weights.',
  );
}
