import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses the provided initial country', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPhoneInput(initialCountry: Country.fromCountryCode('ID')),
      ),
    );

    expect(find.text('+62'), findsOneWidget);
  });

  testWidgets('emits the international number for national input', (
    tester,
  ) async {
    MyPhoneNumber? phoneNumber;

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPhoneInput(
          initialCountry: Country.fromCountryCode('ID'),
          onChanged: (value) => phoneNumber = value,
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), '812345678');
    await tester.pump();

    expect(phoneNumber?.nationalNumber, '812345678');
    expect(phoneNumber?.value, '+62812345678');
  });

  testWidgets('search popup filters by country fields and dial code', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPhoneInput(initialCountry: Country.fromCountryCode('ID')),
      ),
    );

    await tester.tap(find.byKey(const Key('my-phone-input-country-selector')));
    await _pumpPopover(tester);
    tester.testTextInput.enterText('+92');
    await _pumpPopover(tester);

    expect(find.text('Pakistan'), findsOneWidget);
    expect(find.text('Indonesia'), findsNothing);
  });

  testWidgets('pasted international number switches country and strips code', (
    tester,
  ) async {
    final controller = TextEditingController();
    MyPhoneNumber? phoneNumber;
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPhoneInput(
          controller: controller,
          initialCountry: Country.fromCountryCode('ID'),
          onChanged: (value) => phoneNumber = value,
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), '+923001234567');
    await tester.pump();

    expect(controller.text, '3001234567');
    expect(find.text('+92'), findsOneWidget);
    expect(phoneNumber?.country?.iso2, 'PK');
    expect(phoneNumber?.value, '+923001234567');
  });

  testWidgets('provided countries limit search and dial-code detection', (
    tester,
  ) async {
    final controller = TextEditingController();
    final indonesia = Country.fromCountryCode('ID')!;
    MyPhoneNumber? phoneNumber;
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPhoneInput(
          controller: controller,
          initialCountry: indonesia,
          countries: [indonesia],
          onChanged: (value) => phoneNumber = value,
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), '+923001234567');
    await tester.pump();

    expect(controller.text, '923001234567');
    expect(phoneNumber?.country?.iso2, 'ID');

    await tester.tap(find.byKey(const Key('my-phone-input-country-selector')));
    await _pumpPopover(tester);
    tester.testTextInput.enterText('+92');
    await _pumpPopover(tester);

    expect(find.text('Pakistan'), findsNothing);
  });

  testWidgets(
    'external controller updates normalize without duplicating code',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ThemeHarness(
          child: MyPhoneInput(
            controller: controller,
            initialCountry: Country.fromCountryCode('ID'),
          ),
        ),
      );

      controller.text = '+923001234567';
      await tester.pump();

      expect(controller.text, '3001234567');
      expect(find.text('+92'), findsOneWidget);

      controller.text = controller.text;
      await tester.pump();

      expect(controller.text, '3001234567');
      expect(find.text('+92'), findsOneWidget);
    },
  );
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTheme(
        data: MyThemeData(
          colorScheme: MyColorScheme.fromParts(
            base: MyBaseColor.neutral,
            accent: MyAccentColor.blue,
          ),
          typography: const MyTypography.geist(),
        ),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: 320, child: child),
          ),
        ),
      ),
    );
  }
}
