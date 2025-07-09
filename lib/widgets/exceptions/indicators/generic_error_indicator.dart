import '../../../exports/index.dart';

/// Indicates that an unknown error occurred.
class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({
    super.key,
    this.onTryAgain,
    this.title,
    this.message,
    this.scale,
    this.showOnDarkTheme = false,
  });

  final VoidCallback? onTryAgain;
  final String? title;
  final String? message;
  final double? scale;
  final bool showOnDarkTheme;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: title ?? AppStrings.SOMETHING_WENT_WRONG,
        message: message ?? AppStrings.TRY_AGAIN_LATER,
        assetName: AppAssets.UNKNOWN_ERROR,
        onTryAgain: onTryAgain,
        scale: scale ?? 3,
        showOnDarkTheme: showOnDarkTheme,
      );
}
