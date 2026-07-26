/// A cached network payload with metadata used by the transport.
class NetworkCacheEntry {
  /// Creates a cache entry.
  const NetworkCacheEntry({
    required this.rawData,
    required this.statusCode,
    required this.headers,
    required this.cachedAt,
    required this.ttl,
  });

  /// Raw response data stored for later decoding.
  final Object? rawData;

  /// HTTP status code associated with the cached response.
  final int statusCode;

  /// Cached response headers.
  final Map<String, List<String>> headers;

  /// Timestamp when the entry was cached.
  final DateTime cachedAt;

  /// Time-to-live for the entry.
  final Duration ttl;

  /// Returns `true` when the entry is stale.
  bool get isExpired => DateTime.now().isAfter(cachedAt.add(ttl));
}

/// Storage contract for cached network responses.
abstract interface class CacheStore {
  /// Reads a cached entry for [key].
  Future<NetworkCacheEntry?> read(String key);

  /// Writes [entry] to [key].
  Future<void> write(String key, NetworkCacheEntry entry);

  /// Removes an entry from the store.
  Future<void> remove(String key);

  /// Clears the complete cache store.
  Future<void> clear();
}

/// In-memory cache store for lightweight caching needs.
class MemoryCacheStore implements CacheStore {
  /// Creates an in-memory cache store.
  MemoryCacheStore();

  final Map<String, NetworkCacheEntry> _entries = <String, NetworkCacheEntry>{};

  @override
  Future<void> clear() async {
    _entries.clear();
  }

  @override
  Future<NetworkCacheEntry?> read(String key) async {
    final NetworkCacheEntry? entry = _entries[key];
    if (entry == null) {
      return null;
    }

    if (entry.isExpired && !entry.ttl.isNegative) {
      _entries.remove(key);
      return null;
    }

    return entry;
  }

  @override
  Future<void> remove(String key) async {
    _entries.remove(key);
  }

  @override
  Future<void> write(String key, NetworkCacheEntry entry) async {
    _entries[key] = entry;
  }
}
