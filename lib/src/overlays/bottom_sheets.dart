import 'package:flutter/material.dart';

import '../extensions/context/theme.dart';
import '../extensions/context/typography.dart';
import '../themes/my_colors.dart';
import '../widgets/components/dialog/my_dialog.dart';

/// Enum representing types of bottom sheet dialogs.
enum BottomSheetDialog { dialog, bottomSheet }

class MyBottomSheet {
  MyBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget bottomSheet,
    String? title,
    Widget? header,
    Color? color,
    Duration? duration,
    bool isScrollControlled = false,
    double? maxHeight,
    double? maxWidth,
    bool showDivider = true,
    bool isDismissible = true,
    bool showTopBar = true,
  }) async {
    return showModalBottomSheet<T>(
      isDismissible: isDismissible,
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: color,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? 500,
        maxWidth: maxWidth ?? 500,
      ),
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => buildBottomSheetContent(
        context,
        title: title,
        header: header,
        showDivider: showDivider,
        bottomSheet: bottomSheet,
        showTopBar: showTopBar,
      ),
    );
  }

  static ClipRRect buildBottomSheetContent(
    BuildContext context, {
    required Widget bottomSheet,
    Widget? header,
    String? title,
    bool showDivider = true,
    bool showTopBar = true,
  }) => ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
    child: ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          if (showTopBar)
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 2),
              height: 4,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF958F8F),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          header ?? const SizedBox(),
          if (title != null)
            Text(title, style: context.titleLarge)
          else
            const SizedBox(),
          if (showDivider) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFEFEFEF), height: 1),
          ],
          Expanded(child: bottomSheet),
        ],
      ),
    ),
  );

  /// Shows a bottom sheet or a dialog based on the specified type.
  static Future<dynamic> showBottomSheetOrDialog({
    required BuildContext context,
    required Widget child,
    BottomSheetDialog bottomSheetDialog = BottomSheetDialog.dialog,
    bool floating = false,
  }) {
    if (bottomSheetDialog == BottomSheetDialog.bottomSheet) {
      if (floating) {
        return MyBottomSheet.floating(context: context, builder: (_) => child);
      }
      return showModalBottomSheet(context: context, builder: (_) => child);
    } else {
      // Show a dialog.
      return MyDialog.show(context: context, builder: (_) => child);
    }
  }

  static Future<T?> floating<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? barrierLabel,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
  }) {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final localizations = MaterialLocalizations.of(context);

    return navigator.push(
      BottomSheetRoute<T>(
        builder: builder,
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        isScrollControlled: isScrollControlled,
        barrierLabel: barrierLabel ?? localizations.scrimLabel,
        barrierOnTapHint: localizations.scrimOnTapHint(
          localizations.bottomSheetLabel,
        ),
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        settings: routeSettings,
      ),
    );
  }
}

class BottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  BottomSheetRoute({
    required super.builder,
    required super.isScrollControlled,
    super.capturedThemes,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.shape,
    super.clipBehavior,
    super.constraints,
    super.isDismissible = true,
    super.enableDrag = true,
    super.settings,
  }) : super(
         backgroundColor: Colors.transparent,
         sheetAnimationStyle: const AnimationStyle(
           duration: Duration(milliseconds: 200),
           reverseDuration: Duration(milliseconds: 200),
         ),
       );

  @override
  Widget buildModalBarrier() {
    return Builder(
      builder: (context) {
        final barrierColor = context.themed(
          MyColors.lightScrim,
          MyColors.darkScrim,
        );

        final color = animation!.drive(
          ColorTween(
            begin: barrierColor.withAlpha(0),
            end: barrierColor,
          ).chain(CurveTween(curve: barrierCurve)),
        );

        return AnimatedModalBarrier(
          color: color,
          dismissible: barrierDismissible,
          semanticsLabel: barrierLabel,
          barrierSemanticsDismissible: semanticsDismissible,
        );
      },
    );
  }
}
