import 'package:common_tools/index.dart';
import 'package:common_tools/widgets/animations/page_route_animation.dart'
    as route_animation;
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyAnimationsPage extends StatefulWidget {
  const MyAnimationsPage({super.key});

  @override
  State<MyAnimationsPage> createState() => _MyAnimationsPageState();
}

class _MyAnimationsPageState extends State<MyAnimationsPage> {
  int _bounceSeed = 0;
  int _metricIndex = 1;
  int _profileIndex = 0;
  int _storyIndex = 0;
  int _tapCount = 14;
  int _reactCount = 3;
  bool _isShaking = true;

  static const List<_MockInsightCard> _insightCards = [
    _MockInsightCard(
      title: 'Motion Tokens',
      subtitle: 'Durations tuned for cards, sheets, and overlays.',
      icon: Icons.auto_awesome_outlined,
      color: Color(0xFFE3F2FD),
    ),
    _MockInsightCard(
      title: 'Touch Feedback',
      subtitle: 'Tap states stay snappy without overwhelming the layout.',
      icon: Icons.touch_app_outlined,
      color: Color(0xFFE8F5E9),
    ),
    _MockInsightCard(
      title: 'Route Transitions',
      subtitle: 'Preview page motion with focused mock content.',
      icon: Icons.route_outlined,
      color: Color(0xFFFFF3E0),
    ),
    _MockInsightCard(
      title: 'Haptic Effects',
      subtitle: 'Subtle vibrations calibrated for physical confirmation.',
      icon: Icons.vibration_outlined,
      color: Color(0xFFF3E5F5),
    ),
  ];

  static const List<_MockMetric> _metrics = [
    _MockMetric(label: 'Low', value: 28, color: Color(0xFF8ECAE6)),
    _MockMetric(label: 'Medium', value: 64, color: Color(0xFF219EBC)),
    _MockMetric(label: 'High', value: 92, color: Color(0xFF023047)),
  ];

  static const List<_MockProfile> _profiles = [
    _MockProfile(
      name: 'Nora S.',
      role: 'Design systems lead',
      summary: 'Prefers quiet transitions that still read as intentional.',
      color: Color(0xFFD7E3FC),
    ),
    _MockProfile(
      name: 'Miles T.',
      role: 'Growth engineer',
      summary: 'Uses motion to spotlight changes in live dashboards.',
      color: Color(0xFFFFE0B2),
    ),
    _MockProfile(
      name: 'Ava K.',
      role: 'Product designer',
      summary: 'Pairs typography and movement to guide scan order.',
      color: Color(0xFFC8E6C9),
    ),
  ];

  static const List<_MockStory> _stories = [
    _MockStory(
      title: 'Campaign Sync Complete',
      body: 'New assets are staged and ready for review with gentle motion.',
      color: Color(0xFFE1F5FE),
    ),
    _MockStory(
      title: 'Trending Search',
      body: 'Search demos now highlight matching animation utilities.',
      color: Color(0xFFF3E5F5),
    ),
    _MockStory(
      title: 'Base Section Updated',
      body: 'Animations are now grouped with other foundational examples.',
      color: Color(0xFFE8F5E9),
    ),
  ];

  static const List<_RouteAnimationOption> _routeOptions = [
    _RouteAnimationOption(
      label: 'Fade',
      animation: route_animation.PageRouteAnimation.Fade,
      color: Color(0xFFE3F2FD),
    ),
    _RouteAnimationOption(
      label: 'Scale',
      animation: route_animation.PageRouteAnimation.Scale,
      color: Color(0xFFFFF3E0),
    ),
    _RouteAnimationOption(
      label: 'Rotate',
      animation: route_animation.PageRouteAnimation.Rotate,
      color: Color(0xFFF3E5F5),
    ),
    _RouteAnimationOption(
      label: 'Slide',
      animation: route_animation.PageRouteAnimation.Slide,
      color: Color(0xFFE8F5E9),
    ),
    _RouteAnimationOption(
      label: 'Bottom Top',
      animation: route_animation.PageRouteAnimation.SlideBottomTop,
      color: Color(0xFFFFEBEE),
    ),
  ];

