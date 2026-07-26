import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../models/my_picked_file.dart';
import '../core/download_request.dart';
import '../core/network_method.dart';
import '../core/network_request.dart';
import './dio_download_delegate.dart';

/// Creates the web download delegate.
DioDownloadDelegate createDioDownloadDelegate() {
  return const WebDioDownloadDelegate();
}

/// Web download delegate that returns in-memory [MyPickedFile] instances.
class WebDioDownloadDelegate implements DioDownloadDelegate {
  /// Creates the web delegate.
  const WebDioDownloadDelegate();

  @override
  Future<PreparedDownload> prepare({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
  }) async {
    return PreparedDownload(
      suggestedFileName: inferDownloadFileName(request.path),
    );
  }

  @override
  Future<Response<dynamic>> dispatch({
    required Dio dio,
    required NetworkRequest request,
    required PreparedDownload preparedDownload,
    required Map<String, String> headers,
    required CancelToken? cancelToken,
    required Duration timeout,
  }) {
    final Map<String, dynamic> extra = Map<String, dynamic>.from(request.extra);
    return dio.request<List<int>>(
      request.path,
      queryParameters: request.query,
      cancelToken: cancelToken,
      onReceiveProgress: request.onReceiveProgress,
      options: Options(
        method: request.method.value,
        headers: headers,
        sendTimeout: timeout,
        receiveTimeout: timeout,
        validateStatus: (_) => true,
        responseType: ResponseType.bytes,
        extra: extra,
      ),
    );
  }

  @override
  Future<DownloadArtifact> finalize({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
    required PreparedDownload preparedDownload,
    required Response<dynamic> response,
  }) async {
    final Uint8List bytes = _asBytes(response.data);
    final String? mimeType = _mimeTypeFromResponse(response);
    final String fileName =
        filenameFromHeaders(response.headers.map) ??
        preparedDownload.suggestedFileName;

    return DownloadArtifact(
      file: MyPickedFile.fromData(
        bytes,
        mimeType: mimeType,
        name: fileName,
        length: bytes.length,
      ),
      bytesWritten: bytes.length,
    );
  }

  @override
  Future<void> cleanup({
    required PreparedDownload preparedDownload,
    required NetworkRequest networkRequest,
    bool bestEffort = false,
  }) async {}

  @override
  bool isStorageError(Object? error) => false;

  @override
  String? storageErrorMessage(Object? error) => null;

  Uint8List _asBytes(Object? payload) {
    if (payload is Uint8List) {
      return payload;
    }
    if (payload is List<int>) {
      return Uint8List.fromList(payload);
    }
    return Uint8List(0);
  }

  String? _mimeTypeFromResponse(Response<dynamic> response) {
    final String? contentType = response.headers.value(
      Headers.contentTypeHeader,
    );
    if (contentType == null || contentType.trim().isEmpty) {
      return null;
    }
    return contentType.split(';').first.trim();
  }
}
