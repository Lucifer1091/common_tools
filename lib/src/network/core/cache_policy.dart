/// Describes the cache medium requested for a network call.
enum CacheMode {
  /// Disable caching.
  none,

  /// Cache the response in memory.
  memory,

  /// Cache the response in a persistent store.
  disk,
}

/// Configures cache behavior for a request.
class CachePolicy {
  /// Creates a cache policy.
  const CachePolicy({
    this.mode = CacheMode.none,
    this.ttl = Duration.zero,
    this.allowStale = false,
  });

  /// Enables in-memory caching.
  const CachePolicy.memory({
    Duration ttl = const Duration(minutes: 5),
    bool allowStale = false,
  }) : this(mode: CacheMode.memory, ttl: ttl, allowStale: allowStale);

  /// Enables persistent caching.
  const CachePolicy.disk({
    Duration ttl = const Duration(minutes: 5),
    bool allowStale = false,
  }) : this(mode: CacheMode.disk, ttl: ttl, allowStale: allowStale);

  /// Disables caching.
  static const CachePolicy none = CachePolicy();

  /// Selected cache medium.
  final CacheMode mode;

  /// Time-to-live for a cached entry.
  final Duration ttl;

  /// Whether stale entries may be served.
  final bool allowStale;

  /// Returns `true` when caching is enabled.
  bool get isEnabled => mode != CacheMode.none && ttl > Duration.zero;

  /// Creates a new policy with overridden values.
  CachePolicy copyWith({CacheMode? mode, Duration? ttl, bool? allowStale}) {
    return CachePolicy(
      mode: mode ?? this.mode,
      ttl: ttl ?? this.ttl,
      allowStale: allowStale ?? this.allowStale,
    );
  }
}
