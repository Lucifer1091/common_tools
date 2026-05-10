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

    test('compares breakpoint types in Material order', () {
      const types = BreakpointType.values;

      for (var index = 0; index < Breakpoint.defaults.length; index++) {
        final breakpoint = Breakpoint.defaults[index];

        for (var targetIndex = 0; targetIndex < types.length; targetIndex++) {
          final type = types[targetIndex];

          expect(
            breakpoint.isAtLeast(type),
            index >= targetIndex,
            reason: '${breakpoint.type.name}.isAtLeast(${type.name})',
          );
          expect(
            breakpoint.isAtMost(type),
            index <= targetIndex,
            reason: '${breakpoint.type.name}.isAtMost(${type.name})',
          );
        }
      }

      expect(
        const Breakpoint.expanded().isBetweenTypes(
          BreakpointType.medium,
          BreakpointType.large,
        ),
        true,
      );
      expect(
        const Breakpoint.extraLarge().isBetweenTypes(
          BreakpointType.medium,
          BreakpointType.large,
        ),
        false,
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

    testWidgets('platformSizeInfo includes the current screen size', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithWidth(
          width: 840,
          child: PlatformInfoLayoutBuilder(
            builder: (context, info) {
              return Text(
                '${info.screenSize.width}:'
                '${info.screenSize.height}:'
                '${info.breakpoint.type.name}',
              );
            },
          ),
        ),
      );

      expect(find.text('840.0:800.0:expanded'), findsOneWidget);
    });

    test('platformSizeInfo screen size defaults to zero', () {
      const info = PlatformSizeInfo(
        platform: TargetPlatform.android,
        breakpoint: Breakpoint.compact(),
        orientation: Orientation.portrait,
      );

      expect(info.screenSize, Size.zero);
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

  group('ResponsiveVisibility', () {
    testWidgets('throws a clear error without BreakpointProvider', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveVisibility(
            builder: (context) => const Text('visible'),
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

    testWidgets('shows the child on all breakpoints by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithWidth(
          width: 1200,
          child: ResponsiveVisibility(
            builder: (context) => const Text('visible'),
          ),
        ),
      );

      expect(find.text('visible'), findsOneWidget);
    });

    testWidgets('uses replacement and skips hidden builder', (tester) async {
      var hiddenBuilds = 0;
      var replacementBuilds = 0;

      await tester.pumpWidget(
        _wrapWithWidth(
          width: 600,
          child: ResponsiveVisibility.compact(
            builder: (context) {
              hiddenBuilds++;
              return const Text('hidden');
            },
            replacement: (context) {
              replacementBuilds++;
              return const Text('replacement');
            },
          ),
        ),
      );

      expect(find.text('hidden'), findsNothing);
      expect(find.text('replacement'), findsOneWidget);
      expect(hiddenBuilds, 0);
      expect(replacementBuilds, 1);
    });

    testWidgets('named constructors show only their breakpoint', (
      tester,
    ) async {
      final cases = <
        ({
          String label,
          double width,
          Widget Function(WidgetBuilder builder) make,
        })
      >[
        (
          label: 'compact',
          width: 500,
          make: (builder) => ResponsiveVisibility.compact(builder: builder),
        ),
        (
          label: 'medium',
          width: 600,
          make: (builder) => ResponsiveVisibility.medium(builder: builder),
        ),
        (
          label: 'expanded',
          width: 840,
          make: (builder) => ResponsiveVisibility.expanded(builder: builder),
        ),
        (
          label: 'large',
          width: 1200,
          make: (builder) => ResponsiveVisibility.large(builder: builder),
        ),
        (
          label: 'extraLarge',
          width: 1600,
          make: (builder) => ResponsiveVisibility.extraLarge(builder: builder),
        ),
      ];

      for (final testCase in cases) {
        await tester.pumpWidget(
          _wrapWithWidth(
            width: testCase.width,
            child: testCase.make((context) => Text(testCase.label)),
          ),
        );

        expect(find.text(testCase.label), findsOneWidget);
      }
    });

    testWidgets('returns an empty box when hidden without replacement', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithWidth(
          width: 600,
          child: ResponsiveVisibility.compact(
            builder: (context) => const Text('hidden'),
          ),
        ),
      );

      expect(find.text('hidden'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('SplitView', () {
    testWidgets('shows content only below the split breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapSplitView(
          width: 500,
          child: SplitView(
            navigationBuilder: (context) => const Text('navigation'),
            contentBuilder: (context) => const Text('content'),
          ),
        ),
      );

      expect(find.text('navigation'), findsNothing);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('shows navigation and content above the split breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapSplitView(
          width: 700,
          child: SplitView(
            navigationBuilder: (context) => const Text('navigation'),
            contentBuilder: (context) => const Text('content'),
          ),
        ),
      );

      expect(find.text('navigation'), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
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

Widget _wrapSplitView({required double width, required Widget child}) {
  return MaterialApp(
    home: Center(child: SizedBox(width: width, height: 300, child: child)),
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
