part of 'overlays.dart';

/// Enum representing types of bottom sheet dialogs.
enum BottomSheetDialog { dialog, bottomSheet }

class BottomSheets {
  BottomSheets._();

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? header,
    Color? color,
    Duration? duration,
    bool isScrollControlled = false,
    double? maxHeight,
    double? maxWidth,
    required Widget bottomSheet,
    bool showDivider = true,
    bool isDismissible = true,
    bool showTopBar = true,
  }) async {
    SnackBars.closeAllSnackBars();

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
    Widget? header,
    String? title,
    bool showDivider = true,
    bool showTopBar = true,
    required Widget bottomSheet,
  }) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
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
            title != null
                ? Text(title, style: context.titleLarge)
                : const SizedBox(),
            if (showDivider) ...[
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFEFEFEF), height: 1)
            ],
            Expanded(child: bottomSheet),
          ],
        ),
      ),
    );
  }

  /// Shows a bottom sheet or a dialog based on the specified type.
  static Future<dynamic> showBottomSheetOrDialog(
    BuildContext context, {
    required Widget child,
    BottomSheetDialog bottomSheetDialog = BottomSheetDialog.dialog,
  }) {
    if (bottomSheetDialog == BottomSheetDialog.bottomSheet) {
      // Show a bottom sheet.
      return showModalBottomSheet(context: context, builder: (_) => child);
    } else {
      // Show a dialog.
      return Dialogs.show(context, content: child);
    }
  }
}
