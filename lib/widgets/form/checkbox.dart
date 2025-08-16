import 'package:flutter/material.dart';

import '../../index.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    this.size = 24,
    this.value = false,
    this.tristate = false,
    this.enabled = true,
    this.onChanged,
    this.radius,
    this.activeColor,
    this.borderColor,
    this.checkColor,
    this.padding,
    this.title,
    this.titleColor,
    this.titleStyle,
    this.iconTitleSpacing,
    this.showCheckAfterText = true,
    this.showSpacer = false,
  }) : assert(
         titleStyle == null || titleColor == null,
         'Cannot provide both a titleStyle and a titleColor\n'
         'To provide custom, use "titleStyle: TextStyle()".',
       );

  final bool enabled;
  final bool? value;
  final bool tristate;
  final double size;
  final ValueChanged<bool?>? onChanged;

  final Color? activeColor;
  final Color? borderColor;
  final Color? checkColor;

  final double? radius;
  final EdgeInsetsGeometry? padding;

  final String? title;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final double? iconTitleSpacing;
  final bool showSpacer;

  final bool showCheckAfterText;

  @override
  Widget build(BuildContext context) {
    final borderColor = this.borderColor ?? Colors.grey;
    final activeColor =
        enabled ? this.activeColor ?? Colors.blue.shade100 : borderColor;
    final checkColor = this.checkColor ?? Colors.white;

    return Theme(
      data: Theme.of(context).copyWith(
        disabledColor: Colors.transparent,
        unselectedWidgetColor: Colors.transparent,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          onTap: () => enabled ? onChanged?.call(!(value ?? false)) : () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null && !showCheckAfterText) ...[
                _buildTitleText(context).mouseRegion.flexible(),
                spacer,
              ],
              _buildCheckBox(activeColor, checkColor, borderColor).mouseRegion,
              if (title != null && showCheckAfterText) ...[
                spacer,
                _buildTitleText(context).mouseRegion.flexible(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Text _buildTitleText(BuildContext context) {
    return Text(
      title!,
      style:
          titleStyle ??
          context.bodyLarge?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w400,
          ),
      overflow: TextOverflow.ellipsis,
    );
  }

  SizedBox _buildCheckBox(
    Color activeColor,
    Color checkColor,
    Color borderColor,
  ) {
    return SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: size / Checkbox.width,
        child: Checkbox(
          hoverColor: Colors.grey.shade200,
          activeColor: activeColor,
          checkColor: checkColor,
          value: value,
          tristate: tristate,
          side: BorderSide(color: value ?? false ? activeColor : borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 3),
          ),
          onChanged: enabled ? onChanged : (_) {},
        ),
      ),
    );
  }

  Widget get spacer =>
      showSpacer ? const Spacer() : SizedBox(width: iconTitleSpacing ?? 12);
}
