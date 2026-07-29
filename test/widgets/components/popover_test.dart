import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens when the provided focus node gains focus', (tester) async {
    final controller = MyPopoverController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPopover(
          controller: controller,
          focusNode: focusNode,
          popover: (context) => const Text('Focused popover'),
          child: Focus(
            focusNode: focusNode,
            child: const SizedBox(width: 80, height: 32),
          ),
        ),
      ),
    );

    expect(find.text('Focused popover'), findsNothing);

    focusNode.requestFocus();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump();

    expect(find.text('Focused popover'), findsOneWidget);
  });
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
        child: Scaffold(body: child),
      ),
    );
  }
}
