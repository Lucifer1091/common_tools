import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const geistFamily = 'packages/common_tools/Geist';
  const geistMonoFamily = 'packages/common_tools/GeistMono';

  group('MyTypography package fonts', () {
    test('resolves every Geist scale style through common_tools', () {
      const typography = MyTypography.geist();

      for (final style in _allStyles(typography)) {
        expect(style.fontFamily, geistFamily);
      }

      expect(MyTypography.fontPackage, 'common_tools');
      expect(MyTypography.kDefaultFontFamily, geistFamily);
      expect(MyTypography.kDefaultFontFamilyMono, geistMonoFamily);
      expect(MyTypography.geistSansStyle.fontFamily, geistFamily);
      expect(MyTypography.geistMonoStyle.fontFamily, geistMonoFamily);
    });

    test('keeps host-local custom fonts unqualified', () {
      final typography = MyTypography.custom('HostFont');

      for (final style in _allStyles(typography)) {
        expect(style.fontFamily, 'HostFont');
      }
    });

    test('qualifies custom fonts supplied by another package', () {
      final typography = MyTypography.custom('VendorFont', package: 'vendor');

      for (final style in _allStyles(typography)) {
        expect(style.fontFamily, 'packages/vendor/VendorFont');
      }
    });

    test('preserves package ownership while scaling and interpolating', () {
      const typography = MyTypography.geist();
      final scaled = typography.scale(1.25);
      final interpolated = MyTypography.lerp(typography, scaled, 0.5);

      for (final style in [
        ..._allStyles(scaled),
        ..._allStyles(interpolated),
      ]) {
        expect(style.fontFamily, geistFamily);
      }
    });
  });

  group('Material theme integration', () {
    test('retains the resolved family throughout ThemeData', () {
      final theme = MyColorScheme.fromName(
        'blue',
      ).toMaterialTheme(typography: const MyTypography.geist());

      expect(theme.appBarTheme.titleTextStyle?.fontFamily, geistFamily);

      for (final style in [
        ..._allTextThemeStyles(theme.textTheme),
        ..._allTextThemeStyles(theme.primaryTextTheme),
      ]) {
        expect(style.fontFamily, geistFamily);
      }
    });
  });

  group('Component font defaults', () {
    test('swiper pagination uses the resolved Geist family', () {
      const pagination = MyFractionPagination();

      expect(pagination.textStyle?.fontFamily, geistFamily);
      expect(pagination.activeTextStyle?.fontFamily, geistFamily);
    });

    testWidgets('step counters use package-qualified Geist Mono', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          MySteps(
            type: MyStepType.steps,
            steps: [MyStepItem(title: 'Account')],
          ),
        ),
      );

      final counter = tester.widget<Text>(find.text('1'));
      expect(counter.style?.fontFamily, geistMonoFamily);
    });

    testWidgets('OTP slots use package-qualified Geist Mono', (tester) async {
      await tester.pumpWidget(
        _themed(
          const MyOtp(
            maxLength: 1,
            children: [
              MyOtpGroup(children: [MyOtpSlot()]),
            ],
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.style.fontFamily, geistMonoFamily);
    });
  });
}

List<TextStyle> _allStyles(MyTypography typography) {
  return [
    typography.displayLarge,
    typography.displayMedium,
    typography.displaySmall,
    typography.headlineLarge,
    typography.headlineMedium,
    typography.headlineSmall,
    typography.titleLarge,
    typography.titleMedium,
    typography.titleSmall,
    typography.bodyLarge,
    typography.bodyMedium,
    typography.bodySmall,
    typography.labelLarge,
    typography.labelMedium,
    typography.labelSmall,
  ];
}

List<TextStyle> _allTextThemeStyles(TextTheme textTheme) {
  return [
    textTheme.displayLarge!,
    textTheme.displayMedium!,
    textTheme.displaySmall!,
    textTheme.headlineLarge!,
    textTheme.headlineMedium!,
    textTheme.headlineSmall!,
    textTheme.titleLarge!,
    textTheme.titleMedium!,
    textTheme.titleSmall!,
    textTheme.bodyLarge!,
    textTheme.bodyMedium!,
    textTheme.bodySmall!,
    textTheme.labelLarge!,
    textTheme.labelMedium!,
    textTheme.labelSmall!,
  ];
}

Widget _themed(Widget child) {
  final colorScheme = MyColorScheme.fromName('blue');
  return MaterialApp(
    theme: colorScheme.toMaterialTheme(),
    home: MyTheme(
      data: MyThemeData(colorScheme: colorScheme),
      child: Scaffold(body: child),
    ),
  );
}
