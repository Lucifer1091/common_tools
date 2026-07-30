import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';

import '../../base/example_widget.dart';

/// Shadow token example page.
class MyShadowsPage extends StatelessWidget {
  const MyShadowsPage({super.key});

  static const _elevationShadows = <_ShadowSpec>[
    _ShadowSpec(
      name: 'sm',
      shadows: MyBoxShadows.sm,
      intent: 'Subtle separation for compact controls and small tiles.',
    ),
    _ShadowSpec(
      name: 'regular',
      shadows: MyBoxShadows.regular,
      intent: 'Default raised surface for simple cards and menus.',
    ),
    _ShadowSpec(
      name: 'md',
      shadows: MyBoxShadows.md,
      intent: 'Popover, dropdown, and floating panel elevation.',
    ),
    _ShadowSpec(
      name: 'lg',
      shadows: MyBoxShadows.lg,
      intent: 'Prominent cards and surfaces above dense content.',
    ),
    _ShadowSpec(
      name: 'lg2',
      shadows: MyBoxShadows.lg2,
      intent: 'Combined soft depth used by floating action surfaces.',
    ),
    _ShadowSpec(
      name: 'xl',
      shadows: MyBoxShadows.xl,
      intent: 'Large overlays, sheets, and elevated feature panels.',
    ),
    _ShadowSpec(
      name: 'xl2',
      shadows: MyBoxShadows.xl2,
      intent: 'Highest elevation for dramatic modal depth.',
    ),
  ];

  static const _innerShadows = <_ShadowSpec>[
    _ShadowSpec(
      name: 'inner',
      shadows: MyBoxShadows.inner,
      intent: 'Inset depth using BlurStyle.inner.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.background,
      title: myTitle(context),
      exampleCodeGroup: 'shadows',
      desc: 'Deafult shadow presets.',
      children: [
        ExampleModule(
          title: 'Elevation scale',
          children: [
            ExampleItem(
              desc:
                  'The main outward shadow scale from small controls to modal depth.',
              builder: _buildElevationScale,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Inner shadow',
          children: [
            ExampleItem(
              desc: 'Inset shadow token for pressed or recessed surfaces.',
              builder: _buildInnerShadow,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Usage',
          children: [
            ExampleItem(
              desc:
                  'Use these constants anywhere a List<BoxShadow> is accepted.',
              builder: _buildUsageSnippet,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildElevationScale(BuildContext context) {
    return const _ShadowGrid(specs: _elevationShadows);
  }

  Widget _buildInnerShadow(BuildContext context) {
    return const _ShadowGrid(specs: _innerShadows);
  }

  Widget _buildUsageSnippet(BuildContext context) {
    return const _UsageSnippet();
  }
}

class _ShadowSpec {
  const _ShadowSpec({
    required this.name,
    required this.shadows,
    required this.intent,
  });

  final String name;
  final List<BoxShadow> shadows;
  final String intent;

  bool get hasInnerLayer {
    return shadows.any((shadow) => shadow.blurStyle == BlurStyle.inner);
  }
}

class _ShadowGrid extends StatelessWidget {
  const _ShadowGrid({required this.specs});

  final List<_ShadowSpec> specs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [for (final spec in specs) _ShadowCard(spec: spec)],
    );
  }
}

class _ShadowCard extends StatelessWidget {
  const _ShadowCard({required this.spec});

  final _ShadowSpec spec;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return SizedBox(
      width: 220,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.background,
          border: Border.all(color: colors.border),
          borderRadius: MyBorderRadius.large,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShadowPreview(spec: spec),
            const SizedBox(height: 16),
            Text(
              'MyBoxShadows.${spec.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.foreground,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 20 / 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              spec.intent,
              style: TextStyle(
                color: colors.mutedForeground,
                fontSize: 12,
                height: 17 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShadowPreview extends StatelessWidget {
  const _ShadowPreview({required this.spec});

  final _ShadowSpec spec;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final previewColor = spec.hasInnerLayer ? colors.secondary : colors.card;

    return Container(
      height: 124,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: MyBorderRadius.large,
      ),
      child: Container(
        width: 132,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: previewColor,
          border: Border.all(color: colors.border),
          borderRadius: MyBorderRadius.large,
          boxShadow: spec.shadows,
        ),
        child: Text(
          spec.name,
          style: TextStyle(
            color: colors.foreground,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 18 / 13,
          ),
        ),
      ),
    );
  }
}

class _UsageSnippet extends StatelessWidget {
  const _UsageSnippet();

  static const _code = '''
Container(
  decoration: const BoxDecoration(
    boxShadow: MyBoxShadows.md,
  ),
);

MyButton(
  text: 'Floating action',
  shadows: MyBoxShadows.all,
);

MyPopover(
  shadows: MyBoxShadows.lg,
  child: content,
);
''';

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Shadow API'),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

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
