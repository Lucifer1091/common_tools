import 'dart:async';
import 'package:flutter/material.dart';

import '../../../index.dart';
import '../loading/td_circle_indicator.dart';
import '../text/my_text.dart';

enum IconTextDirection { horizontal, vertical }

class TDToast {
  TDToast._();

  static void showText(
    String? text, {
    required BuildContext context,
    Duration duration = TDToast._defaultDisPlayDuration,
    int? maxLines,
    BoxConstraints? constraints,
    bool? preventTap,
    Widget? customWidget,
    Color? backgroundColor,
  }) {
    _showOverlay(
      _TDTextToast(
        text: text,
        maxLines: maxLines,
        constraints: constraints,
        customWidget: customWidget,
      ),
      context: context,
      duration: duration,
      preventTap: preventTap,
      backgroundColor: backgroundColor,
    );
  }

  static void showIconText(
    String? text, {
    required BuildContext context,
    IconData? icon,
    IconTextDirection direction = IconTextDirection.horizontal,
    Duration duration = TDToast._defaultDisPlayDuration,
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
  }) {
    _showOverlay(
      _TDIconTextToast(
        text: text,
        iconData: icon,
        iconTextDirection: direction,
        maxLines: maxLines,
      ),
      context: context,
      duration: duration,
      preventTap: preventTap,
      backgroundColor: backgroundColor,
    );
  }

  static void showSuccess(
    String? text, {
    required BuildContext context,
    IconTextDirection direction = IconTextDirection.horizontal,
    Duration duration = TDToast._defaultDisPlayDuration,
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
  }) {
    _showOverlay(
      _TDIconTextToast(
        text: text,
        iconData: Icons.check_circle_outline_rounded,
        iconTextDirection: direction,
        maxLines: maxLines,
      ),
      context: context,
      duration: duration,
      preventTap: preventTap,
      backgroundColor: backgroundColor,
    );
  }

  /// 警告Toast
  static void showWarning(
    String? text, {
    required BuildContext context,
    IconTextDirection direction = IconTextDirection.horizontal,
    Duration duration = TDToast._defaultDisPlayDuration,
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
  }) {
    _showOverlay(
      _TDIconTextToast(
        text: text,
        iconData: Icons.error_outline_rounded,
        iconTextDirection: direction,
        maxLines: maxLines,
      ),
      context: context,
      duration: duration,
      preventTap: preventTap,
      backgroundColor: backgroundColor,
    );
  }

  static void showFail(
    String? text, {
    required BuildContext context,
    IconTextDirection direction = IconTextDirection.horizontal,
    Duration duration = TDToast._defaultDisPlayDuration,
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
  }) {
    _showOverlay(
      _TDIconTextToast(
        text: text,
        iconData: Icons.cancel_outlined,
        iconTextDirection: direction,
        maxLines: maxLines,
      ),
      context: context,
      duration: duration,
      preventTap: preventTap,
      backgroundColor: backgroundColor,
    );
  }

  static void showLoading({
    required BuildContext context,
    String? text,
    Duration duration = TDToast._infiniteDuration,
    bool? preventTap,
    Widget? customWidget,
    Color? backgroundColor,
  }) {
    _showOverlay(
      _TDToastLoading(text: text, customWidget: customWidget),
      context: context,
      duration: duration,
      preventTap: preventTap,
      backgroundColor: backgroundColor,
    );
  }

  static void showLoadingWithoutText({
    required BuildContext context,
    String? text,
    Duration duration = TDToast._infiniteDuration,
    bool? preventTap,
    Color? backgroundColor,
  }) {
    _showOverlay(
      const _TDToastLoadingWithoutText(),
      context: context,
      duration: duration,
      preventTap: preventTap,
      backgroundColor: backgroundColor,
    );
  }

  static void dismissLoading() {
    _cancel();
  }

