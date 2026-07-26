import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../extensions/widget.dart';
import '../../../themes/my_scroll_wrapper.dart';
import '../text/my_text.dart';
import './my_notice_bar_style.dart';

class MyNoticeBar extends StatefulWidget {
  const MyNoticeBar({
    super.key,
    this.content,
    this.style,
    this.left,
    this.right,
    this.speed = 50,
    this.interval = 3000,
    this.marquee = false,
    this.direction = Axis.horizontal,
    this.theme = MyNoticeBarTheme.info,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onPrefixTap,
    this.onSuffixTap,
    this.height = 22,
    this.maxLines = 1,
  });

  final Object? content;

  final MyNoticeBarStyle? style;

  /// Left content (custom left content, higher priority than prefixIcon)
  final Widget? left;

  /// Right content (custom right content, higher priority than suffixIcon)
  final Widget? right;

  final bool marquee;

  final double speed;

  /// Step scrolling interval (milliseconds)
  final int interval;

  final Axis direction;

  final MyNoticeBarTheme theme;

  final IconData? prefixIcon;

  final IconData? suffixIcon;

  final VoidCallback? onTap;

  final VoidCallback? onPrefixTap;

  final VoidCallback? onSuffixTap;

  /// Text height (When using prefixIcon or suffixIcon, the icon size value
  /// is equal to this attribute)
  final double height;

  final int maxLines;

  @override
  State<StatefulWidget> createState() => _MyNoticeBarState();
}

class _MyNoticeBarState extends State<MyNoticeBar> {
  late final ScrollController _scrollController;
  Timer? _timer;
  int _marqueeSession = 0;

