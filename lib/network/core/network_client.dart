// ignore_for_file: one_member_abstracts

import 'download_request.dart';
import 'download_result.dart';
import 'network_request.dart';
import 'network_response.dart';
import 'response_decoder.dart';

/// Public contract implemented by concrete network transports.
abstract interface class NetworkClient {
  /// Executes [request] and decodes the raw payload with [decoder].
  Future<NetworkResponse<T>> send<T>(
    NetworkRequest request, {
    required ResponseDecoder<T> decoder,
  });

  /// Downloads a file and returns a cross-platform file result.
  Future<DownloadResult> download(DownloadRequest request);
}
