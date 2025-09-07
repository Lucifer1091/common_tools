import 'dart:io';

import 'package:flutter/material.dart';

import '../../../index.dart';
import '../../layout/no_widget.dart';

///封装图片加载控件，增加图片加载失败时加载默认图片
class ImageWidget extends StatefulWidget {
  const ImageWidget({
    required this.image,
    required this.fit,
    required this.src,
    super.key,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
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
    this.errorWidget,
    this.loadingWidget,
    this.cacheWidth,
    this.cacheHeight,
    this.assetUrl,
    this.imageFile,
  });

  ImageWidget.network(
    this.src, {
    super.key,
    this.width,
    this.height,
    double scale = 1.0,
    this.errorWidget,
    this.fit = BoxFit.none,
    this.loadingWidget,
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
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    Map<String, String>? headers,
    this.cacheWidth,
    this.assetUrl,
    this.cacheHeight,
    this.imageFile,
  }) : image = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,
         NetworkImage(src ?? '', scale: scale, headers: headers),
       ),
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0);

  ImageWidget.asset(
    this.assetUrl, {
    super.key,
    AssetBundle? bundle,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    double? scale,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit = BoxFit.none,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    String? package,
    this.filterQuality = FilterQuality.low,
    this.cacheWidth,
    this.cacheHeight,
    this.src,
    this.errorWidget,
    this.loadingWidget,
    this.imageFile,
  }) : image = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,
         scale != null
             ? ExactAssetImage(
               assetUrl ?? '',
               bundle: bundle,
               scale: scale,
               package: package,
             )
             : AssetImage(assetUrl ?? '', bundle: bundle, package: package),
       ),
       loadingBuilder = null,
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0);

  ImageWidget.file(
    this.imageFile, {
    super.key,
    double scale = 1.0,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit = BoxFit.none,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.assetUrl,
    this.cacheWidth,
    this.cacheHeight,
    this.errorWidget,
    this.loadingWidget,
    this.src,
  }) : image = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,
         FileImage(imageFile!, scale: scale),
       ),
       loadingBuilder = null,
       assert(alignment != null),
       assert(repeat != null),
       assert(filterQuality != null),
       assert(matchTextDirection != null),
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0),
       assert(isAntiAlias != null);

  /// 图片地址
  final String? src;

  /// 本地图片地址
  final String? assetUrl;

  /// 图片文件路径
  final File? imageFile;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// 加载错误时展示Widget
  final Widget? errorWidget;

  /// 加载中展示Widget
  final Widget? loadingWidget;

  /// 适配样式
  final BoxFit fit;

  /// 以下系统Image属性，释义请参考系统[Image]中注释
  final ImageProvider image;

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

  final int? cacheWidth;

  final int? cacheHeight;
  @override
  State<StatefulWidget> createState() {
    return _StateImageWidget();
  }
}

class _StateImageWidget extends State<ImageWidget> {
  late Image _image;
  late ImageStream _resolve;
  late ImageStreamListener _listener;
  bool error = false;
  bool loading = true;

  @override
  void didUpdateWidget(covariant ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src || oldWidget.assetUrl != widget.assetUrl) {
      initImage();
    }
  }

  void initImage() {
    _image =
        widget.imageFile == null
            ? widget.assetUrl == null
                ? Image.network(
                  widget.src ?? '',
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
                  loadingBuilder: widget.loadingBuilder,
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
                )
                : Image.asset(
                  widget.assetUrl ?? '',
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
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
                )
            : Image.file(
              widget.imageFile!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
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
    _resolve = _image.image.resolve(ImageConfiguration.empty);
    _listener = ImageStreamListener(
      (_, __) {
        if (mounted) {
          setState(() {
            loading = false;
            error = false;
          });
        }
      },
      onChunk: (ImageChunkEvent event) {
        if (!loading) {
          if (mounted) {
            setState(() {
              loading = true;
              error = false;
            });
          }
        }
      },
      onError: (Object exception, StackTrace? stackTrace) {
        if (!error) {
          setState(() {
            error = true;
            loading = false;
          });
        }
      },
    );
    _resolve.addListener(_listener);
  }

  @override
  void initState() {
    super.initState();
    initImage();
  }

  @override
  Widget build(BuildContext context) {
    if (!error && loading) {
      return Container(
        alignment: widget.alignment,
        color: widget.color ?? ThemeColors.neutral.shade100,
        child:
            widget.loadingWidget ??
            Icon(
              Icons.more_horiz_rounded,
              size: 22,
              color: ThemeColors.neutral.shade700,
            ),
      );
    }

    if (error && !loading) {
      return Container(
        alignment: widget.alignment,
        color: widget.color ?? ThemeColors.neutral.shade100,
        child:
            widget.errorWidget ??
            Icon(
              Icons.close_rounded,
              size: 22,
              color: ThemeColors.neutral.shade700,
            ),
      );
    }

    if (!loading && !error) return _image;

    return const NoWidget();
  }

  @override
  void dispose() {
    super.dispose();
    _resolve.removeListener(_listener);
  }
}
