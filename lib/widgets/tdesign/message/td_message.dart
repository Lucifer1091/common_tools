import 'package:flutter/material.dart';

import '../../../index.dart';
import '../../../constants/shadows.dart';
import '../../../extensions/generic/scope_functions.dart';
import '../../layout/no_widget.dart';
import '../link/td_link.dart';

class MessageLink {
  MessageLink({required this.name, required this.uri, this.color});

  final String name;

  final Uri? uri;

  final Color? color;
}

class MessageMarquee {
  MessageMarquee({this.speed, this.loop, this.delay});

  final int? speed;

  final int? loop;

  final int? delay;
}

enum MessageTheme { info, success, warning, error }

class TDMessage extends StatefulWidget {
  const TDMessage({
    super.key,
    this.closeBtn,
    this.content,
    this.duration = 3000,
    this.icon = true,
    this.link,
    this.marquee,
    this.offset,
    this.theme = MessageTheme.info,
    this.visible = true,
    this.onCloseBtnClick,
    this.onDurationEnd,
    this.onLinkClick,
  });

  final String? content;

  final int? duration;

  final bool? visible;

  final Object? icon;

  final Object? link;

  final Object? closeBtn;

  final MessageMarquee? marquee;

  final List<double>? offset;

  final MessageTheme? theme;

  final VoidCallback? onCloseBtnClick;

  final VoidCallback? onDurationEnd;

  final VoidCallback? onLinkClick;

  @override
  _TDMessageState createState() => _TDMessageState();

  static void showMessage({
    required BuildContext context,
    String? content,
    bool? visible,
    int? duration,
    Object? closeBtn,
    Object? icon,
    Object? link,
    MessageMarquee? marquee,
    List<double>? offset,
    MessageTheme? theme,
    VoidCallback? onCloseBtnClick,
    VoidCallback? onDurationEnd,
    VoidCallback? onLinkClick,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => TDMessage(
            content: content,
            visible: visible,
            duration: duration,
            closeBtn: closeBtn,
            icon: icon,
            link: link,
            marquee: marquee,
            offset: offset,
            theme: theme,
            onDurationEnd: () {
              onDurationEnd?.call();
              overlayEntry.remove();
            },
            onCloseBtnClick: onCloseBtnClick,
            onLinkClick: onLinkClick,
          ),
    );

    overlay.insert(overlayEntry);
  }
}

class _TDMessageState extends State<TDMessage> with TickerProviderStateMixin {
  bool _isVisible = true;
  double _topOffset = 0;
  double initTopOffset = 80;
  double totalWidth = 343;
  AnimationController? animationController;
  bool _isAnimationRunning = false;

