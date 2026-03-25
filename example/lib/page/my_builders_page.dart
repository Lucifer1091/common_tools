import 'package:flutter/material.dart';

import '../base/example_widget.dart';

import 'dart:async';

import 'package:common_tools/index.dart';
import 'package:flutter/rendering.dart';

class MyBuildersPage extends StatelessWidget {
  const MyBuildersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'builders',
      desc:
          'Utility builders for async data, focus and hover state, lifecycle hooks, scroll controllers, and layout-driven composition.',
      children: [
        _buildModule('Async & Refresh', [
          BuilderDemoEntry(
            title: 'AutoRefreshBuilder',
            subtitle: 'Periodic rebuilds and scheduled callbacks.',
            pageDescription:
                'Runs a timer-driven builder or callback on a fixed interval. This demo shows a live ticker you can pause, resume, and reset.',
            demoBuilder: _buildAutoRefreshDemo,
          ),
          BuilderDemoEntry(
            title: 'FutureOrBuilder',
            subtitle: 'One API for immediate values and Futures.',
            pageDescription:
                'Accepts either a synchronous value or a Future and normalizes them into the same loading and success flow.',
            demoBuilder: _buildFutureOrDemo,
          ),
          BuilderDemoEntry(
            title: 'EnhancedFutureBuilder',
            subtitle:
                'Consistent loading, success, and error states for futures.',
            pageDescription:
                'Wraps FutureBuilder with explicit loading, success, and error slots. This demo simulates retryable async requests.',
            demoBuilder: _buildEnhancedFutureDemo,
          ),
          BuilderDemoEntry(
            title: 'EnhancedStreamBuilder',
            subtitle: 'Final-success and error handling for finite streams.',
            pageDescription:
                'Wraps StreamBuilder with explicit loading and error slots. In this implementation, success is shown when the stream completes.',
            demoBuilder: _buildEnhancedStreamDemo,
          ),
        ]),
        _buildModule('Focus & Interaction', [
          BuilderDemoEntry(
            title: 'HoverBuilder',
            subtitle: 'Boolean hover state for desktop and web interactions.',
            pageDescription:
                'Exposes a simple hover boolean so widgets can react to pointer entry and exit without managing MouseRegion state directly.',
            demoBuilder: _buildHoverDemo,
          ),
          BuilderDemoEntry(
            title: 'FocusableControlBuilder',
            subtitle:
                'Hover, focus, press, and keyboard activation in one builder.',
            pageDescription:
                'Combines gesture handling and FocusableActionDetector so a control can render directly from its current interaction state.',
            demoBuilder: _buildFocusableControlDemo,
          ),
        ]),
        _buildModule('State & Lifecycle', [
          BuilderDemoEntry(
            title: 'KeepAliveWrapper',
            subtitle: 'Preserve child state across tab and page switches.',
            pageDescription:
                'Keeps a subtree alive when it would otherwise be disposed, which is handy for tab views and lazily built pages.',
            demoBuilder: _buildKeepAliveDemo,
          ),
          BuilderDemoEntry(
            title: 'LifecycleEventHandler',
            subtitle:
                'Listen to app lifecycle changes with current and previous state.',
            pageDescription:
                'Provides app lifecycle notifications and shared current and previous state access. Background the app and return to see it update.',
            demoBuilder: _buildLifecycleDemo,
          ),
          BuilderDemoEntry(
            title: 'ListenablesBuilder',
            subtitle: 'Rebuild from multiple Listenable sources at once.',
            pageDescription:
                'Listens to several ValueNotifier or ChangeNotifier sources and rebuilds once whenever any of them change.',
            demoBuilder: _buildListenablesDemo,
          ),
        ]),
        _buildModule('Scroll & Layout', [
          BuilderDemoEntry(
            title: 'ScrollControllerBuilder',
            subtitle: 'Expose and own a ScrollController declaratively.',
            pageDescription:
                'Creates a ScrollController and hands it to the builder, keeping controller setup inside the widget tree.',
            demoBuilder: _buildScrollControllerDemo,
          ),
          BuilderDemoEntry(
            title: 'ValueLayoutBuilder',
            subtitle:
                'LayoutBuilder plus an extra injected value in constraints.',
            pageDescription:
                'A lower-level layout builder that receives both box constraints and a custom value. This demo feeds it a slider-controlled value directly.',
            demoBuilder: _buildValueLayoutDemo,
          ),
        ]),
      ],
    );
  }

  ExampleModule _buildModule(String title, List<BuilderDemoEntry> entries) {
    return ExampleModule(
      title: title,
      children: [
        ExampleItem(
          center: false,
          padding: EdgeInsets.only(top: 16),
          builder: (context) => BuilderEntryGroup(entries: entries),
        ),
      ],
    );
  }
}

