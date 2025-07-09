import '../../../exports/index.dart';

/// Basic layout for indicating that an exception occurred.
class ExceptionIndicator extends StatelessWidget {
  const ExceptionIndicator({
    required this.title,
    this.titleStyle,
    required this.assetName,
    this.scale = 3,
    this.message,
    this.messageStyle,
    this.onTryAgain,
    this.showOnDarkTheme = false,
    super.key,
  });

  final String title;
  final TextStyle? titleStyle;
  final String? message;
  final TextStyle? messageStyle;
  final String assetName;
  final VoidCallback? onTryAgain;
  final bool showOnDarkTheme;
  final double scale;

  @override
  Widget build(BuildContext context) => Center(
        child: FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SpaceH16(),
              Image.asset(assetName, scale: scale),
              const SpaceH16(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: titleStyle ??
                      context.titleLarge.copyWith(
                        color: showOnDarkTheme
                            ? Colors.white
                            : context.titleLarge.color,
                      ),
                ),
              ),
              if (message != null) ...[
                const SpaceH16(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: messageStyle ??
                        context.bodyMedium.copyWith(
                          color: showOnDarkTheme
                              ? Colors.white
                              : context.bodyMedium.color,
                        ),
                  ),
                ),
              ],
              if (onTryAgain != null) ...[
                const SpaceH16(),
                SizedBox(
                  height: Sizes.HEIGHT_50,
                  width: 200,
                  child: TextButton.icon(
                    onPressed: onTryAgain,
                    icon: const Icon(EneftyIcons.refresh_outline),
                    label: const Text(
                      AppStrings.TRY_AGAIN,
                      style: TextStyle(fontSize: Sizes.HEIGHT_16),
                    ),
                  ),
                ),
              ],
              const SpaceH32(),
            ],
          ),
        ),
      );
}