  @override
  void initState() {
    super.initState();
    _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
    if (widget.marquee != null) {
      animationController = AnimationController(vsync: this);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _topOffset = widget.offset?[1] ?? initTopOffset;
        });
      }
    });

    if (widget.duration != null && widget.duration! > 0) {
      Future.delayed(Duration(milliseconds: widget.duration!), _closeMessage);
    }

    if (widget.marquee != null) {
      animationController = AnimationController(vsync: this);

      animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.marquee!.speed ?? 10000),
      );
    }
  }

  @override
  void dispose() {
    animationController?.stop();
    animationController?.dispose();
    animationController = null;
    super.dispose();
  }

  void _closeMessage() {
    if (mounted) {
      animationController?.stop();

      setState(() {
        _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
        _isAnimationRunning = false;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _isVisible = false);
          widget.onDurationEnd?.call();
        }
      });
    }
  }

  void startAnimation() {
    if (mounted && animationController != null && !_isAnimationRunning) {
      setState(() => _isAnimationRunning = true);
      if (widget.marquee!.loop == 0) {
        animationController!.forward();
      } else if (widget.marquee!.loop == 1) {
        animationController!.repeat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visible == false) return const NoWidget();

    final leftOffset0 =
        widget.offset?[0] ??
        (MediaQuery.of(context).size.width - totalWidth) / 2;

    Widget getText(BuildContext context) {
      if (widget.marquee == null) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.content ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.content ?? ''),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final textWidth = textPainter.width;

        final containerWidth = calculateTextWidth();

        final animationDuration = Duration(
          milliseconds: widget.marquee!.speed ?? 10000,
        );
        animationController!.duration = animationDuration;

        final tween = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-textWidth, 0),
        );

        if (widget.marquee!.delay != null && widget.marquee!.delay! > 0) {
          Future.delayed(
            Duration(milliseconds: widget.marquee!.delay!),
            startAnimation,
          );
        } else {
          startAnimation();
        }

        return Align(
          child: ClipRect(
            child: SizedBox(
              width: containerWidth,
              child: AnimatedBuilder(
                animation:
                    animationController ?? const AlwaysStoppedAnimation(0),
                builder: (context, child) {
                  final offset = tween.evaluate(
                    animationController ?? const AlwaysStoppedAnimation(0),
                  );
                  return OverflowBox(
                    minWidth: 0,
                    maxWidth: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: offset,
                      child: SizedBox(
                        child: Text(widget.content ?? '', maxLines: 1),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    }

    Widget getIcon(BuildContext context) {
      if (widget.icon != null && widget.icon is Widget) {
        return widget.icon! as Widget;
      } else {
        switch (widget.theme) {
          case MessageTheme.info:
            return Icon(Icons.info_rounded, color: ThemeColors.blue.shade600);
          case MessageTheme.success:
            return Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.success.shade400,
            );
          case MessageTheme.warning:
            return Icon(
              Icons.report_problem_rounded,
              color: ThemeColors.orange.shade400,
            );
          case MessageTheme.error:
            return Icon(
              Icons.report_rounded,
              color: ThemeColors.error.shade500,
            );
          case null:
            return const NoWidget();
        }
      }
    }

    void clickCloseButton() {
      _closeMessage();
      widget.onCloseBtnClick?.call();
    }

    Widget getCloseBtn(BuildContext context) {
      if (widget.closeBtn is Widget) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: widget.closeBtn! as Widget,
        );
      } else if (widget.closeBtn == true) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: const Icon(
            Icons.close_rounded,
            color: Color.fromRGBO(0, 0, 0, 0.4),
          ),
        );
      } else if (widget.closeBtn is String) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: Text(widget.closeBtn! as String),
        );
      } else {
        return const NoWidget();
      }
    }

    void clickLink() {
      widget.onLinkClick?.call();
    }

    Widget getLink(BuildContext context) {
      if (widget.link is MessageLink) {
        return Align(
          child: TDLink(
            label: widget.link.cast<MessageLink>()!.name,
            style: MyLinkStyle.primary,
            uri:
                widget.link.cast<MessageLink>()!.uri ??
                Uri.parse('https://example.com'),
            color:
                widget.link.cast<MessageLink>()!.color ??
                ThemeColors.blue.shade600,
            linkClick: (link) => clickLink(),
          ),
        );
      } else if (widget.link is String) {
        return Align(
          child: GestureDetector(
            onTap: clickLink,
            child: Text(
              widget.link.cast<String>() ?? '',
              style: TextStyle(color: ThemeColors.blue.shade600, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      } else {
        return const NoWidget();
      }
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _topOffset,
      left: leftOffset0,
      child:
          _isVisible
              ? Material(
                color: Colors.transparent,
                child: Container(
                  width: totalWidth,
                  height: 48,
                  padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: MyBoxShadows.middle,
                  ),
                  child: Row(
                    children: [
                      if (widget.icon != false)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                            child: SizedBox(
                              width: 20,
                              height: 22,
                              child: getIcon(context),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: getText(context)),
                            if (widget.link != null)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 40,
                                height: 22,
                                child: getLink(context),
                              ),
                            if (widget.closeBtn != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Align(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: getCloseBtn(context),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : const NoWidget(),
    );
  }

  double calculateTextWidth() {
    double width = totalWidth - 32;

    if (widget.icon != null && widget.icon != false) width -= 30;

    if (widget.link != null) width -= 36;

    if (widget.closeBtn != null) width -= 34;

    return width;
  }
}
