import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_widget.dart';

enum TDImageType {
  clip,
  fitHeight,
  fitWidth,
  stretch,
  square,
  roundedSquare,
  circle,
}

class TDImage extends StatefulWidget {
  const TDImage({
    this.imgUrl,
    super.key,
    this.type = TDImageType.roundedSquare,
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

  final String? imgUrl;

  final String? assetUrl;

  final File? imageFile;

  final TDImageType type;

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
  State<StatefulWidget> createState() => _TDImageState();
}

class _TDImageState extends State<TDImage> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case TDImageType.clip:
        return widget.imageFile == null
            ? (widget.assetUrl == null
                ? ImageWidget.network(
                  widget.imgUrl,
                  height: widget.height ?? 72,
                  width: widget.width ?? 72,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.none,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  loadingBuilder: widget.loadingBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                )
                : ImageWidget.asset(
                  widget.assetUrl,
                  width: widget.width ?? 72,
                  height: widget.height ?? 72,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.none,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                ))
            : ImageWidget.file(
              widget.imageFile,
              width: widget.width ?? 72,
              height: widget.height ?? 72,
              fit: widget.fit ?? BoxFit.none,
              color: widget.color,
              frameBuilder: widget.frameBuilder,
              errorBuilder: widget.errorBuilder,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              colorBlendMode: widget.colorBlendMode,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              filterQuality: widget.filterQuality,
              isAntiAlias: widget.isAntiAlias,
              cacheWidth: widget.cacheWidth,
              cacheHeight: widget.cacheHeight,
            );
      case TDImageType.fitHeight:
        return widget.imageFile == null
            ? (widget.assetUrl == null
                ? ImageWidget.network(
                  widget.imgUrl,
                  height: widget.height,
                  width: widget.width,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.fitHeight,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  loadingBuilder: widget.loadingBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                )
                : ImageWidget.asset(
                  widget.assetUrl,
                  width: widget.width,
                  height: widget.height,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.fitHeight,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                ))
            : ImageWidget.file(
              widget.imageFile,
              width: widget.width,
              height: widget.height,
              fit: widget.fit ?? BoxFit.fitHeight,
              color: widget.color,
              frameBuilder: widget.frameBuilder,
              errorBuilder: widget.errorBuilder,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              colorBlendMode: widget.colorBlendMode,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              filterQuality: widget.filterQuality,
              isAntiAlias: widget.isAntiAlias,
              cacheWidth: widget.cacheWidth,
              cacheHeight: widget.cacheHeight,
            );
      case TDImageType.stretch:
        return widget.imageFile == null
            ? (widget.assetUrl == null
                ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.height ?? 72,
                    maxWidth: widget.width ?? 72,
                  ),
                  child: ImageWidget.network(
                    widget.imgUrl,
                    height: widget.height ?? 72,
                    width: widget.width ?? 72,
                    errorWidget: widget.errorWidget,
                    loadingWidget: widget.loadingWidget,
                    fit: widget.fit ?? BoxFit.fill,
                    color: widget.color,
                    frameBuilder: widget.frameBuilder,
                    loadingBuilder: widget.loadingBuilder,
                    errorBuilder: widget.errorBuilder,
                    semanticLabel: widget.semanticLabel,
                    excludeFromSemantics: widget.excludeFromSemantics,
                    opacity: widget.opacity,
                    colorBlendMode: widget.colorBlendMode,
                    alignment: widget.alignment,
                    repeat: widget.repeat,
                    centerSlice: widget.centerSlice,
                    matchTextDirection: widget.matchTextDirection,
                    gaplessPlayback: widget.gaplessPlayback,
                    filterQuality: widget.filterQuality,
                    isAntiAlias: widget.isAntiAlias,
                    cacheHeight: widget.cacheHeight,
                    cacheWidth: widget.cacheWidth,
                  ),
                )
                : ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.height ?? 72,
                    maxWidth: widget.width ?? 72,
                  ),
                  child: ImageWidget.asset(
                    widget.assetUrl,
                    width: widget.width ?? 72,
                    height: widget.height ?? 72,
                    errorWidget: widget.errorWidget,
                    loadingWidget: widget.loadingWidget,
                    fit: widget.fit ?? BoxFit.fill,
                    color: widget.color,
                    frameBuilder: widget.frameBuilder,
                    errorBuilder: widget.errorBuilder,
                    semanticLabel: widget.semanticLabel,
                    excludeFromSemantics: widget.excludeFromSemantics,
                    opacity: widget.opacity,
                    colorBlendMode: widget.colorBlendMode,
                    alignment: widget.alignment,
                    repeat: widget.repeat,
                    centerSlice: widget.centerSlice,
                    matchTextDirection: widget.matchTextDirection,
                    gaplessPlayback: widget.gaplessPlayback,
                    filterQuality: widget.filterQuality,
                    isAntiAlias: widget.isAntiAlias,
                    cacheHeight: widget.cacheHeight,
                    cacheWidth: widget.cacheWidth,
                  ),
                ))
            : ImageWidget.file(
              widget.imageFile,
              width: widget.width ?? 72,
              height: widget.height ?? 72,
              fit: widget.fit ?? BoxFit.fill,
              color: widget.color,
              frameBuilder: widget.frameBuilder,
              errorBuilder: widget.errorBuilder,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              colorBlendMode: widget.colorBlendMode,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              filterQuality: widget.filterQuality,
              isAntiAlias: widget.isAntiAlias,
              cacheWidth: widget.cacheWidth,
              cacheHeight: widget.cacheHeight,
            );
      case TDImageType.square:
        return widget.imageFile == null
            ? (widget.assetUrl == null
                ? ImageWidget.network(
                  widget.imgUrl,
                  height: widget.height ?? 72,
                  width: widget.width ?? 72,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.cover,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  loadingBuilder: widget.loadingBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                )
                : ImageWidget.asset(
                  widget.assetUrl,
                  width: widget.width ?? 72,
                  height: widget.height ?? 72,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.cover,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                ))
            : ImageWidget.file(
              widget.imageFile,
              width: widget.width ?? 72,
              height: widget.height ?? 72,
              fit: widget.fit ?? BoxFit.cover,
              color: widget.color,
              frameBuilder: widget.frameBuilder,
              errorBuilder: widget.errorBuilder,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              colorBlendMode: widget.colorBlendMode,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              filterQuality: widget.filterQuality,
              isAntiAlias: widget.isAntiAlias,
              cacheWidth: widget.cacheWidth,
              cacheHeight: widget.cacheHeight,
            );
      case TDImageType.roundedSquare:
        return Container(
          height: widget.height ?? 72,
          width: widget.width ?? 72,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child:
              widget.imageFile == null
                  ? (widget.assetUrl == null
                      ? ImageWidget.network(
                        widget.imgUrl,
                        height: widget.height ?? 72,
                        width: widget.width ?? 72,
                        errorWidget: widget.errorWidget,
                        loadingWidget: widget.loadingWidget,
                        fit: widget.fit ?? BoxFit.cover,
                        color: widget.color,
                        frameBuilder: widget.frameBuilder,
                        loadingBuilder: widget.loadingBuilder,
                        errorBuilder: widget.errorBuilder,
                        semanticLabel: widget.semanticLabel,
                        excludeFromSemantics: widget.excludeFromSemantics,
                        opacity: widget.opacity,
                        colorBlendMode: widget.colorBlendMode,
                        alignment: widget.alignment,
                        repeat: widget.repeat,
                        centerSlice: widget.centerSlice,
                        matchTextDirection: widget.matchTextDirection,
                        gaplessPlayback: widget.gaplessPlayback,
                        filterQuality: widget.filterQuality,
                        isAntiAlias: widget.isAntiAlias,
                        cacheHeight: widget.cacheHeight,
                        cacheWidth: widget.cacheWidth,
                      )
                      : ImageWidget.asset(
                        widget.assetUrl,
                        width: widget.width ?? 72,
                        height: widget.height ?? 72,
                        errorWidget: widget.errorWidget,
                        loadingWidget: widget.loadingWidget,
                        fit: widget.fit ?? BoxFit.cover,
                        color: widget.color,
                        frameBuilder: widget.frameBuilder,
                        errorBuilder: widget.errorBuilder,
                        semanticLabel: widget.semanticLabel,
                        excludeFromSemantics: widget.excludeFromSemantics,
                        opacity: widget.opacity,
                        colorBlendMode: widget.colorBlendMode,
                        alignment: widget.alignment,
                        repeat: widget.repeat,
                        centerSlice: widget.centerSlice,
                        matchTextDirection: widget.matchTextDirection,
                        gaplessPlayback: widget.gaplessPlayback,
                        filterQuality: widget.filterQuality,
                        isAntiAlias: widget.isAntiAlias,
                        cacheHeight: widget.cacheHeight,
                        cacheWidth: widget.cacheWidth,
                      ))
                  : ImageWidget.file(
                    widget.imageFile,
                    width: widget.width ?? 72,
                    height: widget.height ?? 72,
                    fit: widget.fit ?? BoxFit.cover,
                    color: widget.color,
                    frameBuilder: widget.frameBuilder,
                    errorBuilder: widget.errorBuilder,
                    semanticLabel: widget.semanticLabel,
                    excludeFromSemantics: widget.excludeFromSemantics,
                    colorBlendMode: widget.colorBlendMode,
                    alignment: widget.alignment,
                    repeat: widget.repeat,
                    centerSlice: widget.centerSlice,
                    matchTextDirection: widget.matchTextDirection,
                    gaplessPlayback: widget.gaplessPlayback,
                    filterQuality: widget.filterQuality,
                    isAntiAlias: widget.isAntiAlias,
                    cacheWidth: widget.cacheWidth,
                    cacheHeight: widget.cacheHeight,
                  ),
        );
      case TDImageType.circle:
        return Container(
          height: widget.height ?? 72,
          width: widget.width ?? 72,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child:
              widget.imageFile == null
                  ? (widget.assetUrl == null
                      ? ImageWidget.network(
                        widget.imgUrl,
                        height: widget.height ?? 72,
                        width: widget.width ?? 72,
                        errorWidget: widget.errorWidget,
                        loadingWidget: widget.loadingWidget,
                        fit: widget.fit ?? BoxFit.cover,
                        color: widget.color,
                        frameBuilder: widget.frameBuilder,
                        loadingBuilder: widget.loadingBuilder,
                        errorBuilder: widget.errorBuilder,
                        semanticLabel: widget.semanticLabel,
                        excludeFromSemantics: widget.excludeFromSemantics,
                        opacity: widget.opacity,
                        colorBlendMode: widget.colorBlendMode,
                        alignment: widget.alignment,
                        repeat: widget.repeat,
                        centerSlice: widget.centerSlice,
                        matchTextDirection: widget.matchTextDirection,
                        gaplessPlayback: widget.gaplessPlayback,
                        filterQuality: widget.filterQuality,
                        isAntiAlias: widget.isAntiAlias,
                        cacheHeight: widget.cacheHeight,
                        cacheWidth: widget.cacheWidth,
                      )
                      : ImageWidget.asset(
                        widget.assetUrl,
                        width: widget.width ?? 72,
                        height: widget.height ?? 72,
                        errorWidget: widget.errorWidget,
                        loadingWidget: widget.loadingWidget,
                        fit: widget.fit ?? BoxFit.cover,
                        color: widget.color,
                        frameBuilder: widget.frameBuilder,
                        errorBuilder: widget.errorBuilder,
                        semanticLabel: widget.semanticLabel,
                        excludeFromSemantics: widget.excludeFromSemantics,
                        opacity: widget.opacity,
                        colorBlendMode: widget.colorBlendMode,
                        alignment: widget.alignment,
                        repeat: widget.repeat,
                        centerSlice: widget.centerSlice,
                        matchTextDirection: widget.matchTextDirection,
                        gaplessPlayback: widget.gaplessPlayback,
                        filterQuality: widget.filterQuality,
                        isAntiAlias: widget.isAntiAlias,
                        cacheHeight: widget.cacheHeight,
                        cacheWidth: widget.cacheWidth,
                      ))
                  : ImageWidget.file(
                    widget.imageFile,
                    width: widget.width ?? 72,
                    height: widget.height ?? 72,
                    errorWidget: widget.errorWidget,
                    loadingWidget: widget.loadingWidget,
                    fit: widget.fit ?? BoxFit.cover,
                    color: widget.color,
                    frameBuilder: widget.frameBuilder,
                    errorBuilder: widget.errorBuilder,
                    semanticLabel: widget.semanticLabel,
                    excludeFromSemantics: widget.excludeFromSemantics,
                    opacity: widget.opacity,
                    colorBlendMode: widget.colorBlendMode,
                    alignment: widget.alignment,
                    repeat: widget.repeat,
                    centerSlice: widget.centerSlice,
                    matchTextDirection: widget.matchTextDirection,
                    gaplessPlayback: widget.gaplessPlayback,
                    filterQuality: widget.filterQuality,
                    isAntiAlias: widget.isAntiAlias,
                    cacheHeight: widget.cacheHeight,
                    cacheWidth: widget.cacheWidth,
                  ),
        );
      case TDImageType.fitWidth:
        return widget.imageFile == null
            ? (widget.assetUrl == null
                ? ImageWidget.network(
                  widget.imgUrl,
                  height: widget.height,
                  width: widget.width,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.fitWidth,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  loadingBuilder: widget.loadingBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                )
                : ImageWidget.asset(
                  widget.assetUrl,
                  width: widget.width,
                  height: widget.height,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: widget.fit ?? BoxFit.fitWidth,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  errorBuilder: widget.errorBuilder,
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  opacity: widget.opacity,
                  colorBlendMode: widget.colorBlendMode,
                  alignment: widget.alignment,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  filterQuality: widget.filterQuality,
                  isAntiAlias: widget.isAntiAlias,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                ))
            : ImageWidget.file(
              widget.imageFile,
              width: widget.width,
              height: widget.height,
              errorWidget: widget.errorWidget,
              loadingWidget: widget.loadingWidget,
              fit: widget.fit ?? BoxFit.fitWidth,
              color: widget.color,
              frameBuilder: widget.frameBuilder,
              errorBuilder: widget.errorBuilder,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              opacity: widget.opacity,
              colorBlendMode: widget.colorBlendMode,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              filterQuality: widget.filterQuality,
              isAntiAlias: widget.isAntiAlias,
              cacheHeight: widget.cacheHeight,
              cacheWidth: widget.cacheWidth,
            );
    }
  }
}