class BuilderDemoEntry {
  const BuilderDemoEntry({
    required this.title,
    required this.subtitle,
    required this.pageDescription,
    required this.demoBuilder,
  });

  final String title;
  final String subtitle;
  final String pageDescription;
  final WidgetBuilder demoBuilder;
}

Widget _buildAutoRefreshDemo(BuildContext context) =>
    const AutoRefreshBuilderDemo();

Widget _buildFutureOrDemo(BuildContext context) => const FutureOrBuilderDemo();

Widget _buildEnhancedFutureDemo(BuildContext context) =>
    const EnhancedFutureBuilderDemo();

Widget _buildEnhancedStreamDemo(BuildContext context) =>
    const EnhancedStreamBuilderDemo();

Widget _buildHoverDemo(BuildContext context) => const HoverBuilderDemo();

Widget _buildFocusableControlDemo(BuildContext context) =>
    const FocusableControlBuilderDemo();

Widget _buildKeepAliveDemo(BuildContext context) =>
    const KeepAliveWrapperDemo();

Widget _buildLifecycleDemo(BuildContext context) =>
    const LifecycleEventHandlerDemo();

Widget _buildListenablesDemo(BuildContext context) =>
    const ListenablesBuilderDemo();

Widget _buildScrollControllerDemo(BuildContext context) =>
    const ScrollControllerBuilderDemo();

Widget _buildValueLayoutDemo(BuildContext context) =>
    const ValueLayoutBuilderDemo();

class BuilderEntryGroup extends StatelessWidget {
  const BuilderEntryGroup({required this.entries, super.key});

  final List<BuilderDemoEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MyCellGroup(
        bordered: true,
        theme: MyCellGroupTheme.card,
        style: MyCellStyle.style(
          context,
        ).copyWith(cardPadding: EdgeInsets.zero),
        cells: [
          for (final entry in entries)
            MyCell(
              title: entry.title,
              description: entry.subtitle,
              arrow: true,
              onTap: (_) => openBuilderEntry(context, entry),
            ),
        ],
      ),
    );
  }
}

void openBuilderEntry(BuildContext context, BuilderDemoEntry entry) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => BuilderExamplePage(entry: entry)),
  );
}

class BuilderExamplePage extends StatelessWidget {
  const BuilderExamplePage({required this.entry, super.key});

  final BuilderDemoEntry entry;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: entry.title,
      desc: entry.pageDescription,
      exampleCodeGroup: 'builders',
      children: [
        ExampleModule(
          title: 'Live Example',
          children: [
            ExampleItem(
              center: false,
              builder: entry.demoBuilder,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ],
        ),
      ],
    );
  }
}

class DemoCard extends StatelessWidget {
  const DemoCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class StateBadge extends StatelessWidget {
  const StateBadge(this.label, {this.active = false, this.color, super.key});

  final String label;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? context.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? accent.withValues(alpha: 0.12)
            : context.colorScheme.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? accent.withValues(alpha: 0.3)
              : context.colorScheme.border,
        ),
      ),
      child: Text(
        label,
        style: context.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorScheme.foreground,
        ),
      ),
    );
  }
}

