import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Duration _bottomSheetEnterDuration = Duration(milliseconds: 250);
const Duration _bottomSheetExitDuration = Duration(milliseconds: 200);

enum SlideTransitionFrom { top, right, left, bottom, center }

/// The route of the Dialog box that pops up by sliding from a certain direction
/// of the screen, such as sliding out the page from the top, bottom, left, or right
class MySlidePopupRoute<T> extends PopupRoute<T> {
  MySlidePopupRoute({
    required this.builder,
    this.barrierLabel,
    this.modalBarrierColor = Colors.black54,
    this.isDismissible = true,
    this.modalBarrierFull = false,
    this.slideTransitionFrom = SlideTransitionFrom.bottom,
    this.modalWidth,
    this.modalHeight,
    this.modalTop = 0,
    this.modalLeft = 0,
    this.open,
    this.opened,
    this.close,
    this.barrierClick,
    this.focusMove = false,
  });

  final WidgetBuilder builder;

  final Color? modalBarrierColor;

  final bool isDismissible;

  final bool modalBarrierFull;

  final SlideTransitionFrom slideTransitionFrom;

  final double? modalWidth;

  final double? modalHeight;

  final double? modalTop;

  final double? modalLeft;

  final VoidCallback? open;

  final VoidCallback? opened;

  final VoidCallback? close;

  /// Mask click event, triggered only when [modalBarrierFull] is false
  final VoidCallback? barrierClick;

  /// Is there an input box that gets the focus and moves as a whole to avoid
  /// the input box being blocked?
  final bool focusMove;

  Color get _barrierColor => modalBarrierColor ?? Colors.black54;

  @override
  Duration get transitionDuration => _bottomSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration => _bottomSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor =>
      modalBarrierFull ? _barrierColor : Colors.transparent;

  var _focusY = 0.0;

  var _focusHeight = 0.0;

