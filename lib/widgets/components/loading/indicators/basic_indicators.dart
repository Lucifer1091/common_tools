part of 'my_loader_icon.dart';

class _MyCircleIndicator extends StatelessWidget {
  const _MyCircleIndicator({required this.size, required this.options});

  final double? size;
  final MyLoaderOptions options;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      constraints: BoxConstraints.tight(
        Size.square(size ?? options.size.value),
      ),
      color: options.color ?? context.colorScheme.primary,
      backgroundColor: options.backgroundColor ?? context.colorScheme.secondary,
      strokeWidth: options.strokeWidth,
      strokeCap: options.strokeCap ?? StrokeCap.round,
    );
  }
}

class _MyLinearIndicator extends StatelessWidget {
  const _MyLinearIndicator({
    required this.height,
    required this.borderRadius,
    required this.options,
  });

  final double? height;
  final BorderRadius? borderRadius;
  final MyLoaderOptions options;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: options.backgroundColor ?? context.colorScheme.secondary,
      color: options.color ?? context.colorScheme.primary,
      minHeight: height ?? 8,
      borderRadius: borderRadius ?? MyBorderRadius.medium,
    );
  }
}
