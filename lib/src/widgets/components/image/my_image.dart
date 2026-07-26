import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../loading/indicators/my_loader_options.dart';
import '../loading/my_loader.dart';
import './my_image_provider.dart';

enum MyImageType {
  clip,
  fitHeight,
  fitWidth,
  stretch,
  square,
  squircle,
  circle,
}

class MyImage extends StatelessWidget {
  const MyImage({
    this.source,
    super.key,
    this.fit,
    this.width,
    this.height,
    this.type = MyImageType.squircle,
    this.loader,
    this.error,
    this.frameBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.colorFilter,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.cacheHeight,
    this.cacheWidth,
    this.scale = 1,
    this.textDirection,
    this.size,
    this.allowDrawingOutsideViewBox = false,
    this.cache = true,
    this.assetPrefix = 'assets',
    this.headers,
    this.fadeDuration = const Duration(milliseconds: 400),
    this.enableZoom = false,
    this.minZoom = 1,
    this.maxZoom = 4,
    this.enableScaleAnimation = false,
    this.normalScale = 1.0,
    this.hoverScale = 1.05,
    this.borderRadius,
  });

  final Object? source;
  final MyImageType type;
  final Widget? loader;
  final Widget? error;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit? fit;
  final double scale;
  final ImageFrameBuilder? frameBuilder;
  final Color? color;
  final Animation<double>? opacity;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final ui.ColorFilter? colorFilter;
  final Alignment alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final bool isAntiAlias;
  final int? cacheHeight;
  final int? cacheWidth;
  final TextDirection? textDirection;
  final bool allowDrawingOutsideViewBox;
  final bool cache;
  final String assetPrefix;
  final Map<String, String>? headers;
  final Duration fadeDuration;
  final bool enableZoom;
  final double minZoom;
  final double maxZoom;
  final bool enableScaleAnimation;
  final double normalScale;
  final double hoverScale;
  final BorderRadiusGeometry? borderRadius;

  Widget _wrap(BuildContext context, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: MyBorderRadius.medium,
      ),
      child: Center(child: child),
    );
  }

  Widget _loader(BuildContext context) {
    return loader ??
        _wrap(
          context,
          loader ??
              MyLoader(
                size: MyLoaderSize.extraSmall,
                options: MyLoaderOptions(strokeWidth: 2.5),
              ),
        );
  }

  Widget _error(BuildContext context) {
    return error ??
        _wrap(
          context,
          Icon(LucideIcons.image, color: context.colorScheme.mutedForeground),
        );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MyImageType.clip:
        return _buildProvider(
          context,
          fitOverride: fit ?? BoxFit.none,
          widthOverride: width ?? 72,
          heightOverride: height ?? 72,
        );
      case MyImageType.fitHeight:
        return _buildProvider(context, fitOverride: fit ?? BoxFit.fitHeight);
      case MyImageType.stretch:
        return _buildProvider(
          context,
          fitOverride: fit ?? BoxFit.fill,
          widthOverride: width ?? 72,
          heightOverride: height ?? 72,
        );
      case MyImageType.square:
        return _buildProvider(
          context,
          fitOverride: fit ?? BoxFit.cover,
          widthOverride: width ?? 72,
          heightOverride: height ?? 72,
        );
      case MyImageType.squircle:
        return Container(
          height: height ?? 72,
          width: width ?? 72,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? MyBorderRadius.medium,
          ),
          child: _buildProvider(
            context,
            fitOverride: fit ?? BoxFit.cover,
            widthOverride: width ?? 72,
            heightOverride: height ?? 72,
          ),
        );
      case MyImageType.circle:
        return Container(
          height: height ?? 72,
          width: width ?? 72,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: _buildProvider(
            context,
            fitOverride: fit ?? BoxFit.cover,
            widthOverride: width ?? 72,
            heightOverride: height ?? 72,
          ),
        );
      case MyImageType.fitWidth:
        return _buildProvider(context, fitOverride: fit ?? BoxFit.fitWidth);
    }
  }

  Widget _buildProvider(
    BuildContext context, {
    BoxFit? fitOverride,
    double? widthOverride,
    double? heightOverride,
  }) {
    return MyImageProvider(
      source,
      height: heightOverride ?? height,
      width: widthOverride ?? width,
      fit: fitOverride ?? fit ?? BoxFit.none,
      color: color,
      frameBuilder: frameBuilder,
      loader: _loader(context),
      error: _error(context),
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      cacheHeight: cacheHeight,
      cacheWidth: cacheWidth,
      size: size,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      assetPrefix: assetPrefix,
      cache: cache,
      colorFilter: colorFilter,
      enableZoom: enableZoom,
      minZoom: minZoom,
      maxZoom: maxZoom,
      enableScaleAnimation: enableScaleAnimation,
      fadeDuration: fadeDuration,
      headers: headers,
      hoverScale: hoverScale,
      normalScale: normalScale,
      scale: scale,
      textDirection: textDirection,
    );
  }
}
