import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';

import '../../base/example_widget.dart';

/// Font example page.
class MyFontPage extends StatelessWidget {
  const MyFontPage({super.key});

  static const _fontWeights = <_FontWeightSpec>[
    _FontWeightSpec('100', FontWeight.w100, 'Thin'),
    _FontWeightSpec('200', FontWeight.w200, 'ExtraLight'),
    _FontWeightSpec('300', FontWeight.w300, 'Light'),
    _FontWeightSpec('400', FontWeight.w400, 'Regular'),
    _FontWeightSpec('500', FontWeight.w500, 'Medium'),
    _FontWeightSpec('600', FontWeight.w600, 'SemiBold'),
    _FontWeightSpec('700', FontWeight.w700, 'Bold'),
    _FontWeightSpec('800', FontWeight.w800, 'ExtraBold'),
    _FontWeightSpec('900', FontWeight.w900, 'Black'),
  ];

  @override
  Widget build(BuildContext context) {
    // debugPaintBaselinesEnabled = true;
    return ExamplePage(
      padding: const EdgeInsets.all(8),
      title: myTitle(context),
      desc:
          'By default it uses Geist as default font family. To change it, add the local font to your project, for example in the /fonts directory. Then update your pubspec.yaml',
      exampleCodeGroup: 'fonts',
      children: [
        ExampleModule(
          title: 'Specimen',
          children: [
            ExampleItem(
              desc:
                  'Geist for interface language, Geist Mono for code and data.',
              builder: _buildHeroComparison,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Weights',
          children: [
            ExampleItem(
              desc: 'Geist supports the complete static weight range.',
              builder: _buildGeistWeights,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ExampleItem(
              desc: 'Geist Mono mirrors the same range for technical UI.',
              builder: _buildGeistMonoWeights,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Applied typography',
          children: [
            ExampleItem(
              desc:
                  'Product copy, labels, source text, and aligned numeric data.',
              builder: _buildAppliedExamples,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Usage',
          children: [
            ExampleItem(
              desc: 'Use the packaged styles when a TextStyle is accepted.',
              builder: _buildUsageSnippet,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroComparison(BuildContext context) {
    return _ResponsivePair(
      first: _SpecimenPanel(
        label: 'GEIST',
        title: 'Ship clean interfaces faster',
        body:
            'A compact sans family for product surfaces, dashboards, and '
            'component libraries that need quiet precision.',
        sample: 'Aa Bb Cc 1234567890',
        style: MyTypography.geistSansStyle,
      ),
      second: _SpecimenPanel(
        label: 'GEIST MONO',
        title: 'const tokens = <String>[];',
        body:
            'A monospaced partner for code blocks, logs, terminal fragments, '
            'IDs, tables, and dense developer-facing data.',
        sample: '0O 1l {} [] != -> #42',
        style: MyTypography.geistMonoStyle,
      ),
    );
  }

  Widget _buildGeistWeights(BuildContext context) {
    return _WeightRamp(
      familyLabel: 'Geist',
      style: MyTypography.geistSansStyle,
      sample: 'The quick brown fox jumps over 13 lazy dogs.',
      weights: _fontWeights,
    );
  }

  Widget _buildGeistMonoWeights(BuildContext context) {
    return _WeightRamp(
      familyLabel: 'Geist Mono',
      style: MyTypography.geistMonoStyle,
      sample: 'final glyphWidth = columns[13] ?? 0;',
      weights: _fontWeights,
    );
  }

  Widget _buildAppliedExamples(BuildContext context) {
    return _ResponsivePair(
      first: const _ProductTypeExample(),
      second: const _TechnicalTypeExample(),
    );
  }

  Widget _buildUsageSnippet(BuildContext context) {
    const code = '''
Text(
  'Interface copy',
  style: MyTypography.geistSansStyle,
);

Text(
  'final value = 42;',
  style: MyTypography.geistMonoStyle,
);

// APIs that only accept a family string:
TextStyle(fontFamily: MyTypography.kDefaultFontFamily);
TextStyle(fontFamily: MyTypography.kDefaultFontFamilyMono);
''';

    final colors = context.colorScheme;
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Preferred package API'),
          const Gap(12),
          Text(
            code.trimRight(),
            style: MyTypography.geistMonoStyle.copyWith(
              color: colors.foreground,
              fontSize: 13,
              height: 20 / 13,
            ),
          ),
          const SizedBox(height: 18),
          _InfoLine(
            label: 'Sans family',
            value: MyTypography.kDefaultFontFamily,
          ),
          const SizedBox(height: 8),
          _InfoLine(
            label: 'Mono family',
            value: MyTypography.kDefaultFontFamilyMono,
          ),
        ],
      ),
    );
  }
}

class _FontWeightSpec {
  const _FontWeightSpec(this.value, this.weight, this.name);

  final String value;
  final FontWeight weight;
  final String name;
}

class _ResponsivePair extends StatelessWidget {
  const _ResponsivePair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [first, const SizedBox(height: 12), second],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 12),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _SpecimenPanel extends StatelessWidget {
  const _SpecimenPanel({
    required this.label,
    required this.title,
    required this.body,
    required this.sample,
    required this.style,
  });

  final String label;
  final String title;
  final String body;
  final String sample;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label),
          const Gap(12),
          Text(
            title,
            style: style.copyWith(
              color: colors.foreground,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 36 / 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: style.copyWith(
              color: colors.mutedForeground,
              fontSize: 14,
              height: 22 / 14,
            ),
          ),
          const SizedBox(height: 24),
          Divider(height: 1, color: colors.border),
          const SizedBox(height: 18),
          Text(
            sample,
            style: style.copyWith(
              color: colors.foreground,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 28 / 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightRamp extends StatelessWidget {
  const _WeightRamp({
    required this.familyLabel,
    required this.style,
    required this.sample,
    required this.weights,
  });

  final String familyLabel;
  final TextStyle style;
  final String sample;
  final List<_FontWeightSpec> weights;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(familyLabel),
          const Gap(12),
          Text(
            'Weights 100-900 are bundled in common_tools.',
            style: MyTypography.geistSansStyle.copyWith(
              color: colors.mutedForeground,
              fontSize: 13,
              height: 20 / 13,
            ),
          ),
          const SizedBox(height: 14),
          for (final weight in weights) ...[
            _WeightRow(spec: weight, style: style, sample: sample),
            if (weight != weights.last)
              Divider(height: 18, color: colors.border),
          ],
        ],
      ),
    );
  }
}

class _WeightRow extends StatelessWidget {
  const _WeightRow({
    required this.spec,
    required this.style,
    required this.sample,
  });

  final _FontWeightSpec spec;
  final TextStyle style;
  final String sample;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final meta = Text(
          '${spec.value} / ${spec.name}',
          style: MyTypography.geistMonoStyle.copyWith(
            color: colors.mutedForeground,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        );
        final specimen = Text(
          sample,
          style: style.copyWith(
            color: colors.foreground,
            fontSize: 18,
            fontWeight: spec.weight,
            height: 26 / 18,
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [meta, const SizedBox(height: 6), specimen],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 116, child: meta),
            Expanded(child: specimen),
          ],
        );
      },
    );
  }
}

class _ProductTypeExample extends StatelessWidget {
  const _ProductTypeExample();

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final style = MyTypography.geistSansStyle;

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Interface scale'),
          const Gap(12),
          Text(
            'Review deployment',
            style: style.copyWith(
              color: colors.foreground,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Production is ready. Confirm the domain, preview URL, and cache '
            'settings before publishing.',
            style: style.copyWith(
              color: colors.mutedForeground,
              fontSize: 14,
              height: 22 / 14,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Pill(label: 'Ready', weight: FontWeight.w600),
              _Pill(label: 'Preview checked', weight: FontWeight.w500),
              _Pill(label: 'Cache warm', weight: FontWeight.w500),
            ],
          ),
        ],
      ),
    );
  }
}

class _TechnicalTypeExample extends StatelessWidget {
  const _TechnicalTypeExample();

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final style = MyTypography.geistMonoStyle;

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Code and data'),
          const Gap(12),
          Text(
            'GET /v1/releases',
            style: style.copyWith(
              color: colors.foreground,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 28 / 20,
            ),
          ),
          const Gap(12),
          _DataRow(label: 'status', value: '200 OK'),
          _DataRow(label: 'latency', value: '42 ms'),
          _DataRow(label: 'commit', value: '7e42eff'),
          const Gap(12),
          Text(
            'const font = MyTypography.geistMonoStyle;',
            style: style.copyWith(
              color: colors.mutedForeground,
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: MyTypography.geistMonoStyle.copyWith(
        color: context.colorScheme.mutedForeground,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.weight});

  final String label;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.secondary,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: MyTypography.geistSansStyle.copyWith(
          color: colors.secondaryForeground,
          fontSize: 12,
          fontWeight: weight,
          height: 16 / 12,
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final style = MyTypography.geistMonoStyle.copyWith(
      fontSize: 13,
      height: 20 / 13,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: style.copyWith(color: colors.mutedForeground),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: style.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final labelWidget = Text(
          label,
          style: MyTypography.geistSansStyle.copyWith(
            color: colors.mutedForeground,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 18 / 13,
          ),
        );
        final valueWidget = Text(
          value,
          style: MyTypography.geistMonoStyle.copyWith(
            color: colors.foreground,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 18 / 13,
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [labelWidget, const SizedBox(height: 4), valueWidget],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 96, child: labelWidget),
            Expanded(child: valueWidget),
          ],
        );
      },
    );
  }
}
