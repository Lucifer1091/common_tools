import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

const _skillPath = '.agents/skills/common-tools-flutter';

const _referenceTitles = <String, String>{
  'themes-and-styling.md': 'Themes and styling',
  'layout-and-responsive.md': 'Layout and responsive APIs',
  'components-actions.md': 'Action components',
  'components-forms.md': 'Form components',
  'components-feedback.md': 'Feedback components',
  'components-data-display.md': 'Data-display components',
  'components-navigation.md': 'Navigation components',
  'components-media.md': 'Media components',
  'components-other.md': 'Other components',
  'animations-builders-lists.md': 'Animations, builders, and lists',
  'forms-and-validation.md': 'Form foundations and validation',
  'overlays-and-feedback.md': 'Overlay foundations',
  'extensions-context-widget.md': 'Context and widget extensions',
  'extensions-values.md': 'Value extensions',
  'networking.md': 'Networking',
  'files-and-services.md': 'Files and services',
  'utilities-and-data-types.md': 'Utilities and data types',
  'localization.md': 'Localization',
};

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    stderr.writeln('Repository root argument is required.');
    exitCode = 64;
    return;
  }
  final root = Directory(arguments.first).absolute;
  final check = arguments.skip(1).contains('--check');
  final generator = CatalogGenerator(root);
  final outputs = generator.generate();
  var different = false;

  for (final entry in outputs.entries) {
    final file = File('${root.path}${Platform.pathSeparator}${entry.key}');
    final existing = file.existsSync() ? file.readAsStringSync() : null;
    if (existing == entry.value) continue;
    different = true;
    if (check) {
      stderr.writeln('Catalogue output is stale: ${entry.key}');
      continue;
    }
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    stdout.writeln('Generated ${entry.key}');
  }

  if (check && different) {
    stderr.writeln(
      'Run `dart run tool/generate_catalog.dart` and review the changes.',
    );
    exitCode = 1;
    return;
  }
  if (check) stdout.writeln('Agent catalogue is current.');
}

class CatalogGenerator {
  CatalogGenerator(this.root);

  final Directory root;
  final Map<String, ParsedFile> _parsed = {};
  final Map<String, Map<String, Set<String>>> _namespaceCache = {};
  final Set<String> _namespaceStack = {};

  Map<String, String> generate() {
    final lib = Directory('${root.path}${Platform.pathSeparator}lib');
    final dartFiles =
        lib
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => _relative(a).compareTo(_relative(b)));
    for (final file in dartFiles) {
      _parsed[_normalize(file.path)] = _parse(file);
    }

    final entrypoints = _parsed.values.where(_isEntrypoint).toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    final exposure = <String, Set<String>>{};
    for (final entrypoint in entrypoints) {
      final import = 'package:common_tools/${entrypoint.path.substring(4)}';
      final namespace = _namespaceFor(entrypoint.absolutePath);
      for (final keys in namespace.values) {
        for (final key in keys) {
          exposure.putIfAbsent(key, () => <String>{}).add(import);
        }
      }
    }

    final symbols = <SymbolRecord>[];
    for (final parsed in _parsed.values) {
      for (final symbol in parsed.symbols) {
        final imports = exposure[symbol.key]?.toList() ?? const <String>[];
        if (imports.isEmpty) continue;
        final sortedImports = imports.toList()..sort(_compareImports);
        symbols.add(
          symbol.copyWith(
            imports: sortedImports,
            recommendedImport: sortedImports.first,
            platforms: parsed.platformNotes,
          ),
        );
      }
    }
    symbols.sort((a, b) {
      final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return byName != 0 ? byName : a.source.compareTo(b.source);
    });

    final files = _parsed.values.map((parsed) {
      final exposed = <String>{};
      for (final symbol in parsed.symbols) {
        exposed.addAll(exposure[symbol.key] ?? const <String>{});
      }
      final exportedDeclarations =
          parsed.symbols
              .where(
                (symbol) =>
                    (exposure[symbol.key] ?? const <String>{}).isNotEmpty,
              )
              .map((symbol) => symbol.name)
              .toList()
            ..sort();
      final relatedFiles =
          _parsed.values
              .where(
                (candidate) =>
                    candidate.path != parsed.path &&
                    _parentPath(candidate.path) == _parentPath(parsed.path),
              )
              .map((candidate) => candidate.path)
              .toList()
            ..sort();
      return parsed.toFileRecord(
        exposed.toList()..sort(_compareImports),
        exportedDeclarations,
        relatedFiles,
      );
    }).toList()..sort((a, b) => a.path.compareTo(b.path));

    final catalogue = <String, Object?>{
      'schemaVersion': 1,
      'source': 'lib/**/*.dart',
      'generatedBy': 'dart run tool/generate_catalog.dart',
      'fileCount': files.length,
      'publicSymbolCount': symbols.length,
      'entrypointCount': entrypoints.length,
      'entrypoints': entrypoints
          .map((entry) => 'package:common_tools/${entry.path.substring(4)}')
          .toList(),
      'symbols': symbols.map((symbol) => symbol.toJson()).toList(),
      'files': files.map((file) => file.toJson()).toList(),
    };

