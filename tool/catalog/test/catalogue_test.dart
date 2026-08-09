import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  final repository = Directory('../..').absolute;
  final skill = Directory(
    '${repository.path}/.agents/skills/common-tools-flutter',
  );
  late Map<String, Object?> catalogue;
  late List<Map<String, Object?>> symbols;
  late List<Map<String, Object?>> files;

  setUpAll(() {
    catalogue =
        jsonDecode(
              File('${skill.path}/assets/catalogue.json').readAsStringSync(),
            )
            as Map<String, Object?>;
    symbols = (catalogue['symbols']! as List<Object?>)
        .cast<Map<String, Object?>>();
    files = (catalogue['files']! as List<Object?>).cast<Map<String, Object?>>();
  });

  test('inventories every Dart file under lib', () {
    final sourceCount = Directory('${repository.path}/lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .length;
    expect(files, hasLength(sourceCount));
    expect(catalogue['fileCount'], sourceCount);
    expect(files.map((file) => file['path']).toSet(), hasLength(sourceCount));
  });

  test('all public symbols have supported non-src imports', () {
    expect(symbols, isNotEmpty);
    for (final symbol in symbols) {
      final imports = (symbol['imports']! as List<Object?>).cast<String>();
      expect(imports, isNotEmpty, reason: '${symbol['name']} has no import');
      expect(
        imports,
        everyElement(
          allOf(startsWith('package:common_tools/'), isNot(contains('/src/'))),
        ),
        reason: '${symbol['name']} exposes an unsupported import',
      );
      expect(symbol['recommendedImport'], imports.first);
      expect(symbol['directImportAllowed'], isTrue);
      expect(symbol['internal'], isFalse);
    }
  });

  test('internal files are navigation-only', () {
    final internalFiles = files.where((file) => file['internal'] == true);
    expect(internalFiles, isNotEmpty);
    for (final file in internalFiles) {
      expect(
        file['directImportAllowed'],
        isFalse,
        reason: '${file['path']} must not be directly importable',
      );
    }
  });

  test('symbol keys and generated references are complete', () {
    final keys = <String>{};
    for (final symbol in symbols) {
      final key = '${symbol['source']}#${symbol['name']}';
      expect(keys.add(key), isTrue, reason: 'duplicate symbol $key');
      final reference = symbol['reference']! as String;
      expect(
        File('${skill.path}/$reference').existsSync(),
        isTrue,
        reason: 'missing reference for $key',
      );
    }
    expect(catalogue['publicSymbolCount'], symbols.length);
  });

  test('skill has no generated private member recommendations', () {
    for (final symbol in symbols) {
      final members = (symbol['members']! as List<Object?>).cast<String>();
      expect(
        members.where(
          (member) => RegExp(r'\b_[A-Za-z]\w*\s*\(').hasMatch(member),
        ),
        isEmpty,
        reason: '${symbol['name']} exposes a private method or constructor',
      );
    }
  });

  test('generated Markdown links resolve locally', () {
    final markdownFiles = <File>[
      File('${skill.path}/SKILL.md'),
      ...Directory(
        '${skill.path}/references',
      ).listSync().whereType<File>().where((file) => file.path.endsWith('.md')),
      File('${repository.path}/llms.txt'),
    ];
    final linkPattern = RegExp(r'\]\(([^)]+)\)');

    for (final markdown in markdownFiles) {
      final contents = markdown.readAsStringSync();
      for (final match in linkPattern.allMatches(contents)) {
        final target = match.group(1)!.split('#').first;
        if (target.isEmpty ||
            target.startsWith('http://') ||
            target.startsWith('https://')) {
          continue;
        }
        final resolved = File.fromUri(markdown.uri.resolve(target));
        expect(
          resolved.existsSync(),
          isTrue,
          reason: '${markdown.path} links to missing $target',
        );
      }
    }
  });

  test('skill entrypoint remains compact and portable', () {
    final entrypoint = File('${skill.path}/SKILL.md').readAsStringSync();
    expect(entrypoint.split('\n').length, lessThanOrEqualTo(500));
    expect(entrypoint, isNot(contains(r'\')));
  });

  test('public family references include usage guidance sections', () {
    final references = symbols
        .map((symbol) => symbol['reference']! as String)
        .toSet();
    for (final reference in references) {
      final contents = File('${skill.path}/$reference').readAsStringSync();
      expect(contents, contains('### Purpose'), reason: reference);
      expect(contents, contains('### Setup and platform'), reason: reference);
      expect(
        contents,
        contains('### Minimal supported import'),
        reason: reference,
      );
      expect(
        contents,
        contains('### State, callbacks, and async'),
        reason: reference,
      );
      expect(contents, contains('### Common mistakes'), reason: reference);
      expect(
        contents,
        contains('### Related public symbols'),
        reason: reference,
      );
    }
  });
}
