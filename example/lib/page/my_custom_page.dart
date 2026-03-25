import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyCustomPage extends StatelessWidget {
  const MyCustomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'custom',
      desc:
          'Utility widgets from the custom directory, with full-page demos only where route-level behavior matters.',
      children: [
        ExampleModule(
          title: 'Playgrounds',
          children: [
            ExampleItem(
              desc:
                  'These helpers make the most sense when they control a full route or subtree.',
              center: false,
              builder: (context) => const _CustomPlaygroundLinks(),
            ),
          ],
        ),
        ExampleModule(
          title: 'Inline Demos',
          children: [
            ExampleItem(
              desc: 'LimitTextScaleWidget',
              ignoreCode: true,
              center: false,
              builder: (context) => const _LimitTextScaleDemo(),
            ),
            ExampleItem(
              desc: 'MyDisabled',
              ignoreCode: true,
              center: false,
              builder: (context) => const _MyDisabledDemo(),
            ),
            ExampleItem(
              desc: 'Shimmer',
              ignoreCode: true,
              center: false,
              builder: (context) => const _ShimmerDemo(),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomPlaygroundLinks extends StatelessWidget {
  const _CustomPlaygroundLinks();

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
          MyCell(
            title: 'DismissKeyboard',
            description: 'Tap outside a field to clear focus.',
            arrow: true,
            onTap: (_) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _DismissKeyboardDemoPage(),
                ),
              );
            },
          ),
          MyCell(
            title: 'DoublePressBackWidget',
            description: 'Requires a route to demonstrate back handling.',
            arrow: true,
            onTap: (_) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _DoublePressBackDemoPage(),
                ),
              );
            },
          ),
          MyCell(
            title: 'RestartAppWidget',
            description: 'Best shown by resetting a live subtree.',
            arrow: true,
            onTap: (_) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _RestartAppDemoPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DismissKeyboardDemoPage extends StatelessWidget {
  const _DismissKeyboardDemoPage();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'DismissKeyboard',
      desc:
          'Wrap a tappable surface and it will unfocus the current field when the user taps outside.',
      exampleCodeGroup: 'custom',
      children: [
        ExampleModule(
          title: 'Live Example',
          children: [
            ExampleItem(
              ignoreCode: true,
              center: false,
              builder: (context) => const _DismissKeyboardPlayground(),
            ),
          ],
        ),
        ExampleModule(
          title: 'Navigator Observer',
          children: [
            ExampleItem(
              ignoreCode: true,
              center: false,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _DemoSurface(
                    child: Text(
                      'This file also includes KeyboardDismissalNavigatorObserver for dismissing focus automatically on push and pop.',
                      style: context.bodyMedium.copyWith(
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _DismissKeyboardPlayground extends StatelessWidget {
  const _DismissKeyboardPlayground();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 360,
        child: _DemoSurface(
          child: DismissKeyboard(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Text(
                  'Tap a field, then tap the empty space in this card.',
                  style: context.bodyMedium.copyWith(
                    color: context.colorScheme.secondaryForeground,
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StateBadge(
                    'DismissKeyboard only clears focus when something is focused.',
                    active: true,
                    color: context.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoublePressBackDemoPage extends StatelessWidget {
  const _DoublePressBackDemoPage();

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: 'Press back again to leave this demo',
      child: ExamplePage(
        title: 'DoublePressBackWidget',
        desc:
            'Use the app-bar back button or system back. The first press shows a prompt, and the second press within two seconds exits.',
        exampleCodeGroup: 'custom',
        children: [
          ExampleModule(
            title: 'Live Example',
            children: [
              ExampleItem(
                ignoreCode: true,
                center: false,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _DemoSurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This whole route is wrapped with DoublePressBackWidget.',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.secondaryForeground,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'First back press shows a SnackBar. The next one within two seconds allows the route to close.',
                            style: context.bodyMedium.copyWith(
                              color: context.colorScheme.secondaryForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RestartAppDemoPage extends StatelessWidget {
  const _RestartAppDemoPage();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'RestartAppWidget',
      desc:
          'Wrap a subtree with RestartAppWidget and call RestartAppWidget.init(context) to rebuild it from scratch.',
      exampleCodeGroup: 'custom',
      children: [
        ExampleModule(
          title: 'Live Example',
          children: [
            ExampleItem(
              ignoreCode: true,
              center: false,
              builder: (context) => const _RestartAppSandbox(),
            ),
          ],
        ),
      ],
    );
  }
}

class _RestartAppSandbox extends StatelessWidget {
  const _RestartAppSandbox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RestartAppWidget(child: const _RestartableLab()),
    );
  }
}

class _RestartableLab extends StatefulWidget {
  const _RestartableLab();

  @override
  State<_RestartableLab> createState() => _RestartableLabState();
}

class _RestartableLabState extends State<_RestartableLab> {
  late final TextEditingController _controller;
  int _counter = 0;
  late final String _seed;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _seed = DateTime.now().toIso8601String().substring(11, 19);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Restartable subtree',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Seed: $_seed',
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Local draft text',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Counter: $_counter',
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(
                text: 'Increment',
                onTap: () {
                  setState(() {
                    _counter++;
                  });
                },
              ),
              MyButton(
                text: 'Restart subtree',
                type: MyButtonType.outline,
                onTap: () => RestartAppWidget.init(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LimitTextScaleDemo extends StatelessWidget {
  const _LimitTextScaleDemo();

  @override
  Widget build(BuildContext context) {
    final scaledData = MediaQuery.of(
      context,
    ).copyWith(textScaler: const TextScaler.linear(1.8));

    Widget panel({
      required BuildContext context,
      required String title,
      required Widget child,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colorScheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.secondaryForeground,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MediaQuery(
        data: scaledData,
        child: _DemoSurface(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              panel(
                context: context,
                title: 'Uncapped',
                child: const Text(
                  'This copy uses the full inherited text scale factor.',
                ),
              ),
              const SizedBox(width: 12),
              panel(
                context: context,
                title: 'Capped at 1.2x',
                child: const LimitTextScaleWidget(
                  maxTextScaleFactor: 1.2,
                  child: Text('This copy is clamped by LimitTextScaleWidget.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyDisabledDemo extends StatefulWidget {
  const _MyDisabledDemo();

  @override
  State<_MyDisabledDemo> createState() => _MyDisabledDemoState();
}

class _MyDisabledDemoState extends State<_MyDisabledDemo> {
  bool _disabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DemoSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toggle disabled state',
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.secondaryForeground,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: MyDisabled(
                        disabled: _disabled,
                        showForbiddenCursor: true,
                        child: MyButton(
                          text: 'Primary Action',
                          isExpanded: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Action triggered')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          MyButton(
            text: _disabled ? 'Enable action' : 'Disable action',
            type: MyButtonType.outline,
            onTap: () {
              setState(() {
                _disabled = !_disabled;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ShimmerDemo extends StatelessWidget {
  const _ShimmerDemo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _DemoSurface(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Shimmer(height: 56, width: 56, radius: 999),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Shimmer(height: 18, width: 220, radius: 999),
                      SizedBox(height: 10),
                      Shimmer(height: 14, width: 180, radius: 999),
                      SizedBox(height: 10),
                      Shimmer(height: 14, width: 140, radius: 999),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Shimmer(height: 14, width: 320, radius: 999),
            const SizedBox(height: 10),
            const Shimmer(height: 14, width: 280, radius: 999),
            const SizedBox(height: 10),
            const Shimmer(height: 14, width: 240, radius: 999),
          ],
        ),
      ),
    );
  }
}

class _DemoSurface extends StatelessWidget {
  const _DemoSurface({required this.child});

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
  const StateBadge(
    this.label, {
    required this.active,
    required this.color,
    super.key,
  });

  final String label;
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? color.withValues(alpha: 0.12)
            : context.colorScheme.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? color.withValues(alpha: 0.3)
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
