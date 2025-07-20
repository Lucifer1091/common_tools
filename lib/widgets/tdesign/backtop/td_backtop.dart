import 'dart:async';

import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../text/td_text.dart';

enum TDBackTopTheme { light, dark }

enum TDBackTopStyle { circle, halfCircle }

/// Example usage:
///```dart
/// class TDBackTopExample extends StatefulWidget {
///   const TDBackTopExample({super.key});

///   @override
///   State<TDBackTopExample> createState() => _TDBackTopExampleState();
/// }

/// class _TDBackTopExampleState extends State<TDBackTopExample> {
///   bool showBackTop = false;
///   TDBackTopStyle style = TDBackTopStyle.circle;

///   @override
///   Widget build(BuildContext context) {
///     return ScrollControllerBuilder(
///       listener: (controller) {
///         if (controller.offset >= 100) {
///           if (!showBackTop) setState(() => showBackTop = true);
///         } else {
///           if (showBackTop) setState(() => showBackTop = false);
///         }
///       },
///       builder: (BuildContext context, ScrollController controller) {
///         return Visibility(
///           visible: showBackTop,
///           child:
///               style == TDBackTopStyle.halfCircle
///                   ? Positioned(
///                     right: -16,
///                     bottom: 10,
///                     child: TDBackTop(
///                       controller: controller,
///                       theme: TDBackTopTheme.dark,
///                       showText: true,
///                       style: style,
///                     ),
///                   )
///                   : TDBackTop(
///                     controller: controller,
///                     theme: TDBackTopTheme.dark,
///                     showText: true,
///                     style: style,
///                   ),
///         );
///       },
///     );
///   }
/// }
/// ```
///
class TDBackTop extends StatelessWidget {
  const TDBackTop({
    super.key,
    this.controller,
    this.theme = TDBackTopTheme.light,
    this.style = TDBackTopStyle.circle,
    this.showText = false,
    this.onTap,
  });

  final ScrollController? controller;

  final TDBackTopTheme theme;

  final TDBackTopStyle style;

  final bool showText;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller != null && controller!.hasClients) {
          unawaited(
            controller!.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            ),
          );
        }

        onTap?.call();
      },
      child:
          style == TDBackTopStyle.circle
              ? _buildCircleWidget(context)
              : _buildHalfCircleWidget(context),
    );
  }

  Widget _buildCircleWidget(BuildContext context) {
    final color =
        theme == TDBackTopTheme.dark
            ? Colors.white
            : const Color.fromRGBO(0, 0, 0, 0.9);

    return Container(
      width: 48,
      height: 48,
      padding: EdgeInsets.symmetric(vertical: showText ? 6 : 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color:
              theme == TDBackTopTheme.dark
                  ? ThemeColors.neutral.shade900
                  : ThemeColors.neutral.shade400,
          width: 0.5,
        ),
        color:
            theme == TDBackTopTheme.light
                ? Colors.white
                : ThemeColors.neutral.shade900,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.arrow_drop_up_rounded, size: 20, color: color),
            Visibility(
              visible: showText,
              child: TDText(
                'Top',
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfCircleWidget(BuildContext context) {
    final color =
        theme == TDBackTopTheme.dark
            ? Colors.white
            : const Color.fromRGBO(0, 0, 0, 0.9);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 38),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              theme == TDBackTopTheme.light
                  ? Colors.white
                  : ThemeColors.neutral.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(999),
            bottomLeft: Radius.circular(999),
          ),
          border: Border.all(
            color:
                theme == TDBackTopTheme.dark
                    ? Color.fromRGBO(94, 94, 94, 1)
                    : Color.fromRGBO(220, 220, 220, 1),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_drop_up_rounded, size: 22, color: color),
            const SizedBox(width: 2),
            Visibility(
              visible: showText,
              child: SizedBox(
                height: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TDText(
                      'Back',
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TDText(
                      'Top',
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
