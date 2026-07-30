import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

/// Radius token example page.
class MyRadiusPage extends StatelessWidget {
  const MyRadiusPage({super.key});

  static const _radiusSpecs = <_RadiusSpec>[
    _RadiusSpec(
      name: 'small',
      value: MyRadius.small,
      radius: MyRadi.small,
      borderRadius: MyBorderRadius.small,
      intent: 'Tiny controls and compact indicators.',
    ),
    _RadiusSpec(
      name: 'medium',
      value: MyRadius.medium,
      radius: MyRadi.medium,
      borderRadius: MyBorderRadius.medium,
      intent: 'Default controls, inputs, and menus.',
    ),
    _RadiusSpec(
      name: 'large',
      value: MyRadius.large,
      radius: MyRadi.large,
      borderRadius: MyBorderRadius.large,
      intent: 'Cards, images, and grouped content.',
    ),
    _RadiusSpec(
      name: 'extraLarge',
      value: MyRadius.extraLarge,
      radius: MyRadi.extraLarge,
      borderRadius: MyBorderRadius.extraLarge,
      intent: 'Panels, sheets, and larger surfaces.',
    ),
    _RadiusSpec(
      name: 'round',
      value: MyRadius.round,
      radius: MyRadi.round,
      borderRadius: MyBorderRadius.round,
      intent: 'Capsules, pills, and fully rounded affordances.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'radius',
      desc: 'Radius presets used in this app as defaults.',
      children: [
        ExampleModule(
          title: 'Scale',
          children: [
            ExampleItem(
              desc: 'The complete radius token scale from my_radius.dart.',
              builder: _buildRadiusScale,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Usage',
          children: [
            ExampleItem(
              desc: 'Preferred calls for the exported radius constants.',
              builder: _buildUsageSnippet,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadiusScale(BuildContext context) {
    return const _RadiusScale(specs: _radiusSpecs);
  }

  Widget _buildUsageSnippet(BuildContext context) {
    return const _UsageSnippet();
  }
}

class _RadiusSpec {
  const _RadiusSpec({
    required this.name,
    required this.value,
    required this.radius,
    required this.borderRadius,
    required this.intent,
  });

  final String name;
  final double value;
  final Radius radius;
  final BorderRadius borderRadius;
  final String intent;
}

class _RadiusScale extends StatelessWidget {
  const _RadiusScale({required this.specs});

  final List<_RadiusSpec> specs;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [for (final spec in specs) _RadiusTile(spec: spec)],
      ),
    );
  }
}

class _RadiusTile extends StatelessWidget {
  const _RadiusTile({required this.spec});

  final _RadiusSpec spec;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return SizedBox(
      width: 176,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 78,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.secondary,
              border: Border.all(color: colors.border),
              borderRadius: MyBorderRadius.small,
            ),
            child: Container(
              width: spec.name == 'round' ? 96 : 64,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: spec.borderRadius,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${spec.name.capitalize}',
            style: context.titleSmall.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${spec.value.toStringAsFixed(0)} px',
            style: TextStyle(color: colors.mutedForeground),
          ),
          const SizedBox(height: 4),
          Text(spec.intent, style: TextStyle(color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

class _UsageSnippet extends StatelessWidget {
  const _UsageSnippet();

  static const _code = '''
Container(
  decoration: const BoxDecoration(
    borderRadius: MyBorderRadius.large,
  ),
);

BorderRadius.circular(MyRadius.medium);

const BorderRadius.only(
  topLeft: MyRadi.small,
  bottomRight: MyRadi.extraLarge,
);
''';

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Label('Radius API'),
          const SizedBox(height: 14),
          Text(
            _code.trimRight(),
            style: TextStyle(
              color: colors.foreground,
              fontSize: 13,
              height: 20 / 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(color: colors.border),
        borderRadius: MyBorderRadius.large,
      ),
      child: child,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: MyTypography.geistMonoStyle.copyWith(
        color: context.colorScheme.mutedForeground,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
