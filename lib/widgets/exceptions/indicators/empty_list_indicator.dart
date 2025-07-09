import '../../../exports/index.dart';

/// Indicates that no items were found.
class EmptyListIndicator extends StatelessWidget {
  final String? title;
  final String? message;

  final VoidCallback? onTryAgain;
  final double scale;
  final bool showOnDarkTheme;
  final TextStyle? titleStyle;

  const EmptyListIndicator({
    super.key,
    this.onTryAgain,
    this.title,
    this.message,
    this.scale = 3,
    this.showOnDarkTheme = false,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: title ?? AppStrings.NO_RECORDS_FOUND,
        message: message ??
            'If using a custom view, try adjusting the filters.\n'
                'Otherwise, create some data !',
        assetName: AppAssets.EMPTY_LIST,
        onTryAgain: onTryAgain,
        scale: scale,
        showOnDarkTheme: showOnDarkTheme,
        titleStyle: titleStyle,
      );
}
