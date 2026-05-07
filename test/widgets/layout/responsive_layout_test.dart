import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Breakpoint', () {
    test('resolves default boundary widths', () {
      final cases = <double, BreakpointType>{
        0.0: BreakpointType.compact,
        599.0: BreakpointType.compact,
        600.0: BreakpointType.medium,
        839.0: BreakpointType.medium,
        840.0: BreakpointType.expanded,
        1199.0: BreakpointType.expanded,
        1200.0: BreakpointType.large,
        1599.0: BreakpointType.large,
        1600.0: BreakpointType.extraLarge,
      };

      for (final entry in cases.entries) {
        expect(
          Breakpoint.forWidth(entry.key).type,
          entry.value,
          reason: 'width ${entry.key}',
        );
      }
    });

    test('resolves custom sorted breakpoints', () {
      const breakpoints = <Breakpoint>[
        Breakpoint(start: 0, end: 320, type: BreakpointType.compact),
        Breakpoint(start: 320, end: 720, type: BreakpointType.medium),
        Breakpoint(start: 720, type: BreakpointType.expanded),
      ];

      expect(
        Breakpoint.forWidth(319, breakpoints: breakpoints).type,
        BreakpointType.compact,
      );
      expect(
        Breakpoint.forWidth(320, breakpoints: breakpoints).type,
        BreakpointType.medium,
      );
      expect(
        Breakpoint.forWidth(720, breakpoints: breakpoints).type,
        BreakpointType.expanded,
      );
    });

    test('asserts for empty breakpoints', () {
      expect(
        () => Breakpoint.forWidth(100, breakpoints: const <Breakpoint>[]),
        throwsAssertionError,
      );
    });

    test('asserts for unsorted breakpoints', () {
      const breakpoints = <Breakpoint>[
        Breakpoint(start: 600, type: BreakpointType.medium),
        Breakpoint(start: 0, type: BreakpointType.compact),
      ];

      expect(
        () => Breakpoint.forWidth(100, breakpoints: breakpoints),
        throwsAssertionError,
      );
    });
  });

  group('BreakpointProvider', () {
    testWidgets('throws a clear error without BreakpointProvider', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              Breakpoint.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final exception = tester.takeException();
      expect(exception, isFlutterError);
      expect(
        exception.toString(),
        contains('does not contain a BreakpointProvider'),
      );
    });

    testWidgets('works below MaterialApp with MediaQuery', (tester) async {
      await tester.pumpWidget(
        _wrapWithWidth(
          width: 840,
          child: BreakpointLayoutBuilder(
            builder: (context, breakpoint) => Text(breakpoint.type.name),
          ),
        ),
      );

      expect(find.text('expanded'), findsOneWidget);
    });

    testWidgets('sorts custom breakpoints in the provider', (tester) async {
      const breakpoints = <Breakpoint>[
        Breakpoint(start: 300, type: BreakpointType.medium),
        Breakpoint(start: 0, type: BreakpointType.compact),
      ];

      await tester.pumpWidget(
        _wrapWithWidth(
          width: 100,
          breakpoints: breakpoints,
          child: BreakpointLayoutBuilder(
            builder: (context, breakpoint) => Text(breakpoint.type.name),
          ),
        ),
      );

      expect(find.text('compact'), findsOneWidget);
    });
  });

  group('AdaptiveWidget', () {
    testWidgets('falls back to the nearest smaller implemented layout', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithWidth(
          width: 1200,
          child: const _AdaptiveProbe(medium: Text('medium')),
        ),
      );

      expect(find.text('medium'), findsOneWidget);
    });
  });

  group('Responsive', () {
    testWidgets('value listens to breakpoint changes by default', (
      tester,
    ) async {
      final key = GlobalKey<_BreakpointHarnessState>();

      await tester.pumpWidget(
        _BreakpointHarness(
          key: key,
          width: 500,
          child: const _ResponsiveValueText(listen: true),
        ),
      );

      expect(find.text('compact'), findsOneWidget);

      key.currentState!.setWidth(600);
      await tester.pump();

      expect(find.text('medium'), findsOneWidget);
    });

    testWidgets('value can read without subscribing', (tester) async {
      final key = GlobalKey<_BreakpointHarnessState>();

      await tester.pumpWidget(
        _BreakpointHarness(
          key: key,
          width: 500,
          child: const _ResponsiveValueText(listen: false),
        ),
      );

      expect(find.text('compact'), findsOneWidget);

      key.currentState!.setWidth(600);
      await tester.pump();

      expect(find.text('compact'), findsOneWidget);
      expect(find.text('medium'), findsNothing);
    });

    testWidgets('builder only builds the selected branch', (tester) async {
      final key = GlobalKey<_BreakpointHarnessState>();
      var compactBuilds = 0;
      var mediumBuilds = 0;

      await tester.pumpWidget(
        _BreakpointHarness(
          key: key,
          width: 500,
          child: Responsive.builder(
            compact: (context) {
              compactBuilds++;
              return const Text('compact');
            },
            medium: (context) {
              mediumBuilds++;
              return const Text('medium');
            },
          ),
        ),
      );

      expect(find.text('compact'), findsOneWidget);
      expect(compactBuilds, 1);
      expect(mediumBuilds, 0);

      key.currentState!.setWidth(600);
      await tester.pump();

      expect(find.text('medium'), findsOneWidget);
      expect(compactBuilds, 1);
      expect(mediumBuilds, 1);
    });
  });
}

Widget _wrapWithWidth({
  required double width,
  required Widget child,
  List<Breakpoint> breakpoints = Breakpoint.defaults,
}) {
  return MaterialApp(
    builder: (context, _) {
      final mediaQuery = MediaQuery.of(context);
      return MediaQuery(
        data: mediaQuery.copyWith(size: Size(width, 800)),
        child: BreakpointProvider(breakpoints: breakpoints, child: child),
      );
    },
    home: const SizedBox.shrink(),
  );
}

class _BreakpointHarness extends StatefulWidget {
  const _BreakpointHarness({
    required this.child,
    required this.width,
    super.key,
  });

  final Widget child;
  final double width;

  @override
  State<_BreakpointHarness> createState() => _BreakpointHarnessState();
}

class _BreakpointHarnessState extends State<_BreakpointHarness> {
  late double _width = widget.width;

  void setWidth(double value) {
    setState(() {
      _width = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithWidth(width: _width, child: widget.child);
  }
}

class _AdaptiveProbe extends AdaptiveWidget {
  const _AdaptiveProbe({this.medium});

  final Widget? medium;

  @override
  Widget buildCompact(BuildContext context) => const Text('compact');

  @override
  Widget? buildMedium(BuildContext context) => medium;
}

class _ResponsiveValueText extends StatelessWidget {
  const _ResponsiveValueText({required this.listen});

  final bool listen;

  @override
  Widget build(BuildContext context) {
    final value = Responsive.value<String>(
      context,
      compact: 'compact',
      medium: 'medium',
      listen: listen,
    );
    return Text(value);
  }
}
