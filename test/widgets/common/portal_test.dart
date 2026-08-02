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

  testWidgets('auto anchor honors exact bottom-left and top-left points', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _PositionedPortalHarness(
        triggerOffset: Offset(40, 30),
        triggerSize: Size(50, 20),
        popoverSize: Size(80, 40),
        anchor: MyAnchorAuto(
          offset: Offset(0, 4),
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
        ),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(40, 54));
  });

  testWidgets('auto anchor flips vertically when there is no room below', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _PositionedPortalHarness(
        triggerOffset: Offset(40, 260),
        triggerSize: Size(50, 20),
        popoverSize: Size(80, 60),
        anchor: MyAnchorAuto(
          offset: Offset(0, 4),
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
        ),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(40, 196));
  });

  testWidgets('auto anchor opens a submenu beside its target', (tester) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _PositionedPortalHarness(
        triggerOffset: Offset(100, 50),
        triggerSize: Size(80, 30),
        popoverSize: Size(100, 60),
        anchor: MyAnchorAuto(
          offset: Offset(4, -2),
          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.topLeft,
        ),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(184, 48));
  });

  testWidgets('auto anchor flips a submenu near the right viewport edge', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _PositionedPortalHarness(
        triggerOffset: Offset(300, 50),
        triggerSize: Size(80, 30),
        popoverSize: Size(100, 60),
        anchor: MyAnchorAuto(
          offset: Offset(4, -2),
          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.topLeft,
        ),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(196, 48));
  });

  testWidgets('auto anchor clamps to its viewport padding as a fallback', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _PositionedPortalHarness(
        triggerOffset: Offset.zero,
        triggerSize: Size(20, 20),
        popoverSize: Size(100, 40),
        anchor: MyAnchorAuto(
          offset: Offset(0, 4),
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
        ),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(8, 24));
  });

  testWidgets('global anchor places the overlay top-left at the pointer', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _GlobalPortalHarness(
        anchor: MyGlobalAnchor(Offset(80, 60)),
        popoverSize: Size(100, 40),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(80, 60));
  });

  testWidgets('global anchor flips near the right and bottom viewport edges', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _GlobalPortalHarness(
        anchor: MyGlobalAnchor(Offset(380, 280)),
        popoverSize: Size(100, 60),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(280, 220));
  });

  testWidgets('global anchor clamps to viewport padding as a fallback', (
    tester,
  ) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _GlobalPortalHarness(
        anchor: MyGlobalAnchor(Offset(2, 2)),
        popoverSize: Size(100, 40),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(8, 8));
  });

  testWidgets('global anchor repositions while visible', (tester) async {
    await _setViewport(tester, const Size(400, 300));
    await tester.pumpWidget(
      const _GlobalPortalHarness(
        anchor: MyGlobalAnchor(Offset(40, 40)),
        popoverSize: Size(100, 40),
      ),
    );
    await _settlePortal(tester);
    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(40, 40));

    await tester.pumpWidget(
      const _GlobalPortalHarness(
        anchor: MyGlobalAnchor(Offset(140, 90)),
        popoverSize: Size(100, 40),
      ),
    );
    await _settlePortal(tester);

    expect(tester.getTopLeft(find.byKey(_popoverKey)), const Offset(140, 90));
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

class _PositionedPortalHarness extends StatelessWidget {
  const _PositionedPortalHarness({
    required this.triggerOffset,
    required this.triggerSize,
    required this.popoverSize,
    required this.anchor,
  });

  final Offset triggerOffset;
  final Size triggerSize;
  final Size popoverSize;
  final MyAnchorAuto anchor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: triggerOffset.dx,
              top: triggerOffset.dy,
              child: MyPortal(
                visible: true,
                anchor: anchor,
                portalBuilder: (context) => SizedBox(
                  key: _popoverKey,
                  width: popoverSize.width,
                  height: popoverSize.height,
                ),
                child: SizedBox(
                  key: _triggerKey,
                  width: triggerSize.width,
                  height: triggerSize.height,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlobalPortalHarness extends StatelessWidget {
  const _GlobalPortalHarness({required this.anchor, required this.popoverSize});

  final MyGlobalAnchor anchor;
  final Size popoverSize;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyPortal(
          visible: true,
          anchor: anchor,
          portalBuilder: (context) => SizedBox(
            key: _popoverKey,
            width: popoverSize.width,
            height: popoverSize.height,
          ),
          child: const SizedBox(key: _triggerKey, width: 20, height: 20),
        ),
      ),
    );
  }
}