    final references = _buildReferences(symbols, files, entrypoints);
    final outputs = <String, String>{
      '$_skillPath/assets/catalogue.json':
          '${const JsonEncoder.withIndent('  ').convert(catalogue)}\n',
      ...references.map(
        (name, content) => MapEntry('$_skillPath/references/$name', content),
      ),
      'llms.txt': _buildLlmsIndex(references),
      'llms-full.txt': _buildLlmsFull(references),
      'tool/public_api.txt': _buildPublicApi(symbols),
    };
    return outputs;
  }

  ParsedFile _parse(File file) {
    final source = file.readAsStringSync();
    final relative = _relative(file);
    final result = parseString(
      content: source,
      path: file.path,
      throwIfDiagnostics: false,
    );
    final symbols = <SymbolRecord>[];
    var privateDeclarationCount = 0;
    for (final declaration in result.unit.declarations) {
      if (declaration is TopLevelVariableDeclaration) {
        for (final variable in declaration.variables.variables) {
          final name = variable.name.lexeme;
          if (name.startsWith('_')) {
            privateDeclarationCount++;
            continue;
          }
          symbols.add(
            _symbol(
              relative,
              name,
              'variable',
              _variableSignature(declaration.variables, name),
              _documentation(declaration),
              const [],
            ),
          );
        }
        continue;
      }
      final name = _declarationName(declaration);
      if (name == null) continue;
      if (name.startsWith('_')) {
        privateDeclarationCount++;
        continue;
      }
      symbols.add(
        _symbol(
          relative,
          name,
          _declarationKind(declaration),
          _signature(declaration),
          _documentation(declaration),
          _memberSignatures(declaration),
        ),
      );
    }

    final exports = <ExportSpec>[];
    final exportPattern = RegExp(
      r'''export\s+['"]([^'"]+)['"]([^;]*);''',
      multiLine: true,
    );
    for (final match in exportPattern.allMatches(source)) {
      final tail = match.group(2) ?? '';
      final uris = <String>[match.group(1)!];
      uris.addAll(
        RegExp(
          r'''if\s*\([^)]*\)\s*['"]([^'"]+)['"]''',
        ).allMatches(tail).map((match) => match.group(1)!),
      );
      final show = _namesAfter(tail, 'show');
      final hide = _namesAfter(tail, 'hide');
      exports.add(ExportSpec(uris, show, hide));
    }
    final parts = RegExp(
      r'''part\s+['"]([^'"]+)['"]\s*;''',
    ).allMatches(source).map((match) => match.group(1)!).toList();
    final conditional = source.contains(RegExp(r'\bif\s*\([^)]*dart\.library'));
    final platformNotes = <String>{};
    for (final match in RegExp(
      r'dart\.library\.([a-zA-Z0-9_]+)',
    ).allMatches(source)) {
      platformNotes.add(match.group(1)!);
    }

    return ParsedFile(
      absolutePath: _normalize(file.path),
      path: relative,
      source: source,
      symbols: symbols,
      exports: exports,
      parts: parts,
      isPart: RegExp(r'^\s*part\s+of\b', multiLine: true).hasMatch(source),
      hasConditionalDirective: conditional,
      platformNotes: platformNotes.toList()..sort(),
      privateDeclarationCount: privateDeclarationCount,
    );
  }

  SymbolRecord _symbol(
    String source,
    String name,
    String kind,
    String signature,
    String documentation,
    List<String> members,
  ) {
    final classification = _classify(source);
    return SymbolRecord(
      key: '$source#$name',
      name: name,
      kind: kind,
      signature: signature,
      documentation: documentation,
      members: members,
      deprecation: _deprecationForSource(signature),
      platforms: const [],
      source: source,
      domain: classification.domain,
      family: classification.family,
      reference: classification.reference,
      imports: const [],
      recommendedImport: '',
    );
  }

  Map<String, Set<String>> _namespaceFor(String absolutePath) {
    final normalized = _normalize(absolutePath);
    final cached = _namespaceCache[normalized];
    if (cached != null) return cached;
    if (!_namespaceStack.add(normalized)) return const {};
    final parsed = _parsed[normalized];
    if (parsed == null) return const {};
    final result = <String, Set<String>>{};
    void addSymbol(SymbolRecord symbol) {
      result.putIfAbsent(symbol.name, () => <String>{}).add(symbol.key);
    }

    for (final symbol in parsed.symbols) {
      addSymbol(symbol);
    }
    for (final part in parsed.parts) {
      final target = _resolveLocal(parsed.absolutePath, part);
      final partFile = target == null ? null : _parsed[target];
      if (partFile != null) {
        for (final symbol in partFile.symbols) {
          addSymbol(symbol);
        }
      }
    }
    for (final export in parsed.exports) {
      for (final uri in export.uris) {
        final target = _resolveLocal(parsed.absolutePath, uri);
        if (target == null) continue;
        final exported = _namespaceFor(target);
        for (final entry in exported.entries) {
          if (export.show.isNotEmpty && !export.show.contains(entry.key)) {
            continue;
          }
          if (export.hide.contains(entry.key)) {
            continue;
          }
          result.putIfAbsent(entry.key, () => <String>{}).addAll(entry.value);
        }
      }
    }
    _namespaceStack.remove(normalized);
    _namespaceCache[normalized] = result;
    return result;
  }

  String? _resolveLocal(String from, String uri) {
    if (uri.startsWith('dart:') || uri.startsWith('package:')) return null;
    final resolved = _normalize(File.fromUri(File(from).uri.resolve(uri)).path);
    return _parsed.containsKey(resolved) ? resolved : null;
  }

  Map<String, String> _buildReferences(
    List<SymbolRecord> symbols,
    List<FileRecord> files,
    List<ParsedFile> entrypoints,
  ) {
    final output = <String, String>{};
    final byReference = <String, List<SymbolRecord>>{};
    for (final symbol in symbols) {
      byReference.putIfAbsent(symbol.reference, () => []).add(symbol);
    }
    for (final entry in _referenceTitles.entries) {
      output[entry.key] = _domainReference(
        entry.value,
        byReference[entry.key] ?? const [],
      );
    }
    output['setup-and-imports.md'] = _setupReference(entrypoints, symbols);
    output['catalogue-index.md'] = _catalogueIndex(symbols, files, byReference);
    output['internal-file-index.md'] = _fileIndex(files);
    return output;
  }

  String _domainReference(String title, List<SymbolRecord> symbols) {
    final buffer = StringBuffer()
      ..writeln('<!-- Generated by `dart run tool/generate_catalog.dart`. -->')
      ..writeln('# $title')
      ..writeln()
      ..writeln(
        'Use only the public imports shown below. Search exact APIs with '
        '`scripts/query_catalog.dart`.',
      )
      ..writeln();
    final families = <String, List<SymbolRecord>>{};
    for (final symbol in symbols) {
      families.putIfAbsent(symbol.family, () => []).add(symbol);
    }
    if (families.length > 2) {
      buffer
        ..writeln('## Contents')
        ..writeln();
      for (final family in families.keys.toList()..sort()) {
        buffer.writeln(
          '- [${_display(family)}](#${_anchor(_display(family))})',
        );
      }
      buffer.writeln();
    }
    for (final family in families.keys.toList()..sort()) {
      final familySymbols = families[family]!
        ..sort((a, b) => a.name.compareTo(b.name));
      final imports =
          familySymbols
              .map((symbol) => symbol.recommendedImport)
              .toSet()
              .toList()
            ..sort(_compareImports);
      final documented = familySymbols
          .where((symbol) => symbol.documentation.isNotEmpty)
          .toList();
      final platforms =
          familySymbols.expand((symbol) => symbol.platforms).toSet()
            ..removeWhere((note) => note.isEmpty);
      final controllers = familySymbols
          .where((symbol) => symbol.name.contains('Controller'))
          .map((symbol) => symbol.name)
          .toList();
      final asynchronous = familySymbols
          .where(
            (symbol) =>
                symbol.signature.contains('Future<') ||
                symbol.signature.contains('Stream<') ||
                symbol.members.any(
                  (member) =>
                      member.contains('Future<') || member.contains('Stream<'),
                ),
          )
          .map((symbol) => symbol.name)
          .toList();
      final callbacks = familySymbols
          .where(
            (symbol) => symbol.members.any(
              (member) =>
                  member.contains('Callback') ||
                  member.contains('ValueChanged<') ||
                  member.contains('void Function('),
            ),
          )
          .map((symbol) => symbol.name)
          .toList();
      buffer
        ..writeln('## ${_display(family)}')
        ..writeln()
        ..writeln('### Purpose')
        ..writeln()
        ..writeln(
          documented.isNotEmpty
              ? _firstDocumentationParagraph(documented.first.documentation)
              : 'This family contains ${familySymbols.length} public APIs '
                    'defined by the `${familySymbols.first.source}` source '
                    'family. No source-level purpose prose is available.',
        )
        ..writeln()
        ..writeln('### Setup and platform')
        ..writeln();
      if (platforms.isEmpty) {
        buffer.writeln(
          'No conditional platform restriction is declared for this family '
          'under `lib/`.',
        );
      } else {
        for (final note in platforms.toList()..sort()) {
          buffer.writeln('- $note');
        }
      }
      buffer
        ..writeln()
        ..writeln('### Minimal supported import')
        ..writeln()
        ..writeln('Preferred imports:');
      for (final import in imports.take(5)) {
        buffer.writeln('- `$import`');
      }
      buffer
        ..writeln()
        ..writeln('```dart')
        ..writeln("import '${imports.first}';")
        ..writeln('```')
        ..writeln()
        ..writeln('### State, callbacks, and async')
        ..writeln()
        ..writeln(
          controllers.isEmpty
              ? '- No public controller type is declared in this family.'
              : '- Controller types: `${controllers.join('`, `')}`.',
        )
        ..writeln(
          callbacks.isEmpty
              ? '- No callback-bearing public type was detected.'
              : '- Callback-bearing types: `${callbacks.join('`, `')}`.',
        )
        ..writeln(
          asynchronous.isEmpty
              ? '- No public `Future` or `Stream` signature was detected.'
              : '- Async-bearing types: `${asynchronous.join('`, `')}`.',
        )
        ..writeln()
        ..writeln('### Common mistakes')
        ..writeln()
        ..writeln('- Do not import the defining `lib/src/` file.')
        ..writeln(
          '- Do not infer parameters or defaults beyond the signatures below.',
        )
        ..writeln()
        ..writeln('### Related public symbols')
        ..writeln()
        ..writeln(familySymbols.map((symbol) => '`${symbol.name}`').join(', '))
        ..writeln();
      for (final symbol in familySymbols) {
        buffer
          ..writeln('### `${symbol.name}`')
          ..writeln()
          ..writeln('- Kind: ${symbol.kind}')
          ..writeln('- Import: `${symbol.recommendedImport}`')
          ..writeln('- Source: `${symbol.source}`')
          ..writeln('- Signature: `${_escapeInline(symbol.signature)}`');
        if (symbol.documentation.isNotEmpty) {
          buffer
            ..writeln()
            ..writeln(symbol.documentation)
            ..writeln();
        } else {
          buffer.writeln();
        }
        if (symbol.deprecation.isNotEmpty) {
          buffer.writeln('Deprecated: `${_escapeInline(symbol.deprecation)}`');
          buffer.writeln();
        }
        if (symbol.members.isNotEmpty) {
          buffer.writeln('Owned public members:');
          for (final member in symbol.members) {
            buffer.writeln('- `${_escapeInline(member)}`');
          }
          buffer.writeln();
        }
      }
    }
    return buffer.toString();
  }

  String _firstDocumentationParagraph(String documentation) {
    final paragraph = documentation.split(RegExp(r'\n\s*\n')).first.trim();
    return paragraph.replaceAll(RegExp(r'\s+'), ' ');
  }

  String _setupReference(
    List<ParsedFile> entrypoints,
    List<SymbolRecord> symbols,
  ) {
    final buffer = StringBuffer()
      ..writeln('<!-- Generated by `dart run tool/generate_catalog.dart`. -->')
      ..writeln('# Setup and imports')
      ..writeln()
      ..writeln(
        'Use a non-`src` facade. Prefer the narrowest facade that exposes the API.',
      )
      ..writeln()
      ..writeln('```dart')
      ..writeln("import 'package:common_tools/common_tools.dart';")
      ..writeln('```')
      ..writeln()
      ..writeln('Never import `package:common_tools/src/...`.')
      ..writeln()
      ..writeln('## Public entrypoints')
      ..writeln();
    for (final entrypoint in entrypoints) {
      final import = 'package:common_tools/${entrypoint.path.substring(4)}';
      final count = symbols
          .where((symbol) => symbol.imports.contains(import))
          .length;
      buffer.writeln('- `$import` — $count symbols');
    }
    return buffer.toString();
  }

  String _catalogueIndex(
    List<SymbolRecord> symbols,
    List<FileRecord> files,
    Map<String, List<SymbolRecord>> byReference,
  ) {
    final buffer = StringBuffer()
      ..writeln('<!-- Generated by `dart run tool/generate_catalog.dart`. -->')
      ..writeln('# Common Tools catalogue')
      ..writeln()
      ..writeln('- Source boundary: `lib/**/*.dart`')
      ..writeln('- Inventoried Dart files: ${files.length}')
      ..writeln('- Supported public symbols: ${symbols.length}')
      ..writeln()
      ..writeln('## Domains')
      ..writeln();
    for (final entry in _referenceTitles.entries) {
      buffer.writeln(
        '- [${entry.value}](${entry.key}) — ${byReference[entry.key]?.length ?? 0} symbols',
      );
    }
    buffer
      ..writeln()
      ..writeln('## Lookup')
      ..writeln()
      ..writeln('```shell')
      ..writeln(
        'dart run .agents/skills/common-tools-flutter/scripts/query_catalog.dart MyButton',
      )
      ..writeln('```')
      ..writeln()
      ..writeln(
        'Use [internal-file-index.md](internal-file-index.md) only for codebase navigation.',
      );
    return buffer.toString();
  }

  String _fileIndex(List<FileRecord> files) {
    final buffer = StringBuffer()
      ..writeln('<!-- Generated by `dart run tool/generate_catalog.dart`. -->')
      ..writeln('# Complete `lib/` file inventory')
      ..writeln()
      ..writeln(
        'Files under `lib/src/` are implementation details. Navigate them when '
        'debugging, but import only the public facades reported by the catalogue.',
      )
      ..writeln()
      ..writeln(
        '| File | Role | Domain / family | Public symbols | Direct import |',
      )
      ..writeln('|---|---|---|---:|:---:|');
    for (final file in files) {
      buffer.writeln(
        '| `${file.path}` | ${file.role} | ${file.domain} / ${file.family} | '
        '${file.exportedDeclarations.length} | ${file.directImportAllowed ? 'yes' : 'no'} |',
      );
    }
    return buffer.toString();
  }

  String _buildLlmsIndex(Map<String, String> references) {
    final buffer = StringBuffer()
      ..writeln('# common_tools')
      ..writeln()
      ..writeln(
        '> Private Flutter package catalogue generated exclusively from `lib/**/*.dart`.',
      )
      ..writeln()
      ..writeln(
        'Never import `package:common_tools/src/...`. Use the narrowest public facade.',
      )
      ..writeln()
      ..writeln('## Guides')
      ..writeln();
    for (final entry in _referenceTitles.entries) {
      buffer.writeln(
        '- [${entry.value}]($_skillPath/references/${entry.key}): Generated public API reference.',
      );
    }
    buffer
      ..writeln()
      ..writeln('## Optional')
      ..writeln()
      ..writeln(
        '- [Complete internal file index]($_skillPath/references/internal-file-index.md): Navigation only; do not import internal paths.',
      );
    return buffer.toString();
  }

  String _buildLlmsFull(Map<String, String> references) {
    final order = <String>[
      'setup-and-imports.md',
      ..._referenceTitles.keys,
      'internal-file-index.md',
    ];
    final buffer = StringBuffer()
      ..writeln('# common_tools full LLM reference')
      ..writeln()
      ..writeln('Generated exclusively from `lib/**/*.dart`.')
      ..writeln()
      ..writeln('Never import `package:common_tools/src/...`.')
      ..writeln();
    for (final name in order) {
      buffer
        ..writeln('---')
        ..writeln()
        ..writeln(
          references[name]!.replaceFirst(RegExp(r'^<!--.*?-->\r?\n'), ''),
        );
    }
    return buffer.toString();
  }

  String _buildPublicApi(List<SymbolRecord> symbols) {
    final lines =
        symbols
            .map((symbol) => '${symbol.name}\t${symbol.source}')
            .toSet()
            .toList()
          ..sort();
    return [
      '# Generated by `dart run tool/generate_catalog.dart`.',
      '# Review changes to this file as public API changes.',
      ...lines,
      '',
    ].join('\n');
  }

  bool _isEntrypoint(ParsedFile file) {
    if (file.isPart || file.path.startsWith('lib/src/')) return false;
    return !file.path.split('/').last.startsWith('_');
  }

  String _relative(File file) =>
      _normalize(file.absolute.path.substring(root.path.length + 1));
}

