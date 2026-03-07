import 'package:common_tools/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('String converters', () {
    test('normalization getters are null-safe', () {
      String? value;
      expect(value.lowercase, isNull);
      expect(value.uppercase, isNull);
      expect(value.initials, isNull);
    });

    test('chunks handles null/empty safely', () {
      String? value;
      expect(value.chunks(2).toList(), isEmpty);
      expect(''.chunks(2).toList(), isEmpty);
      expect('abcde'.chunks(2).toList(), ['ab', 'cd', 'e']);
      expect(() => 'abc'.chunks(0).toList(), throwsArgumentError);
    });

    test('single-character initials do not throw', () {
      expect('a'.initials, 'A');
    });
  });

  group('String misc/operators', () {
    test('readTime uses seconds from WPM', () {
      final text = List.filled(200, 'word').join(' ');
      expect(text.readTime(), 60);
    });

    test('replaceAt and charAt enforce safe bounds', () {
      expect('abc'.replaceAt(index: 3, replacement: 'z'), 'abc');
      expect('abc'.charAt(3), isNull);
    });

    test('addAfter inserts after full pattern', () {
      expect('abcDEFghi'.addAfter('DEF', 'X'), 'abcDEFXghi');
    });

    test('repeat with non-positive count returns empty', () {
      expect('abc'.repeat(0), '');
      expect('abc'.repeat(-5), '');
    });
  });

  group('String validators/sanitizers', () {
    test('hasSpecial and isMixedCase logic', () {
      expect('Hello World'.hasSpecial, isFalse);
      expect('Hello, World'.hasSpecial, isTrue);
      expect('Hello'.isMixedCase, isTrue);
      expect('hello'.isMixedCase, isFalse);
      expect('12345'.isMixedCase, isFalse);
    });

    test('char class methods escape special characters', () {
      expect('[[abc]]'.strip('[]'), 'abc');
      expect('a[b]c'.whitelist('[]'), '[]');
      expect('a[b]c'.blacklist('[]'), 'abc');
    });
  });

  group('String similarity', () {
    test('compareBatch uses chunked branch correctly', () {
      final pairs = [
        ['a', 'a'],
        ['a', 'b'],
        ['abc', 'abc'],
      ];
      final config = const StringSimilarityConfig(chunkSize: 1);
      expect(
        StringSimilarity.compareBatch(
          pairs,
          SimilarityAlgorithm.diceCoefficient,
          config: config,
          parallel: true,
        ),
        [1.0, 0.0, 1.0],
      );
    });
  });
}
