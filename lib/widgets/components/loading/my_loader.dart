import 'package:flutter/material.dart';
import '../../../index.dart';

class MyLoader extends StatelessWidget {
  const MyLoader({
    super.key,
    this.icon,
    this.gap,
    this.axis = Axis.vertical,
    this.text,
    this.style,
    this.textColor,
    this.refreshWidget,
    this.size = MyLoaderSize.medium,
  });

  final MyLoaderIcon? icon;
  final double? gap;
  final String? text;
  final Color? textColor;
  final TextStyle? style;
  final Widget? refreshWidget;
  final Axis axis;
  final MyLoaderSize size;

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return _contentWidget(context);
    }

    return Wrap(children: [_contentWidget(context)]);
  }

  Widget _contentWidget(BuildContext context) {
    final MyLoaderIcon icon0 = icon ?? MyCircleLoader(size: size.value);
    final Widget indicator = icon0.buildIcon(context);

    if (text == null) {
      return indicator;
    } else if (axis == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [indicator, Gap(_gap()), textWidget(context)],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [indicator, Gap(_gap()), textWidget(context)],
      );
    }
  }

  double _gap() {
    return gap ??
        switch (size) {
          MyLoaderSize.extraLarge => 12,
          MyLoaderSize.large => 12,
          MyLoaderSize.medium => 12,
          MyLoaderSize.small => 6,
          MyLoaderSize.extraSmall => 4,
        };
  }

  TextStyle _getStlye(BuildContext context) {
    return style ??
        switch (size) {
          MyLoaderSize.extraLarge => context.titleLarge,
          MyLoaderSize.large => context.bodyLarge,
          MyLoaderSize.medium => context.bodyMedium,
          MyLoaderSize.small => context.bodySmall,
          MyLoaderSize.extraSmall => context.labelSmall,
        };
  }

  Widget textWidget(BuildContext context) {
    Widget result = MyText(
      text,
      fontWeight: FontWeight.w400,
      style: _getStlye(context).copyWith(
        color: textColor ?? context.colorScheme.foreground,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );

    if (refreshWidget != null) {
      result = Row(
        mainAxisSize: MainAxisSize.min,
        children: [result, const Gap(4), refreshWidget!],
      );
    }

    return result;
  }
}