String? _declarationName(CompilationUnitMember declaration) {
  if (declaration is ClassDeclaration) {
    return declaration.namePart.typeName.lexeme;
  }
  if (declaration is EnumDeclaration) {
    return declaration.namePart.typeName.lexeme;
  }
  if (declaration is MixinDeclaration) return declaration.name.lexeme;
  if (declaration is ExtensionDeclaration) return declaration.name?.lexeme;
  if (declaration is ExtensionTypeDeclaration) {
    return declaration.namePart.typeName.lexeme;
  }
  if (declaration is GenericTypeAlias) return declaration.name.lexeme;
  if (declaration is FunctionTypeAlias) return declaration.name.lexeme;
  if (declaration is ClassTypeAlias) return declaration.name.lexeme;
  if (declaration is FunctionDeclaration) return declaration.name.lexeme;
  return null;
}

String _declarationKind(CompilationUnitMember declaration) {
  if (declaration is ClassDeclaration) return 'class';
  if (declaration is EnumDeclaration) return 'enum';
  if (declaration is MixinDeclaration) return 'mixin';
  if (declaration is ExtensionDeclaration) return 'extension';
  if (declaration is ExtensionTypeDeclaration) return 'extension type';
  if (declaration is GenericTypeAlias || declaration is FunctionTypeAlias) {
    return 'typedef';
  }
  if (declaration is ClassTypeAlias) return 'class alias';
  if (declaration is FunctionDeclaration) return 'function';
  return 'declaration';
}

