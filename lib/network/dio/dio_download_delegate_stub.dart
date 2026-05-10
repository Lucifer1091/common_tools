import 'package:dio/dio.dart';

import '../core/index.dart';
import 'dio_download_delegate.dart';

/// Fallback delegate used when no supported platform implementation exists.
class UnsupportedDioDownloadDelegate implements DioDownloadDelegate {
  /// Creates the unsupported delegate.
  const UnsupportedDioDownloadDelegate();

  @override
  Future<void> cleanup({
    required PreparedDownload preparedDownload,
    required NetworkRequest networkRequest,
    bool bestEffort = false,
  }) async {}

  @override
  Future<Response<dynamic>> dispatch({
    required Dio dio,
    required NetworkRequest request,
    required PreparedDownload preparedDownload,
    required Map<String, String> headers,
    required CancelToken? cancelToken,
    required Duration timeout,
  }) {
    throw UnsupportedError('Downloads are not supported on this platform.');
  }

  @override
  Future<DownloadArtifact> finalize({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
    required PreparedDownload preparedDownload,
    required Response<dynamic> response,
  }) {
    throw UnsupportedError('Downloads are not supported on this platform.');
  }

  @override
  bool isStorageError(Object? error) => false;

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
  String? storageErrorMessage(Object? error) => null;
}

/// Creates the fallback download delegate.
DioDownloadDelegate createDioDownloadDelegate() {
  return const UnsupportedDioDownloadDelegate();
}