class LoadingPanel extends StatelessWidget {
  const LoadingPanel({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MessagePanel(
      title: title,
      message: message,
      accent: context.colorScheme.primary,
      leading: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _AsyncResultPanel extends StatelessWidget {
  const _AsyncResultPanel({required this.sample, required this.accent});

  final _AsyncSample sample;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return MessagePanel(
      title: sample.title,
      message: '${sample.message}\nSource: ${sample.source}',
      accent: accent,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: sample.progress,
              color: accent,
              backgroundColor: accent.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagePanel extends StatelessWidget {
  const MessagePanel({
    required this.title,
    required this.message,
    required this.accent,
    this.footer,
    this.leading,
    super.key,
  });

  final String title;
  final String message;
  final Color accent;
  final Widget? footer;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading ??
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      message,
                      style: context.bodyMedium.copyWith(
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class AutoRefreshBuilderDemo extends StatefulWidget {
  const AutoRefreshBuilderDemo({super.key});

  @override
  State<AutoRefreshBuilderDemo> createState() => _AutoRefreshBuilderDemoState();
}

class _AutoRefreshBuilderDemoState extends State<AutoRefreshBuilderDemo> {
  bool _enabled = true;
  int _seed = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoCard(
            child: AutoRefreshBuilder(
              key: ValueKey(_seed),
              duration: const Duration(seconds: 1),
              enableTimer: _enabled,
              enableWidgetBindingObserver: true,
              builder: (tick) {
                final progress = ((tick % 6) / 5).clamp(0.0, 1.0);
                final clock = _formatClock(DateTime.now());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Heartbeat ticker',
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$tick',
                      style: context.headlineLarge.copyWith(
                        color: context.colorScheme.secondaryForeground,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StateBadge(
                          _enabled ? 'Timer running' : 'Timer paused',
                          active: _enabled,
                          color: MyColors.green,
                        ),
                        StateBadge(clock, active: true),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: progress,
                        color: context.colorScheme.primary,
                        backgroundColor: context.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Gap(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(
                text: _enabled ? 'Pause timer' : 'Resume timer',
                onTap: () {
                  setState(() {
                    _enabled = !_enabled;
                  });
                },
              ),
              MyButton(
                text: 'Reset',
                type: MyButtonType.outline,
                onTap: () {
                  setState(() {
                    _seed++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FutureOrBuilderDemo extends StatefulWidget {
  const FutureOrBuilderDemo({super.key});

  @override
  State<FutureOrBuilderDemo> createState() => _FutureOrBuilderDemoState();
}

class _FutureOrBuilderDemoState extends State<FutureOrBuilderDemo> {
  bool _useFuture = true;
  int _requestId = 1;

  FutureOr<_AsyncSample> _buildRequest() {
    if (_useFuture) {
      return Future<_AsyncSample>.delayed(
        const Duration(milliseconds: 900),
        () => _AsyncSample(
          title: 'Future result #$_requestId',
          message: 'Resolved asynchronously after 900ms.',
          progress: 0.7,
          source: 'Future',
        ),
      );
    }

    return _AsyncSample(
      title: 'Immediate result #$_requestId',
      message: 'Returned synchronously from the same widget tree.',
      progress: 0.45,
      source: 'Immediate value',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoCard(
            child: FutureOrBuilder<_AsyncSample>(
              future: _buildRequest(),
              inProgress: const LoadingPanel(
                title: 'Preparing result',
                message: 'This branch is waiting for async data.',
              ),
              onLoading: const LoadingPanel(
                title: 'Resolving FutureOr',
                message: 'Future values will show a loading state first.',
              ),
              onSuccess: (sample) {
                return _AsyncResultPanel(
                  sample: sample,
                  accent: context.colorScheme.primary,
                );
              },
            ),
          ),
          const Gap(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(
                text: _useFuture ? 'Use immediate value' : 'Use future',
                onTap: () {
                  setState(() {
                    _useFuture = !_useFuture;
                  });
                },
              ),
              MyButton(
                text: 'Refresh sample',
                type: MyButtonType.outline,
                onTap: () {
                  setState(() {
                    _requestId++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EnhancedFutureBuilderDemo extends StatefulWidget {
  const EnhancedFutureBuilderDemo({super.key});

  @override
  State<EnhancedFutureBuilderDemo> createState() =>
      _EnhancedFutureBuilderDemoState();
}

class _EnhancedFutureBuilderDemoState extends State<EnhancedFutureBuilderDemo> {
  late Future<_AsyncSample> _future;
  bool _shouldFail = false;
  int _requestId = 1;

  @override
  void initState() {
    super.initState();
    _future = _createFuture();
  }

  Future<_AsyncSample> _createFuture() {
    final requestId = _requestId;
    final shouldFail = _shouldFail;
    return Future<_AsyncSample>.delayed(const Duration(milliseconds: 1100), () {
      if (shouldFail) {
        throw StateError('Request #$requestId failed intentionally.');
      }
      return _AsyncSample(
        title: 'Loaded request #$requestId',
        message: 'Future completed successfully and rendered onSuccess.',
        progress: 0.82,
        source: 'EnhancedFutureBuilder',
      );
    });
  }

  void _reload() {
    setState(() {
      _requestId++;
      _future = _createFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoCard(
            child: MyFutureBuilder<_AsyncSample>(
              future: _future,
              rememberFutureResult: true,
              inProgress: LoadingPanel(
                title: 'Loading request #$_requestId',
                message: 'Simulating an async call with retry support.',
              ),
              onLoading: LoadingPanel(
                title: 'Fetching data',
                message: 'Request #$_requestId is still in flight.',
              ),
              onSuccess: (sample) {
                return _AsyncResultPanel(
                  sample: sample,
                  accent: MyColors.green,
                );
              },
              onError: (error) {
                return MessagePanel(
                  title: 'Future failed',
                  message: error.toString(),
                  accent: context.colorScheme.destructive,
                  footer: Align(
                    alignment: Alignment.centerLeft,
                    child: MyButton(
                      text: 'Retry',
                      type: MyButtonType.outline,
                      onTap: _reload,
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(text: 'New request', onTap: _reload),
              MyButton(
                text: _shouldFail ? 'Disable error' : 'Simulate error',
                type: MyButtonType.outline,
                onTap: () {
                  setState(() {
                    _shouldFail = !_shouldFail;
                    _future = _createFuture();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EnhancedStreamBuilderDemo extends StatefulWidget {
  const EnhancedStreamBuilderDemo({super.key});

  @override
  State<EnhancedStreamBuilderDemo> createState() =>
      _EnhancedStreamBuilderDemoState();
}

class _EnhancedStreamBuilderDemoState extends State<EnhancedStreamBuilderDemo> {
  late Stream<_StreamSummary> _stream;
  bool _shouldFail = false;
  int _runId = 1;

  @override
  void initState() {
    super.initState();
    _stream = _createStream();
  }

  Stream<_StreamSummary> _createStream() async* {
    final runId = _runId;
    final shouldFail = _shouldFail;

    for (var step = 1; step <= 4; step++) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (shouldFail && step == 3) {
        throw StateError('Stream run #$runId failed on event $step.');
      }
      yield _StreamSummary(
        runId: runId,
        eventCount: step,
        label: 'Processed event $step of 4',
      );
    }
  }

  void _restart() {
    setState(() {
      _runId++;
      _stream = _createStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoCard(
            child: MyStreamBuilder<_StreamSummary>(
              stream: _stream,
              initialData: const _StreamSummary(
                runId: 0,
                eventCount: 0,
                label: 'Waiting for stream to start',
              ),
              inProgress: const LoadingPanel(
                title: 'Receiving events',
                message:
                    'This builder shows its success view after the stream closes.',
              ),
              onLoading: const LoadingPanel(
                title: 'Subscribing to stream',
                message: 'A finite stream is being attached.',
              ),
              onSuccess: (summary) {
                return MessagePanel(
                  title: 'Stream completed',
                  message:
                      'Run #${summary.runId} finished after ${summary.eventCount} events.\n${summary.label}',
                  accent: MyColors.blue,
                );
              },
              onError: (error) {
                return MessagePanel(
                  title: 'Stream failed',
                  message: error.toString(),
                  accent: context.colorScheme.destructive,
                );
              },
            ),
          ),
          const Gap(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(text: 'Restart stream', onTap: _restart),
              MyButton(
                text: _shouldFail ? 'Disable error' : 'Simulate error',
                type: MyButtonType.outline,
                onTap: () {
                  setState(() {
                    _shouldFail = !_shouldFail;
                    _stream = _createStream();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AsyncSample {
  const _AsyncSample({
    required this.title,
    required this.message,
    required this.progress,
    required this.source,
  });

  final String title;
  final String message;
  final double progress;
  final String source;
}

class _StreamSummary {
  const _StreamSummary({
    required this.runId,
    required this.eventCount,
    required this.label,
  });

  final int runId;
  final int eventCount;
  final String label;
}

String _formatClock(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  final second = time.second.toString().padLeft(2, '0');
  return '$hour:$minute:$second';
}

class HoverBuilderDemo extends StatelessWidget {
  const HoverBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: HoverBuilder(
        cursor: SystemMouseCursors.click,
        builder: (context, hovering) {
          final accent = hovering
              ? context.colorScheme.primary
              : context.colorScheme.border;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: hovering
                  ? context.colorScheme.primary.withValues(alpha: 0.08)
                  : context.colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent),
              boxShadow: hovering ? MyBoxShadows.md : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  hovering
                      ? Icons.waving_hand_rounded
                      : Icons.touch_app_rounded,
                  color: context.colorScheme.secondaryForeground,
                ),
                const SizedBox(height: 16),
                Text(
                  hovering ? 'Pointer detected' : 'Hover over this panel',
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.secondaryForeground,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'HoverBuilder keeps the interaction model down to one boolean.',
                  style: context.bodyMedium.copyWith(
                    color: context.colorScheme.secondaryForeground,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FocusableControlBuilderDemo extends StatefulWidget {
  const FocusableControlBuilderDemo({super.key});

  @override
  State<FocusableControlBuilderDemo> createState() =>
      _FocusableControlBuilderDemoState();
}

class _FocusableControlBuilderDemoState
    extends State<FocusableControlBuilderDemo> {
  int _pressCount = 0;
  String _lastEvent = 'Idle';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FocusableControlBuilder(
            semanticButtonLabel: 'Focusable control demo',
            onPressed: () {
              setState(() {
                _pressCount++;
                _lastEvent = 'Pressed';
              });
            },
            onHoverChanged: (_, control) {
              setState(() {
                _lastEvent = control.isHovered ? 'Hovered' : 'Hover ended';
              });
            },
            onFocusChanged: (_, control) {
              setState(() {
                _lastEvent = control.isFocused ? 'Focused' : 'Focus lost';
              });
            },
            builder: (context, control) {
              final accent = control.isPressed
                  ? context.colorScheme.primary
                  : control.isHovered || control.isFocused
                  ? MyColors.blue
                  : context.colorScheme.border;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: control.isPressed
                      ? context.colorScheme.primary.withValues(alpha: 0.1)
                      : context.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.gamepad_rounded,
                          color: context.colorScheme.secondaryForeground,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Focusable control surface',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.secondaryForeground,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StateBadge(
                          control.isHovered ? 'Hovered' : 'Not hovered',
                          active: control.isHovered,
                          color: MyColors.blue,
                        ),
                        StateBadge(
                          control.isFocused ? 'Focused' : 'Not focused',
                          active: control.isFocused,
                          color: context.colorScheme.primary,
                        ),
                        StateBadge(
                          control.isPressed ? 'Pressed' : 'Released',
                          active: control.isPressed,
                          color: MyColors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Activate it with mouse, Enter, or Space.',
                      style: context.bodyMedium.copyWith(
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Gap(16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StateBadge('Press count: $_pressCount', active: true),
              StateBadge(_lastEvent, active: true),
            ],
          ),
        ],
      ),
    );
  }
}

class KeepAliveWrapperDemo extends StatelessWidget {
  const KeepAliveWrapperDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DefaultTabController(
        length: 2,
        child: DemoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch tabs and keep each tab state alive.',
                style: context.bodyMedium.copyWith(
                  color: context.colorScheme.secondaryForeground,
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Settings'),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(
                height: 280,
                child: TabBarView(
                  children: [
                    KeepAliveWrapper(child: _KeepAliveTab(label: 'Profile')),
                    KeepAliveWrapper(child: _KeepAliveTab(label: 'Settings')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeepAliveTab extends StatefulWidget {
  const _KeepAliveTab({required this.label});

  final String label;

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab> {
  late final TextEditingController _controller;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.label} draft');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          '${widget.label} tab',
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.secondaryForeground,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Local text',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        MyButton(
          text: 'Increment local counter ($_counter)',
          onTap: () {
            setState(() {
              _counter++;
            });
          },
        ),
      ],
    );
  }
}

class LifecycleEventHandlerDemo extends StatefulWidget {
  const LifecycleEventHandlerDemo({super.key});

  @override
  State<LifecycleEventHandlerDemo> createState() =>
      _LifecycleEventHandlerDemoState();
}

class _LifecycleEventHandlerDemoState extends State<LifecycleEventHandlerDemo>
    with LifecycleMixin<LifecycleEventHandlerDemo> {
  final List<AppLifecycleState> _history = [LifecycleEventHandler.stateCurrent];

  @override
  void onChangeLifecycleState(AppLifecycleState lifecycleState) {
    if (!mounted) return;
    setState(() {
      _history.add(lifecycleState);
      if (_history.length > 6) {
        _history.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DemoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Background the app and come back to trigger new lifecycle entries.',
              style: context.bodyMedium.copyWith(
                color: context.colorScheme.secondaryForeground,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StateBadge(
                  'Current: ${LifecycleEventHandler.stateCurrent.name}',
                  active: true,
                  color: context.colorScheme.primary,
                ),
                StateBadge(
                  'Previous: ${LifecycleEventHandler.statePrevious.name}',
                  active: true,
                  color: MyColors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Recent events',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.secondaryForeground,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in _history.reversed)
                  StateBadge(item.name, active: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ListenablesBuilderDemo extends StatefulWidget {
  const ListenablesBuilderDemo({super.key});

  @override
  State<ListenablesBuilderDemo> createState() => _ListenablesBuilderDemoState();
}

class _ListenablesBuilderDemoState extends State<ListenablesBuilderDemo> {
  late final ValueNotifier<int> _count;
  late final ValueNotifier<double> _progress;
  late final ValueNotifier<Color> _accent;

  @override
  void initState() {
    super.initState();
    _count = ValueNotifier<int>(3);
    _progress = ValueNotifier<double>(0.35);
    _accent = ValueNotifier<Color>(MyColors.blue);
  }

  @override
  void dispose() {
    _count.dispose();
    _progress.dispose();
    _accent.dispose();
    super.dispose();
  }

  void _cycleAccent() {
    final colors = <Color>[MyColors.blue, MyColors.green, MyColors.warning];
    final currentIndex = colors.indexOf(_accent.value);
    final nextIndex = (currentIndex + 1) % colors.length;
    _accent.value = colors[nextIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListenablesBuilder(
            listenables: [_count, _progress, _accent],
            builder: (context) {
              return DemoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Combined listenable state',
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_count.value} cards selected',
                      style: context.headlineSmall.copyWith(
                        color: context.colorScheme.secondaryForeground,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: _progress.value,
                        color: _accent.value,
                        backgroundColor: _accent.value.withValues(alpha: 0.15),
                      ),
                    ),
                    const SizedBox(height: 14),
                    StateBadge(
                      'Accent ${_accent.value == MyColors.blue
                          ? "Blue"
                          : _accent.value == MyColors.green
                          ? "Green"
                          : "Warning"}',
                      active: true,
                      color: _accent.value,
                    ),
                  ],
                ),
              );
            },
          ),
          const Gap(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(
                text: 'Add card',
                onTap: () => _count.value = _count.value + 1,
              ),
              MyButton(
                text: 'Advance progress',
                type: MyButtonType.outline,
                onTap: () {
                  final next = _progress.value + 0.15;
                  _progress.value = next > 1 ? 0.15 : next;
                },
              ),
              MyButton(
                text: 'Cycle accent',
                type: MyButtonType.outline,
                onTap: _cycleAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScrollControllerBuilderDemo extends StatefulWidget {
  const ScrollControllerBuilderDemo({super.key});

  @override
  State<ScrollControllerBuilderDemo> createState() =>
      _ScrollControllerBuilderDemoState();
}

class _ScrollControllerBuilderDemoState
    extends State<ScrollControllerBuilderDemo> {
  double _offset = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 360,
        child: DemoCard(
          child: ScrollControllerBuilder(
            listener: (controller) {
              if (!mounted || !controller.hasClients) return;
              setState(() {
                _offset = controller.offset;
              });
            },
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StateBadge(
                        'Offset ${_offset.toStringAsFixed(0)} px',
                        active: true,
                      ),
                      MyButton(
                        text: 'Top',
                        size: MyButtonSize.small,
                        type: MyButtonType.outline,
                        onTap: () {
                          controller.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        },
                      ),
                      MyButton(
                        text: 'Jump to 400',
                        size: MyButtonSize.small,
                        type: MyButtonType.outline,
                        onTap: () {
                          controller.animateTo(
                            400,
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeOutCubic,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Scrollbar(
                      controller: controller,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: controller,
                        itemCount: 20,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: context.colorScheme.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: context.colorScheme.border,
                              ),
                            ),
                            child: Text(
                              'Scrollable row ${index + 1}',
                              style: context.bodyMedium.copyWith(
                                color: context.colorScheme.secondaryForeground,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ValueLayoutBuilderDemo extends StatefulWidget {
  const ValueLayoutBuilderDemo({super.key});

  @override
  State<ValueLayoutBuilderDemo> createState() => _ValueLayoutBuilderDemoState();
}

class _ValueLayoutBuilderDemoState extends State<ValueLayoutBuilderDemo> {
  double _progress = 0.32;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This host injects a custom value into box constraints during layout.',
                  style: context.bodyMedium.copyWith(
                    color: context.colorScheme.secondaryForeground,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 190,
                  child: _ValueConstraintHost<double>(
                    value: _progress,
                    child: ValueLayoutBuilder<double>(
                      builder: (context, constraints) {
                        final alignmentX = -1 + (constraints.value * 2);
                        final bubbleSize =
                            54 +
                            (constraints.maxHeight * constraints.value * 0.32);
                        final fillWidth =
                            constraints.maxWidth *
                            (0.2 + constraints.value * 0.65);

                        return Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: context.colorScheme.background,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: context.colorScheme.border,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: fillWidth,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primary
                                        .withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment(alignmentX, 0),
                                child: Container(
                                  width: bubbleSize,
                                  height: bubbleSize,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: MyBoxShadows.sm,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Text(
                                  'width ${constraints.maxWidth.toStringAsFixed(0)}\nvalue ${constraints.value.toStringAsFixed(2)}',
                                  style: context.bodySmall.copyWith(
                                    color:
                                        context.colorScheme.secondaryForeground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          Text(
            'Injected value ${(100 * _progress).round()}%',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.foreground,
            ),
          ),
          Slider(
            value: _progress,
            onChanged: (value) {
              setState(() {
                _progress = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ValueConstraintHost<T> extends SingleChildRenderObjectWidget {
  const _ValueConstraintHost({required this.value, super.key, super.child});

  final T value;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderValueConstraintHost<T>(value);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderValueConstraintHost<T> renderObject,
  ) {
    renderObject.value = value;
  }
}

class _RenderValueConstraintHost<T> extends RenderProxyBox {
  _RenderValueConstraintHost(this._value);

  T _value;

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.biggest;
      return;
    }

    child.layout(
      BoxValueConstraints<T>(value: _value, constraints: constraints),
      parentUsesSize: true,
    );
    size = constraints.constrain(child.size);
  }
}
