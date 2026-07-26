import 'dart:async';

import 'package:flutter/material.dart';

import '../flutter_swiper.dart';

class MySwiperControl extends SwiperPlugin {
  const MySwiperControl({
    this.iconPrevious = Icons.arrow_back_ios,
    this.iconNext = Icons.arrow_forward_ios,
    this.color,
    this.disableColor,
    this.key,
    this.size = 30.0,
    this.padding = const EdgeInsets.all(5),
  });

  /// IconData for previous
  final IconData iconPrevious;

  /// IconData fopr next
  final IconData iconNext;

  /// Icon size
  final double size;

  /// Icon normal color, The theme's [ThemeData.primaryColor] by default.
  final Color? color;

  /// If set loop=false on Swiper, this color will be used when swiper goto the last slide.
  /// The theme's [ThemeData.disabledColor] by default.
  final Color? disableColor;

  final EdgeInsetsGeometry padding;

  final Key? key;

  Widget buildButton(
    SwiperPluginConfig config,
    Color color,
    IconData iconDaga,
    int quarterTurns,
    bool previous,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (previous) {
          unawaited(config.controller.previous());
        } else {
          unawaited(config.controller.next());
        }
      },
      child: Padding(
        padding: padding,
        child: RotatedBox(
          quarterTurns: quarterTurns,
          child: Icon(
            iconDaga,
            semanticLabel: previous ? 'Previous' : 'Next',
            size: size,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final ThemeData themeData = Theme.of(context);

    final Color color = this.color ?? themeData.primaryColor;
    final Color disableColor = this.disableColor ?? themeData.disabledColor;
    Color prevColor;
    Color nextColor;

    if (config.loop) {
      prevColor = nextColor = color;
    } else {
      final bool next = config.activeIndex < config.itemCount - 1;
      final bool prev = config.activeIndex > 0;
      prevColor = prev ? color : disableColor;
      nextColor = next ? color : disableColor;
    }

    Widget child;
    if (config.scrollDirection == Axis.horizontal) {
      child = Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildButton(config, prevColor, iconPrevious, 0, true),
          buildButton(config, nextColor, iconNext, 0, false),
        ],
      );
    } else {
      child = Column(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildButton(config, prevColor, iconPrevious, -3, true),
          buildButton(config, nextColor, iconNext, -3, false),
        ],
      );
    }

    return SizedBox.expand(child: child);
  }
}
