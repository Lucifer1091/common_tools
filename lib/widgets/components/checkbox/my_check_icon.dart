part of 'my_check_box.dart';

class _MyCheckboxIcon extends StatelessWidget {
  const _MyCheckboxIcon({
    required this.size,
    required this.shape,
    this.value,
    this.enabled = true,
    this.fillColor,
    this.checkColor,
    this.disabledColor,
  });

  final bool? value;
  final bool enabled;
  final double size;
  final MyCheckboxShape shape;
  final Color? fillColor, checkColor, disabledColor;

  @override
  Widget build(BuildContext context) {
    final disabled = disabledColor ?? context.colorScheme.muted;
    final fill =
        enabled
            ? (value ?? true
                ? fillColor ?? context.colorScheme.primary
                : Colors.transparent)
            : disabled;
    final border =
        enabled
            ? (value ?? true)
                ? fill
                : context.colorScheme.border
            : disabled;

    final Color check;

    if (shape == MyCheckboxShape.check) {
      check =
          enabled
              ? (checkColor ?? context.colorScheme.primary)
              : context.colorScheme.mutedForeground;
    } else {
      check =
          enabled
              ? checkColor ?? context.colorScheme.primaryForeground
              : context.colorScheme.mutedForeground;
    }

    final radius =
        shape == MyCheckboxShape.circle ? null : MyBorderRadius.small;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: shape == MyCheckboxShape.check ? null : fill,
        borderRadius: radius,
        border:
            shape == MyCheckboxShape.check
                ? null
                : Border.all(color: border, width: 1.5),
        shape:
            shape == MyCheckboxShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
      ),
      child: Icon(
        switch (value) {
          true => LucideIcons.check,
          false => null,
          null => LucideIcons.minus,
        },
        color: check,
        size: shape == MyCheckboxShape.check ? null : size * 0.55,
      ),
    );
  }
}
