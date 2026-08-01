import 'package:common_tools/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _triggerKey = ValueKey<String>('portal-trigger');
const _popoverKey = ValueKey<String>('portal-popover');

void main() {
  testWidgets('auto anchor follows trigger after viewport resize', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));

    await tester.pumpWidget(const _PortalHarness(followTargetOnResize: true));
    await _settlePortal(tester);

    final beforeResize = tester.getTopLeft(find.byKey(_popoverKey));

    await _setViewport(tester, const Size(600, 300));
    await _settlePortal(tester);

    final afterResize = tester.getTopLeft(find.byKey(_popoverKey));

    expect(afterResize.dx, greaterThan(beforeResize.dx));
    expect(afterResize.dy, beforeResize.dy);
  });

  testWidgets('auto anchor can opt out of viewport resize following', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));

    await tester.pumpWidget(const _PortalHarness(followTargetOnResize: false));
    await _settlePortal(tester);

    final beforeResize = tester.getTopLeft(find.byKey(_popoverKey));

    await _setViewport(tester, const Size(600, 300));
    await _settlePortal(tester);

    final afterPopoverCenter = tester.getCenter(find.byKey(_popoverKey));
    final afterTriggerCenter = tester.getCenter(find.byKey(_triggerKey));

    expect(afterPopoverCenter.dx, lessThan(afterTriggerCenter.dx - 100));
    expect(afterPopoverCenter.dy, beforeResize.dy + 10);
  });

  testWidgets('auto anchored portal becomes interactive after measurement', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyPortal(
            visible: true,
            anchor: const MyAnchorAuto(offset: Offset(0, 4)),
            portalBuilder: (context) => GestureDetector(
              key: _popoverKey,
              behavior: HitTestBehavior.opaque,
              onTap: () => tapped = true,
              child: const SizedBox(width: 80, height: 20),
            ),
            child: const SizedBox(key: _triggerKey, width: 40, height: 20),
          ),
        ),
      ),
    );
    await _settlePortal(tester);

    expect(find.byKey(_popoverKey).hitTestable(), findsOneWidget);
    await tester.tap(find.byKey(_popoverKey));
    expect(tapped, isTrue);
  });
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Future<void> _settlePortal(WidgetTester tester) async {
  for (var frame = 0; frame < 5; frame++) {
    await tester.pump();
  }
}

class _PortalHarness extends StatelessWidget {
  const _PortalHarness({required this.followTargetOnResize});

  final bool followTargetOnResize;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topRight,
          child: MyPortal(
            visible: true,
            anchor: MyAnchorAuto(
              offset: const Offset(0, 4),
              followTargetOnResize: followTargetOnResize,
              followerAnchor: Alignment.topCenter,
              targetAnchor: Alignment.bottomCenter,
            ),
            portalBuilder: (context) =>
                const SizedBox(key: _popoverKey, width: 80, height: 20),
            child: const SizedBox(key: _triggerKey, width: 40, height: 20),
          ),
        ),
      ),
    );
  }
}
