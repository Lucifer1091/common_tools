import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../exports/index.dart' hide FormData;
import 'api_response_model.dart';
import 'error_handler.dart';

const LogType logType = LogType.none;

enum RequestType { get, post, put, delete, patch }

class DioClient {
  DioClient._();

  static Map<String, String> generateHeaders({
    int? userId,
    int? storeId,
    int? corpCode,
    String? token,
    String? contentType,
  }) {
    Object? screenId;

    try {
      screenId =
          AuthManager.instance.activity.screenId ?? Layout.instance.moduleId;
    } catch (_) {
      screenId = 0;
    }

    if (screenId == 0) screenId = -1;

    Map<String, String> headers = {
      'content-type': contentType ?? 'application/json',
      'currentDate': DateTime.now().toUtcString(),
      if (!AuthManager.instance.isLoggedIn && token == null) ...{
        'Authorization': 'Bearer ',
      } else ...{
        'UserID': '${userId ?? AuthManager.instance.user?.userID}',
        'StoreID': '${storeId ?? AuthManager.instance.store?.storeID}',
        'IsTimeClockFromCloud':
            '${AuthManager.instance.store?.isTimeClockFromCloud ?? true}',
        'corpCode': '${corpCode ?? AuthManager.instance.corpId}',
        'screenID': screenId.toString(),
        'refId': AuthManager.instance.activity.refId ?? '0',
        // 'LevelID': AuthManager.instance.store?.levelID,
        'Authorization': 'Bearer ${token ?? AuthManager.instance.token}',
        'tokenIp': '${AuthManager.instance.deviceInfo?.ipv6}',
      },
    };

    return headers;
  }

