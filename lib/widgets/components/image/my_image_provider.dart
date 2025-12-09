import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../index.dart';

/// The prefix of memory data
const String _base64UriPrefix = 'data:image/';

/// A widget to display all image types for all platforms.
///
/// It does supports `JPEG`, `PNG`, `GIF`, `Animated GIF`, `WebP`, `Animated WebP`, `BMP`, and `WBMP` from [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
///
/// For `SVG`, it uses [flutter_svg](https://pub.dev/packages/flutter_svg)
///
/// It also supports caching image with [cached_network_image](https://pub.dev/packages/cached_network_image)
///
/// It can handle all providers without specifying network, assets or file, just use `imageUri`
///
/// It can work with Icons font & memory image as well
///
/// Example:
///
/// `Assets provider`: `MyImageProvider('assets/image.png')`
///
/// `File provider`: `MyImageProvider('/user/app/image.png')`
///
/// `Network provider`: `MyImageProvider('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')`
///
/// `Icon provider`: `MyImageProvider(Icons.add)`
///
/// `Memory provider`: `MyImageProvider('base64://base64string')`
class MyImageProvider extends StatelessWidget {
  ///
  /// Create image widet base on uri
  ///
  const MyImageProvider(
    this.source, {
    super.key,
    this.scale = 1.0,
    this.frameBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.none,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.cacheWidth,
    this.cacheHeight,
    this.allowDrawingOutsideViewBox = false,
    this.size,
    this.textDirection,
    this.loader,
    this.error,
    this.cache = true,
    this.assetPrefix = 'assets',
    this.colorFilter,
    this.headers,
    this.opacity,
    this.fadeDuration = const Duration(milliseconds: 400),
    this.enableZoom = false,
    this.minZoom = 1,
    this.maxZoom = 4,
    this.enableScaleAnimation = false,
    this.normalScale = 1.0,
    this.hoverScale = 1.05,
  });

  /// Represents the alignment of the image within its container.
  final Alignment alignment;

  /// A boolean property that determines whether the image can be drawn outside its viewBox. Default is `false`.
  final bool allowDrawingOutsideViewBox;

  /// An optional integer property that sets the height of the image cache.
  final int? cacheHeight;

  /// An optional integer property that sets the width of the image cache.
  final int? cacheWidth;

  ///  An optional `Rect` property that defines the center slice of the image.
  final Rect? centerSlice;

  /// An optional `Color` property that sets the color of the image.
  final Color? color;

  /// An optional `BlendMode` property that defines how the image color should blend with the background.
  final BlendMode? colorBlendMode;

  /// A boolean property that determines whether the image is excluded from semantics. Default is `false`.
  final bool excludeFromSemantics;

  /// A `FilterQuality` property that sets the quality of image filtering.
  final FilterQuality filterQuality;

  /// An optional `BoxFit` property that defines how the image should fit within its container.
  final BoxFit fit;

  /// An optional `ImageFrameBuilder` property that defines the frame builder for the image.
  final ImageFrameBuilder? frameBuilder;

  /// A boolean property that determines whether the image should have gapless playback. Default is `false`.
  final bool gaplessPlayback;

  /// An optional double property that sets the height of the image.
  final double? height;

  /// An optional `Widget` property that defines the placeholder widget displayed while the image is loading.
  final Widget? loader;

  /// An optional `Widget` property that defines the error placeholder widget displayed when the image fails to load.
  final Widget? error;

  /// A boolean property that determines whether the image should be cached. Default is `true`.
  /// If false then use [Image.network] else [CachedNetworkImage]
  final bool cache;

  /// An optional `ui.ColorFilter` property that sets the color filter of the image.
  final ui.ColorFilter? colorFilter;

  /// Image source, it can be http url, assets file path (assets path must start with `assets`),
  /// local file or icon data
  final Object? source;

  /// A boolean property that determines whether the image should be anti-aliased.
  /// Default is `false`.
  final bool isAntiAlias;

  /// Indicates whether the image should match the text direction or not.
  final bool matchTextDirection;

