import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../extensions/generic/index.dart';
import '../../../index.dart';
import '../text/my_text.dart';
import 'td_notice_bar_style.dart';

class TDNoticeBar extends StatefulWidget {
  const TDNoticeBar({
    super.key,
    this.content,
    this.style,
    this.left,
    this.right,
    this.speed = 50,
    this.interval = 3000,
    this.marquee = false,
    this.direction = Axis.horizontal,
    this.theme = TDNoticeBarTheme.info,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onPrefixTap,
    this.onSuffixTap,
    this.height = 22,
    this.maxLines = 1,
  });

  final Object? content;

  final TDNoticeBarStyle? style;

  /// Left content (custom left content, higher priority than prefixIcon)
  final Widget? left;

  /// Right content (custom right content, higher priority than suffixIcon)
  final Widget? right;

  final bool marquee;

  final double? speed;

  /// Step scrolling interval (milliseconds)
  final int? interval;

  final Axis? direction;

  final TDNoticeBarTheme? theme;

  final IconData? prefixIcon;

  final IconData? suffixIcon;

  final VoidCallback? onTap;

  final VoidCallback? onPrefixTap;

  final VoidCallback? onSuffixTap;

  /// Text height (When using prefixIcon or suffixIcon, the icon size value
  /// is equal to this attribute)
  final double height;

  final int? maxLines;

  @override
  State<StatefulWidget> createState() => _TDNoticeBarState();
}

class _TDNoticeBarState extends State<TDNoticeBar> {
  ScrollController? _scrollController;
  Timer? _timer;
  Size? size0;
  TDNoticeBarStyle? _style;
  Color? _backgroundColor;
  Widget? _left;
  Widget? _right;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _contextKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (widget.speed! < 0) {
      throw Exception('speed must not be less than 0');
    }

    if (widget.interval! <= 0) {
      throw Exception('interval must not be less than 0');
    }

    _scrollController = ScrollController();

