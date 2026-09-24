import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:flutter_tmdb_app/data/local/hive_service.dart';

void main() {
  group('HiveService', () {
    late HiveService<String> service;
    late Box<String> testBox;

    setUp(() async {
      Hive.init('./test_hive');
      testBox = await Hive.openBox<String>('test_box');
      service = HiveService<String>('test_box');
      await service.init();
    });

    tearDown(() async {
      await testBox.clear();
      await testBox.close();
    });

    test('should store and retrieve value', () async {
      await service.put('test_key', 'test_value');
      final result = service.get('test_key');
      expect(result, 'test_value');
    });

    test('should return null for non-existent key', () {
      final result = service.get('non_existent');
      expect(result, isNull);
    });

    test('should delete value', () async {
      await service.put('test_key', 'test_value');
      await service.delete('test_key');
      final result = service.get('test_key');
      expect(result, isNull);
    });

    test('should clear all values', () async {
      await service.put('key1', 'value1');
      await service.put('key2', 'value2');
      await service.clear();
      expect(service.get('key1'), isNull);
      expect(service.get('key2'), isNull);
    });

    test('should check if key exists', () async {
      await service.put('test_key', 'test_value');
      expect(await service.containsKey('test_key'), true);
      expect(await service.containsKey('non_existent'), false);
    });
  });
}