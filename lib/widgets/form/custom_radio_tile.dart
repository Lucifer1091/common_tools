import 'package:flutter/material.dart';

class CustomRadioTile<T> extends StatelessWidget {
  // ListTile
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final EdgeInsetsGeometry? contentPadding;
  final VisualDensity? visualDensity;

  // Radio
  final T value;
  final T? selected;
  final void Function(T?)? onChanged;
  final double radioScaleFactor;

  final Color? color;
  final bool isLeading;

  const CustomRadioTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.visualDensity,
    required this.value,
    this.selected,
    this.onChanged,
    this.color,
    this.contentPadding,
    this.radioScaleFactor = 1.0,
    this.isLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        visualDensity: visualDensity,
        leading: isLeading ? _buildRadioButton() : leading,
        title: title,
        subtitle: subtitle,
        selected: value == selected,
        contentPadding: contentPadding,
        minVerticalPadding: 0,
        onTap: () {
          if (onChanged != null && value != selected) {
            onChanged!(value);
          }
        },
        trailing: !isLeading ? _buildRadioButton() : null,
      ),
    );
  }

  Transform _buildRadioButton() {
    return Transform.scale(
      scale: radioScaleFactor,
      child: Radio<T>(
        value: value,
        fillColor: WidgetStateColor.resolveWith(
          (states) => color ?? Colors.black,
        ),
        groupValue: selected,
        onChanged: onChanged,
      ),
    );
  }
}
