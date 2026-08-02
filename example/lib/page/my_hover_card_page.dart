import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyHoverCardPage extends StatelessWidget {
  const MyHoverCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'Hover cards display contextual content when users hover over or long-press an anchor.',
      exampleCodeGroup: 'hover-card',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Basic Hover Card', builder: _basicHoverCard),
            ExampleItem(desc: 'Delayed Hover Card', builder: _delayedHoverCard),
            ExampleItem(desc: 'Long Press Hover Card', builder: _longPressCard),
          ],
        ),
        ExampleModule(
          title: 'My Tooltip',
          children: [
            ExampleItem(desc: 'Basic Tooltip', builder: _basicInfoWidget),
            ExampleItem(desc: 'Rich Message Tooltip', builder: _richInfoWidget),
            ExampleItem(
              desc: 'Custom Tooltip Bubble',
              builder: _customInfoWidget,
            ),
          ],
        ),
      ],
    );
  }

  Widget _basicHoverCard(BuildContext context) {
    return MyHoverCard(
      hoverBuilder: (context) {
        return const _ProfileCard(
          leading: FlutterLogo(),
          title: '@flutter',
          content:
              'The Flutter SDK provides the tools to build beautiful apps for mobile, web, and desktop from a single codebase.',
        );
      },
      child: MyButton(type: MyButtonType.link, text: '@flutter', onTap: () {}),
    );
  }

  Widget _delayedHoverCard(BuildContext context) {
    return MyHoverCard(
      wait: const Duration(milliseconds: 800),
      debounce: const Duration(milliseconds: 250),
      hoverBuilder: (context) {
        return const _ProfileCard(
          title: 'Delayed reveal',
          content:
              'This card waits longer before opening and closes quickly after hover exits.',
        );
      },
      child: MyButton(
        type: MyButtonType.outline,
        text: 'Hover with delay',
        onTap: () {},
      ),
    );
  }

  Widget _longPressCard(BuildContext context) {
    return MyHoverCard(
      hoverBuilder: (context) {
        return const _ProfileCard(
          title: 'Touch friendly',
          content:
              'Hover opens this card on desktop. Long press opens it on touch devices.',
        );
      },
      child: MyButton(
        type: MyButtonType.ghost,
        shape: MyButtonShape.square,
        iconWidget: Icon(
          LucideIcons.info,
          size: 18,
          color: context.colorScheme.primary,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _basicInfoWidget(BuildContext context) {
    return MyTooltip(
      message: 'This action opens contextual details without leaving the page.',
      child: MyButton(
        type: MyButtonType.ghost,
        shape: MyButtonShape.square,
        iconWidget: Icon(
          LucideIcons.info,
          size: 18,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _richInfoWidget(BuildContext context) {
    return MyTooltip(
      richMessage: TextSpan(
        style: context.bodySmall.copyWith(
          color: context.colorScheme.popoverForeground,
        ),
        children: [
          TextSpan(
            text: 'Status: ',
            style: context.bodySmall.copyWith(
              color: context.colorScheme.popoverForeground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: 'Configured with rich inline content.'),
        ],
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.popover,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colorScheme.border),
      ),
      child: MyButton(
        type: MyButtonType.outline,
        iconWidget: Icon(
          LucideIcons.info,
          size: 16,
          color: context.colorScheme.primary,
        ),
        text: 'Rich info',
      ),
    );
  }

  Widget _customInfoWidget(BuildContext context) {
    return MyTooltip(
      message:
          'Custom tooltip surface with tuned spacing, timing, and max width.',
      waitDuration: const Duration(milliseconds: 250),
      showDuration: const Duration(seconds: 6),
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.foreground.withValues(alpha: 0.12),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      textStyle: context.bodySmall.copyWith(
        color: context.colorScheme.primaryForeground,
      ),
      child: MyButton(
        type: MyButtonType.secondary,
        iconWidget: Icon(
          LucideIcons.info,
          size: 16,
          color: context.colorScheme.secondaryForeground,
        ),
        text: 'Custom info',
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.title,
    required this.content,
    this.leading,
  });

  final Widget? leading;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.popover,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: .start,
                  children: [
                    MyText(
                      title,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.popoverForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MyText(
                      content,
                      textAlign: .left,
                      style: context.bodyMedium.copyWith(
                        color: context.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
