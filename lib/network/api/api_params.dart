import 'package:dio/dio.dart';

import 'dio_logger.dart';

class ApiParams {
  final String? baseUrl;
  final Map<String, dynamic>? headers;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Function? onLoading;
  final LogType logType;
  final ResponseType? responseType;

  const ApiParams({
    this.baseUrl,
    this.headers,
    this.data,
    this.queryParameters,
    this.onLoading,
    this.logType = LogType.none,
    this.responseType,
  });
}
