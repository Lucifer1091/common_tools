import 'package:cross_file/cross_file.dart';

import 'download_request.dart';

/// Completed file download metadata.
class DownloadResult {
  /// Creates a completed download result.
  const DownloadResult({
    required this.file,
    required this.filePath,
    required this.statusCode,
    required this.headers,
    required this.bytesWritten,
    required this.request,
    this.contentLength,
    this.mimeType,
  });

  /// Cross-platform file abstraction for the downloaded payload.
  final XFile file;

  /// Final path of the downloaded file on disk when one exists.
  final String? filePath;

  /// HTTP status code.
  final int statusCode;

  /// Response headers.
  final Map<String, List<String>> headers;

  /// Total bytes written to the file.
  final int bytesWritten;

  /// Reported content length when available.
  final int? contentLength;

  /// Response MIME type when available.
  final String? mimeType;

  /// Effective request used for the completed download.
  final DownloadRequest request;
}
