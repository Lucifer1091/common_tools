import 'package:dio/dio.dart';

import '../core/network_cancel_token.dart';

/// Network cancellation token backed by Dio's [CancelToken].
class DioCancelToken implements NetworkCancelToken {
  /// Creates a Dio-backed cancellation token.
  DioCancelToken({CancelToken? token}) : _token = token ?? CancelToken();

  final CancelToken _token;

  /// Cancels the associated request.
  void cancel([Object? reason]) {
    _token.cancel(reason);
  }

  @override
  bool get isCancelled => _token.isCancelled;

  @override
  Object get rawValue => _token;
}
