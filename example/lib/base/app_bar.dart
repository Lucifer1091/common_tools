import 'package:common_tools/index.dart';
import 'package:example/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final notifier = ref.read(themeProvider.notifier);

    return AppBar(
      backgroundColor: context.colorScheme.primary,
      titleTextStyle: context.textTheme.titleLarge.copyWith(
        color: context.colorScheme.primaryForeground,
      ),
      title: titleWidget ?? Text(title!),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: MyButton(
            onTap: () {
              notifier.setMode(
                theme.mode == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light,
              );
            },
            type: MyButtonType.primary,
            icon: theme.mode == ThemeMode.light
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: MyButton(
            onTap: () {
              TDPicker.showMultiPicker(
                context,
                title: 'Select Color',
                onConfirm: (selected) {
                  notifier.setColor(MyColorScheme.schemes[selected.first]);
                  Navigator.of(context).pop();
                },
                data: [MyColorScheme.schemes],
              );
            },
            type: MyButtonType.primary,
            text: theme.color.capitalize,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
