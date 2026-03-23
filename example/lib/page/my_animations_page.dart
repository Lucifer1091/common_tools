import 'package:common_tools/index.dart';
import 'package:example/base/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyAnimationsPage extends StatefulWidget {
  const MyAnimationsPage({super.key});

  @override
  State<MyAnimationsPage> createState() => _MyAnimationsPageState();
}

class _MyAnimationsPageState extends State<MyAnimationsPage> {
  static const List<_RouteAnimationOption> _routeOptions = [
    _RouteAnimationOption(label: 'Fade', animation: PageRouteAnimation.Fade),
    _RouteAnimationOption(label: 'Scale', animation: PageRouteAnimation.Scale),
    _RouteAnimationOption(
      label: 'Rotate',
      animation: PageRouteAnimation.Rotate,
    ),
    _RouteAnimationOption(label: 'Slide', animation: PageRouteAnimation.Slide),
    _RouteAnimationOption(
      label: 'Bottom Top',
      animation: PageRouteAnimation.SlideBottomTop,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'animations',
      desc: 'Animations for widgets, transition and user interaction.',
      children: [
        ExampleModule(
          title: 'Entry & Reveal',
          children: [
            ExampleItem(
              desc: 'Animated Fade Scale Transition',
              builder: _buildFadeScaleDemo,
              center: false,
            ),
            ExampleItem(
              desc: 'Animated Bounce',
              builder: _buildBounceDemo,
              center: false,
            ),
            ExampleItem(
              desc: 'Animated Fade Slide',
              builder: _buildFadeSlideDemo,
              center: false,
            ),
          ],
        ),
        ExampleModule(
          title: 'Builders & Utilities',
          children: [
            ExampleItem(
              desc: 'Animated Value Builder',
              builder: _buildAnimatedValueDemo,
              center: false,
            ),
            ExampleItem(
              desc: 'Repeated Animation Builder',
              builder: _buildRepeatedAnimationDemo,
            ),
          ],
        ),
        ExampleModule(
          title: 'Text Animations',
          children: [
            ExampleItem(
              desc: 'Animated Typewriter',
              builder: _buildAnimatedTextDemo,
              center: false,
            ),
            ExampleItem(
              desc: 'Animated Text Reveal',
              builder: _buildAnimatedTextRevealDemo,
              center: false,
            ),
          ],
        ),
        ExampleModule(
          title: 'Effects & Feedback',
          children: [
            ExampleItem(desc: 'Animated Ripple', builder: _buildRippleDemo),
            ExampleItem(desc: 'Animated Blur', builder: _buildAnimatedBlur),
            ExampleItem(desc: 'Animated Hover', builder: _buildHoverDemo),
            ExampleItem(desc: 'Animated Shake', builder: _buildShakeDemo),
            ExampleItem(desc: 'Animated OnTap', builder: _buildOnTapScalerDemo),
          ],
        ),
        ExampleModule(
          title: 'Routes',
          children: [
            ExampleItem(
              desc: 'Page Route Animation',
              builder: _buildRouteAnimationDemo,
              center: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedBlur(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          MyImage(
            height: 500,
            width: double.maxFinite,
            source: 'https://i.ibb.co/T1Fz7gL/big-cat.jpg',
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  Expanded(child: _BlurredCard(blurAmount: 8)),
                  SizedBox(height: 20),
                  Expanded(child: _BlurredCard(blurAmount: 40)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFadeScaleDemo(BuildContext context) {
    return const _FadeScaleDemo();
  }

  Widget _buildBounceDemo(BuildContext context) {
    return const _BounceDemo();
  }

  Widget _buildRippleDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RippleWave(
        color: context.colorScheme.primary,
        child: MyAvatar(type: MyAvatarType.initials, initials: 'AA'),
      ).sizedBox(height: 200, width: 200),
    );
  }

  Widget _buildAnimatedValueDemo(BuildContext context) {
    return const _AnimatedValueDemo();
  }

  Widget _buildRepeatedAnimationDemo(BuildContext context) {
    return const _RepeatedAnimationDemo();
  }

  Widget _buildFadeSlideDemo(BuildContext context) {
    return const _FadeSlideDemo();
  }

  Widget _buildAnimatedTextDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        child: DefaultTextStyle(
          style: context.titleMedium.copyWith(
            color: context.colorScheme.secondaryForeground,
            fontWeight: FontWeight.w600,
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            pause: Duration(milliseconds: 650),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
            texts: [
              AnimatedTypewriter('Syncing animation tokens...'),
              AnimatedTypewriter('Preparing mock route previews...'),
              AnimatedTypewriter('Animations now live in Base section.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextRevealDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        child: DefaultTextStyle(
          style: context.titleMedium.copyWith(
            color: context.colorScheme.secondaryForeground,
            fontWeight: FontWeight.w700,
            fontFamily: MyTypography.kDefaultFontFamilyMono,
            letterSpacing: 0.5,
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            pause: const Duration(milliseconds: 800),
            texts: [
              AnimatedTextReveal(
                'SECURING CONNECTION',
                duration: const Duration(milliseconds: 1400),
                characters: '01',
              ),
              AnimatedTextReveal(
                'DEPLOYMENT READY',
                duration: const Duration(milliseconds: 1200),
                characters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
              ),
              AnimatedTextReveal(
                'COMMON TOOLS ONLINE',
                duration: const Duration(milliseconds: 1300),
                characters: '#%&@!?ABCDEFGHIJKLMNOPQRSTUVWXYZ',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShakeDemo(BuildContext context) {
    return const _ShakeDemo();
  }

  Widget _buildHoverDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 16,
        children: [
          SizedBox(
            height: 160,
            child: AnimatedHover(
              shadow: MyBoxShadows.md.first,
              builder: (context, hovering) {
                return Container(
                  color: context.colorScheme.secondary,
                  child: Center(child: FlutterLogo(size: 100)),
                );
              },
            ),
          ).expanded(),
          SizedBox(
            height: 160,
            child: AnimatedHover(
              shadow: MyBoxShadows.md.first,
              depth: 10,
              depthColor: Colors.red,
              builder: (context, hovering) {
                return Container(
                  color: context.colorScheme.secondary,
                  child: Center(child: FlutterLogo(size: 100)),
                );
              },
            ),
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildOnTapScalerDemo(BuildContext context) {
    return const _OnTapScalerDemo();
  }

  Widget _buildRouteAnimationDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final option in _routeOptions)
            MyButton(
              text: option.label,
              type: MyButtonType.outline,
              onTap: () {
                Navigator.of(context).push(
                  MyPageRoute.build<void>(
                    _RoutePreviewPage(option: option),
                    option.animation,
                    const Duration(milliseconds: 360),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FadeScaleDemo extends StatefulWidget {
  const _FadeScaleDemo();

  @override
  State<_FadeScaleDemo> createState() => _FadeScaleDemoState();
}

class _FadeScaleDemoState extends State<_FadeScaleDemo> {
  int _fadeScaleSeed = 0;

  final items = [
    _MockInsightCard(
      title: 'Motion Tokens',
      subtitle: 'Durations tuned for cards, sheets, and overlays.',
      icon: LucideIcons.bubbles,
    ),
    _MockInsightCard(
      title: 'Touch Feedback',
      subtitle: 'Tap states stay snappy without overwhelming the layout.',
      icon: LucideIcons.monitorSmartphone,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.mapIndexed((index, item) {
              return SizedBox(
                width: 200,
                child: AnimatedFadeScale(
                  key: ValueKey('fade-card-$index-$_fadeScaleSeed'),
                  delay: Duration(milliseconds: 120 * index),
                  child: _FeatureCard(card: item),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          MyButton(
            text: 'Replay Fade Scale',
            type: MyButtonType.outline,
            onTap: () {
              setState(() {
                _fadeScaleSeed++;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _BounceDemo extends StatefulWidget {
  const _BounceDemo();

  @override
  State<_BounceDemo> createState() => _BounceDemoState();
}

class _BounceDemoState extends State<_BounceDemo> {
  int _bounceSeed = 0;

  final items = [
    _MockInsightCard(
      title: 'Route Transitions',
      subtitle: 'Preview page motion with focused mock content.',
      icon: LucideIcons.route,
    ),
    _MockInsightCard(
      title: 'Haptic Effects',
      subtitle: 'Subtle vibrations calibrated for physical confirmation.',
      icon: LucideIcons.vibrate,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.mapIndexed((index, item) {
              return SizedBox(
                width: 200,
                child: AnimatedBounce(
                  key: ValueKey('bounce-$index-$_bounceSeed'),
                  child: _FeatureCard(card: item),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          MyButton(
            text: 'Replay Bounce',
            type: MyButtonType.outline,
            onTap: () {
              setState(() {
                _bounceSeed++;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _AnimatedValueDemo extends StatefulWidget {
  const _AnimatedValueDemo();

  @override
  State<_AnimatedValueDemo> createState() => _AnimatedValueDemoState();
}

class _AnimatedValueDemoState extends State<_AnimatedValueDemo> {
  int _metricIndex = 1;

  final List<_MockMetric> _metrics = [
    _MockMetric(label: 'Low', value: 28, color: MyColors.red),
    _MockMetric(label: 'Medium', value: 64, color: MyColors.yellow),
    _MockMetric(label: 'High', value: 92, color: MyColors.green),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedMetric = _metrics[_metricIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SurfaceCard(
            child: AnimatedValueBuilder<double>(
              initialValue: _metrics.first.value.toDouble(),
              value: selectedMetric.value.toDouble(),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                final progress = value / 100;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confidence score',
                      style: context.textTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${value.toStringAsFixed(0)}%',
                      style: context.textTheme.headlineMedium.copyWith(
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 12,
                        value: progress,
                        color: selectedMetric.color,
                        backgroundColor: selectedMetric.color.withValues(
                          alpha: 0.18,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          MyRadioGroup(
            selectId: 'index:$_metricIndex',
            cardMode: true,
            direction: Axis.horizontal,
            onRadioGroupChange: (selectedId) {
              var index = selectedId?.split(':').last.toInt() ?? 0;
              setState(() {
                _metricIndex = index;
              });
            },
            rowCount: 3,
            margin: EdgeInsets.zero,
            directionalTdRadios: [
              for (var index = 0; index < _metrics.length; index++)
                MyRadio(
                  id: 'index:$index',
                  title: '${_metrics[index].label} ${_metrics[index].value}%',
                  cardMode: true,
                  backgroundColor: context.colorScheme.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RepeatedAnimationDemo extends StatefulWidget {
  const _RepeatedAnimationDemo();

  @override
  State<_RepeatedAnimationDemo> createState() => _RepeatedAnimationDemoState();
}

class _RepeatedAnimationDemoState extends State<_RepeatedAnimationDemo> {
  bool _play = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _SurfaceCard(
            child: SizedBox(
              width: double.infinity,
              height: 140,
              child: ClipRect(
                child: Center(
                  child: RepeatedAnimationBuilder<Offset>(
                    play: _play,
                    start: const Offset(-100, 0),
                    end: const Offset(100, 0),
                    duration: const Duration(seconds: 1),
                    reverseDuration: const Duration(seconds: 5),
                    curve: Curves.linear,
                    reverseCurve: Curves.easeInOutCubic,
                    mode: RepeatMode.pingPong,
                    child: const SizedBox(
                      width: 100,
                      height: 100,
                      child: ColoredBox(color: Colors.red),
                    ),
                    builder: (context, value, child) {
                      return Transform.translate(offset: value, child: child);
                    },
                  ),
                ),
              ),
            ),
          ),
          const Gap(24),
          MyButton(
            text: _play ? 'Stop' : 'Play',
            type: MyButtonType.outline,
            onTap: () {
              setState(() {
                _play = !_play;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _FadeSlideDemo extends StatefulWidget {
  const _FadeSlideDemo();

  @override
  State<_FadeSlideDemo> createState() => _FadeSlideDemoState();
}

class _FadeSlideDemoState extends State<_FadeSlideDemo> {
  int _storyIndex = 0;

  final items = [
    _MockInsightCard(
      title: 'Route Transitions',
      subtitle: 'Preview page motion with focused mock content.',
      icon: LucideIcons.route,
    ),
    _MockInsightCard(
      title: 'Haptic Effects',
      subtitle: 'Subtle vibrations calibrated for physical confirmation.',
      icon: LucideIcons.vibrate,
    ),
    _MockInsightCard(
      title: 'Motion Tokens',
      subtitle: 'Durations tuned for cards, sheets, and overlays.',
      icon: LucideIcons.bubbles,
    ),
    _MockInsightCard(
      title: 'Touch Feedback',
      subtitle: 'Tap states stay snappy without overwhelming the layout.',
      icon: LucideIcons.monitorSmartphone,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360,
            child: AnimatedFadeSlide(
              transitionKey: ValueKey(_storyIndex),
              child: _FeatureCard(card: items[_storyIndex]),
            ),
          ),
          const SizedBox(height: 16),
          MyButton(
            text: 'Switch Card',
            type: MyButtonType.outline,
            onTap: () {
              setState(() {
                _storyIndex = CommonUtils.randomInt(3);
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ShakeDemo extends StatefulWidget {
  const _ShakeDemo();

  @override
  State<_ShakeDemo> createState() => _ShakeDemoState();
}

class _ShakeDemoState extends State<_ShakeDemo> {
  bool _isShaking = true;

  final List<_MockAppIcon> _shakeIcons = [
    _MockAppIcon(
      title: 'Camera',
      icon: Icons.camera_alt_rounded,
      color: MyColors.blue,
    ),
    _MockAppIcon(
      title: 'Notes',
      icon: Icons.sticky_note_2_rounded,
      color: MyColors.warning,
    ),
    _MockAppIcon(
      title: 'Music',
      icon: Icons.music_note_rounded,
      color: MyColors.error,
    ),
    _MockAppIcon(
      title: 'Maps',
      icon: Icons.map_rounded,
      color: MyColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _shakeIcons.mapIndexed((index, item) {
              return AnimatedShake(
                enabled: _isShaking,
                delay: Duration(milliseconds: index * 70),
                child: _ShakeDemoIcon(item: item, showRemoveBadge: _isShaking),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          MyButton(
            text: _isShaking ? 'Stop Shake' : 'Start Shake',
            type: MyButtonType.outline,
            onTap: () {
              setState(() {
                _isShaking = !_isShaking;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _OnTapScalerDemo extends StatefulWidget {
  const _OnTapScalerDemo();

  @override
  State<_OnTapScalerDemo> createState() => _OnTapScalerDemoState();
}

class _OnTapScalerDemoState extends State<_OnTapScalerDemo> {
  int _tapCount = 14;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedOnTap(
        onTap: () {
          setState(() {
            _tapCount++;
          });
        },
        child: _SurfaceCard(
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.colorScheme.background,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.ads_click_rounded,
                  color: context.colorScheme.foreground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tap scaler card',
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Recorded taps: $_tapCount',
                      style: context.bodyMedium.copyWith(
                        color: context.colorScheme.secondaryForeground,
                      ),
                    ),
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

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorScheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.card});

  final _MockInsightCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.colorScheme.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(card.icon, color: context.colorScheme.foreground),
          ),
          const SizedBox(height: 18),
          Text(
            card.title,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.subtitle,
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShakeDemoIcon extends StatelessWidget {
  const _ShakeDemoIcon({required this.item, required this.showRemoveBadge});

  final _MockAppIcon item;
  final bool showRemoveBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: MyBoxShadows.lg,
                ),
                child: Icon(item.icon, size: 30, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.bodySmall.copyWith(
                  color: context.colorScheme.foreground,
                ),
              ),
            ],
          ),
          Positioned(
            left: -6,
            top: -6,
            child: AnimatedOpacity(
              opacity: showRemoveBadge ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: context.colorScheme.destructive,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.remove_rounded,
                  size: 14,
                  color: context.colorScheme.destructiveForeground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePreviewPage extends StatelessWidget {
  const _RoutePreviewPage({required this.option});

  final _RouteAnimationOption option;

  @override
  Widget build(BuildContext context) {
    final foreground = context.colorScheme.secondaryForeground;

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: MyAppBar(title: '${option.label} Preview'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.slideshow_rounded, size: 32, color: foreground),
                const SizedBox(height: 16),
                Text(
                  option.label,
                  style: context.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This preview page uses the selected route animation to enter the stack.',
                  style: context.bodyMedium.copyWith(color: foreground),
                ),
                const SizedBox(height: 20),
                MyButton(
                  text: 'Close Preview',
                  shape: MyButtonShape.round,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MockInsightCard {
  const _MockInsightCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _MockMetric {
  const _MockMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
}

class _RouteAnimationOption {
  const _RouteAnimationOption({required this.label, required this.animation});

  final String label;
  final PageRouteAnimation animation;
}

class _MockAppIcon {
  const _MockAppIcon({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;
}

class _BlurredCard extends StatefulWidget {
  final double? blurAmount;

  const _BlurredCard({this.blurAmount});

  @override
  State<_BlurredCard> createState() => _BlurredCardState();
}

class _BlurredCardState extends State<_BlurredCard> {
  bool _isBlurred = false;

  void toggleBlur() {
    _isBlurred = !_isBlurred;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double maxBlurAmount = widget.blurAmount ?? 8;
    double minBlurAmount = 0;

    return Container(
      // Make sure to use a Clip setting other than none. Otherwise, the blurring will be applied to whole background.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0x1FFFFFFF),
        borderRadius: MyBorderRadius.large,
      ),
      child: AnimatedBlur(
        blur: _isBlurred ? maxBlurAmount : minBlurAmount,
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
        child: MyGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: toggleBlur,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(maxHeight: 40),
              decoration: BoxDecoration(color: Color(0xC2000000)),
              padding: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Tap to Toggle Blur',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: -0.5,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
