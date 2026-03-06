import 'package:common_tools/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Num extensions', () {
    test('to() uses directional step safely', () {
      expect(3.to(6).toList(), [3, 4, 5]);
      expect(8.to(3, step: 2).toList(), [8, 6, 4]);
      expect(3.to(6, step: -2).toList(), [3, 5]);
      expect(() => 3.to(6, step: 0).toList(), throwsArgumentError);
    });

    test('isPowerOf handles edge cases', () {
      expect(8.isPowerOf(2), isTrue);
      expect(0.isPowerOf(2), isFalse);
      expect(() => 8.isPowerOf(1), throwsArgumentError);
    });

    test('lcm handles zero values', () {
      expect(0.lcm(0), 0);
      expect(0.lcm(5), 0);
      expect(6.lcm(8), 24);
    });

    test('digit extractors support multi-digit markers', () {
      expect(123451234.digitsBetween(1234, 1234), 5);
      expect(123451234.digitsBeforeFirst(1234), 0);
      expect(123451234.digitsAfterFirst(1234), 51234);
      expect(123451234.digitsAfterLast(1234), 0);
    });

    test('toPrice forwards custom unit', () {
      expect(12.toPrice(withSymbol: true, unit: '€', dp: 0), '€ 12');
      expect('12'.toPrice(withSymbol: true, unit: '€', dp: 0), '€ 12');
    });

    test('validator semantics are explicit', () {
      expect(1.isDouble, isFalse);
      expect(1.0.isDouble, isTrue);
      expect(5.outside(1, 5), isFalse);
      expect(5.outside(1, 5, inclusive: false), isTrue);
    });

    test('sumOfDigits and digits work for signed and decimal values', () {
      expect((-12).sumOfDigits(), 3);
      expect(12.34.sumOfDigits(), 10);
      expect((-12.34).digits, [1, 2, 3, 4]);
    });

    test('percentage and significant digits', () {
      expect(() => 50.percentage(0), throwsArgumentError);
      expect(3.14159.toSignificantDigits(digit: 3), '3.14');
      expect(1.toSignificantDigits(), '1');
    });

    test('roman parser only accepts canonical forms', () {
      expect(NumbersHelper.fromRomanNumeral('XCIX'), 99);
      expect(() => NumbersHelper.fromRomanNumeral('IC'), throwsArgumentError);
    });
  });
}