  /// Determines how the image should be repeated.
  final ImageRepeat repeat;

  /// The scale to apply to the image.
  final double scale;

  /// The semantic label for the image, used for accessibility.
  final String? semanticLabel;

  /// The width of the image.
  final double? width;

  /// The size of the icon, if the resource is an icon.
  final double? size;

  /// The text direction for the icon, if the resource is an icon.
  final TextDirection? textDirection;

  /// The prefix used for asset images.
  final String assetPrefix;

  final Animation<double>? opacity;

  /// HTTP headers for network image authentication
  final Map<String, String>? headers;

  /// Duration of the fade-in animation for the image.
  final Duration fadeDuration;

  /// Whether zoom functionality is enabled for the image.
  final bool enableZoom;

  /// Scale when not hovered (default 1.0).
  final double minZoom;

  /// Scale to use when hovered (default 4).
  final double maxZoom;

  /// Whether scale animation is enabled for the image on hover.
  final bool enableScaleAnimation;

  /// Scale when not hovered (default 1.0).
  final double normalScale;

  /// Scale to use when hovered (default 1.05).
  final double hoverScale;

  /// Checks if the image is a network image.
  bool get _isNetwork => imageUri.startsWith('http');

  /// Checks if the image is an asset image.
  bool get _isAsset => imageUri.startsWith(assetPrefix);

  /// Checks if the image is an SVG.
  bool get _isSvg => imageUri.endsWith('.svg');

  /// Checks if the image is a base64 memory image.
  bool get _isBase64 => imageUri.startsWith(_base64UriPrefix);

  /// The URI string of the image.
  String get imageUri => source.toString();

  /// The icon data, if the resource is an icon.
  IconData? get icon => source is IconData ? source as IconData? : null;

  /// Create svg image widget.
  ///
  /// For web (without skia enable), it uses [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
  ///
  /// Otherwise it uses [flutter_svg](https://pub.dev/packages/flutter_svg)
  Widget _createSvgImage() {
    if (_isAsset) {
      return SvgPicture.asset(
        imageUri,
        key: key,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        semanticsLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder: loader != null ? (_) => loader! : null,
        errorBuilder: error != null ? (_, _, _) => error! : null,
        colorFilter: _getColorFilter(colorFilter, color, colorBlendMode),
      );
    }

    if (_isNetwork) {
      return SvgPicture.network(
        imageUri,
        key: key,
        fit: fit,
        width: width,
        height: height,
        headers: headers,
        alignment: alignment,
        semanticsLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder: loader != null ? (_) => loader! : null,
        errorBuilder: error != null ? (_, _, _) => error! : null,
        colorFilter: _getColorFilter(colorFilter, color, colorBlendMode),
      );
    }

    return SvgPicture.string(
      imageUri,
      key: key,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: loader != null ? (_) => loader! : null,
      colorFilter: _getColorFilter(colorFilter, color, colorBlendMode),
      errorBuilder: error != null ? (_, _, _) => error! : null,
    );
  }

  /// Create any image type except svg
  Widget? _createOtherImage() {
    final error = (this.error != null ? (_, _, _) => this.error! : null);

    if (_isAsset) {
      return Image.asset(
        imageUri,
        key: key,
        fit: fit,
        filterQuality: filterQuality,
        scale: scale,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
        isAntiAlias: isAntiAlias,
        repeat: repeat,
        centerSlice: centerSlice,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: error,
        frameBuilder: frameBuilder,
        opacity: opacity,
      );
    }

    final bool isFile = !_isNetwork;
    final bool isNetwork = _isNetwork || (isFile && MyPlatform.isWeb);

    String url = imageUri;
    File? file;

    if (isFile) {
      if (source is String) {
        file = File(source! as String);
      } else if (source is XFile) {
        file = File((source! as XFile).path);
      } else {
        file = source! as File;
      }

      if (MyPlatform.isWeb) url = file.path;
    }

    if (isNetwork) {
      if (!cache) {
        return Image.network(
          url,
          key: key,
          fit: fit,
          scale: scale,
          color: color,
          width: width,
          height: height,
          alignment: alignment,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
          isAntiAlias: isAntiAlias,
          repeat: repeat,
          centerSlice: centerSlice,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          headers: headers,
          frameBuilder: frameBuilder,
          loadingBuilder: loader != null ? (_, _, _) => loader! : null,
          errorBuilder: error,
          opacity: opacity,
        );
      }

      return CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        scale: scale,
        placeholder: loader != null ? (_, _) => loader! : null,
        errorWidget: error,
        fadeInDuration: fadeDuration,
        fadeOutDuration: const Duration(milliseconds: 300),
        httpHeaders: headers,
        cacheKey: url,
        maxHeightDiskCache: cacheHeight,
        maxWidthDiskCache: cacheWidth,
        memCacheHeight: cacheHeight,
        memCacheWidth: cacheWidth,
        filterQuality: filterQuality,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
        matchTextDirection: matchTextDirection,
      );
    }

