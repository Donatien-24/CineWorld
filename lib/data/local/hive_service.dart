import 'package:hive_flutter/hive_flutter.dart';
import 'local_storage_service.dart';

class HiveService<T> implements LocalStorageService<T> {
  late Box<T> _box;
  final String boxName;

  HiveService(this.boxName);

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<T>(boxName);
    } else {
      _box = Hive.box<T>(boxName);
    }
  }

  @override
  Future<void> put(String key, T value) async {
    await _box.put(key, value);
  }

  @override
  T? get(String key) {
    return _box.get(key);
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _box.containsKey(key);
  }
}