import 'package:common_tools/common_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool enabled;
  final bool value;
  final void Function(bool)? onChanged;
  final Color? activeColor, trackColor, thumbColor;

  final double? radius;
  final EdgeInsetsGeometry? padding;

  final String? title;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final double? iconTitleSpacing;
  final bool showSpacer;

  final bool showToggleAfterText;

  const CustomSwitch({
    super.key,
    required this.value,
    this.enabled = true,
    this.onChanged,
    this.activeColor,
    this.trackColor,
    this.thumbColor,
    this.radius,
    this.padding,
    this.title,
    this.titleColor,
    this.titleStyle,
    this.iconTitleSpacing,
    this.showSpacer = false,
    this.showToggleAfterText = false,
  }) : assert(
          titleStyle == null || titleColor == null,
          'Cannot provide both a titleStyle and a titleColor\n'
          'To provide custom, use "titleStyle: TextStyle()".',
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null && !showToggleAfterText) ...[
            buildTitleText(context).flexible(),
          ],
          buildCupertinoSwitch(value),
          if (title != null && showToggleAfterText) ...[
            buildTitleText(context),
          ],
        ],
      ),
    );
  }

  Text buildTitleText(BuildContext context) {
    return Text(
      title!,
      style: titleStyle ??
          context.bodyLarge.copyWith(
            color: enabled ? titleColor ?? Colors.black : Colors.black,
            fontWeight: FontWeight.w400,
          ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  CupertinoSwitch buildCupertinoSwitch(bool value) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      thumbColor: thumbColor ?? Colors.white,
      trackColor: trackColor ?? Colors.grey.shade50,
      activeColor: activeColor ?? Colors.green,
    );
  }

  Widget get spacer => showSpacer
      ? const Spacer()
      : SizedBox(
          width: iconTitleSpacing ?? 12,
        );
}
