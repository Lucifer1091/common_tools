// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import '../core/index.dart';
import 'dio_download_delegate.dart';

/// Creates the native download delegate.
DioDownloadDelegate createDioDownloadDelegate() {
  return const IoDioDownloadDelegate();
}

/// Native/mobile/desktop download delegate backed by `dart:io`.
class IoDioDownloadDelegate implements DioDownloadDelegate {
  /// Creates the native delegate.
  const IoDioDownloadDelegate();

  @override
  Future<PreparedDownload> prepare({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
  }) async {
    final String suggestedFileName = inferDownloadFileName(request.path);
    final String finalPath = await _resolveFinalPath(
      request: request,
      suggestedFileName: suggestedFileName,
    );
    final File destinationFile = File(finalPath);
    final File tempFile = File(_temporaryDownloadPath(finalPath));

    try {
      if (!await destinationFile.parent.exists()) {
        await destinationFile.parent.create(recursive: true);
      }
      if (!request.overwriteExisting && await destinationFile.exists()) {
        throw NetworkException.storage(
          message: 'Destination file already exists: ${destinationFile.path}',
          request: networkRequest,
        );
      }

      await cleanup(
        preparedDownload: PreparedDownload(
          suggestedFileName: suggestedFileName,
          filePath: finalPath,
          tempPath: tempFile.path,
        ),
        networkRequest: networkRequest,
      );

      return PreparedDownload(
        suggestedFileName: suggestedFileName,
        filePath: finalPath,
        tempPath: tempFile.path,
      );
    } on NetworkException {
      rethrow;
    } on FileSystemException catch (error, stackTrace) {
      throw NetworkException.storage(
        message: 'Failed to prepare download destination',
        request: networkRequest,
        cause: error,
        stackTrace: stackTrace,
      );
    }
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
    final String savePath = preparedDownload.tempPath!;
    final Map<String, dynamic> extra = Map<String, dynamic>.from(request.extra);
    return dio.download(
      request.path,
      savePath,
      queryParameters: request.query,
      cancelToken: cancelToken,
      onReceiveProgress: request.onReceiveProgress,
      options: Options(
        headers: headers,
        sendTimeout: timeout,
        receiveTimeout: timeout,
        validateStatus: (_) => true,
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
    final String finalPath = preparedDownload.filePath!;
    final File destinationFile = File(finalPath);
    final File tempFile = File(preparedDownload.tempPath!);

    if (!await tempFile.exists()) {
      throw NetworkException.storage(
        message: 'Temporary download file is missing',
        request: networkRequest,
      );
    }

    final File backupFile = File(_backupDownloadPath(finalPath));
    bool committed = false;

    try {
      if (await destinationFile.exists()) {
        await backupFile.parent.create(recursive: true);
        if (await backupFile.exists()) {
          await backupFile.delete();
        }
        await destinationFile.rename(backupFile.path);
      }

      final File completedFile = await tempFile.rename(destinationFile.path);
      committed = true;
      return DownloadArtifact(
        file: XFile(
          completedFile.path,
          mimeType: _mimeTypeFromResponse(response),
        ),
        filePath: completedFile.path,
        bytesWritten: completedFile.lengthSync(),
      );
    } on FileSystemException catch (error, stackTrace) {
      try {
        await _restoreBackupIfNeeded(
          destinationFile: destinationFile,
          backupFile: backupFile,
        );
      } on FileSystemException {
        // Keep the original write failure as the surfaced error.
      }
      throw NetworkException.storage(
        message: 'Failed to finalize downloaded file',
        request: networkRequest,
        cause: error,
        stackTrace: stackTrace,
      );
    } finally {
      if (committed && await backupFile.exists()) {
        try {
          await backupFile.delete();
        } on FileSystemException {
          // Best-effort cleanup only after a successful commit.
        }
      }
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } on FileSystemException {
          // Best-effort cleanup only.
        }
      }
    }
  }

  @override
  Future<void> cleanup({
    required PreparedDownload preparedDownload,
    required NetworkRequest networkRequest,
    bool bestEffort = false,
  }) async {
    final List<String> candidates = <String>[
      if (preparedDownload.tempPath != null) preparedDownload.tempPath!,
      if (preparedDownload.filePath != null)
        _backupDownloadPath(preparedDownload.filePath!),
    ];

    for (final String candidate in candidates) {
      final File file = File(candidate);
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } on FileSystemException catch (error, stackTrace) {
        if (bestEffort) {
          continue;
        }
        throw NetworkException.storage(
          message: 'Failed to clean up temporary download file',
          request: networkRequest,
          cause: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  @override
  bool isStorageError(Object? error) => error is FileSystemException;

  @override
  String? storageErrorMessage(Object? error) {
    if (error is FileSystemException) {
      return error.message;
    }
    return null;
  }

  Future<String> _resolveFinalPath({
    required DownloadRequest request,
    required String suggestedFileName,
  }) async {
    final String? savePath = request.savePath;
    if (savePath != null && savePath.trim().isNotEmpty) {
      return savePath;
    }

    final Directory tempDirectory = await Directory.systemTemp.createTemp(
      'common_tools_download_',
    );
    return path.join(tempDirectory.path, suggestedFileName);
  }

  Future<void> _restoreBackupIfNeeded({
    required File destinationFile,
    required File backupFile,
  }) async {
    if (!await backupFile.exists()) {
      return;
    }
    if (await destinationFile.exists()) {
      await destinationFile.delete();
    }
    await backupFile.rename(destinationFile.path);
  }

  String _temporaryDownloadPath(String savePath) {
    return '$savePath.part';
  }

  String _backupDownloadPath(String savePath) {
    final String directory = path.dirname(savePath);
    final String fileName = path.basename(savePath);
    return path.join(directory, '$fileName.bak');
  }

  String? _mimeTypeFromResponse(Response<dynamic> response) {
    final String? contentType = response.headers.value(Headers.contentTypeHeader);
    if (contentType == null || contentType.trim().isEmpty) {
      return null;
    }
    return contentType.split(';').first.trim();
  }
}
