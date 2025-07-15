import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'td_text.dart';

/// 线上字体加载工具
class TDFontLoader {
  TDFontLoader._();

  /// 缓存字体FontLoader,防止重复加载
  static final _record = <String, bool>{};

  /// 加载字体资源
  static Future<bool> load({
    required String name,
    required String fontFamilyUrl,
  }) async {
    try {
      if (!(_record[name] ?? false)) {
        final fontLoader = FontLoader(name)..addFont(
          Future(() {
            final uri = Uri.parse(fontFamilyUrl);
            final bundle = NetworkAssetBundle(uri);
            return bundle.load('');
          }),
        );

        await fontLoader.load();
        _record[name] = true;
      }
      return true;
    } catch (e) {
      debugPrint(
        'TDFontLoader load error, name: $name, fontFamilyUrl: $fontFamilyUrl, e: $e',
      );
    }
    return false;
  }
}

/// 懒加载FontWidget
class TDFontLoaderWidget extends StatefulWidget {
  const TDFontLoaderWidget({
    required this.textWidget,
    required this.fontFamilyUrl,
    super.key,
  });

  final TDText textWidget;

  /// FontFamily的下载地址
  final String fontFamilyUrl;

  @override
  State<TDFontLoaderWidget> createState() => _TDFontLoaderWidgetState();
}

class _TDFontLoaderWidgetState extends State<TDFontLoaderWidget> {
  bool fontFamilyLoaded = false;
  @override
  void initState() {
    super.initState();
    unawaited(loadFont());
  }

  Future<void> loadFont() async {
    if ((widget.textWidget.fontFamily?.fontFamily.isNotEmpty ?? false) &&
        widget.fontFamilyUrl.isNotEmpty) {
      try {
        if (await TDFontLoader.load(
          name: widget.textWidget.fontFamily!.fontFamily,
          fontFamilyUrl: widget.fontFamilyUrl,
        )) {
          setState(() {});
        }
      } catch (e) {
        debugPrint(
          'TDFontLoader loadFont error, data: ${widget.textWidget.data}, fontFamily: ${widget.textWidget.fontFamilyUrl}, e: $e',
        );
      }
    }

    fontFamilyLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return TDText(
      widget.textWidget.data,
      font: widget.textWidget.font,
      fontWeight: widget.textWidget.fontWeight ?? FontWeight.w400,
      fontFamily: widget.textWidget.fontFamily,
      textColor: widget.textWidget.textColor,
      backgroundColor: widget.textWidget.backgroundColor,
      isTextThrough: widget.textWidget.isTextThrough,
      lineThroughColor: widget.textWidget.lineThroughColor,
      package: widget.textWidget.package,
      forceVerticalCenter: widget.textWidget.forceVerticalCenter,
      style: widget.textWidget.style,
      strutStyle: widget.textWidget.strutStyle,
      textAlign: widget.textWidget.textAlign,
      textDirection: widget.textWidget.textDirection,
      locale: widget.textWidget.locale,
      softWrap: widget.textWidget.softWrap,
      overflow: widget.textWidget.overflow,
      textScaler: widget.textWidget.textScaler,
      maxLines: widget.textWidget.maxLines,
      semanticsLabel: widget.textWidget.semanticsLabel,
      textWidthBasis: widget.textWidget.textWidthBasis,
      textHeightBehavior: widget.textWidget.textHeightBehavior,
      isInFontLoader: true,
    );
  }
}