String _signature(CompilationUnitMember declaration) {
  final source = declaration.toSource();
  if (declaration is GenericTypeAlias ||
      declaration is FunctionTypeAlias ||
      declaration is ClassTypeAlias) {
    return _compactSignature(source);
  }
  return _compactSignature(_header(source));
}

List<String> _memberSignatures(CompilationUnitMember declaration) {
  final members = <ClassMember>[];
  if (declaration is ClassDeclaration) members.addAll(declaration.body.members);
  if (declaration is EnumDeclaration) members.addAll(declaration.body.members);
  if (declaration is MixinDeclaration) members.addAll(declaration.body.members);
  if (declaration is ExtensionDeclaration) {
    members.addAll(declaration.body.members);
  }
  if (declaration is ExtensionTypeDeclaration) {
    members.addAll(declaration.body.members);
  }
  final signatures = <String>[];
  if (declaration is EnumDeclaration) {
    signatures.addAll(
      declaration.body.constants
          .where((constant) => !constant.name.lexeme.startsWith('_'))
          .map((constant) => constant.toSource()),
    );
  }
  for (final member in members) {
    if (member is MethodDeclaration && member.name.lexeme.startsWith('_')) {
      continue;
    }
    if (member is ConstructorDeclaration &&
        member.name != null &&
        member.name!.lexeme.startsWith('_')) {
      continue;
    }
    if (member is FieldDeclaration) {
      final publicNames = member.fields.variables
          .map((variable) => variable.name.lexeme)
          .where((name) => !name.startsWith('_'));
      if (publicNames.isEmpty) continue;
    }
    final signature = switch (member) {
      ConstructorDeclaration() => _constructorSignature(member),
      MethodDeclaration() => _methodSignature(member),
      FieldDeclaration() => _fieldSignature(member),
      _ => _compactSignature(_header(member.toSource())),
    };
    signatures.add(signature);
  }
  return signatures.where((value) => value.isNotEmpty).toSet().toList()..sort();
}

