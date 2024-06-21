part of 'overlays.dart';

/// Basic SnackBars called using [key]
/// Need to assign the key in Material App
/// ```dart
/// return MaterialApp(
///      scaffoldMessengerKey: SnackBars.snackbarKey,
///     );
/// ```

class SnackBars {
  SnackBars._();

  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  // 1000 * 3 = 3 secs
  static Duration defaultDuration = Durations.extralong4 * 3;

  static SnackBar _snackBar({
    required String title,
    Duration? duration,
    Color? color,
    IconData? icon,
    Color? iconColor,
    Color? textColor,
  }) {
    return SnackBar(
      duration: duration ?? defaultDuration,
      backgroundColor: color,
      dismissDirection: DismissDirection.none,
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: iconColor ?? Colors.white),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static void success({required String title, Duration? duration}) async {
    closeAllSnackBars();

    key.currentState?.showSnackBar(_snackBar(
      title: title,
      duration: duration,
      color: Colors.green,
      icon: Icons.check_circle_outline_rounded,
    ));
  }

  static void error({required String title, Duration? duration}) async {
    closeAllSnackBars();

    key.currentState?.showSnackBar(_snackBar(
      title: title,
      duration: duration,
      color: Colors.red,
      icon: Icons.warning_amber_rounded,
    ));
  }

  static void info({required String title, Duration? duration}) async {
    closeAllSnackBars();

    key.currentState?.showSnackBar(_snackBar(
      title: title,
      duration: duration,
      color: Colors.blue,
      icon: Icons.help_outline_outlined,
    ));
  }

  static void closeAllSnackBars() {
    key.currentState?.clearSnackBars();
  }
}
