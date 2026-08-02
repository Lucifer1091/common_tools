import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../common/portal.dart';
import '../button/my_button.dart';
import '../popover/popover.dart';
import '../text/my_text.dart';

class MyBreadcrumb extends StatelessWidget {
  const MyBreadcrumb({
    required this.children,
    super.key,
    this.separator,
    this.spacing = 8,
    this.runSpacing,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textStyle,
    this.currentTextStyle,
    this.separatorColor,
  });

  static const Widget arrowSeparator = MyBreadcrumbSeparator();

  static const Widget slashSeparator = MyBreadcrumbSeparator.slash();

  final List<Widget> children;
  final Widget? separator;
  final double spacing;
  final double? runSpacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextStyle? textStyle;
  final TextStyle? currentTextStyle;
  final Color? separatorColor;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final effectiveTextStyle =
        textStyle ??
        context.bodySmall.copyWith(color: context.colorScheme.mutedForeground);
    final effectiveCurrentTextStyle =
        currentTextStyle ??
        context.bodySmall.copyWith(color: context.colorScheme.foreground);
    final effectiveSeparatorColor =
        separatorColor ?? context.colorScheme.mutedForeground;
    final effectiveSeparator = separator ?? arrowSeparator;

    return Wrap(
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      spacing: 0,
      runSpacing: runSpacing ?? spacing,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: [
        for (var index = 0; index < children.length; index++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: DefaultTextStyle.merge(
                  style: index == children.length - 1
                      ? effectiveCurrentTextStyle
                      : effectiveTextStyle,
                  child: children[index],
                ),
              ),
              if (index < children.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing),
                  child: IconTheme.merge(
                    data: IconThemeData(color: effectiveSeparatorColor),
                    child: DefaultTextStyle.merge(
                      style: effectiveTextStyle.copyWith(
                        color: effectiveSeparatorColor,
                      ),
                      child: effectiveSeparator,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class MyBreadcrumbLink extends StatefulWidget {
  const MyBreadcrumbLink({
    super.key,
    this.child,
    this.text,
    this.onTap,
    this.enabled = true,
    this.normalColor,
    this.hoverColor,
    this.textStyle,
    this.type = MyButtonType.link,
  }) : assert(
         (child != null) ^ (text != null),
         'Provide either child or text, but not both.',
       );

  final Widget? child;
  final String? text;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? normalColor;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final MyButtonType type;

  @override
  State<MyBreadcrumbLink> createState() => _MyBreadcrumbLinkState();
}

class _MyBreadcrumbLinkState extends State<MyBreadcrumbLink> {
  @override
  Widget build(BuildContext context) {
    return MyButton(
      height: 16,
      enabled: widget.enabled,
      type: widget.type,
      padding: EdgeInsets.zero,
      size: MyButtonSize.extraSmall,
      textStyle: widget.textStyle,
      onTap: widget.onTap,
      text: widget.text,
      child: widget.child,
    );
  }
}

class MyBreadcrumbSeparator extends StatelessWidget {
  const MyBreadcrumbSeparator({
    super.key,
    this.icon = LucideIcons.chevronRight,
    this.size = 14,
    this.color,
  }) : slash = null;

  const MyBreadcrumbSeparator.slash({super.key, this.size = 14, this.color})
    : icon = null,
      slash = '/';

  final IconData? icon;
  final String? slash;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? IconTheme.of(context).color;

    if (slash != null) {
      return MyText(
        slash!,
        style: context.bodySmall.copyWith(color: effectiveColor),
      );
    }

    return Icon(icon, size: size, color: effectiveColor);
  }
}

class MyBreadcrumbEllipsis extends StatelessWidget {
  const MyBreadcrumbEllipsis({super.key, this.size = 16, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      LucideIcons.ellipsis,
      size: size,
      color: color ?? context.colorScheme.mutedForeground,
    );
  }
}

class MyBreadcrumbDropdown extends StatefulWidget {
  const MyBreadcrumbDropdown({
    required this.child,
    required this.items,
    super.key,
    this.controller,
    this.anchor,
    this.padding,
    this.showDropdownArrow = true,
  });

  final Widget child;
  final List<Widget> items;
  final MyPopoverController? controller;
  final MyAnchorBase? anchor;
  final EdgeInsetsGeometry? padding;
  final bool showDropdownArrow;

  @override
  State<MyBreadcrumbDropdown> createState() => _MyBreadcrumbDropdownState();
}

class _MyBreadcrumbDropdownState extends State<MyBreadcrumbDropdown> {
  MyPopoverController? _controller;

  MyPopoverController get _effectiveController =>
      widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = MyPopoverController();
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MyBreadcrumbDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _controller)?.removeListener(
        _handleControllerChanged,
      );
      if (widget.controller == null && oldWidget.controller != null) {
        _controller = MyPopoverController();
      } else if (widget.controller != null) {
        _controller?.dispose();
        _controller = null;
      }
      _effectiveController.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = _effectiveController;
    final color = controller.isOpen
        ? context.colorScheme.foreground
        : context.colorScheme.mutedForeground;

    return MyPopover(
      controller: controller,
      anchor:
          widget.anchor ??
          const MyAnchorAuto(
            offset: Offset(0, 4),
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
          ),
      padding: widget.padding ?? const EdgeInsets.all(4),
      popover: (context) => IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.items,
        ),
      ),
      child: MyBreadcrumbLink(
        normalColor: color,
        hoverColor: context.colorScheme.foreground,
        onTap: controller.toggle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
            if (widget.showDropdownArrow) ...[
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: controller.isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 150),
                child: Icon(LucideIcons.chevronDown, size: 14, color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MyBreadcrumbMenuItem extends StatelessWidget {
  const MyBreadcrumbMenuItem({
    super.key,
    this.child,
    this.text,
    this.onTap,
    this.padding,
    this.textStyle,
  }) : assert(
         (child != null) ^ (text != null),
         'Provide either child or text, but not both.',
       );

  final Widget? child;
  final String? text;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      type: MyButtonType.ghost,
      size: MyButtonSize.small,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: onTap,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle.merge(
          style:
              textStyle ??
              context.bodySmall.copyWith(
                color: context.colorScheme.popoverForeground,
              ),
          child: child ?? MyText(text!),
        ),
      ),
    );
  }
}
