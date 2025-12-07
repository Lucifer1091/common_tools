import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';
import 'my_image_provider.dart';

enum MyImageType {
  clip,
  fitHeight,
  fitWidth,
  stretch,
  square,
  roundedSquare,
  circle,
}

class MyImage extends StatelessWidget {
  const MyImage({
    this.image,
    super.key,
    this.type = MyImageType.roundedSquare,
    this.errorWidget,
    this.loadingWidget,
    this.width,
    this.height,
    this.fit,
    this.frameBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.cacheHeight,
    this.cacheWidth,
  });

  final Object? image;
  final MyImageType type;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageFrameBuilder? frameBuilder;
  final Color? color;
  final Animation<double>? opacity;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
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

  Widget _wrap(BuildContext context, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: MyBorderRadius.medium,
      ),
      child: Center(
        child: MyLoader(
          size: MyLoaderSize.small,
          icon: MyCircleLoader(options: MyLoaderOptions(strokeWidth: 3)),
        ),
      ),
    );
  }

  Widget _loader(BuildContext context) {
    return loadingWidget ??
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: MyBorderRadius.medium,
          ),
          child: Center(
            child: MyLoader(
              size: MyLoaderSize.small,
              icon: MyCircleLoader(options: MyLoaderOptions(strokeWidth: 3)),
            ),
          ),
        );
  }

  Widget _error(BuildContext context) {
    return errorWidget ??
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: MyBorderRadius.medium,
          ),
          child: Center(
            child: Icon(
              LucideIcons.image,
              color: context.colorScheme.mutedForeground,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MyImageType.clip:
        return MyImageProvider(
          image,
          height: height ?? 72,
          width: width ?? 72,
          fit: fit ?? BoxFit.none,
          color: color,
          frameBuilder: frameBuilder,
          loadingBuilder: _loader(context),
          errorBuilder: _error(context),
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
        );
      case MyImageType.fitHeight:
        return MyImageProvider(
          image,
          height: height,
          width: width,
          fit: fit ?? BoxFit.fitHeight,
          color: color,
          frameBuilder: frameBuilder,
          loadingBuilder: _loader(context),
          errorBuilder: _error(context),
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
        );
      case MyImageType.stretch:
        return MyImageProvider(
          image,
          height: height ?? 72,
          width: width ?? 72,
          fit: fit ?? BoxFit.fill,
          color: color,
          frameBuilder: frameBuilder,
          loadingBuilder: _loader(context),
          errorBuilder: _error(context),
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
        );
      case MyImageType.square:
        return MyImageProvider(
          image,
          height: height ?? 72,
          width: width ?? 72,
          fit: fit ?? BoxFit.cover,
          color: color,
          frameBuilder: frameBuilder,
          loadingBuilder: _loader(context),
          errorBuilder: _error(context),
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
        );
      case MyImageType.roundedSquare:
        return Container(
          height: height ?? 72,
          width: width ?? 72,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: MyBorderRadius.medium),
          child: MyImageProvider(
            image,
            height: height ?? 72,
            width: width ?? 72,
            fit: fit ?? BoxFit.cover,
            color: color,
            frameBuilder: frameBuilder,
            loadingBuilder: _loader(context),
            errorBuilder: _error(context),
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
          ),
        );
      case MyImageType.circle:
        return Container(
          height: height ?? 72,
          width: width ?? 72,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: MyImageProvider(
            image,
            height: height ?? 72,
            width: width ?? 72,
            fit: fit ?? BoxFit.cover,
            color: color,
            frameBuilder: frameBuilder,
            loadingBuilder: _loader(context),
            errorBuilder: _error(context),
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
          ),
        );
      case MyImageType.fitWidth:
        return MyImageProvider(
          image,
          height: height,
          width: width,
          fit: fit ?? BoxFit.fitWidth,
          color: color,
          frameBuilder: frameBuilder,
          loadingBuilder: _loader(context),
          errorBuilder: _error(context),
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
        );
    }
  }
}