String _constructorSignature(ConstructorDeclaration declaration) {
  final parts = <String>[
    if (declaration.externalKeyword != null) 'external',
    if (declaration.constKeyword != null) 'const',
    if (declaration.factoryKeyword != null) 'factory',
    if (declaration.newKeyword != null) 'new',
    if (declaration.typeName != null) declaration.typeName!.toSource(),
    if (declaration.period != null) '.',
    if (declaration.name != null) declaration.name!.lexeme,
    declaration.parameters.toSource(),
  ];
  return _compactSignature(parts.join(' ').replaceAll(' . ', '.'));
}

String _methodSignature(MethodDeclaration declaration) {
  final parts = <String>[
    if (declaration.externalKeyword != null) 'external',
    if (declaration.modifierKeyword != null)
      declaration.modifierKeyword!.lexeme,
    if (declaration.returnType != null) declaration.returnType!.toSource(),
    if (declaration.propertyKeyword != null)
      declaration.propertyKeyword!.lexeme,
    if (declaration.operatorKeyword != null)
      declaration.operatorKeyword!.lexeme,
    declaration.name.lexeme,
    if (declaration.typeParameters != null)
      declaration.typeParameters!.toSource(),
    if (declaration.parameters != null) declaration.parameters!.toSource(),
  ];
  return _compactSignature(parts.join(' '));
}

