import 'dart:async';

/// Converts raw transport payloads into typed models.
typedef ResponseDecoder<T> = FutureOr<T> Function(Object? rawData);
