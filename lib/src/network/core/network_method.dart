/// HTTP methods supported by the reusable network layer.
enum RequestMethod {
  /// `GET`
  get,

  /// `POST`
  post,

  /// `PUT`
  put,

  /// `PATCH`
  patch,

  /// `DELETE`
  delete,

  /// `HEAD`
  head,
}

/// Convenience helpers for [RequestMethod].
extension RequestMethodX on RequestMethod {
  /// Canonical uppercase HTTP method name.
  String get value {
    return switch (this) {
      RequestMethod.get => 'GET',
      RequestMethod.post => 'POST',
      RequestMethod.put => 'PUT',
      RequestMethod.patch => 'PATCH',
      RequestMethod.delete => 'DELETE',
      RequestMethod.head => 'HEAD',
    };
  }

  /// Returns `true` when the method is idempotent by default.
  bool get isIdempotent {
    return switch (this) {
      RequestMethod.get ||
      RequestMethod.put ||
      RequestMethod.delete ||
      RequestMethod.head => true,
      RequestMethod.post || RequestMethod.patch => false,
    };
  }
}
