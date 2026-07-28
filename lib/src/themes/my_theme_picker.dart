import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../extensions/context/theme.dart';
import '../extensions/context/typography.dart';
import '../extensions/misc/color.dart';
import '../extensions/string/converters.dart';
import '../widgets/animations/animated_on_tap.dart';
import '../widgets/components/button/my_button.dart';
import '../widgets/components/dialog/my_dialog.dart';
import '../widgets/components/dialog/my_dialog_config.dart';
import '../widgets/components/dialog/my_dialog_widget.dart';
import '../widgets/components/divider/my_divider.dart';
import '../widgets/packages/gap/src/widgets/gap.dart';
import './my_color_scheme.dart';
import './my_theme.dart';

@immutable
class MyThemePickerValue {
  const MyThemePickerValue({
    required this.mode,
    required this.baseColor,
    this.accentColor,
  });

  final ThemeMode mode;
  final MyBaseColor baseColor;
  final MyAccentColor? accentColor;

  MyAccentColor get effectiveAccentColor {
    return accentColor ??
        MyAccentColor.values.firstWhere(
          (accent) => accent.name == baseColor.name,
        );
  }

  MyColorScheme colorScheme({Brightness brightness = Brightness.light}) {
    return MyColorScheme.fromParts(
      base: baseColor,
      accent: accentColor,
      brightness: brightness,
    );
  }

  MyThemePickerValue copyWith({
    ThemeMode? mode,
    MyBaseColor? baseColor,
    MyAccentColor? accentColor,
    bool clearAccentColor = false,
  }) {
    return MyThemePickerValue(
      mode: mode ?? this.mode,
      baseColor: baseColor ?? this.baseColor,
      accentColor: clearAccentColor ? null : accentColor ?? this.accentColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyThemePickerValue &&
        other.mode == mode &&
        other.baseColor == baseColor &&
        other.accentColor == accentColor;
  }

  @override
  int get hashCode => Object.hash(mode, baseColor, accentColor);

  @override
  String toString() {
    return 'MyThemePickerValue(mode: $mode, baseColor: $baseColor, '
        'accentColor: $accentColor)';
  }
}

class MyThemePicker extends StatelessWidget {
  const MyThemePicker({
    required this.selectedMode,
    required this.selectedBaseColor,
    required this.selectedAccentColor,
    required this.onModeChanged,
    required this.onBaseColorChanged,
    required this.onAccentColorChanged,
    super.key,
    this.onClose,
    this.padding = const EdgeInsets.all(24),
  });

  final ThemeMode selectedMode;
  final MyBaseColor selectedBaseColor;
  final MyAccentColor? selectedAccentColor;
  final ValueChanged<ThemeMode> onModeChanged;
  final ValueChanged<MyBaseColor> onBaseColorChanged;
  final ValueChanged<MyAccentColor?> onAccentColorChanged;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry padding;

  static Future<MyThemePickerValue?> showDialog({
    required BuildContext context,
    required MyThemePickerValue value,
    bool barrierDismissible = true,
  }) {
    final theme = context.theme;

    return MyDialog.show<MyThemePickerValue>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => MyTheme(
        data: theme,
        child: MyThemePickerDialog(value: value),
      ),
    );
  }

