import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../extensions/context/theme.dart';
import '../extensions/context/typography.dart';
import '../extensions/misc/color.dart';
import '../widgets/animations/animated_on_tap.dart';
import '../widgets/components/divider/my_divider.dart';
import '../widgets/packages/gap/src/widgets/gap.dart';

class MyThemeSwitcher extends StatelessWidget {
  const MyThemeSwitcher({
    required this.selectedMode,
    required this.onChanged,
    required this.onClose,
    super.key,
  });

  final ThemeMode selectedMode;

  final ValueChanged<ThemeMode> onChanged;

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

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
                          'Appearance',
                          style: context.titleLarge.copyWith(
                            fontSize: 20,
                            color: context.colorScheme.popoverForeground,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    _CloseButton(onTap: onClose),
                  ],
                ),
                const Gap(20),
                const MyDivider(),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    for (final mode in ThemeMode.values)
                      Flexible(
                        child: _Item(
                          icon: switch (mode) {
                            ThemeMode.system =>
                              LucideIcons.monitorSmartphone300,
                            ThemeMode.light => LucideIcons.sun300,
                            ThemeMode.dark => LucideIcons.moon300,
                          },
                          title: switch (mode) {
                            ThemeMode.system => 'System',
                            ThemeMode.light => 'Light',
                            ThemeMode.dark => 'Dark',
                          },
                          borderGradientColors: switch (mode) {
                            ThemeMode.system || ThemeMode.light =>
                              lightBorderGradient(colors.primary),
                            ThemeMode.dark => darkBorderGradient,
                          },
                          isSelected: mode == selectedMode,
                          onTap: () {
                            if (selectedMode != mode) {
                              onChanged(mode);
                            }
                          },
                        ),
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

  static List<Color> lightBorderGradient(Color primaryColor) => [
    primaryColor,
    primaryColor.lighten(.25),
    primaryColor,
  ];

  static const darkBorderGradient = [
    Color(0xFF797579),
    Color(0xFFFFFCFF),
    Color(0xFF797579),
  ];
}

class _Item extends StatefulWidget {
  const _Item({
    required this.icon,
    required this.title,
    required this.borderGradientColors,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final List<Color> borderGradientColors;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> with TickerProviderStateMixin {
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
  void didUpdateWidget(_Item oldWidget) {
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(20),
                ValueListenableBuilder(
                  valueListenable: _opacityController,
                  builder: (context, borderOpacity, _) {
                    final iconColor = Color.lerp(
                      colors.mutedForeground.scaleAlpha(0.5),
                      colors.secondaryForeground,
                      borderOpacity,
                    )!;

                    return Icon(widget.icon, size: 50, color: iconColor);
                  },
                ),
                const Gap(10),
                Text(
                  widget.title,
                  style: context.titleMedium.copyWith(
                    color: context.colorScheme.secondaryForeground,
                  ),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),
                const Gap(14),
              ],
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
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..shader = SweepGradient(
          colors: colors,
          transform: GradientRotation(math.pi * 2 * rotation.value),
        ).withOpacity(opacity.value).createShader(borderRect),
    );
  }

  @override
  bool shouldRepaint(_BorderPainter oldDelegate) {
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