String _fieldSignature(FieldDeclaration declaration) {
  final fields = declaration.fields;
  final parts = <String>[
    if (declaration.externalKeyword != null) 'external',
    if (declaration.staticKeyword != null) 'static',
    if (declaration.abstractKeyword != null) 'abstract',
    if (declaration.covariantKeyword != null) 'covariant',
    if (fields.lateKeyword != null) 'late',
    if (fields.keyword != null) fields.keyword!.lexeme,
    if (fields.type != null) fields.type!.toSource(),
    fields.variables
        .map((variable) => variable.name.lexeme)
        .where((name) => !name.startsWith('_'))
        .join(', '),
  ];
  return '${_compactSignature(parts.join(' '))};';
}

String _parentPath(String path) {
  final separator = path.lastIndexOf('/');
  return separator == -1 ? '' : path.substring(0, separator);
}

String _variableSignature(VariableDeclarationList variables, String name) {
  final parts = <String>[
    if (variables.lateKeyword != null) 'late',
    if (variables.keyword != null) variables.keyword!.lexeme,
    if (variables.type != null) variables.type!.toSource(),
    name,
  ];
  return '${_compactSignature(parts.join(' '))};';
}

String _documentation(CompilationUnitMember declaration) {
  final comment = declaration.documentationComment;
  if (comment == null) return '';
  return comment.tokens
      .map(
        (token) => token.lexeme
            .replaceFirst(RegExp(r'^\s*///\s?'), '')
            .replaceFirst(RegExp(r'^\s*/\*\*?\s?'), '')
            .replaceFirst(RegExp(r'\s*\*/\s*$'), ''),
      )
      .join('\n')
      .trim();
}

