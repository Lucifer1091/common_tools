import 'package:common_tools/extensions/generic/function_extension.dart';
import 'package:common_tools/extensions/generic/predicate_functions.dart';
import 'package:common_tools/extensions/generic/scope_functions.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  group('BooleanPredicateExtensions', () {
    test('negate returns callable predicate', () {
      bool alwaysTrue() => true;

      final alwaysFalse = alwaysTrue.negate;

      expect(alwaysFalse(), isFalse);
    });
  });

  group('ScopeFunction', () {
    test('run uses receiver and returns null for null receiver', () {
      final int value = 5;
      final int? nullableValue = null;

      expect(value.run((it) => it * 2), 10);
      expect(nullableValue.run((it) => it * 2), isNull);
    });

    test('apply uses receiver and returns receiver', () {
      final list = <int>[1, 2, 3].apply((it) => it.add(4));

      expect(list, <int>[1, 2, 3, 4]);
    });
  });

  group('throwIf helpers', () {
    test('throwIf and throwIfNot allow throwing any object', () {
      expect(() => throwIf(true, () => Exception('boom')), throwsException);
      expect(() => throwIfNot(false, () => 'boom'), throwsA(equals('boom')));
    });
  });

  group('runCaching', () {
    test('handles sync errors via onError', () async {
      final result = await Future<int?>.value(
        runCaching<int>(() => int.parse('bad'), onError: (_, _) => 7),
      );

      expect(result, 7);
    });

    test('handles async errors via onError', () async {
      final result = await Future<int?>.value(
        runCaching<int>(
          () async => throw StateError('failed'),
          onError: (_, _) => 9,
        ),
      );

      expect(result, 9);
    });

    test('returns null when no onError is provided', () async {
      final result = await Future<int?>.value(
        runCaching<int>(() async => throw StateError('failed')),
      );

      expect(result, isNull);
    });
  });

  group('FunctionExtension.catchAll', () {
    test('catches async errors with stack trace', () async {
      Object? capturedError;
      StackTrace? capturedStackTrace;

      await (() async => throw StateError('failed')).catchAll((error, stack) {
        capturedError = error;
        capturedStackTrace = stack;
      });

      expect(capturedError, isA<StateError>());
      expect(capturedStackTrace, isNotNull);
    });
  });
}
