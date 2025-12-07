import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_widget.dart';

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
    this.loadingBuilder,
    this.errorBuilder,
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
    this.assetUrl,
    this.imageFile,
  });

  final String? image;

  final String? assetUrl;

  final File? imageFile;

  final MyImageType type;

  final Widget? loadingWidget;

  final Widget? errorWidget;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final ImageFrameBuilder? frameBuilder;

  final ImageLoadingBuilder? loadingBuilder;

  final ImageErrorWidgetBuilder? errorBuilder;

  final Color? color;

  final Animation<double>? opacity;

  final FilterQuality filterQuality;

  final BlendMode? colorBlendMode;

  final AlignmentGeometry alignment;

  final ImageRepeat repeat;

  final Rect? centerSlice;

  final bool matchTextDirection;

  final bool gaplessPlayback;

  final String? semanticLabel;

  final bool excludeFromSemantics;

  final bool isAntiAlias;

  final int? cacheHeight;

  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MyImageType.clip:
        return imageFile == null
            ? (assetUrl == null
                ? ImageWidget.network(
                  image,
                  height: height ?? 72,
                  width: width ?? 72,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.none,
                  color: color,
                  frameBuilder: frameBuilder,
                  loadingBuilder: loadingBuilder,
                  errorBuilder: errorBuilder,
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
                )
                : ImageWidget.asset(
                  assetUrl,
                  width: width ?? 72,
                  height: height ?? 72,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.none,
                  color: color,
                  frameBuilder: frameBuilder,
                  errorBuilder: errorBuilder,
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
                ))
            : ImageWidget.file(
              imageFile,
              width: width ?? 72,
              height: height ?? 72,
              fit: fit ?? BoxFit.none,
              color: color,
              frameBuilder: frameBuilder,
              errorBuilder: errorBuilder,
              semanticLabel: semanticLabel,
              excludeFromSemantics: excludeFromSemantics,
              colorBlendMode: colorBlendMode,
              alignment: alignment,
              repeat: repeat,
              centerSlice: centerSlice,
              matchTextDirection: matchTextDirection,
              gaplessPlayback: gaplessPlayback,
              filterQuality: filterQuality,
              isAntiAlias: isAntiAlias,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            );
      case MyImageType.fitHeight:
        return imageFile == null
            ? (assetUrl == null
                ? ImageWidget.network(
                  image,
                  height: height,
                  width: width,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.fitHeight,
                  color: color,
                  frameBuilder: frameBuilder,
                  loadingBuilder: loadingBuilder,
                  errorBuilder: errorBuilder,
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
                )
                : ImageWidget.asset(
                  assetUrl,
                  width: width,
                  height: height,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.fitHeight,
                  color: color,
                  frameBuilder: frameBuilder,
                  errorBuilder: errorBuilder,
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
                ))
            : ImageWidget.file(
              imageFile,
              width: width,
              height: height,
              fit: fit ?? BoxFit.fitHeight,
              color: color,
              frameBuilder: frameBuilder,
              errorBuilder: errorBuilder,
              semanticLabel: semanticLabel,
              excludeFromSemantics: excludeFromSemantics,
              colorBlendMode: colorBlendMode,
              alignment: alignment,
              repeat: repeat,
              centerSlice: centerSlice,
              matchTextDirection: matchTextDirection,
              gaplessPlayback: gaplessPlayback,
              filterQuality: filterQuality,
              isAntiAlias: isAntiAlias,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            );
      case MyImageType.stretch:
        return imageFile == null
            ? (assetUrl == null
                ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height ?? 72,
                    maxWidth: width ?? 72,
                  ),
                  child: ImageWidget.network(
                    image,
                    height: height ?? 72,
                    width: width ?? 72,
                    errorWidget: errorWidget,
                    loadingWidget: loadingWidget,
                    fit: fit ?? BoxFit.fill,
                    color: color,
                    frameBuilder: frameBuilder,
                    loadingBuilder: loadingBuilder,
                    errorBuilder: errorBuilder,
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
                )
                : ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height ?? 72,
                    maxWidth: width ?? 72,
                  ),
                  child: ImageWidget.asset(
                    assetUrl,
                    width: width ?? 72,
                    height: height ?? 72,
                    errorWidget: errorWidget,
                    loadingWidget: loadingWidget,
                    fit: fit ?? BoxFit.fill,
                    color: color,
                    frameBuilder: frameBuilder,
                    errorBuilder: errorBuilder,
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
                ))
            : ImageWidget.file(
              imageFile,
              width: width ?? 72,
              height: height ?? 72,
              fit: fit ?? BoxFit.fill,
              color: color,
              frameBuilder: frameBuilder,
              errorBuilder: errorBuilder,
              semanticLabel: semanticLabel,
              excludeFromSemantics: excludeFromSemantics,
              colorBlendMode: colorBlendMode,
              alignment: alignment,
              repeat: repeat,
              centerSlice: centerSlice,
              matchTextDirection: matchTextDirection,
              gaplessPlayback: gaplessPlayback,
              filterQuality: filterQuality,
              isAntiAlias: isAntiAlias,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            );
      case MyImageType.square:
        return imageFile == null
            ? (assetUrl == null
                ? ImageWidget.network(
                  image,
                  height: height ?? 72,
                  width: width ?? 72,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.cover,
                  color: color,
                  frameBuilder: frameBuilder,
                  loadingBuilder: loadingBuilder,
                  errorBuilder: errorBuilder,
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
                )
                : ImageWidget.asset(
                  assetUrl,
                  width: width ?? 72,
                  height: height ?? 72,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.cover,
                  color: color,
                  frameBuilder: frameBuilder,
                  errorBuilder: errorBuilder,
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
                ))
            : ImageWidget.file(
              imageFile,
              width: width ?? 72,
              height: height ?? 72,
              fit: fit ?? BoxFit.cover,
              color: color,
              frameBuilder: frameBuilder,
              errorBuilder: errorBuilder,
              semanticLabel: semanticLabel,
              excludeFromSemantics: excludeFromSemantics,
              colorBlendMode: colorBlendMode,
              alignment: alignment,
              repeat: repeat,
              centerSlice: centerSlice,
              matchTextDirection: matchTextDirection,
              gaplessPlayback: gaplessPlayback,
              filterQuality: filterQuality,
              isAntiAlias: isAntiAlias,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            );
      case MyImageType.roundedSquare:
        return Container(
          height: height ?? 72,
          width: width ?? 72,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child:
              imageFile == null
                  ? (assetUrl == null
                      ? ImageWidget.network(
                        image,
                        height: height ?? 72,
                        width: width ?? 72,
                        errorWidget: errorWidget,
                        loadingWidget: loadingWidget,
                        fit: fit ?? BoxFit.cover,
                        color: color,
                        frameBuilder: frameBuilder,
                        loadingBuilder: loadingBuilder,
                        errorBuilder: errorBuilder,
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
                      )
                      : ImageWidget.asset(
                        assetUrl,
                        width: width ?? 72,
                        height: height ?? 72,
                        errorWidget: errorWidget,
                        loadingWidget: loadingWidget,
                        fit: fit ?? BoxFit.cover,
                        color: color,
                        frameBuilder: frameBuilder,
                        errorBuilder: errorBuilder,
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
                      ))
                  : ImageWidget.file(
                    imageFile,
                    width: width ?? 72,
                    height: height ?? 72,
                    fit: fit ?? BoxFit.cover,
                    color: color,
                    frameBuilder: frameBuilder,
                    errorBuilder: errorBuilder,
                    semanticLabel: semanticLabel,
                    excludeFromSemantics: excludeFromSemantics,
                    colorBlendMode: colorBlendMode,
                    alignment: alignment,
                    repeat: repeat,
                    centerSlice: centerSlice,
                    matchTextDirection: matchTextDirection,
                    gaplessPlayback: gaplessPlayback,
                    filterQuality: filterQuality,
                    isAntiAlias: isAntiAlias,
                    cacheWidth: cacheWidth,
                    cacheHeight: cacheHeight,
                  ),
        );
      case MyImageType.circle:
        return Container(
          height: height ?? 72,
          width: width ?? 72,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child:
              imageFile == null
                  ? (assetUrl == null
                      ? ImageWidget.network(
                        image,
                        height: height ?? 72,
                        width: width ?? 72,
                        errorWidget: errorWidget,
                        loadingWidget: loadingWidget,
                        fit: fit ?? BoxFit.cover,
                        color: color,
                        frameBuilder: frameBuilder,
                        loadingBuilder: loadingBuilder,
                        errorBuilder: errorBuilder,
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
                      )
                      : ImageWidget.asset(
                        assetUrl,
                        width: width ?? 72,
                        height: height ?? 72,
                        errorWidget: errorWidget,
                        loadingWidget: loadingWidget,
                        fit: fit ?? BoxFit.cover,
                        color: color,
                        frameBuilder: frameBuilder,
                        errorBuilder: errorBuilder,
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
                      ))
                  : ImageWidget.file(
                    imageFile,
                    width: width ?? 72,
                    height: height ?? 72,
                    errorWidget: errorWidget,
                    loadingWidget: loadingWidget,
                    fit: fit ?? BoxFit.cover,
                    color: color,
                    frameBuilder: frameBuilder,
                    errorBuilder: errorBuilder,
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
        return imageFile == null
            ? (assetUrl == null
                ? ImageWidget.network(
                  image,
                  height: height,
                  width: width,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.fitWidth,
                  color: color,
                  frameBuilder: frameBuilder,
                  loadingBuilder: loadingBuilder,
                  errorBuilder: errorBuilder,
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
                )
                : ImageWidget.asset(
                  assetUrl,
                  width: width,
                  height: height,
                  errorWidget: errorWidget,
                  loadingWidget: loadingWidget,
                  fit: fit ?? BoxFit.fitWidth,
                  color: color,
                  frameBuilder: frameBuilder,
                  errorBuilder: errorBuilder,
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
                ))
            : ImageWidget.file(
              imageFile,
              width: width,
              height: height,
              errorWidget: errorWidget,
              loadingWidget: loadingWidget,
              fit: fit ?? BoxFit.fitWidth,
              color: color,
              frameBuilder: frameBuilder,
              errorBuilder: errorBuilder,
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
