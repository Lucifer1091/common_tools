import 'package:example/common_tools_catalog.dart';
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
            onTap: () => _showThemePicker(context),
            type: MyButtonType.primary,
            icon: switch (theme.mode) {
              ThemeMode.system => LucideIcons.monitorSmartphone,
              ThemeMode.light => LucideIcons.sun,
              ThemeMode.dark => LucideIcons.moon,
            },
            text: theme.label,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _showThemePicker(BuildContext context) async {
    final container = ProviderScope.containerOf(context, listen: false);
    final notifier = container.read(themeProvider.notifier);
    final theme = container.read(themeProvider);
    final value = await MyThemePicker.showDialog(
      context: context,
      value: theme.pickerValue,
    );

    if (value != null) notifier.setValue(value);
  }
}
