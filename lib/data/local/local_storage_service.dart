abstract class LocalStorageService<T> {
  Future<void> init();
  Future<void> put(String key, T value);
  T? get(String key);
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}