  static void _showOverlay(
    Widget? widget, {
    required BuildContext context,
    Duration duration = TDToast._defaultDisPlayDuration,
    bool? preventTap,
    Color? backgroundColor,
  }) {
    _cancel();
    _showing = true;
    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => Center(
            child: AnimatedOpacity(
              opacity: _showing ? 1.0 : 0.0,
              duration:
                  _showing
                      ? const Duration(milliseconds: 100)
                      : const Duration(milliseconds: 200),
              child: widget,
            ),
          ),
    );

    if (preventTap ?? false) {
      _overlayEntry = OverlayEntry(
        builder:
            (BuildContext context) => Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Container(
                color: backgroundColor,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: _showing ? 1.0 : 0.0,
                    duration:
                        _showing
                            ? const Duration(milliseconds: 100)
                            : const Duration(milliseconds: 200),
                    child: widget,
                  ),
                ),
              ),
            ),
      );
    }

    if (_overlayEntry != null) overlayState.insert(_overlayEntry!);

    _startTimer(duration);
  }

  static void _cancel() {
    _timer?.cancel();
    _timer = null;
    _disposeTimer?.cancel();
    _disposeTimer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _showing = false;
  }

  static void _startTimer(Duration duration) {
    _timer?.cancel();
    _disposeTimer?.cancel();
    _timer = Timer(duration, () {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
      _timer = null;
      _disposeTimer = Timer(const Duration(milliseconds: 200), () {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _disposeTimer = null;
      });
    });
  }

  static OverlayEntry? _overlayEntry;
  static bool _showing = false;
  static Timer? _timer;
  static Timer? _disposeTimer;
  static const Duration _defaultDisPlayDuration = Duration(milliseconds: 3000);
  static const Duration _infiniteDuration = Duration(seconds: 99999999);
}

class _TDIconTextToast extends StatelessWidget {
  const _TDIconTextToast({
    this.text,
    this.iconData,
    this.iconTextDirection = IconTextDirection.horizontal,
    this.maxLines,
  });

  final String? text;
  final IconData? iconData;
  final IconTextDirection iconTextDirection;
  final int? maxLines;

  Widget buildHorizontalWidgets(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 191, maxHeight: 94),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        decoration: BoxDecoration(
          color: ThemeColors.neutral.shade900,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            MyText(
              text ?? '',
              style: context.bodyMedium,
              fontWeight: FontWeight.w400,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerticalWidgets(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 136),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColors.neutral.shade900,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            MyText(
              text ?? '',
              style: context.bodyMedium,
              fontWeight: FontWeight.w400,
              maxLines: maxLines ?? 1,
              overflow: TextOverflow.ellipsis,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return iconTextDirection == IconTextDirection.horizontal
        ? buildHorizontalWidgets(context)
        : buildVerticalWidgets(context);
  }
}

class _TDToastLoading extends StatelessWidget {
  const _TDToastLoading({this.text, this.customWidget});
  final String? text;

  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColors.neutral.shade900,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TDCircleIndicator(color: Colors.white, size: 26, lineWidth: 4),
          const SizedBox(height: 8),
          customWidget ??
              MyText(
                text ?? 'loading...',
                style: context.bodyMedium,
                fontWeight: FontWeight.w400,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textColor: Colors.white,
              ),
        ],
      ),
    );
  }
}

class _TDToastLoadingWithoutText extends StatelessWidget {
  const _TDToastLoadingWithoutText();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColors.neutral.shade900,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TDCircleIndicator(color: Colors.white, size: 26, lineWidth: 4),
    );
  }
}

class _TDTextToast extends StatelessWidget {
  const _TDTextToast({
    this.text,
    this.maxLines,
    this.constraints,
    this.customWidget,
  });
  final String? text;

  final int? maxLines;

  final BoxConstraints? constraints;

  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints ?? BoxConstraints(maxWidth: 191),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          color: ThemeColors.neutral.shade900,
          borderRadius: BorderRadius.circular(6),
        ),
        child:
            customWidget ??
            MyText(
              text ?? '',
              style: context.bodyMedium,
              fontWeight: FontWeight.w400,
              maxLines: maxLines ?? 3,
              overflow: TextOverflow.ellipsis,
              textColor: Colors.white,
            ),
      ),
    );
  }
}
