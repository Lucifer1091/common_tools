// ignore_for_file: one_member_abstracts

/// Checks whether the client should attempt network work right now.
abstract interface class ConnectivityProbe {
  /// Returns `true` when connectivity is available.
  Future<bool> hasConnection();
}
