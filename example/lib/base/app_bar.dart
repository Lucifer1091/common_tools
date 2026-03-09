import 'package:common_tools/index.dart';
import 'package:example/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, this.title, this.titleWidget})
    : assert(
        (title != null) ^ (titleWidget != null),
        'Must provide either title or titleWidget',
      );

  final String? title;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeProvider);

    return AppBar(
      backgroundColor: context.colorScheme.primary,
      titleTextStyle: context.textTheme.titleLarge.copyWith(
        color: context.colorScheme.primaryForeground,
      ),
      title: titleWidget ?? Text(title!),
      iconTheme: IconThemeData(color: context.colorScheme.primaryForeground),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: MyButton(
            onTap: () => _showThemeSwitcher(context),
            icon: theme.mode == ThemeMode.light
                ? LucideIcons.sun
                : LucideIcons.moon,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: MyButton(
            onTap: () => _showColorSwitcher(context),
            type: MyButtonType.primary,
            text: theme.color.capitalize,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _showThemeSwitcher(BuildContext context) async {
    await MyBottomSheet.floating(
      context: context,
      builder: (context) {
        return SafeArea(
          minimum: const EdgeInsets.only(bottom: 34),
          child: Consumer(
            builder: (context, ref, _) {
              final theme = ref.watch(themeProvider);
              final notifier = ref.read(themeProvider.notifier);

              return MyThemeSwitcher(
                selectedMode: theme.mode,
                onChanged: notifier.setMode,
                onClose: () => Navigator.of(context).pop(),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showColorSwitcher(BuildContext context) async {
    await MyBottomSheet.floating(
      context: context,
      builder: (context) {
        return SafeArea(
          minimum: const EdgeInsets.only(bottom: 34),
          child: Consumer(
            builder: (context, ref, _) {
              final theme = ref.watch(themeProvider);
              final notifier = ref.read(themeProvider.notifier);

              return MyColorSwitcher(
                selectedColor: theme.color,
                onChanged: notifier.setColor,
                onClose: () => Navigator.of(context).pop(),
              );
            },
          ),
        );
      },
    );
  }
}
