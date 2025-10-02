part of 'my_check_box.dart';

class _MyCheckboxIcon extends StatelessWidget {
  const _MyCheckboxIcon({
    required this.size,
    required this.shape,
    this.value,
    this.fillColor,
    this.checkColor,
  });

  final bool? value;
  final double size;
  final MyCheckboxShape shape;
  final Color? fillColor, checkColor;

  @override
  Widget build(BuildContext context) {
    final fill =
        (value ?? true
            ? fillColor ?? context.colorScheme.primary
            : Colors.transparent);
    final border = (value ?? true) ? fill : context.colorScheme.border;

    final Color check;

    if (shape == MyCheckboxShape.check) {
      check = checkColor ?? context.colorScheme.primary;
    } else {
      check = checkColor ?? context.colorScheme.primaryForeground;
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
                : Border.all(color: border, width: 2),
        shape:
            shape == MyCheckboxShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
      ),
      alignment: Alignment.center,
      child: Icon(
        switch (value) {
          true => LucideIcons.check,
          false => null,
          null => LucideIcons.minus,
        },
        color: check,
        size: shape == MyCheckboxShape.check ? size * 0.95 : size * 0.5,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
