import 'package:flutter/widgets.dart';
import '../flutter_swiper.dart';

/// plugin to display swiper components
///
abstract class SwiperPlugin {
  const SwiperPlugin();

  Widget build(BuildContext context, SwiperPluginConfig config);
}

class SwiperPluginConfig {
  const SwiperPluginConfig({
    required this.scrollDirection,
    required this.controller,
    this.activeIndex = 0,
    this.itemCount = 0,
    this.indicatorLayout,
    this.outer = false,
    this.pageController,
    this.layout,
    this.loop = false,
  });

  final int activeIndex;
  final int itemCount;
  final PageIndicatorLayout? indicatorLayout;
  final Axis scrollDirection;
  final bool loop;
  final bool outer;
  final PageController? pageController;
  final MySwiperController controller;
  final SwiperLayout? layout;
}

class SwiperPluginView extends StatelessWidget {
  const SwiperPluginView(this.plugin, this.config, {super.key});

  final SwiperPlugin plugin;
  final SwiperPluginConfig config;

  @override
  Widget build(BuildContext context) {
    return plugin.build(context, config);
  }
}
