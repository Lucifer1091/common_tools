import 'package:flutter/material.dart';

import '../../common_tools.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  const CustomRadioGroup({
    required this.items,
    required this.onChanged,
    super.key,
    this.selected,
    this.transformer,
    this.style,
    this.fillColor,
    this.activeColor,
    this.spacer,
    this.physics,
    this.fontSize,
    this.wrapAlignment,
    this.wrap = false,
  });

  final List<T> items;
  final T? selected;
  final String Function(T)? transformer;
  final ValueChanged<T?> onChanged;
  final TextStyle? style;
  final Color? fillColor;
  final Color? activeColor;
  final double? spacer;
  final bool wrap;
  final ScrollPhysics? physics;
  final double? fontSize;
  final WrapAlignment? wrapAlignment;

  @override
  Widget build(BuildContext context) {
    if (!wrap) {
      return ListView.separated(
        shrinkWrap: true,
        physics: physics,
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final T item = items[index];

          return RadioButton(
            label: transformer?.call(item) ?? item.toString(),
            value: item,
            groupValue: selected,
            onChanged: onChanged,
            style: style,
            fillColor: fillColor,
            activeColor: activeColor,
            fontSize: fontSize,
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: spacer ?? 16),
      );
    }

    return Wrap(
      runAlignment: WrapAlignment.center,
      alignment: wrapAlignment ?? WrapAlignment.center,
      spacing: spacer ?? 16,
      children:
          items.map((type) {
            return RadioButton<T>(
              label: transformer?.call(type) ?? type.toString(),
              value: type,
              groupValue: selected,
              onChanged: onChanged,
              style: style,
              fillColor: fillColor,
              activeColor: activeColor,
            );
          }).toList(),
    );
  }
}

class RadioButton<T> extends StatelessWidget {
  const RadioButton({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
    this.groupValue,
    this.style,
    this.fillColor,
    this.activeColor,
    this.fontSize,
  });

  final T? groupValue;
  final T value;
  final ValueChanged<T?> onChanged;
  final String label;
  final TextStyle? style;
  final Color? fillColor;
  final Color? activeColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          visualDensity: VisualDensity.compact,
          splashRadius: 18,
          onChanged: onChanged,
          // fillColor:
          //     fillColor != null
          //         ? WidgetStateProperty.all(fillColor)
          //         : groupValue == value
          //         ? WidgetStateProperty.all(AppColors.blueShade1)
          //         : WidgetStateProperty.all(AppColors.greyShade3),
          // activeColor: activeColor ?? AppColors.blueShade1,
        ),
        GestureDetector(
          onTap: () => onChanged(value),
          child: Text(
            label,
            style:
                style ??
                TextStyle(
                  // color:
                  //     groupValue == value
                  //         ? AppColors.blueShade1
                  //         : AppColors.blackShade4,
                  fontSize: fontSize ?? 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ).mouseRegion,
      ],
    );
  }
}