  static List<MyAccentColor> get explicitAccentColors {
    final baseNames = MyColorScheme.baseColors.map((base) => base.name).toSet();

    return List<MyAccentColor>.unmodifiable(
      MyColorScheme.accentColors.where(
        (accent) => !baseNames.contains(accent.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final previewBrightness = _previewBrightness(context, selectedMode);
    final previewScheme = MyColorScheme.fromParts(
      base: selectedBaseColor,
      accent: selectedAccentColor,
      brightness: previewBrightness,
    );

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Theme',
                  style: context.titleLarge.copyWith(
                    fontSize: 20,
                    color: colors.popoverForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onClose != null) _CloseButton(onTap: onClose!),
            ],
          ),
          const Gap(8),
          Text(
            'Choose how the app feels: mode, foundation, and accent.',
            style: context.bodyMedium.copyWith(color: colors.mutedForeground),
          ),
          const Gap(20),
          _ThemePreview(
            scheme: previewScheme,
            baseLabel: _enumLabel(selectedBaseColor),
            accentLabel: selectedAccentColor == null
                ? 'Same as base'
                : _enumLabel(selectedAccentColor!),
          ),
          const Gap(20),
          const MyDivider(),
          const Gap(20),
          _SectionTitle(title: 'Mode', caption: _modeCaption(selectedMode)),
          const Gap(12),
          _ModeSelector(selectedMode: selectedMode, onChanged: onModeChanged),
          const Gap(22),
          const _SectionTitle(
            title: 'Base color',
            caption: 'Restrained surfaces, text, borders, and focus rings.',
          ),
          const Gap(12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final base in MyColorScheme.baseColors)
                _ColorChoice(
                  key: ValueKey('my_theme_picker.base.${base.name}'),
                  label: _enumLabel(base),
                  color: MyColorScheme.fromParts(
                    base: base,
                    brightness: previewBrightness,
                  ).primary,
                  selected: selectedBaseColor == base,
                  semanticLabel: '${_enumLabel(base)} base color',
                  onTap: () {
                    if (selectedBaseColor != base) onBaseColorChanged(base);
                  },
                ),
            ],
          ),
          const Gap(22),
          const _SectionTitle(
            title: 'Accent color',
            caption: 'Primary actions, selection, and chart palette.',
          ),
          const Gap(12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ColorChoice(
                key: const ValueKey('my_theme_picker.accent.same_as_base'),
                label: 'Same as base',
                color: MyColorScheme.fromParts(
                  base: selectedBaseColor,
                  brightness: previewBrightness,
                ).primary,
                selected: selectedAccentColor == null,
                semanticLabel: 'Use ${_enumLabel(selectedBaseColor)} as accent',
                onTap: () => onAccentColorChanged(null),
              ),
              for (final accent in explicitAccentColors)
                _ColorChoice(
                  key: ValueKey('my_theme_picker.accent.${accent.name}'),
                  label: _enumLabel(accent),
                  color: MyColorScheme.fromName(
                    accent.name,
                    brightness: previewBrightness,
                  ).primary,
                  selected: selectedAccentColor == accent,
                  semanticLabel: '${_enumLabel(accent)} accent color',
                  onTap: () {
                    if (selectedAccentColor != accent) {
                      onAccentColorChanged(accent);
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyThemePickerDialog extends StatefulWidget {
  const MyThemePickerDialog({required this.value, super.key});

  final MyThemePickerValue value;

  @override
  State<MyThemePickerDialog> createState() => _MyThemePickerDialogState();
}

class _MyThemePickerDialogState extends State<MyThemePickerDialog> {
  late MyThemePickerValue _value = widget.value;

  @override
  Widget build(BuildContext context) {
    return MyDialogScaffold(
      width: 560,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height - 96,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: MyThemePicker(
                  selectedMode: _value.mode,
                  selectedBaseColor: _value.baseColor,
                  selectedAccentColor: _value.accentColor,
                  onModeChanged: (mode) {
                    setState(() => _value = _value.copyWith(mode: mode));
                  },
                  onBaseColorChanged: (baseColor) {
                    setState(
                      () => _value = _value.copyWith(baseColor: baseColor),
                    );
                  },
                  onAccentColorChanged: (accentColor) {
                    setState(
                      () => _value = _value.copyWith(
                        accentColor: accentColor,
                        clearAccentColor: accentColor == null,
                      ),
                    );
                  },
                  onClose: () => Navigator.pop(context),
                ),
              ),
            ),
            const Gap(8),
            MyDialogShrinkButtons(
              leftBtn: MyDialogButtonOptions(
                title: 'Cancel',
                type: MyButtonType.outline,
                action: () => Navigator.pop(context),
              ),
              rightBtn: MyDialogButtonOptions(
                title: 'Apply',
                titleColor: context.colorScheme.primaryForeground,
                action: () => Navigator.pop(context, _value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.selectedMode, required this.onChanged});

  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (final mode in ThemeMode.values)
              Expanded(
                child: _ModeOption(
                  mode: mode,
                  selected: mode == selectedMode,
                  onTap: () {
                    if (selectedMode != mode) onChanged(mode);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final ThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final foreground = selected
        ? colors.primaryForeground
        : colors.mutedForeground;
    final background = selected ? colors.primary : Colors.transparent;

    return Semantics(
      button: true,
      selected: selected,
      label: '${_modeLabel(mode)} theme mode',
      child: AnimatedOnTap(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.primary.scaleAlpha(.22),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_modeIcon(mode), size: 17, color: foreground),
              const Gap(8),
              Flexible(
                child: Text(
                  _modeLabel(mode),
                  style: context.titleSmall.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({
    required this.label,
    required this.color,
    required this.selected,
    required this.semanticLabel,
    required this.onTap,
    super.key,
  });

  final String label;
  final Color color;
  final bool selected;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final borderColor = selected ? colors.ring : colors.border;
    final textColor = selected ? colors.foreground : colors.mutedForeground;

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: AnimatedOnTap(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colors.accent : colors.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background.scaleAlpha(.6)),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: color.scaleAlpha(.35),
                            blurRadius: 14,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: SizedBox.square(
                  dimension: 18,
                  child: selected
                      ? Icon(
                          LucideIcons.check,
                          size: 13,
                          color: color.isDark
                              ? Colors.white
                              : const Color(0xff09090b),
                        )
                      : null,
                ),
              ),
              const Gap(8),
              Text(
                label,
                style: context.titleSmall.copyWith(
                  color: textColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({
    required this.scheme,
    required this.baseLabel,
    required this.accentLabel,
  });

  final MyColorScheme scheme;
  final String baseLabel;
  final String accentLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$baseLabel foundation',
                    style: context.titleMedium.copyWith(
                      color: scheme.foreground,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    child: Text(
                      accentLabel,
                      style: context.labelMedium.copyWith(
                        color: scheme.primaryForeground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 96,
                            height: 9,
                            decoration: BoxDecoration(
                              color: scheme.cardForeground,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const Gap(8),
                          Container(
                            width: 146,
                            height: 8,
                            decoration: BoxDecoration(
                              color: scheme.mutedForeground.scaleAlpha(.45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final color in [
                          scheme.chart1,
                          scheme.chart2,
                          scheme.chart3,
                          scheme.chart4,
                          scheme.chart5,
                        ])
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: const SizedBox.square(dimension: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.caption});

  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.titleMedium.copyWith(
            color: colors.popoverForeground,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          caption,
          style: context.bodySmall.copyWith(color: colors.mutedForeground),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Semantics(
      button: true,
      label: 'Close theme picker',
      child: AnimatedOnTap(
        onTap: onTap,
        child: SizedBox.square(
          dimension: 34,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: colors.border),
            ),
            child: Icon(
              LucideIcons.x,
              size: 17,
              color: colors.secondaryForeground,
            ),
          ),
        ),
      ),
    );
  }
}

Brightness _previewBrightness(BuildContext context, ThemeMode mode) {
  return switch (mode) {
    ThemeMode.dark => Brightness.dark,
    ThemeMode.light => Brightness.light,
    ThemeMode.system => context.colorScheme.brightness,
  };
}

String _enumLabel(Enum value) => value.name.titleCase ?? value.name;

String _modeLabel(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };
}

String _modeCaption(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => 'Following your device appearance.',
    ThemeMode.light => 'Using the light theme preview.',
    ThemeMode.dark => 'Using the dark theme preview.',
  };
}

IconData _modeIcon(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => LucideIcons.monitorSmartphone,
    ThemeMode.light => LucideIcons.sun,
    ThemeMode.dark => LucideIcons.moon,
  };
}