  final GlobalKey _contentKey = GlobalKey();
  final GlobalKey _viewportKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _validateConfiguration();
    _scheduleMarqueeRestart();
  }

  @override
  void didUpdateWidget(covariant MyNoticeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validateConfiguration();

    if (_shouldRestartMarquee(oldWidget)) {
      _scheduleMarqueeRestart();
    }
  }

  @override
  void dispose() {
    _stopMarquee();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateConfiguration() {
    final content = widget.content;
    if (content != null && content is! String && content is! List<String>) {
      throw ArgumentError.value(
        content,
        'content',
        'must be a String or List<String>',
      );
    }

    if (widget.speed <= 0) {
      throw ArgumentError.value(
        widget.speed,
        'speed',
        'must be greater than 0',
      );
    }

    if (widget.interval <= 0) {
      throw ArgumentError.value(
        widget.interval,
        'interval',
        'must be greater than 0',
      );
    }

    if (widget.maxLines <= 0) {
      throw ArgumentError.value(
        widget.maxLines,
        'maxLines',
        'must be greater than 0',
      );
    }
  }

  bool _shouldRestartMarquee(MyNoticeBar oldWidget) {
    return oldWidget.content != widget.content ||
        oldWidget.style != widget.style ||
        oldWidget.theme != widget.theme ||
        oldWidget.left != widget.left ||
        oldWidget.right != widget.right ||
        oldWidget.prefixIcon != widget.prefixIcon ||
        oldWidget.suffixIcon != widget.suffixIcon ||
        oldWidget.marquee != widget.marquee ||
        oldWidget.speed != widget.speed ||
        oldWidget.interval != widget.interval ||
        oldWidget.direction != widget.direction ||
        oldWidget.height != widget.height ||
        oldWidget.maxLines != widget.maxLines;
  }

  void _scheduleMarqueeRestart() {
    _stopMarquee();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _restartMarquee();
    });
  }

  void _restartMarquee() {
    _stopMarquee();
    _marqueeSession++;

    if (!widget.marquee || _contents.isEmpty || !_scrollController.hasClients) {
      _safeJumpTo(0);
      return;
    }

    switch (widget.direction) {
      case Axis.horizontal:
        unawaited(_runHorizontalMarquee(_marqueeSession));
      case Axis.vertical:
        if (_contents.length > 1) {
          _runVerticalMarquee(_marqueeSession);
        }
    }
  }

  void _stopMarquee() {
    _marqueeSession++;
    _timer?.cancel();
    _timer = null;
  }

  MyNoticeBarStyle get _style =>
      widget.style ??
      MyNoticeBarStyle.generateTheme(context: context, theme: widget.theme);

  EdgeInsets get _resolvedPadding =>
      _style.getPadding.resolve(Directionality.of(context));

  List<String> get _contents {
    final content = widget.content;
    if (content == null) return const [];
    if (content is String) return [content];
    if (content is List<String>) return content;

    throw StateError('content must be a String or List<String>');
  }

  String get _primaryContent => _contents.isEmpty ? '' : _contents.first;

  Widget? get _leftWidget {
    if (widget.left != null) return widget.left;
    if (widget.prefixIcon == null) return null;

    return Icon(
      widget.prefixIcon,
      color: _style.leftIconColor,
      size: widget.height,
    );
  }

  Widget? get _rightWidget {
    if (widget.right != null) return widget.right;
    if (widget.suffixIcon == null) return null;

    return Icon(
      widget.suffixIcon,
      color: _style.rightIconColor,
      size: widget.height,
    );
  }

  Future<void> _runHorizontalMarquee(int session) async {
    final double scrollDistance = _getContentWidth() + _getEmptyWidth();
    if (scrollDistance <= 0) return;

    _safeJumpTo(0);

    while (mounted &&
        session == _marqueeSession &&
        widget.marquee &&
        widget.direction == Axis.horizontal &&
        _scrollController.hasClients) {
      await _safeAnimateTo(
        scrollDistance,
        duration: _durationForDistance(scrollDistance),
      );

      if (!mounted ||
          session != _marqueeSession ||
          !_scrollController.hasClients) {
        return;
      }

      _safeJumpTo(0);
    }
  }

  void _runVerticalMarquee(int session) {
    int step = 0;

    _timer = Timer.periodic(Duration(milliseconds: widget.interval), (
      timer,
    ) async {
      if (!mounted ||
          session != _marqueeSession ||
          !_scrollController.hasClients) {
        timer.cancel();
        return;
      }

      final int nextStep = step + 1;
      final double offset = nextStep * widget.height;

      await _safeAnimateTo(
        offset,
        duration: _durationForDistance(widget.height),
      );

      if (!mounted ||
          session != _marqueeSession ||
          !_scrollController.hasClients) {
        return;
      }

      if (nextStep >= _contents.length) {
        _safeJumpTo(0);
        step = 0;
      } else {
        step = nextStep;
      }
    });
  }

  Duration _durationForDistance(double distance) {
    final int milliseconds = (distance / widget.speed * 1000).round();
    return Duration(milliseconds: milliseconds <= 0 ? 1 : milliseconds);
  }

  Future<void> _safeAnimateTo(
    double offset, {
    required Duration duration,
    Curve curve = Curves.linear,
  }) async {
    if (!mounted || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final double target = offset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    if ((position.pixels - target).abs() < 0.5) return;

    try {
      await _scrollController.animateTo(
        target,
        duration: duration,
        curve: curve,
      );
    } catch (_) {
      // Ignore scroll errors during disposal or interrupted layout changes.
    }
  }

  void _safeJumpTo(double offset) {
    if (!mounted || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final double target = offset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    if ((position.pixels - target).abs() < 0.5) return;

    try {
      _scrollController.jumpTo(target);
    } catch (_) {
      // Ignore scroll errors during disposal or interrupted layout changes.
    }
  }

  Size _measureText({
    required String text,
    required int maxLines,
    required double maxWidth,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: _style.getTextStyle),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    return textPainter.size;
  }

  double _getViewportWidth() {
    final renderObject = _viewportKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      return renderObject.size.width;
    }

    final width =
        MediaQuery.of(context).size.width - _resolvedPadding.horizontal;
    return width > 0 ? width : 0;
  }

  double _getContentWidth() {
    final renderObject = _contentKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.size.width > 0) {
      return renderObject.size.width;
    }

    return _measureText(
      text: _primaryContent,
      maxLines: 1,
      maxWidth: double.infinity,
    ).width;
  }

  double _getEmptyWidth() {
    final double viewportWidth = _getViewportWidth();
    return viewportWidth > 0 ? viewportWidth : 0;
  }

  double _getTextHeight() {
    return _measureText(
      text: _primaryContent,
      maxLines: widget.marquee ? 1 : widget.maxLines,
      maxWidth: _getViewportWidth(),
    ).height;
  }

  Widget _buildText(
    String text, {
    required int maxLines,
    TextOverflow? overflow,
  }) {
    return MyText(
      text,
      style: _style.getTextStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  Widget _contentWidget() {
    if (_contents.isEmpty) return const SizedBox.shrink();

    final double textHeight = _getTextHeight();
    final Widget baseText = SizedBox(
      height: textHeight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: textHeight,
          child: _buildText(
            _primaryContent,
            maxLines: widget.marquee ? 1 : widget.maxLines,
          ),
        ),
      ),
    );

    if (!widget.marquee) return baseText;

    switch (widget.direction) {
      case Axis.horizontal:
        final double emptyWidth = _getEmptyWidth();
        final double contentWidth = _getContentWidth();

        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(key: _contentKey, height: textHeight, child: baseText),
              SizedBox(width: emptyWidth),
              SizedBox(
                width: emptyWidth > contentWidth ? emptyWidth : contentWidth,
                height: textHeight,
                child: baseText,
              ),
            ],
          ),
        );
      case Axis.vertical:
        return SizedBox(
          height: widget.height,
          child: DisableScrollbar(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final content in _contents)
                    SizedBox(
                      height: widget.height,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildText(
                          content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  SizedBox(
                    key: _contentKey,
                    height: widget.height,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildText(
                        _contents.first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final leftWidget = _leftWidget;
    final rightWidget = _rightWidget;

    return Container(
      padding: _style.getPadding,
      decoration: BoxDecoration(color: _style.backgroundColor),
      child: Row(
        children: [
          if (leftWidget != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: leftWidget,
            ).clickable(onTap: widget.onPrefixTap ?? widget.onTap),
          Expanded(
            key: _viewportKey,
            child: _contentWidget().clickable(onTap: widget.onTap),
          ),
          if (rightWidget != null)
            rightWidget.clickable(onTap: widget.onSuffixTap ?? widget.onTap),
        ],
      ),
    );
  }
}
