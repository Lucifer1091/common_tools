// ignore_for_file: one_member_abstracts

/// Provides access tokens for authenticated requests.
abstract interface class TokenProvider {
  /// Returns the current bearer token or `null` when unavailable.
  Future<String?> getToken();
}
