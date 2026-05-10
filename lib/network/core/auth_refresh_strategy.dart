// ignore_for_file: one_member_abstracts

/// Refreshes authentication state after an unauthorized response.
abstract interface class AuthRefreshStrategy {
  /// Attempts to refresh authentication credentials.
  ///
  /// Returns `true` when the credentials were refreshed and the request may be
  /// retried once, otherwise returns `false`.
  Future<bool> refreshToken();
}