    if (file != null) {
      return Image.file(
        file,
        key: key,
        fit: fit,
        scale: scale,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
        isAntiAlias: isAntiAlias,
        repeat: repeat,
        centerSlice: centerSlice,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        frameBuilder: frameBuilder,
        errorBuilder: error,
        opacity: opacity,
      );
    }

    return null;
  }

  ///
  /// Create image from icon data
  ///
  Widget _createIconImage() {
    return Icon(
      icon,
      size: size,
      color: color,
      textDirection: textDirection,
      blendMode: colorBlendMode,
      semanticLabel: semanticLabel,
    );
  }

  /// Create image from base64 data
  Widget _createBase64Image() {
    final error = (this.error != null ? (_, _, _) => this.error! : null);

    final data = imageUri;
    final bytes = data.base64Bytes;

    return Image.memory(
      bytes,
      key: key,
      fit: fit,
      scale: scale,
      color: color,
      width: width,
      height: height,
      alignment: alignment,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      isAntiAlias: isAntiAlias,
      repeat: repeat,
      centerSlice: centerSlice,
      frameBuilder: frameBuilder,
      errorBuilder: error,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  /// Create image from memory image
  Widget _createMemoryImage() {
    final error = (this.error != null ? (_, _, _) => this.error! : null);

    final Uint8List bytes = source! as Uint8List;

    return Image.memory(
      bytes,
      key: key,
      fit: fit,
      scale: scale,
      color: color,
      width: width,
      height: height,
      alignment: alignment,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      isAntiAlias: isAntiAlias,
      repeat: repeat,
      centerSlice: centerSlice,
      frameBuilder: frameBuilder,
      errorBuilder: error,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ///
  /// Get color filter for svg base on `color` and `colorBlendMode`
  ///
  ui.ColorFilter? _getColorFilter(
    ui.ColorFilter? filter,
    ui.Color? color,
    ui.BlendMode? colorBlendMode,
  ) {
    if (filter != null) return filter;

    if (color != null) {
      return ui.ColorFilter.mode(color, colorBlendMode ?? ui.BlendMode.srcIn);
    }

    return null;
  }

  /// Build widget
  @override
  Widget build(BuildContext context) {
    Widget? image;
    if (source is String) {
      if (_isSvg) {
        image = _createSvgImage();
      } else if (_isBase64) {
        image = _createBase64Image();
      } else {
        image = _createOtherImage();
      }
    } else if (source is XFile || source is File) {
      image = _createOtherImage();
    } else if (source is IconData) {
      image = _createIconImage();
    } else if (source is Uint8List) {
      image = _createMemoryImage();
    }

    if (image == null) {
      return error ?? const NoWidget();
    }

    // Builds the image content with optional zoom functionality.
    Widget imageContent = AnimatedSwitcher(
      duration: fadeDuration,
      child: image,
    );

    if (enableScaleAnimation) {
      imageContent = HoverBuilder(
        builder: (context, hover) {
          return AnimatedScale(
            duration: kDefaultDuration,
            scale: hover ? hoverScale : normalScale,
            child: image,
          );
        },
      );
    }

    // Wraps the image content with InteractiveViewer if zoom is enabled.
    if (enableZoom) {
      imageContent = InteractiveViewer(
        minScale: minZoom,
        maxScale: maxZoom,
        child: imageContent,
      );
    }

    return imageContent;
  }

  /// Precache the image
  static Future<void> precache(
    BuildContext context,
    String imageUri, {
    String assetPrefix = 'assets',
  }) async {
    if (imageUri.endsWith('.svg')) {
      if (imageUri.startsWith(assetPrefix)) {
        final loader = SvgAssetLoader(imageUri);
        await svg.cache.putIfAbsent(
          loader.cacheKey(null),
          () => loader.loadBytes(null),
        );
      } else if (imageUri.startsWith('http')) {
        final loader = SvgNetworkLoader(imageUri);
        await svg.cache.putIfAbsent(
          loader.cacheKey(null),
          () => loader.loadBytes(null),
        );
      }
    } else {
      if (imageUri.startsWith(assetPrefix)) {
        await precacheImage(AssetImage(imageUri), context);
      } else if (imageUri.startsWith('http')) {
        await precacheImage(NetworkImage(imageUri), context);
      }
    }
  }
}

extension $Uint8List on Uint8List {
  /// Convert bytes array into base64 image
  String get base64Image {
    final base64String = base64Encode(this);
    final format = _detectFormat(this);
    return 'data:$format;base64,$base64String';
  }
}

extension $String on String {
  /// Convert base64 image into bytes array
  Uint8List get base64Bytes {
    String normalizedString = this;
    if (normalizedString.contains(',')) {
      normalizedString = normalizedString.split(',')[1];
    }
    return base64Decode(normalizedString);
  }
}

/// Detect the MIME type of an image from its bytes.
///
/// Supports the following formats:
///
/// * JPEG
/// * PNG
/// * GIF
/// * WebP
/// * BMP
/// * TIFF (Intel and Motorola)
/// * ICO
///
/// If the format is not recognized, returns 'image/unknown'.
String _detectFormat(Uint8List bytes) {
  if (bytes.length < 12) {
    return 'image/unknown';
  }

  // Check for JPEG
  if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
    return 'image/jpeg';
  }

  // Check for PNG
  if (bytes[0] == 0x89 &&
      bytes[1] == 0x50 && // P
      bytes[2] == 0x4E && // N
      bytes[3] == 0x47 && // G
      bytes[4] == 0x0D && // CR
      bytes[5] == 0x0A && // LF
      bytes[6] == 0x1A && // EOF
      bytes[7] == 0x0A) {
    // LF
    return 'image/png';
  }

  // Check for GIF
  if (bytes[0] == 0x47 && // G
      bytes[1] == 0x49 && // I
      bytes[2] == 0x46 && // F
      bytes[3] == 0x38 && // 8
      (bytes[4] == 0x37 || bytes[4] == 0x39) && // 7 or 9
      bytes[5] == 0x61) {
    return 'image/gif';
  }

  // Check for WebP
  if (bytes.length > 12 &&
      bytes[8] == 0x57 && // W
      bytes[9] == 0x45 && // E
      bytes[10] == 0x42 && // B
      bytes[11] == 0x50) {
    // P
    return 'image/webp';
  }

  // Check for BMP
  if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
    // BM
    return 'image/bmp';
  }

  // Check for TIFF (Intel)
  if (bytes[0] == 0x49 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x2A &&
      bytes[3] == 0x00) {
    return 'image/tiff';
  }

  // Check for TIFF (Motorola)
  if (bytes[0] == 0x4D &&
      bytes[1] == 0x4D &&
      bytes[2] == 0x00 &&
      bytes[3] == 0x2A) {
    return 'image/tiff';
  }

  // Check for ICO
  if (bytes[0] == 0x00 &&
      bytes[1] == 0x00 &&
      bytes[2] == 0x01 &&
      bytes[3] == 0x00) {
    return 'image/x-icon';
  }

  return 'image/unknown';
}