    // Initialize the style and left and right widgets
    _init();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      if (widget.marquee) _startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _scrollController?.dispose();
  }

  void _init() {
    if (widget.style != null) {
      _style = widget.style;
    } else {
      _style = TDNoticeBarStyle.generateTheme(theme: widget.theme);
    }

    _backgroundColor = _style!.backgroundColor;
    _setLeftWidget();
    _setRightWidget();
  }

  void _startTimer() {
    if (widget.direction == Axis.horizontal) {
      _scroll();
    } else if (widget.direction == Axis.vertical) {
      _step();
    }
  }

  void _scroll() {
    final scrollDistance =
        _getContentWidth() + (size0!.width - _style!.getPadding.horizontal);

    var remainder = scrollDistance % widget.speed!;
    _scrollController!.jumpTo(0);
    var offset = 0.0 + widget.speed!;

    unawaited(
      _scrollController!.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.linear,
      ),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (offset < scrollDistance - remainder) {
        offset += widget.speed!;
        await _scrollController!.animateTo(
          offset,
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
      } else {
        // If the remaining distance is less than 50, scroll this part first
        // and then scroll the remaining part
        // The time required to scroll the remaining distance
        final time = (remainder / widget.speed! * 1000).round();

        // Scroll the last part (bottom out)
        await _scrollController!.animateTo(
          scrollDistance,
          duration: Duration(milliseconds: time),
          curve: Curves.linear,
        );

        // Back to top (connection)
        _scrollController!.jumpTo(0);

        // Modify the starting position
        offset = widget.speed! - remainder;

        // Calculate the final scrolling distance of the new starting point
        remainder = (scrollDistance - offset) % widget.speed!;

        // Scroll to the new starting point (to make up for the bottoming speed scrolling length)
        await _scrollController!.animateTo(
          offset,
          duration: Duration(milliseconds: 1000 - time),
          curve: Curves.linear,
        );
      }
    });
  }

  void _step() {
    var step = 0;
    var offset = 0.0;
    _timer = Timer.periodic(Duration(milliseconds: widget.interval!), (timer) {
      final time = (widget.height / widget.speed! * 1000).round();
      if (step >= (widget.content.cast<String>()?.length ?? 0)) {
        step = 0;
        offset = 0;
        _scrollController!.jumpTo(0);
      }
      step++;
      // Fixed scroll row height (22)
      offset += widget.height;
      unawaited(
        _scrollController!.animateTo(
          offset,
          duration: Duration(milliseconds: time),
          curve: Curves.linear,
        ),
      );
    });
  }

  Size _getFontSize() {
    String text = widget.content.toString();

    if (widget.content is List<String>) {
      text = widget.content.cast<List<String>>()![0];
    }

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: _style!.getTextStyle),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
      maxLines: widget.marquee ? 1 : widget.maxLines,
    )..layout(maxWidth: size0!.width);

    return textPainter.size;
  }

  void _setLeftWidget() {
    if (widget.prefixIcon != null) {
      _left = Icon(
        widget.prefixIcon,
        color: _style!.leftIconColor,
        size: widget.height,
      );
    }

    if (widget.left != null) _left = widget.left;
  }

  void _setRightWidget() {
    if (widget.suffixIcon != null) {
      _right = Icon(
        widget.suffixIcon,
        color: _style!.rightIconColor,
        size: widget.height,
      );
    }
    if (widget.right != null) {
      _right = widget.right;
    }
  }

  double _getContentWidth() {
    var contentWidth =
        _key.currentContext?.findRenderObject()?.paintBounds.size.width ?? 0;

    if (contentWidth == 0) contentWidth = _getFontSize().width;

    return contentWidth;
  }

  double _getEmptyWidth() {
    return _contextKey.currentContext
            ?.findRenderObject()
            ?.paintBounds
            .size
            .width ??
        (size0!.width - _style!.getPadding.horizontal);
  }

  double _getTextHeight() {
    return _getFontSize().height;
  }

  Widget _contentWidget() {
    var valid = false;
    Widget? textWidget;

    if (widget.content is String) {
      valid = true;
      textWidget = SizedBox(
        height: _getTextHeight(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: _getTextHeight(),
            child: MyText(
              widget.content.cast<String>(),
              style: _style?.getTextStyle,
              maxLines: widget.marquee ? 1 : widget.maxLines,
            ),
          ),
        ),
      );
    }
    if (widget.content is List<String>) {
      valid = true;
      textWidget = SizedBox(
        height: _getTextHeight(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: _getTextHeight(),
            child: MyText(
              widget.content.cast<List<String>>()![0],
              style: _style?.getTextStyle,
              maxLines: 1,
            ),
          ),
        ),
      );
    }

    if (!valid) throw Exception('context must be String or List<String>');

    if (!widget.marquee) return textWidget!;

    Widget? child;

    switch (widget.direction) {
      case Axis.horizontal:
        child = SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(key: _key, height: _getTextHeight(), child: textWidget),
              SizedBox(width: _getEmptyWidth()),
              SizedBox(
                width:
                    _getEmptyWidth() > _getContentWidth()
                        ? _getEmptyWidth()
                        : _getContentWidth(),
                height: _getTextHeight(),
                child: textWidget,
              ),
            ],
          ),
        );
      case Axis.vertical:
        final contents = widget.content! as List<String>;
        child = SizedBox(
          height: widget.height,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < contents.length; i++)
                  SizedBox(
                    height: widget.height,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        contents[i],
                        style: _style!.getTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                SizedBox(
                  key: _key,
                  height: widget.height,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      contents[0],
                      style: _style?.getTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case null:
        child = textWidget;
    }
    return child!;
  }

  @override
  Widget build(BuildContext context) {
    size0 = MediaQuery.of(context).size;
    return Container(
      padding: _style!.getPadding,
      decoration: BoxDecoration(color: _backgroundColor),
      child: Row(
        children: [
          Visibility(
            visible: _left != null,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: _left,
            ).clickable(onTap: widget.onTap),
          ),
          Expanded(
            key: _contextKey,
            child: _contentWidget().clickable(onTap: widget.onTap),
          ),
          Visibility(
            visible: _right != null,
            child: _right!.clickable(onTap: widget.onSuffixTap),
          ),
        ],
      ),
    );
  }
}
