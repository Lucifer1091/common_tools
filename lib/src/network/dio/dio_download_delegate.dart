import 'package:dio/dio.dart';

import '../../models/my_picked_file.dart';
import '../core/download_request.dart';
import '../core/network_request.dart';
import 'dio_download_delegate_stub.dart'
    if (dart.library.io) 'dio_download_delegate_io.dart'
    if (dart.library.js_interop) 'dio_download_delegate_web.dart'
    if (dart.library.html) 'dio_download_delegate_web.dart'
    as delegate_impl;

/// Creates the platform-specific download delegate.
DioDownloadDelegate createDioDownloadDelegate() {
  return delegate_impl.createDioDownloadDelegate();
}

/// Platform-specific download adapter used by the Dio network client.
abstract interface class DioDownloadDelegate {
  /// Prepares any platform-specific download target before dispatch.
  Future<PreparedDownload> prepare({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
  });

  /// Performs the platform-specific transport operation.
  Future<Response<dynamic>> dispatch({
    required Dio dio,
    required NetworkRequest request,
    required PreparedDownload preparedDownload,
    required Map<String, String> headers,
    required CancelToken? cancelToken,
    required Duration timeout,
  });

  /// Converts a completed response into a platform-independent artifact.
  Future<DownloadArtifact> finalize({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
    required PreparedDownload preparedDownload,
    required Response<dynamic> response,
  });

  /// Cleans up any temporary download resources.
  Future<void> cleanup({
    required PreparedDownload preparedDownload,
    required NetworkRequest networkRequest,
    bool bestEffort = false,
  });

  /// Returns `true` when the platform considers [error] a storage failure.
  bool isStorageError(Object? error);

  /// Builds a readable storage error message for [error] when possible.
  String? storageErrorMessage(Object? error);
}

/// Prepared platform-specific download target information.
class PreparedDownload {
  /// Creates prepared download target metadata.
  const PreparedDownload({
    required this.suggestedFileName,
    this.filePath,
    this.tempPath,
  });

  /// Suggested file name used for temporary/native or in-memory/web outputs.
  final String suggestedFileName;

  /// Final on-disk path when the platform writes to disk.
  final String? filePath;

  /// Temporary download path when the platform needs a staging file.
  final String? tempPath;
}

/// Completed platform-specific download artifact.
class DownloadArtifact {
  /// Creates a completed artifact.
  const DownloadArtifact({
    required this.file,
    required this.bytesWritten,
    this.filePath,
  });

  /// Cross-platform file abstraction for the completed download.
  final MyPickedFile file;

  /// Final on-disk path when the download is persisted locally.
  final String? filePath;

  /// Number of bytes written into the artifact.
  final int bytesWritten;
}

/// Infers a stable fallback file name from [requestPath].
String inferDownloadFileName(String requestPath) {
  final Uri? uri = Uri.tryParse(requestPath);
  if (uri != null && uri.pathSegments.isNotEmpty) {
    final String candidate = uri.pathSegments.last.trim();
    if (candidate.isNotEmpty) {
      return candidate;
    }
  }

  final String sanitizedPath = requestPath.trim();
  if (sanitizedPath.isEmpty) {
    return 'download';
  }

  final List<String> rawSegments = sanitizedPath.split(RegExp(r'[\\/]+'));
  for (final String segment in rawSegments.reversed) {
    final String candidate = segment.trim();
    if (candidate.isNotEmpty) {
      return candidate;
    }
  }

  return 'download';
}

/// Extracts a filename hint from response headers when available.
String? filenameFromHeaders(Map<String, List<String>> headers) {
  final String? rawHeader = headers['content-disposition']?.first;
  if (rawHeader == null || rawHeader.trim().isEmpty) {
    return null;
  }

  final RegExp encodedPattern = RegExp(
    r'''filename\*\s*=\s*([^']*)''([^;]+)''',
    caseSensitive: false,
  );
  final RegExpMatch? encodedMatch = encodedPattern.firstMatch(rawHeader);
  if (encodedMatch != null) {
    final String encodedName = encodedMatch.group(2) ?? '';
    final String decodedName = Uri.decodeFull(encodedName).trim();
    if (decodedName.isNotEmpty) {
      return decodedName;
    }
  }

  final RegExp quotedPattern = RegExp(
    r'''filename\s*=\s*"([^"]+)"''',
    caseSensitive: false,
  );
  final RegExpMatch? quotedMatch = quotedPattern.firstMatch(rawHeader);
  if (quotedMatch != null) {
    final String quotedName = (quotedMatch.group(1) ?? '').trim();
    if (quotedName.isNotEmpty) {
      return quotedName;
    }
  }

  final RegExp plainPattern = RegExp(
    r'''filename\s*=\s*([^;]+)''',
    caseSensitive: false,
  );
  final RegExpMatch? plainMatch = plainPattern.firstMatch(rawHeader);
  if (plainMatch != null) {
    final String plainName = (plainMatch.group(1) ?? '').trim();
    if (plainName.isNotEmpty) {
      return plainName.replaceAll('"', '');
    }
  }

  return null;
}
