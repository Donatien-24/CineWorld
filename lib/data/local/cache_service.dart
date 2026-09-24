import 'package:injectable/injectable.dart';
import 'local_storage_service.dart';
import '../../core/config/constants.dart';

@injectable
class CacheService {
  final LocalStorageService<Map> _cacheStorage;

  CacheService(this._cacheStorage);

  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    final cacheItem = {
      'data': data,
      'cached_at': DateTime.now().toIso8601String(),
    };
    await _cacheStorage.put(key, cacheItem);
  }

  Future<Map<String, dynamic>?> getCachedData(String key) async {
    final cached = _cacheStorage.get(key);
    if (cached == null) return null;

    final cachedAt = DateTime.parse(cached['cached_at'] as String);
    final isExpired = DateTime.now().difference(cachedAt) > AppConstants.cacheExpiry;

    if (isExpired) {
      await _cacheStorage.delete(key);
      return null;
    }

    return cached['data'] as Map<String, dynamic>;
  }

  Future<void> clearCache(String key) async {
    await _cacheStorage.delete(key);
  }

  Future<void> clearAllCache() async {
    await _cacheStorage.clear();
  }
}