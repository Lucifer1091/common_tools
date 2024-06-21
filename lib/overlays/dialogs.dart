part of 'overlays.dart';

class Dialogs {
  Dialogs._();

  static Future<dynamic> show<T>(
    BuildContext context, {
    required Widget content,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return content;
      },
    );
  }

  static Future<dynamic> alert(
    BuildContext context, {
    String? title,
    String? msg,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCloseButton = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Failed'),
          content: Text(msg ?? 'Something went wrong. Please try again later.'),
          actions: [
            if (showCloseButton)
              TextButton(onPressed: onCancel, child: const Text('Cancel')),
            if (onConfirm != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm.call();
                },
                child: const Text('Confirm'),
              ),
          ],
        );
      },
    );
  }
}
