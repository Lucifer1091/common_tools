import '../exports/index.dart';

class AppException implements Exception {
  final String? title;
  final String? detail;

  AppException({
    this.title,
    this.detail,
  }) {
    detail != null
        ? SnackBars.error(
            title: title ?? '',
            message: detail ?? '',
          )
        : SnackBars.error(message: title ?? '');
  }

  factory AppException.error(String title) => AppException(title: title);

  factory AppException.unknownError() => AppException(
        title: 'An Unknown Error occurred.',
      );

  factory AppException.wentWrong() => AppException(
        title: 'Something Went Wrong.',
      );

  @override
  String toString() => '${title ?? ''}${detail != null ? ', $detail' : ''}';
}
