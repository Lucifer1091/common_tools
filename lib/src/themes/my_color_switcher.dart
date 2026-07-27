import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../extensions/context/theme.dart';
import '../extensions/context/typography.dart';
import '../extensions/misc/color.dart';
import '../extensions/string/converters.dart';
import '../widgets/animations/animated_on_tap.dart';
import '../widgets/components/divider/my_divider.dart';
import '../widgets/packages/gap/src/widgets/gap.dart';
import './my_color_scheme.dart';
import './my_theme_switcher.dart';

class MyColorSwitcher extends StatelessWidget {
  const MyColorSwitcher({
    required this.selectedColor,
    required this.onChanged,
    required this.onClose,
    super.key,
    this.options,
  });

  final String selectedColor;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;
  final List<MyColorSwitcherOption>? options;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final selected = selectedColor.toLowerCase();
    final colorOptions = options ?? MyColorSwitcherOption.defaults;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.popover,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 386),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: Text(
                          'Color',
                          style: context.titleLarge.copyWith(
                            fontSize: 20,
                            color: colors.popoverForeground,
                          ),
                        ),
                      ),
                    ),
                    _CloseButton(onTap: onClose),
                  ],
                ),
                const Gap(20),
                const MyDivider(),
                const Gap(20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final option in colorOptions)
                      Builder(
                        builder: (context) {
                          final previewColor = option
                              .resolve(brightness: colors.brightness)
                              .primary;

                          return _ColorItem(
                            title: option.label,
                            swatchColor: previewColor,
                            borderGradientColors:
                                switch (context.colorScheme.brightness) {
                                  Brightness.light =>
                                    MyThemeSwitcher.lightBorderGradient(
                                      colors.primary,
                                    ),
                                  Brightness.dark =>
                                    MyThemeSwitcher.darkBorderGradient,
                                },
                            isSelected: selected == option.value.toLowerCase(),
                            onTap: () {
                              if (selected != option.value.toLowerCase()) {
                                onChanged(option.value);
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class MyColorSwitcherOption {
  const MyColorSwitcherOption({
    required this.value,
    required this.label,
    required this.schemeBuilder,
  });

  MyColorSwitcherOption.builtIn(String name)
    : this(
        value: name,
        label: name.capitalize ?? name,
        schemeBuilder: (brightness) {
          return MyColorScheme.fromName(name, brightness: brightness);
        },
      );

  final String value;
  final String label;
  final MyColorScheme Function(Brightness brightness) schemeBuilder;

  MyColorScheme resolve({required Brightness brightness}) {
    return schemeBuilder(brightness);
  }

  static final List<MyColorSwitcherOption> defaults =
      List<MyColorSwitcherOption>.unmodifiable([
        for (final scheme in MyColorScheme.schemes)
          MyColorSwitcherOption.builtIn(scheme),
      ]);
}

class _ColorItem extends StatefulWidget {
  const _ColorItem({
    required this.title,
    required this.swatchColor,
    required this.borderGradientColors,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final Color swatchColor;
  final List<Color> borderGradientColors;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ColorItem> createState() => _ColorItemState();
}

class _ColorItemState extends State<_ColorItem> with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _opacityController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    if (widget.isSelected) {
      unawaited(_rotationController.repeat());
      _opacityController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant _ColorItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        unawaited(_rotationController.repeat());
        unawaited(_opacityController.forward());
      } else {
        _rotationController.stop();
        unawaited(_opacityController.reverse());
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return AnimatedOnTap(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        foregroundPainter: _BorderPainter(
          colors: widget.borderGradientColors,
          rotation: _rotationController,
          opacity: _opacityController,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: ValueListenableBuilder(
              valueListenable: _opacityController,
              builder: (context, borderOpacity, _) {
                final textColor = Color.lerp(
                  colors.mutedForeground,
                  colors.secondaryForeground,
                  borderOpacity,
                )!;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.swatchColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.background.scaleAlpha(.55),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.swatchColor.scaleAlpha(
                              .5 * borderOpacity,
                            ),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const SizedBox.square(dimension: 16),
                    ),
                    const Gap(8),
                    Text(
                      widget.title,
                      style: context.titleMedium.copyWith(
                        color: textColor,
                        height: 1,
                      ),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter({
    required this.colors,
    required this.rotation,
    required this.opacity,
  }) : super(repaint: Listenable.merge([rotation, opacity]));

  final List<Color> colors;
  final Animation<double> rotation;
  final Animation<double> opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity.value == 0) {
      return;
    }

    final childRect = Offset.zero & size;
    final borderRect = Rect.fromLTRB(
      childRect.left - 4.5,
      childRect.top - 4.5,
      childRect.right + 4.5,
      childRect.bottom + 4.5,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(borderRect, const Radius.circular(22)),
      Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..shader = SweepGradient(
          colors: colors,
          transform: GradientRotation(math.pi * 2 * rotation.value),
        ).withOpacity(opacity.value).createShader(borderRect),
    );
  }

  @override
  bool shouldRepaint(covariant _BorderPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.rotation != rotation ||
        oldDelegate.opacity != opacity;
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return ClipOval(
      child: AnimatedOnTap(
        onTap: onTap,
        child: SizedBox.square(
          dimension: 32,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.destructive,
            ),
            child: Center(
              child: Icon(
                LucideIcons.x,
                size: 16,
                color: colors.destructiveForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