  static const List<_MockAppIcon> _shakeIcons = [
    _MockAppIcon(
      title: 'Camera',
      icon: Icons.camera_alt_rounded,
      color: Color(0xFFFF9F80),
    ),
    _MockAppIcon(
      title: 'Notes',
      icon: Icons.sticky_note_2_rounded,
      color: Color(0xFFFFF59D),
    ),
    _MockAppIcon(
      title: 'Music',
      icon: Icons.music_note_rounded,
      color: Color(0xFFFF80AB),
    ),
    _MockAppIcon(
      title: 'Maps',
      icon: Icons.map_rounded,
      color: Color(0xFF80CBC4),
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
            ),
            ExampleItem(desc: 'Animated Bounce', builder: _buildBounceDemo),
          ],
        ),
        ExampleModule(
          title: 'Builders & Transitions',
          children: [
            ExampleItem(
              desc: 'Animated Value Builder',
              builder: _buildAnimatedValueDemo,
            ),
            ExampleItem(
              desc: 'Repeated Animation Builder',
              builder: _buildRepeatedAnimationDemo,
            ),
            ExampleItem(
              desc: 'AnimationBuilder with IntervalDuration stages a pulse.',
              builder: _buildAnimationBuilderDemo,
            ),
            ExampleItem(
              desc: 'CrossFadedTransition swaps between mocked team profiles.',
              builder: _buildCrossFadeDemo,
            ),
            ExampleItem(
              desc:
                  'FadeSlideTransition rotates through mocked product updates.',
              builder: _buildFadeSlideDemo,
            ),
            ExampleItem(
              desc: 'AnimatedTextKit renders TypewriterAnimatedText messages.',
              builder: _buildAnimatedTextDemo,
              center: false,
            ),
          ],
        ),
        ExampleModule(
          title: 'Touch & Routes',
          children: [
            ExampleItem(
              desc: 'AnimatedShake mimics the iOS home-screen edit wiggle.',
              builder: _buildShakeDemo,
              center: false,
            ),
            ExampleItem(
              desc: 'OnTapScaler tracks taps on a mocked action card.',
              builder: _buildOnTapScalerDemo,
              center: false,
            ),
            ExampleItem(
              desc:
                  'ReactOnTap shows combined, scale-only, and opacity-only feedback.',
              builder: _buildReactOnTapDemo,
              center: false,
            ),
            ExampleItem(
              desc: 'TranslateOnClick adds a press lift to a mocked CTA.',
              builder: _buildTranslateOnClickDemo,
              center: false,
            ),
            ExampleItem(
              desc:
                  'PageRoute.build previews every PageRouteAnimation variant.',
              builder: _buildRouteAnimationDemo,
              center: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFadeScaleDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _insightCards.sublist(0, 2).mapIndexed((index, item) {
          return SizedBox(
            width: 180,
            child: AnimatedFadeScale(
              key: ValueKey('fade-card-$index'),
              delay: Duration(milliseconds: 120 * index),
              child: _FeatureCard(card: item),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBounceDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _insightCards.sublist(2, 4).map((item) {
              return SizedBox(
                width: 180,
                child: AnimatedBounce(
                  key: ValueKey(_bounceSeed),
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

  Widget _buildAnimatedValueDemo(BuildContext context) {
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${value.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.headlineMedium,
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < _metrics.length; index++)
                ChoiceChip(
                  label: Text(
                    '${_metrics[index].label} ${_metrics[index].value}%',
                  ),
                  selected: index == _metricIndex,
                  onSelected: (_) {
                    setState(() {
                      _metricIndex = index;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatedAnimationDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        child: SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              RepeatedAnimationBuilder<double>(
                start: -12,
                end: 12,
                duration: const Duration(milliseconds: 900),
                mode: RepeatMode.pingPong,
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: child,
                  );
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2196F3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.24),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.waves_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationBuilderDemo(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _AnimationBuilderPulseDemo(),
    );
  }

  Widget _buildCrossFadeDemo(BuildContext context) {
    final profile = _profiles[_profileIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360,
            child: CrossFadedTransition(
              duration: const Duration(milliseconds: 350),
              child: _ProfileCard(
                key: ValueKey(profile.name),
                profile: profile,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < _profiles.length; index++)
                ChoiceChip(
                  label: Text(_profiles[index].name),
                  selected: index == _profileIndex,
                  onSelected: (_) {
                    setState(() {
                      _profileIndex = index;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFadeSlideDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360,
            child: FadeSlideTransition(
              transitionKey: ValueKey(_storyIndex),
              child: _StoryCard(story: _stories[_storyIndex]),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < _stories.length; index++)
                ChoiceChip(
                  label: Text(_stories[index].title),
                  selected: index == _storyIndex,
                  onSelected: (_) {
                    setState(() {
                      _storyIndex = index;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        color: const Color(0xFF0F172A),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            pause: Duration(milliseconds: 650),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
            texts: [
              TypewriterAnimatedText('Syncing animation tokens...'),
              TypewriterAnimatedText('Preparing mock route previews...'),
              TypewriterAnimatedText('Animations now live in Base section.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShakeDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _shakeIcons.mapIndexed((index, item) {
              return AnimatedShake(
                enabled: _isShaking,
                delay: Duration(milliseconds: index * 70),
                rotationDegrees: 2,
                horizontalOffset: 0.4,
                verticalOffset: 0.6,
                child: _ShakeDemoIcon(item: item, showRemoveBadge: _isShaking),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          MyButton(
            text: _isShaking ? 'Stop Shake' : 'Start Shake',
            type: MyButtonType.outline,
            shape: MyButtonShape.round,
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

  Widget _buildOnTapScalerDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OnTapScaler(
        onTap: () {
          setState(() {
            _tapCount++;
          });
        },
        child: _SurfaceCard(
          color: const Color(0xFFF1F8E9),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEDC8),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.ads_click_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tap scaler card',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text('Recorded taps: $_tapCount'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactOnTapDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ReactOnTap(
            onTap: () {
              setState(() {
                _reactCount++;
              });
            },
            child: _ReactionChip(
              label: 'Default reaction',
              count: _reactCount,
              color: const Color(0xFFE3F2FD),
            ),
          ),
          ReactOnTap.scale(
            onTap: () {
              setState(() {
                _reactCount++;
              });
            },
            child: _ReactionChip(
              label: 'Scale only',
              count: _reactCount + 4,
              color: const Color(0xFFFFF3E0),
            ),
          ),
          ReactOnTap.opacity(
            onTap: () {
              setState(() {
                _reactCount++;
              });
            },
            child: _ReactionChip(
              label: 'Opacity only',
              count: _reactCount + 9,
              color: const Color(0xFFF3E5F5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslateOnClickDemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TranslateOnClick(
        child: _SurfaceCard(
          color: const Color(0xFFFFF8E1),
          child: const Row(
            children: [
              Icon(Icons.rocket_launch_rounded),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Press and hold this CTA card to preview the translate effect.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              shape: MyButtonShape.round,
              onTap: () {
                Navigator.of(context).push(
                  route_animation.PageRoute.build<void>(
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

class _AnimationBuilderPulseDemo extends StatefulWidget {
  const _AnimationBuilderPulseDemo();

  @override
  State<_AnimationBuilderPulseDemo> createState() =>
      _AnimationBuilderPulseDemoState();
}

class _AnimationBuilderPulseDemoState
    extends State<_AnimationBuilderPulseDemo> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: SizedBox(
        height: 132,
        child: AnimationBuilder(
          duration: const Duration(milliseconds: 1800),
          builder: (context, controller) {
            if (!_started) {
              _started = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !controller.isAnimating) {
                  controller.repeat(reverse: true);
                }
              });
            }

            final progress = IntervalDuration(
              duration: const Duration(milliseconds: 1800),
              start: const Duration(milliseconds: 250),
              end: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
            ).transform(controller.value);

            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color(0xFFF8FAFC),
                    ),
                  ),
                ),
                Positioned(
                  left: 12 + (progress * 180),
                  child: Container(
                    width: 54 + (progress * 18),
                    height: 54 + (progress * 18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(
                        0xFF4F46E5,
                      ).withValues(alpha: 0.20 + (progress * 0.25)),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Staged pulse',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(999),
                        color: const Color(0xFF4F46E5),
                        backgroundColor: const Color(
                          0xFF4F46E5,
                        ).withValues(alpha: 0.12),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.16),
        ),
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
        color: card.color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(card.icon),
          ),
          const SizedBox(height: 18),
          Text(card.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(card.subtitle),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({super.key, required this.profile});

  final _MockProfile profile;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      color: profile.color,
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.85),
            child: Text(
              profile.name.characters.first,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(profile.role),
                const SizedBox(height: 8),
                Text(profile.summary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.story});

  final _MockStory story;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      color: story.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.motion_photos_on_rounded),
              ),
              const SizedBox(width: 10),
              const Text(
                'Mock update',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            story.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(story.body),
        ],
      ),
    );
  }
}

class _ReactionChip extends StatelessWidget {
  const _ReactionChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label  $count'),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(item.icon, size: 30),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
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
                  color: const Color(0xFFE5E7EB),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.remove_rounded, size: 14),
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
    return Scaffold(
      appBar: AppBar(title: Text('${option.label} Preview')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: option.color,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.slideshow_rounded, size: 32),
                const SizedBox(height: 16),
                Text(
                  option.label,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This preview page uses the selected route animation to enter the stack.',
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
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
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

class _MockProfile {
  const _MockProfile({
    required this.name,
    required this.role,
    required this.summary,
    required this.color,
  });

  final String name;
  final String role;
  final String summary;
  final Color color;
}

class _MockStory {
  const _MockStory({
    required this.title,
    required this.body,
    required this.color,
  });

  final String title;
  final String body;
  final Color color;
}

class _RouteAnimationOption {
  const _RouteAnimationOption({
    required this.label,
    required this.animation,
    required this.color,
  });

  final String label;
  final route_animation.PageRouteAnimation animation;
  final Color color;
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
