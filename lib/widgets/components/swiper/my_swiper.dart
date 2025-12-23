import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';

const _kAminatedDuration = 100;

class MySwiperPagination extends SwiperPlugin {
  const MySwiperPagination({
    this.alignment,
    this.key,
    this.margin = const EdgeInsets.all(10),
    this.builder = MySwiperPagination.dots,
  });

  /// Dot Style
  static const SwiperPlugin dots = MySwiperDotsPagination();

  /// Rounded rectangle + dot style default width 20, height 6
  static const SwiperPlugin dotsBar = MySwiperDotsPagination(
    roundedRectangleWidth: 20,
  );

  /// Number style
  static const SwiperPlugin fraction = MyFractionPagination();

  /// Arrow style
  static const SwiperPlugin controls = MySwiperArrowPagination();

  /// When [MySwiper.scrollDirection] == [Axis.horizontal], the default is [Alignment.bottomCenter]
  /// When [MySwiper.scrollDirection] == [Axis.vertical], the default is [Alignment.centerRight]
  final Alignment? alignment;

  /// The distance between the indicator and the container
  final EdgeInsetsGeometry margin;

  final SwiperPlugin builder;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final alignment =
        this.alignment ??
        (config.scrollDirection == Axis.horizontal
            ? Alignment.bottomCenter
            : Alignment.centerRight);

    Widget child = Padding(
      padding: margin,
      child: builder.build(context, config),
    );

    if (!config.outer) {
      child = Align(key: key, alignment: alignment, child: child);
    }

    return child;
  }
}

class MySwiperDotsPagination extends SwiperPlugin {
  const MySwiperDotsPagination({
    this.activeColor,
    this.color,
    this.key,
    this.size = 6.0,
    this.activeSize = 6.0,
    this.space = 4.0,
    this.roundedRectangleWidth,
    this.animationDuration,
  });

  final Color? activeColor;
  final Color? color;
  final double activeSize;
  final double size;
  final double space;
  final double? roundedRectangleWidth;
  final int? animationDuration;
  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    if (config.itemCount > 20) {
      debugPrint(
        'warning: The itemCount is too big, '
        'we suggest use MyFractionPaginationBuilder',
      );
    }
    final activeColor =
        this.activeColor ??
        (config.outer ? context.colorScheme.primary : Colors.white);

    final color =
        this.color ??
        (config.outer
            ? context.colorScheme.secondary
            : Colors.white.withValues(alpha: 0.55));

    if (config.indicatorLayout != PageIndicatorLayout.NONE &&
        config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: config.itemCount,
        controller: config.pageController,
        layout: config.indicatorLayout,
        size: size,
        activeColor: activeColor,
        color: color,
        space: space,
      );
    }

    final list = <Widget>[];

    final itemCount = config.itemCount;
    final activeIndex = config.activeIndex;

    for (var i = 0; i < itemCount; ++i) {
      final active = i == activeIndex;
      final isActiviRectangle =
          roundedRectangleWidth != null && roundedRectangleWidth! > 0 && active;
      double? scalableLen;
      double? fixedLen;

      scalableLen =
          isActiviRectangle
              ? roundedRectangleWidth
              : (active ? activeSize : size);
      fixedLen = active ? activeSize : size;

      list.add(
        Container(
          key: Key('pagination_$i'),
          margin: EdgeInsets.all(space),
          child: AnimatedContainer(
            duration: Duration(
              milliseconds: animationDuration ?? _kAminatedDuration,
            ),
            width:
                config.scrollDirection == Axis.horizontal
                    ? scalableLen
                    : fixedLen,
            height:
                config.scrollDirection == Axis.horizontal
                    ? fixedLen
                    : scalableLen,
            decoration: BoxDecoration(
              color: active ? activeColor : color,
              borderRadius: BorderRadius.circular(activeSize / 2),
            ),
          ),
        ),
      );
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(key: key, mainAxisSize: MainAxisSize.min, children: list);
    } else {
      return Row(key: key, mainAxisSize: MainAxisSize.min, children: list);
    }
  }
}

class MyFractionPagination extends SwiperPlugin {
  const MyFractionPagination({
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.color = Colors.white,
    this.textStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontFamily: MyTypography.kDefaultFontFamily,
    ),
    this.activeTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontFamily: MyTypography.kDefaultFontFamily,
    ),
    this.key,
    this.activeColor = Colors.white,
  });

  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? color;
  final Color? activeColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;
  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    Widget child;
    if (Axis.vertical == config.scrollDirection) {
      child = Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('${config.activeIndex + 1}', style: activeTextStyle),
          Text(' / ', style: textStyle),
          Text('${config.itemCount}', style: textStyle),
        ],
      );
    } else {
      child = Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('${config.activeIndex + 1}', style: activeTextStyle),
          Text(' / ${config.itemCount}', style: textStyle),
        ],
      );
    }

    return Container(
      width: width ?? 40,
      height: height ?? 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0x66000000),
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      child: child,
    );
  }
}

class MySwiperArrowPagination extends SwiperPlugin {
  const MySwiperArrowPagination({
    this.radius,
    this.backgroundColor,
    this.backArrow,
    this.forwardArrow,
    this.autoHideWhenAtBoundary = true,
  });

  final bool? autoHideWhenAtBoundary;
  final Widget? backArrow;
  final Widget? forwardArrow;
  final double? radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final itemCount = config.itemCount;
    final activeIndex = config.activeIndex;

    return Row(
      children: [
        Visibility(
          visible:
              config.loop ||
              ((autoHideWhenAtBoundary ?? false) && activeIndex != 0),
          child: MyGestureDetector(
            child: CircleAvatar(
              radius: radius ?? 10.0,
              backgroundColor: backgroundColor ?? Colors.black54,
              child:
                  backArrow ??
                  const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                    size: 9,
                  ),
            ),
            onTap: () {
              unawaited(config.controller.previous());
            },
          ),
        ),
        const Spacer(),
        Visibility(
          visible:
              config.loop ||
              ((autoHideWhenAtBoundary ?? false) &&
                  activeIndex != itemCount - 1),
          child: MyGestureDetector(
            child: CircleAvatar(
              radius: radius ?? 10.0,
              backgroundColor: backgroundColor ?? Colors.black54,
              child:
                  forwardArrow ??
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                    size: 9,
                  ),
            ),
            onTap: () {
              unawaited(config.controller.next());
            },
          ),
        ),
      ],
    );
  }
}
