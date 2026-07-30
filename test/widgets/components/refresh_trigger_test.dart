import 'dart:async';

import 'package:common_tools/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _scrollableKey = Key('refresh-scrollable');

Widget _buildRefreshTrigger({
  required Future<void> Function() onRefresh,
  Widget? child,
  bool reverse = false,
  double minExtent = 40,
  Duration completeDuration = const Duration(milliseconds: 50),
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox.expand(
        child: MyRefreshTrigger(
          minExtent: minExtent,
          maxExtent: 100,
          reverse: reverse,
          completeDuration: completeDuration,
          indicatorBuilder: _stageIndicatorBuilder,
          onRefresh: onRefresh,
          child:
              child ??
              SingleChildScrollView(
                key: _scrollableKey,
                child: const SizedBox(height: 1200),
              ),
        ),
      ),
    ),
  );
}

Widget _stageIndicatorBuilder(BuildContext context, RefreshTriggerStage stage) {
  return AnimatedBuilder(
    animation: stage.extent,
    builder: (context, child) {
      return Text(stage.stage.name);
    },
  );
}

void main() {
  testWidgets('pull down from the top triggers refresh', (tester) async {
    final completer = Completer<void>();
    var refreshCount = 0;

    await tester.pumpWidget(
      _buildRefreshTrigger(
        onRefresh: () {
          refreshCount++;
          return completer.future;
        },
      ),
    );

    await tester.drag(find.byKey(_scrollableKey), const Offset(0, 500));
    await tester.pumpAndSettle();

    expect(refreshCount, 1);
    expect(find.text(TriggerStage.refreshing.name), findsOneWidget);

    completer.complete();
    await tester.pump();
    await tester.pump();

    expect(find.text(TriggerStage.completed.name), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text(TriggerStage.idle.name), findsOneWidget);
  });

  testWidgets('pull below the threshold resets without refreshing', (
    tester,
  ) async {
    var refreshCount = 0;

    await tester.pumpWidget(
      _buildRefreshTrigger(
        minExtent: 120,
        onRefresh: () async {
          refreshCount++;
        },
      ),
    );

    await tester.drag(find.byKey(_scrollableKey), const Offset(0, 30));
    await tester.pumpAndSettle();

    expect(refreshCount, 0);
    expect(find.text(TriggerStage.idle.name), findsOneWidget);
  });

  testWidgets('short content remains refreshable', (tester) async {
    var refreshCount = 0;

    await tester.pumpWidget(
      _buildRefreshTrigger(
        onRefresh: () async {
          refreshCount++;
        },
        child: SingleChildScrollView(
          key: _scrollableKey,
          child: const SizedBox(height: 100),
        ),
      ),
    );

    await tester.drag(find.byKey(_scrollableKey), const Offset(0, 250));
    await tester.pumpAndSettle();

    expect(refreshCount, 1);
  });

  testWidgets('reverse mode triggers refresh from the bottom', (tester) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);
    var refreshCount = 0;

    await tester.pumpWidget(
      _buildRefreshTrigger(
        reverse: true,
        onRefresh: () async {
          refreshCount++;
        },
        child: SingleChildScrollView(
          key: _scrollableKey,
          controller: scrollController,
          child: const SizedBox(height: 1200),
        ),
      ),
    );

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await tester.pump();

    await tester.drag(find.byKey(_scrollableKey), const Offset(0, -250));
    await tester.pumpAndSettle();

    expect(refreshCount, 1);
  });
}