String _header(String source) {
  var paren = 0;
  var bracket = 0;
  var angle = 0;
  var quote = '';
  for (var index = 0; index < source.length; index++) {
    final char = source[index];
    if (quote.isNotEmpty) {
      if (char == quote && (index == 0 || source[index - 1] != r'\')) {
        quote = '';
      }
      continue;
    }
    if (char == "'" || char == '"') {
      quote = char;
      continue;
    }
    if (char == '(') paren++;
    if (char == ')') paren--;
    if (char == '[') bracket++;
    if (char == ']') bracket--;
    if (char == '<') angle++;
    if (char == '>' && angle > 0) angle--;
    if (paren == 0 && bracket == 0 && angle == 0) {
      if (char == '{') return source.substring(0, index).trim();
      if (char == '=' &&
          index + 1 < source.length &&
          source[index + 1] == '>') {
        return source.substring(0, index).trim();
      }
    }
  }
  return source.trim();
}

String _compactSignature(String value) {
  final compact = value.replaceAll(RegExp(r'\s+'), ' ').trim();
  return compact.length <= 1000 ? compact : '${compact.substring(0, 997)}...';
}

String _deprecationForSource(String signature) {
  final match = RegExp(r'@Deprecated\(([^)]*)\)').firstMatch(signature);
  if (match != null) return match.group(1)!.trim();
  return signature.contains('@deprecated') ? 'deprecated' : '';
}

Set<String> _namesAfter(String tail, String keyword) {
  final match = RegExp(
    '\\b$keyword\\s+([^;]+?)(?=\\bshow\\b|\\bhide\\b|\$)',
  ).firstMatch(tail);
  if (match == null) return {};
  return match
      .group(1)!
      .split(',')
      .map((name) => name.trim())
      .where((name) => RegExp(r'^[A-Za-z_]\w*$').hasMatch(name))
      .toSet();
}

Classification _classify(String path) {
  final segments = path.split('/');
  String familyAfter(String marker, [String fallback = 'general']) {
    final index = segments.indexOf(marker);
    return index >= 0 && index + 1 < segments.length
        ? segments[index + 1].replaceAll('.dart', '')
        : fallback;
  }

  if (path.contains('/themes/') || path == 'lib/theme.dart') {
    return Classification(
      'theme',
      familyAfter('themes'),
      'themes-and-styling.md',
    );
  }
  if (path.contains('/widgets/layout/') || path == 'lib/layout.dart') {
    return Classification(
      'layout',
      familyAfter('layout'),
      'layout-and-responsive.md',
    );
  }
  if (path.contains('/widgets/components/')) {
    final family = familyAfter('components');
    const actions = {'action_sheet', 'button', 'drop_down_menu', 'menu'};
    const forms = {
      'checkbox',
      'color_picker',
      'date_time_picker',
      'input',
      'otp',
      'picker',
      'phone_input',
      'radio',
      'rating_bar',
      'select',
      'slider',
      'stepper',
      'switch',
      'text_area',
      'upload',
    };
    const feedback = {
      'dialog',
      'error',
      'loading',
      'notice_bar',
      'popover',
      'popup',
      'progress',
      'refresh',
      'result',
      'skeleton',
      'swipe_cell',
      'toast',
    };
    const data = {
      'avatar',
      'badge',
      'cell',
      'chat',
      'collapse',
      'footer',
      'indexes',
      'numbers',
      'table',
      'tag',
      'text',
      'time_counter',
      'tree',
    };
    const navigation = {
      'backtop',
      'breadcrumb',
      'drawer',
      'navbar',
      'pagination',
      'sidebar',
      'steps',
      'tabs',
    };
    const media = {'image', 'image_viewer', 'swiper'};
    final reference = actions.contains(family)
        ? 'components-actions.md'
        : forms.contains(family)
        ? 'components-forms.md'
        : feedback.contains(family)
        ? 'components-feedback.md'
        : data.contains(family)
        ? 'components-data-display.md'
        : navigation.contains(family)
        ? 'components-navigation.md'
        : media.contains(family)
        ? 'components-media.md'
        : 'components-other.md';
    return Classification('components', family, reference);
  }
  if (path.startsWith('lib/components/')) {
    final family = segments.last.replaceAll('.dart', '');
    final reference = switch (family) {
      'actions' => 'components-actions.md',
      'forms' => 'components-forms.md',
      'feedback' => 'components-feedback.md',
      'data_display' => 'components-data-display.md',
      'navigation' => 'components-navigation.md',
      'media' => 'components-media.md',
      _ => 'components-other.md',
    };
    return Classification('components', family, reference);
  }
  if (path.contains('/widgets/animations/') ||
      path.contains('/widgets/builders/') ||
      path.contains('/widgets/lists/') ||
      path.contains('/widgets/common/') ||
      path.contains('/widgets/display/') ||
      path.contains('/widgets/custom/') ||
      path.contains('/widgets/misc/') ||
      path.contains('/widgets/packages/')) {
    return Classification(
      'widgets',
      familyAfter('widgets'),
      'animations-builders-lists.md',
    );
  }
  if (path.contains('/widgets/form/')) {
    return Classification(
      'forms',
      familyAfter('form'),
      'forms-and-validation.md',
    );
  }
  if (path.contains('/overlays/')) {
    return Classification(
      'overlays',
      familyAfter('overlays'),
      'overlays-and-feedback.md',
    );
  }
  if (path.contains('/extensions/context/') ||
      path.endsWith('/extensions/widget.dart') ||
      path.endsWith('/extensions/context.dart')) {
    return Classification(
      'extensions',
      familyAfter('extensions'),
      'extensions-context-widget.md',
    );
  }
  if (path.contains('/extensions/') || path.startsWith('lib/extensions/')) {
    return Classification(
      'extensions',
      familyAfter('extensions'),
      'extensions-values.md',
    );
  }
  if (path.contains('/network/') || path == 'lib/network.dart') {
    return Classification(
      'networking',
      familyAfter('network'),
      'networking.md',
    );
  }
  if (path.contains('/services/') ||
      path == 'lib/services.dart' ||
      path == 'lib/files.dart') {
    return Classification(
      'files-services',
      familyAfter('services', 'files'),
      'files-and-services.md',
    );
  }
  if (path.contains('/localization/') || path == 'lib/localization.dart') {
    return Classification(
      'localization',
      familyAfter('localization'),
      'localization.md',
    );
  }
  if (path.contains('/utilities/') ||
      path.contains('/data_types/') ||
      path.contains('/constants/') ||
      path.contains('/models/') ||
      path == 'lib/utilities.dart') {
    final domain = path.contains('/utilities/') ? 'utilities' : 'data-types';
    return Classification(
      domain,
      familyAfter('src'),
      'utilities-and-data-types.md',
    );
  }
  return const Classification('core', 'general', 'utilities-and-data-types.md');
}

int _compareImports(String a, String b) {
  final aSegments = '/'.allMatches(a).length;
  final bSegments = '/'.allMatches(b).length;
  if (aSegments != bSegments) return bSegments.compareTo(aSegments);
  return a.compareTo(b);
}

String _normalize(String path) => path.replaceAll(r'\', '/');
String _display(String value) => value
    .split('_')
    .map(
      (word) =>
          word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}',
    )
    .join(' ');
String _anchor(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-|-$'), '');
String _escapeInline(String value) => value.replaceAll('`', r'\`');

class ExportSpec {
  const ExportSpec(this.uris, this.show, this.hide);
  final List<String> uris;
  final Set<String> show;
  final Set<String> hide;
}

class ParsedFile {
  const ParsedFile({
    required this.absolutePath,
    required this.path,
    required this.source,
    required this.symbols,
    required this.exports,
    required this.parts,
    required this.isPart,
    required this.hasConditionalDirective,
    required this.platformNotes,
    required this.privateDeclarationCount,
  });
  final String absolutePath;
  final String path;
  final String source;
  final List<SymbolRecord> symbols;
  final List<ExportSpec> exports;
  final List<String> parts;
  final bool isPart;
  final bool hasConditionalDirective;
  final List<String> platformNotes;
  final int privateDeclarationCount;

  FileRecord toFileRecord(
    List<String> exposedBy,
    List<String> exportedDeclarations,
    List<String> relatedFiles,
  ) {
    final classification = _classify(path);
    final internal = path.startsWith('lib/src/');
    final role = isPart
        ? 'part file'
        : hasConditionalDirective
        ? 'conditional platform implementation'
        : exports.isNotEmpty && symbols.isEmpty
        ? internal
              ? 'internal export index'
              : 'public facade'
        : internal
        ? 'internal implementation'
        : 'public entrypoint';
    return FileRecord(
      path: path,
      role: role,
      domain: classification.domain,
      family: classification.family,
      internal: internal,
      directImportAllowed:
          !internal && !isPart && !path.split('/').last.startsWith('_'),
      declarations: symbols.map((symbol) => symbol.name).toList()..sort(),
      exportedDeclarations: exportedDeclarations,
      exposedBy: exposedBy,
      relatedFiles: relatedFiles,
      privateDeclarationCount: privateDeclarationCount,
      platforms: platformNotes,
    );
  }
}

class SymbolRecord {
  const SymbolRecord({
    required this.key,
    required this.name,
    required this.kind,
    required this.signature,
    required this.documentation,
    required this.members,
    required this.deprecation,
    required this.platforms,
    required this.source,
    required this.domain,
    required this.family,
    required this.reference,
    required this.imports,
    required this.recommendedImport,
  });
  final String key;
  final String name;
  final String kind;
  final String signature;
  final String documentation;
  final List<String> members;
  final String deprecation;
  final List<String> platforms;
  final String source;
  final String domain;
  final String family;
  final String reference;
  final List<String> imports;
  final String recommendedImport;

  SymbolRecord copyWith({
    required List<String> imports,
    required String recommendedImport,
    required List<String> platforms,
  }) => SymbolRecord(
    key: key,
    name: name,
    kind: kind,
    signature: signature,
    documentation: documentation,
    members: members,
    deprecation: deprecation,
    platforms: platforms,
    source: source,
    domain: domain,
    family: family,
    reference: reference,
    imports: imports,
    recommendedImport: recommendedImport,
  );

  Map<String, Object?> toJson() => {
    'name': name,
    'kind': kind,
    'signature': signature,
    'documentation': documentation,
    'members': members,
    'deprecation': deprecation,
    'platforms': platforms,
    'source': source,
    'domain': domain,
    'family': family,
    'reference': 'references/$reference',
    'imports': imports,
    'recommendedImport': recommendedImport,
    'internal': false,
    'directImportAllowed': true,
  };
}

class FileRecord {
  const FileRecord({
    required this.path,
    required this.role,
    required this.domain,
    required this.family,
    required this.internal,
    required this.directImportAllowed,
    required this.declarations,
    required this.exportedDeclarations,
    required this.exposedBy,
    required this.relatedFiles,
    required this.privateDeclarationCount,
    required this.platforms,
  });
  final String path;
  final String role;
  final String domain;
  final String family;
  final bool internal;
  final bool directImportAllowed;
  final List<String> declarations;
  final List<String> exportedDeclarations;
  final List<String> exposedBy;
  final List<String> relatedFiles;
  final int privateDeclarationCount;
  final List<String> platforms;

  Map<String, Object?> toJson() => {
    'path': path,
    'role': role,
    'domain': domain,
    'family': family,
    'internal': internal,
    'directImportAllowed': directImportAllowed,
    'declarations': declarations,
    'exportedDeclarations': exportedDeclarations,
    'exposedBy': exposedBy,
    'relatedFiles': relatedFiles,
    'privateDeclarationCount': privateDeclarationCount,
    'platforms': platforms,
  };
}

class Classification {
  const Classification(this.domain, this.family, this.reference);
  final String domain;
  final String family;
  final String reference;
}