  // Request Apis
  static Future<dynamic> request(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    // while sending (uploading) progress
    Function(int total, int progress)? onSendProgress,
    Function? onLoading,
    dynamic data,
    LogType logType = logType,
    String? baseUrl,
    ResponseType? responseType,
    ApiParams? params,
  }) async {
    try {
      if (headers?.isNotEmpty ?? true) AuthManager.instance.getIp();
    } catch (e) {
      log.e(e);
    }

    ApiParams params0 =
        params ??
        ApiParams(
          headers: headers,
          queryParameters: queryParameters,
          onLoading: onLoading,
          data: data,
          logType: logType,
          baseUrl: baseUrl,
          responseType: responseType,
        );

    try {
      Dio dio = Dio(BaseOptions(baseUrl: params0.baseUrl ?? AppUrls.BASE_URL));

      if (!kReleaseMode && params0.logType != LogType.none) {
        dio.interceptors.add(
          DioLogger(
            requestHeader: true,
            requestBody: true,
            compact: true,
            maxWidth: 80,
            logType: params0.logType,
          ),
        );
      }

      // 1) indicate loading state
      await onLoading?.call();
      // 2) try to perform http request
      late Response response;

      if (requestType == RequestType.get) {
        response = await dio.get(
          url,
          onReceiveProgress: onReceiveProgress,
          queryParameters: params0.queryParameters,
          options: Options(
            headers: params0.headers ?? generateHeaders(),
            responseType: params0.responseType,
          ),
        );
      } else if (requestType == RequestType.post) {
        response = await dio.post(
          url,
          data: params0.data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: params0.queryParameters,
          options: Options(
            headers: params0.headers ?? generateHeaders(),
            responseType: params0.responseType,
          ),
        );
      } else if (requestType == RequestType.put) {
        response = await dio.put(
          url,
          data: params0.data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: params0.queryParameters,
          options: Options(
            headers: params0.headers ?? generateHeaders(),
            responseType: params0.responseType,
          ),
        );
      } else if (requestType == RequestType.patch) {
        response = await dio.patch(
          url,
          data: params0.data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: params0.queryParameters,
          options: Options(
            headers: params0.headers ?? generateHeaders(),
            responseType: params0.responseType,
          ),
        );
      } else {
        response = await dio.delete(
          url,
          data: params0.data,
          queryParameters: params0.queryParameters,
          options: Options(
            headers: params0.headers ?? generateHeaders(),
            responseType: params0.responseType,
          ),
        );
      }
      // 3) return response (api done successfully)

      AuthManager.instance.lastResponseStatusCode = response.statusCode;

      return await onSuccess(response);
    } on DioException catch (error) {
      // Prints Api Error
      if (params0.logType != LogType.none) log.e(error);

      _handleDioError(error: error, url: url, onError: onError);
    } on SocketException {
      // No internet connection

      _handleSocketException(url: url, onError: onError);
    } on TimeoutException {
      // Api call went out of time

      _handleTimeoutException(url: url, onError: onError);
    } catch (error) {
      // Prints Api Error
      if (logType != LogType.none) log.e(error);

      // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url, onError: onError, error: error);
    }
  }

  /// POST : To Generate MultiPart Data from Data and Files
  /// [filesAsMap] can be used for each file having different Key
  /// [filesAsList] can be used for array of files having [fileKey] as a Key
  static dynamic formData({
    Map<String, dynamic>? data,
    Map<String, XFile>? filesAsMap,
    Map<String, List<XFile>>? filesAsList,
  }) async {
    try {
      FormData formData = FormData();

      // If Data isNotNull create FormData
      if (data != null) formData = FormData.fromMap(data);

      /// If Files As Map  isNotNull add files in FormData
      if (filesAsMap != null && filesAsMap.isNotEmpty) {
        for (MapEntry<String, XFile> file in filesAsMap.entries) {
          formData.files.add(
            MapEntry(
              file.key,
              UniversalPlatform.isWeb
                  ? MultipartFile.fromBytes(
                    await file.value.readAsBytes(),
                    filename:
                        file.value.name.isNotEmpty
                            ? file.value.name
                            : file.value.path,
                  )
                  : MultipartFile.fromFileSync(file.value.path),
            ),
          );
        }
      }

      // If Files as List isNotNull add files in FormData
      if (filesAsList != null && filesAsList.isNotEmpty) {
        for (var entry in filesAsList.entries) {
          for (XFile file in entry.value) {
            formData.files.add(
              MapEntry(
                entry.key,
                UniversalPlatform.isWeb
                    ? MultipartFile.fromBytes(
                      await file.readAsBytes(),
                      filename: file.name,
                    )
                    : MultipartFile.fromFileSync(file.path),
              ),
            );
          }
        }
      }
      return formData;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// download file
  static download({
    required String url, // file url
    required String savePath, // where to save file
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    required Function onSuccess,
  }) async {
    try {
      Dio dio = Dio(BaseOptions(baseUrl: AppUrls.BASE_URL));

      await dio.download(
        url,
        savePath,
        options: Options(
          receiveTimeout: const Duration(seconds: 999999),
          sendTimeout: const Duration(seconds: 999999),
        ),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  static Future<void> stream<T>({
    required String url,
    String? baseUrl,
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    required void Function(T chunk) onData,
    void Function()? onDone,
    void Function(dynamic error)? onError,
    StreamTransformer<Uint8List, T>? transformer,
  }) async {
    Dio dio = Dio(BaseOptions(baseUrl: baseUrl ?? ''));

    try {
      Response<ResponseBody> response = await dio.request<ResponseBody>(
        url,
        data: data,
        queryParameters: queryParams,
        options: Options(
          responseType: ResponseType.stream,
          method: "GET",
          headers: headers,
        ),
      );

      // Default transformer for UTF-8 text response
      StreamTransformer<Uint8List, T> transformer0 =
          StreamTransformer.fromHandlers(
            handleData: (Uint8List data, EventSink<T> sink) {
              sink.add(utf8.decode(data) as T); // Convert Uint8List to String
            },
          );

      response.data?.stream
          .transform(transformer ?? transformer0)
          .listen(onData, onDone: onDone, onError: onError);
    } catch (e) {
      onError?.call(e);
    }
  }

  /// handle unexpected error
  static _handleUnexpectedException({
    Function(ApiException)? onError,
    required String url,
    required Object error,
  }) {
    if (onError != null) {
      onError(ApiException(message: error.toString(), url: url));
    } else {
      _handleError(error.toString());
    }
  }

  /// handle timeout exception
  static _handleTimeoutException({
    Function(ApiException)? onError,
    required String url,
  }) {
    if (onError != null) {
      onError(
        ApiException(message: AppStrings.SERVER_NOT_RESPONDING, url: url),
      );
    } else {
      _handleError(AppStrings.SERVER_NOT_RESPONDING);
    }
  }

  /// handle socket exception
  static _handleSocketException({
    Function(ApiException)? onError,
    required String url,
  }) {
    if (onError != null) {
      onError(
        ApiException(message: AppStrings.NO_INTERNET_CONNECTION, url: url),
      );
    } else {
      _handleError(AppStrings.NO_INTERNET_CONNECTION);
    }
  }

  /// handle Dio error
  static _handleDioError({
    required DioException error,
    Function(ApiException)? onError,
    required String url,
  }) async {
    // log.w(error.error);
    ApiException? exception;

    if (error.response?.statusCode == 419 &&
        AuthManager.instance.lastResponseStatusCode != 419) {
      AuthManager.instance.lastResponseStatusCode = 419;

      await AuthManager.instance.logout();

      Dialogs.info(
        message: 'Your session has expired. Please login again.',
        panaraDialogType: PanaraDialogType.custom,
        onTapDismiss: () => Get.close(1),
      );

      return;
    }

    if (error.response?.statusCode == 400) {
      String? result =
          error.response?.data['message'] ??
          error.response?.data['failReason'] ??
          error.response?.data['failReason']['message'];

      exception = ApiException(
        url: url,
        message: result ?? AppStrings.SOMETHING_WENT_WRONG,
        response: error.response,
        statusCode: error.response?.statusCode,
      );
    }

    exception ??= ApiException(
      url: url,
      message: ErrorHandler.get(
        error.response?.statusCode,
        body: error.response?.data.toString(),
      ),
      response: error.response,
      statusCode: error.response?.statusCode,
    );

    if (onError != null) {
      return onError(exception);
    } else {
      return handleApiError(exception);
    }
  }

  /// handle error automatically (if user didn't pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason
  static handleApiError(ApiException apiException) {
    String msg = apiException.toString();
    SnackBars.error(message: msg);
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    SnackBars.error(message: msg);
  }

  static void onListening(
    Object? response, {
    ValueChanged? onSuccess,
    ValueChanged<String>? onError,
  }) {
    if (response == null) return;

    if (response is String) {
      _handleOnError(error: response, onError: onError);
      return;
    } else if (response is Map) {
      if (response.isEmpty) return;

      SignalRResponse result = SignalRResponse.fromJson(response);

      try {
        if (result.isSuccess ?? false) {
          onSuccess?.call(result.content);
        } else {
          _handleOnError(error: result.error, onError: onError);
        }
      } catch (e) {
        _handleOnError(error: e.toString(), onError: onError);
      }
    }
  }

  static void _handleOnError({String? error, ValueChanged<String>? onError}) {
    String msg = error ?? 'Something went wrong.';

    if (onError != null) return onError.call(msg);

    SnackBars.error(message: msg);
  }
}

class SignalRResponse {
  SignalRResponse({this.isSuccess, this.error, this.content});

  bool? isSuccess;
  String? error;
  dynamic content;

  SignalRResponse.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    error = json['error'];
    content = json['returnObject'];
  }
}

extension ConvertResponseX on Response {
  dynamic success({VoidCallback? onError}) {
    ApiResponse response = ApiResponse.fromJson(data);
    if (!response.isSuccess) {
      if (onError == null) {
        if (response.failReason is String) {
          SnackBars.error(message: response.failReason ?? '');
        } else {
          SnackBars.error(message: AppStrings.SOMETHING_WENT_WRONG);
        }
      } else {
        onError.call();
      }
    }

    return ApiResponse.fromJson(data).successContents;
  }

  bool isSuccess({String? successMsg, String? errorMsg, String? pattern}) {
    ApiResponse response = ApiResponse.fromJson(data);
    if (response.isSuccess) {
      if (successMsg != null) SnackBars.success(message: successMsg);
    } else {
      if (response.failReason is String) {
        if (pattern == null) {
          SnackBars.error(message: response.failReason ?? '');
        } else {
          if (response.failReason?.toString().contains(pattern) ?? false) {
            SnackBars.error(message: errorMsg ?? response.failReason ?? '');
          }
        }
      } else {
        SnackBars.error(message: AppStrings.SOMETHING_WENT_WRONG);
      }
    }
    return response.isSuccess;
  }

  // TODO : Implement Loading Progress Function
  // void showProgress(received, total) {
  //   if (total != -1) {
  //     log.e((received / total * 100).toStringAsFixed(0) + '%');
  //   }
  // }
  //
  // void onSendProgress(received, total) {
  //   if (total != -1) {
  //     log.e('${(received / total * 100).toStringAsFixed(0)}%');
  //   }
  // }
}
