part of 'utilities.dart';

/// https://m3.material.io/foundations/layout/understanding-layout/overview
///
/// Layout Breakpoints applied according to the material 3 UI standards
///
/// This will handle devices from mobile to large desktops in portrait,
/// landscape and folded devices
///
/// [showDeviceLogs] when set to true will print exact breakpoints in console
///
class Responsive extends StatelessWidget {
  final Widget compact;
  final Widget? medium;
  final Widget? expanded;
  final Widget? large;
  final Widget? extraLarge;

  final bool showDeviceLogs;

  const Responsive({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
    this.showDeviceLogs = false,
  });

  static bool isCompact(BuildContext context) => context.width < 600;

  static bool isMedium(BuildContext context) =>
      context.width >= 600 && context.width < 840;

  static bool isExpanded(BuildContext context) =>
      context.width >= 840 && context.width < 1200;

  static bool isLarge(BuildContext context) =>
      context.width >= 1200 && context.width < 1600;

  static bool isExtraLarge(BuildContext context) => context.width >= 1600;

  /// Set padding or any thing according to breakpoints
  static T value<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    if (isExtraLarge(context)) {
      return extraLarge ?? large ?? expanded ?? medium ?? compact;
    } else if (isLarge(context)) {
      return large ?? expanded ?? medium ?? compact;
    } else if (isExpanded(context)) {
      return expanded ?? medium ?? compact;
    } else if (isMedium(context)) {
      return medium ?? compact;
    } else {
      return compact;
    }
  }

  /// Call different functions according to breakpoints
  static void callback(
    BuildContext context, {
    required VoidCallback compact,
    VoidCallback? medium,
    VoidCallback? expanded,
    VoidCallback? large,
    VoidCallback? extraLarge,
  }) {
    if (isExtraLarge(context)) {
      return (extraLarge ?? large ?? expanded ?? medium ?? compact)();
    } else if (isLarge(context)) {
      return (large ?? expanded ?? medium ?? compact)();
    } else if (isExpanded(context)) {
      return (expanded ?? medium ?? compact)();
    } else if (isMedium(context)) {
      return (medium ?? compact)();
    } else {
      return compact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _showLog(context);

        if (isExtraLarge(context)) {
          return extraLarge ?? large ?? expanded ?? medium ?? compact;
        } else if (isLarge(context)) {
          return large ?? expanded ?? medium ?? compact;
        } else if (isExpanded(context)) {
          return expanded ?? medium ?? compact;
        } else if (isMedium(context)) {
          return medium ?? compact;
        } else {
          return compact;
        }
      },
    );
  }

  void _showLog(BuildContext context) {
    if (!showDeviceLogs) return;

    // print("context.height : ${context.height}");
    // print("context.width : ${context.width}");
    // print("Get.context!.width : ${Get.context!.width}");
    // print("constraints.minWidth : ${constraints.minWidth}");
    // print("constraints.maxWidth : ${constraints.maxWidth}");

    if (isExtraLarge(context)) {
      log.i(
          "EXTRA LARGE => Width: ${context.width}, Height: ${context.height}");
    } else if (isLarge(context)) {
      log.i("LARGE => Width: ${context.width}, Height: ${context.height}");
    } else if (isExpanded(context)) {
      log.i("EXPANDED => Width: ${context.width}, Height: ${context.height}");
    } else if (isMedium(context)) {
      log.i("MEDIUM => Width: ${context.width}, Height: ${context.height}");
    } else {
      log.i("COMPACT => Width: ${context.width}, Height: ${context.height}");
    }
  }

  static Responsive test() {
    return Responsive(
      showDeviceLogs: true,
      compact: Container(
        color: Colors.red,
        child: const Text('COMPACT'),
      ),
      medium: Container(
        color: Colors.blue,
        child: const Text('MEDIUM'),
      ),
      expanded: Container(
        color: Colors.green,
        child: const Text('EXPANDED'),
      ),
      large: Container(
        color: Colors.yellow,
        child: const Text('LARGE'),
      ),
      extraLarge: Container(
        color: Colors.deepPurpleAccent,
        child: const Text('EXTRA LARGE'),
      ),
    );
  }
}
