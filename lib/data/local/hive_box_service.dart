import 'package:hive_flutter/hive_flutter.dart';
import 'local_storage_service.dart';

/// Implémentation concrète de [LocalStorageService] basée sur une Hive [Box].
/// On injecte directement la Box déjà ouverte pour éviter les problèmes
/// de génériques avec injectable.
class HiveBoxService<T> implements LocalStorageService<T> {
  final Box<T> _box;

  HiveBoxService(this._box);

  @override
  Future<void> init() async {
    // La box est déjà ouverte à l'injection.
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
