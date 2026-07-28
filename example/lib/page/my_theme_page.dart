import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

/// Theme color example page.
class MyThemeColorsPage extends StatefulWidget {
  const MyThemeColorsPage({super.key});

  @override
  State<MyThemeColorsPage> createState() => _MyThemeColorsPageState();
}

class _MyThemeColorsPageState extends State<MyThemeColorsPage> {
  static const _shadeStops = <int>[
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    950,
  ];

  static const _palettes = <_PaletteSpec>[
    _PaletteSpec('Zinc', MyColors.zinc),
    _PaletteSpec('Neutral', MyColors.neutral),
    _PaletteSpec('Stone', MyColors.stone),
    _PaletteSpec('Mauve', MyColors.mauve),
    _PaletteSpec('Olive', MyColors.olive),
    _PaletteSpec('Mist', MyColors.mist),
    _PaletteSpec('Taupe', MyColors.taupe),
    _PaletteSpec('Red', MyColors.red),
    _PaletteSpec('Orange', MyColors.orange),
    _PaletteSpec('Amber', MyColors.amber),
    _PaletteSpec('Yellow', MyColors.yellow),
    _PaletteSpec('Lime', MyColors.lime),
    _PaletteSpec('Green', MyColors.green),
    _PaletteSpec('Emerald', MyColors.emerald),
    _PaletteSpec('Teal', MyColors.teal),
    _PaletteSpec('Cyan', MyColors.cyan),
    _PaletteSpec('Sky', MyColors.sky),
    _PaletteSpec('Blue', MyColors.blue),
    _PaletteSpec('Indigo', MyColors.indigo),
    _PaletteSpec('Violet', MyColors.violet),
    _PaletteSpec('Purple', MyColors.purple),
    _PaletteSpec('Fuchsia', MyColors.fuchsia),
    _PaletteSpec('Pink', MyColors.pink),
    _PaletteSpec('Rose', MyColors.rose),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Color tokens, semantic roles, and theme schemes used by this app.',
      exampleCodeGroup: 'theme',
      children: [
        ExampleModule(
          title: 'MyColors palettes',
          children: [
            ExampleItem(
              desc: 'Raw palette tokens with shades 50 through 950.',
              builder: _buildPaletteGrid,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Current semantic scheme',
          children: [
            ExampleItem(
              desc:
                  'The active context.colorScheme roles resolved for this page.',
              builder: _buildSemanticRoles,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ExampleItem(
              desc: 'Chart colors from the active semantic scheme.',
              builder: _buildCurrentChartStrip,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: 'Built-in color schemes',
          children: [
            ExampleItem(
              desc:
                  'Generated shadcn-style schemes composed from a base color and an accent color.',
              builder: _buildBaseAccentSchemes,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ExampleItem(
              desc: 'Every package color scheme in light and dark mode.',
              builder: _buildBuiltInSchemes,
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBaseAccentSchemes(BuildContext context) {
    final generatedExamples = <_GeneratedSchemeSpec>[
      const _GeneratedSchemeSpec(MyBaseColor.mauve, MyAccentColor.blue),
      const _GeneratedSchemeSpec(MyBaseColor.taupe, MyAccentColor.brown),
      const _GeneratedSchemeSpec(MyBaseColor.mist, MyAccentColor.gold),
      const _GeneratedSchemeSpec(MyBaseColor.olive, MyAccentColor.lime),
      const _GeneratedSchemeSpec(MyBaseColor.zinc, MyAccentColor.red),
      const _GeneratedSchemeSpec(MyBaseColor.stone, MyAccentColor.violet),
    ];

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Base colors'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final base in MyColorScheme.baseColors)
                _SchemeCard(
                  title: '${_enumTitle(base)} base',
                  light: MyColorScheme.fromParts(
                    base: base,
                    brightness: Brightness.light,
                  ),
                  dark: MyColorScheme.fromParts(
                    base: base,
                    brightness: Brightness.dark,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),
          const _SectionLabel('Accent colors on neutral'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final accent in MyThemePicker.explicitAccentColors)
                _AccentChip(accent: accent),
            ],
          ),
          const SizedBox(height: 22),
          const _SectionLabel('Generated examples'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final spec in generatedExamples)
                _SchemeCard(
                  title:
                      '${_enumTitle(spec.base)} + ${_enumTitle(spec.accent)}',
                  light: MyColorScheme.fromParts(
                    base: spec.base,
                    accent: spec.accent,
                    brightness: Brightness.light,
                  ),
                  dark: MyColorScheme.fromParts(
                    base: spec.base,
                    accent: spec.accent,
                    brightness: Brightness.dark,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteGrid(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('MyColors.values'),
          const SizedBox(height: 14),
          for (final palette in _palettes) ...[
            _PaletteRow(spec: palette, shadeStops: _shadeStops),
            if (palette != _palettes.last)
              Divider(height: 22, color: context.colorScheme.border),
          ],
        ],
      ),
    );
  }

  Widget _buildSemanticRoles(BuildContext context) {
    final roleNames = <String>[
      'background',
      'foreground',
      'card',
      'cardForeground',
      'popover',
      'popoverForeground',
      'primary',
      'primaryForeground',
      'secondary',
      'secondaryForeground',
      'muted',
      'mutedForeground',
      'accent',
      'accentForeground',
      'destructive',
      'destructiveForeground',
      'warning',
      'warningForeground',
      'success',
      'successForeground',
      'border',
      'input',
      'ring',
      'selection',
    ];
    final colors = context.colorScheme.toColorMap();

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('context.colorScheme'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final name in roleNames)
                _RoleTile(name: name, color: colors[name]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentChartStrip(BuildContext context) {
    final colors = context.colorScheme;
    return _Surface(
      child: _ChartStrip(
        title: 'Active chart tokens',
        colors: [
          colors.chart1,
          colors.chart2,
          colors.chart3,
          colors.chart4,
          colors.chart5,
        ],
      ),
    );
  }

  Widget _buildBuiltInSchemes(BuildContext context) {
    return _Surface(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final name in MyColorScheme.schemes)
            _SchemeCard(
              title: _titleCase(name),
              light: MyColorScheme.fromName(name, brightness: Brightness.light),
              dark: MyColorScheme.fromName(name, brightness: Brightness.dark),
            ),
        ],
      ),
    );
  }
}

class _PaletteSpec {
  const _PaletteSpec(this.name, this.palette);

  final String name;
  final MaterialColor palette;
}

class _GeneratedSchemeSpec {
  const _GeneratedSchemeSpec(this.base, this.accent);

  final MyBaseColor base;
  final MyAccentColor accent;
}

class _AccentChip extends StatelessWidget {
  const _AccentChip({required this.accent});

  final MyAccentColor accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final scheme = MyColorScheme.fromParts(
      base: MyBaseColor.neutral,
      accent: accent,
      brightness: colors.brightness,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.border),
        borderRadius: MyBorderRadius.medium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Dot(color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            _enumTitle(accent),
            style: TextStyle(
              color: colors.foreground,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteRow extends StatelessWidget {
  const _PaletteRow({required this.spec, required this.shadeStops});

  final _PaletteSpec spec;
  final List<int> shadeStops;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: compact ? double.infinity : 96,
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
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final shade in shadeStops)
                  _ShadeChip(shade: shade, color: spec.palette[shade]!),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ShadeChip extends StatelessWidget {
  const _ShadeChip({required this.shade, required this.color});

  final int shade;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textColor = _readableTextColor(color);
    return Container(
      width: 58,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: context.colorScheme.border),
        borderRadius: MyBorderRadius.medium,
      ),
      child: Text(
        '$shade',
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 14 / 11,
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return SizedBox(
      width: 178,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.background,
          border: Border.all(color: colors.border),
          borderRadius: MyBorderRadius.large,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: colors.border),
                borderRadius: MyBorderRadius.medium,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.foreground,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 18 / 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _hex(color),
              style: TextStyle(
                color: colors.mutedForeground,
                fontSize: 12,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  const _SchemeCard({
    required this.title,
    required this.light,
    required this.dark,
  });

  final String title;
  final MyColorScheme light;
  final MyColorScheme dark;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return SizedBox(
      width: 252,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.background,
          border: Border.all(color: colors.border),
          borderRadius: MyBorderRadius.large,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.foreground,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 20 / 14,
              ),
            ),
            const SizedBox(height: 12),
            _SchemePreview(label: 'Light', scheme: light),
            const SizedBox(height: 10),
            _SchemePreview(label: 'Dark', scheme: dark),
            const SizedBox(height: 12),
            _ChartStrip(
              title: 'Charts',
              colors: [
                light.chart1,
                light.chart2,
                light.chart3,
                light.chart4,
                light.chart5,
              ],
              compact: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SchemePreview extends StatelessWidget {
  const _SchemePreview({required this.label, required this.scheme});

  final String label;
  final MyColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.background,
        border: Border.all(color: scheme.border),
        borderRadius: MyBorderRadius.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: scheme.foreground,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 16 / 12,
                  ),
                ),
              ),
              _Dot(color: scheme.ring),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SchemePill(
                  label: 'Primary',
                  background: scheme.primary,
                  foreground: scheme.primaryForeground,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SchemePill(
                  label: 'Secondary',
                  background: scheme.secondary,
                  foreground: scheme.secondaryForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SchemePill extends StatelessWidget {
  const _SchemePill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: MyBorderRadius.round,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 14 / 11,
        ),
      ),
    );
  }
}

class _ChartStrip extends StatelessWidget {
  const _ChartStrip({
    required this.title,
    required this.colors,
    this.compact = false,
  });

  final String title;
  final List<Color> colors;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textColor = context.colorScheme.mutedForeground;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            height: 16 / 11,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: MyBorderRadius.round,
          child: Row(
            children: [
              for (final color in colors)
                Expanded(
                  child: Container(height: compact ? 18 : 34, color: color),
                ),
            ],
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              for (var index = 0; index < colors.length; index++)
                Text(
                  'chart${index + 1} ${_hex(colors[index])}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    height: 16 / 12,
                  ),
                ),
            ],
          ),
        ],
      ],
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
      style: TextStyle(
        color: context.colorScheme.mutedForeground,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 16 / 11,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

String _hex(Color color) {
  final value = color
      .toARGB32()
      .toRadixString(16)
      .padLeft(8, '0')
      .toUpperCase();
  return value.startsWith('FF') ? '#${value.substring(2)}' : '#$value';
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}

String _enumTitle(Enum value) {
  return _titleCase(value.name);
}

Color _readableTextColor(Color background) {
  return background.computeLuminance() > .48 ? Colors.black : Colors.white;
}
