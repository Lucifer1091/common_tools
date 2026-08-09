import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    stderr.writeln(
      'Usage: dart run scripts/query_catalog.dart <symbol-or-keywords>',
    );
    exitCode = 64;
    return;
  }

  final script = File.fromUri(Platform.script).absolute;
  final catalogue = File.fromUri(
    script.parent.parent.uri.resolve('assets/catalogue.json'),
  );
  if (!catalogue.existsSync()) {
    stderr.writeln('Catalogue not found: ${catalogue.path}');
    exitCode = 66;
    return;
  }

  final root = jsonDecode(catalogue.readAsStringSync()) as Map<String, Object?>;
  final query = arguments.join(' ').toLowerCase();
  final terms = query.split(RegExp(r'\s+')).where((term) => term.isNotEmpty);
  final symbols =
      (root['symbols']! as List<Object?>).cast<Map<String, Object?>>().where((
        symbol,
      ) {
        final haystack = [
          symbol['name'],
          symbol['kind'],
          symbol['domain'],
          symbol['family'],
          symbol['documentation'],
          ...(symbol['members']! as List<Object?>),
          symbol['source'],
        ].join(' ').toLowerCase();
        return terms.every(haystack.contains);
      }).toList()..sort((a, b) {
        final aName = (a['name']! as String).toLowerCase();
        final bName = (b['name']! as String).toLowerCase();
        final aExact = aName == query ? 0 : 1;
        final bExact = bName == query ? 0 : 1;
        return aExact != bExact ? aExact - bExact : aName.compareTo(bName);
      });

  if (symbols.isEmpty) {
    stdout.writeln('No public common_tools API matched "$query".');
    exitCode = 1;
    return;
  }

  for (final symbol in symbols.take(25)) {
    stdout.writeln(symbol['name']);
    stdout.writeln('  kind: ${symbol['kind']}');
    stdout.writeln('  family: ${symbol['domain']} / ${symbol['family']}');
    stdout.writeln('  import: ${symbol['recommendedImport']}');
    stdout.writeln('  source: ${symbol['source']}');
    final signature = (symbol['signature'] as String?)?.trim();
    if (signature != null && signature.isNotEmpty) {
      stdout.writeln('  signature: $signature');
    }
    final documentation = (symbol['documentation'] as String?)?.trim();
    if (documentation != null && documentation.isNotEmpty) {
      stdout.writeln(
        '  docs: ${documentation.replaceAll(RegExp(r'\s+'), ' ')}',
      );
    }
    stdout.writeln();
  }
  if (symbols.length > 25) {
    stdout.writeln('${symbols.length - 25} additional matches omitted.');
  }
}