  var _lastBottom = 0.0;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final animValue = Easing.standardDecelerate.transform(animation.value);
    return Stack(
      children: [
        if (!modalBarrierFull)
          _getPositionWidget(
            context,
            IgnorePointer(
              child: ColoredBox(
                color: _barrierColor.withAlpha(
                  (animValue * (_barrierColor.a * 255.0).round()).toInt(),
                ),
                child: GestureDetector(
                  onTap: () {
                    barrierClick?.call();
                    if (isDismissible) {
                      Navigator.pop(context);
                    }
                  },
                  onDoubleTap: () {
                    barrierClick?.call();
                    if (isDismissible) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ),
        _getPositionWidget(
          context,
          Align(
            alignment: slideTransitionFromToAlignment(slideTransitionFrom),
            child:
                slideTransitionFrom != SlideTransitionFrom.center
                    ? FractionalTranslation(
                      translation: _getOffset(animValue, slideTransitionFrom),
                      child: ClipRect(
                        clipper: RectClipper(animValue, slideTransitionFrom),
                        child: child,
                      ),
                    )
                    : Transform(
                      transform: Matrix4.diagonal3Values(
                        animValue,
                        animValue,
                        1,
                      ),
                      alignment: Alignment.center,
                      child: child,
                    ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(color: Colors.transparent, child: builder.call(context));
  }

  @override
  TickerFuture didPush() {
    startFocusListener(navigator!.context);
    open?.call();
    animation?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        opened?.call();
      }
    });
    return super.didPush();
  }

  @override
  void dispose() {
    close?.call();
    stopFocusListener(navigator!.context);
    super.dispose();
  }

  /// 监听焦点变化
  void startFocusListener(BuildContext context) {
    FocusManager.instance.addListener(_handleFocusChange);
  }

  /// 停止监听焦点变化
  void stopFocusListener(BuildContext context) {
    FocusManager.instance.removeListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    // 获取当前的焦点节点
    final focusNode = FocusManager.instance.primaryFocus;
    if (focusNode != null && focusNode.context != null) {
      final renderObject = focusNode.context!.findRenderObject();
      if (renderObject is RenderPointerListener) {
        _focusY = renderObject.localToGlobal(Offset.zero).dy;
        _focusHeight = renderObject.size.height;
      }
    }
    (focusNode?.context as Element?)?.markNeedsBuild();
  }

  @override
  bool didPop(T? result) {
    close?.call();
    return super.didPop(result);
  }

  Widget _getPositionWidget(BuildContext context, Widget child) {
    var bottom = 0.0;
    final mediaQuery = MediaQuery.of(context);
    if (slideTransitionFrom == SlideTransitionFrom.bottom) {
      bottom = mediaQuery.viewInsets.bottom;
    } else {
      if ((_focusY + mediaQuery.viewInsets.bottom + _focusHeight) >
          mediaQuery.size.height) {
        bottom =
            -(mediaQuery.size.height -
                (_focusY + mediaQuery.viewInsets.bottom + _focusHeight + 10));
        _lastBottom = bottom;
      } else {
        if (_lastBottom > 0.0) {
          bottom = max(_lastBottom -= 5, 0).toDouble();
        }
      }
    }

    final screenSize = mediaQuery.size;
    final modalTop0 =
        (modalTop ?? 0).clamp(0, screenSize.height).toDouble() -
        (focusMove ? bottom : 0);
    final modalLeft0 = (modalLeft ?? 0).clamp(0, screenSize.width).toDouble();
    final modalHeight0 =
        (modalHeight ?? screenSize.height)
            .clamp(0, screenSize.height - modalTop0)
            .toDouble();
    final modalWidth0 =
        (modalWidth ?? screenSize.width)
            .clamp(0, screenSize.width - modalLeft0)
            .toDouble();

    return Positioned(
      top: modalTop0,
      bottom: screenSize.height - modalTop0 - modalHeight0,
      left: modalLeft0,
      right: screenSize.width - modalLeft0 - modalWidth0,
      child: child,
    );
  }

  Offset _getOffset(double animValue, SlideTransitionFrom slideTransitionFrom) {
    switch (slideTransitionFrom) {
      case SlideTransitionFrom.top:
        return Offset(0, animValue - 1);
      case SlideTransitionFrom.right:
        return Offset(1 - animValue, 0);
      case SlideTransitionFrom.left:
        return Offset(animValue - 1, 0);
      case SlideTransitionFrom.bottom:
        return Offset(0, 1 - animValue);
      case SlideTransitionFrom.center:
        return Offset.zero;
    }
  }
}

Alignment slideTransitionFromToAlignment(SlideTransitionFrom from) {
  switch (from) {
    case SlideTransitionFrom.top:
      return Alignment.topCenter;
    case SlideTransitionFrom.right:
      return Alignment.centerRight;
    case SlideTransitionFrom.left:
      return Alignment.centerLeft;
    case SlideTransitionFrom.bottom:
      return Alignment.bottomCenter;
    case SlideTransitionFrom.center:
      return Alignment.center;
  }
}

class RectClipper extends CustomClipper<Rect> {
  RectClipper(this.animValue, this.slideTransitionFrom);

  final double animValue;
  final SlideTransitionFrom slideTransitionFrom;

  @override
  Rect getClip(Size size) {
    switch (slideTransitionFrom) {
      case SlideTransitionFrom.top:
        return Rect.fromLTWH(
          0,
          size.height * (1 - animValue),
          size.width,
          size.height,
        );
      case SlideTransitionFrom.right:
        return Rect.fromLTWH(0, 0, size.width * animValue, size.height);
      case SlideTransitionFrom.left:
        return Rect.fromLTWH(
          size.width * (1 - animValue),
          0,
          size.width,
          size.height,
        );
      case SlideTransitionFrom.bottom:
        return Rect.fromLTWH(0, 0, size.width, size.height * animValue);
      case SlideTransitionFrom.center:
        return Rect.fromLTWH(0, 0, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return oldClipper != this;
  }
}
