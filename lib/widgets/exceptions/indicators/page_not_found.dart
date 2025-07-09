import '../../../exports/index.dart';

/// Indicates that an unknown error occurred.
class PageNotFoundIndicator extends StatelessWidget {
  const PageNotFoundIndicator({
    super.key,
    this.onTryAgain,
  });

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.white,
        child: ExceptionIndicator(
          title: '404 \nPage Not Found !!',
          message: "The page you are looking for doesn't seem to exist...",
          titleStyle: context.headlineLarge.copyWith(
            color: context.headlineLarge.color,
          ),
          messageStyle: context.titleLarge.copyWith(
            color: context.titleLarge.color,
            fontWeight: FontWeight.w500,
          ),
          assetName: AppAssets.EMPTY_LIST,
          onTryAgain: onTryAgain,
          scale: 1.5,
        ),
      );
}
