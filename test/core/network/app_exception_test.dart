import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tmdb_app/core/network/app_exception.dart';

void main() {
  group('AppException', () {
    test('should create AppException with message', () {
      final exception = AppException(message: 'Test error');
      expect(exception.message, 'Test error');
      expect(exception.toString(), 'Test error');
    });

    test('should handle socket exception', () {
      final exception = AppException.fromDioError('SocketException');
      expect(exception.message, 'No internet connection');
    });

    test('should handle timeout exception', () {
      final exception = AppException.fromDioError('TimeoutException');
      expect(exception.message, 'Request timeout');
    });

    test('should return same AppException if passed', () {
      final original = AppException(message: 'Original error');
      final result = AppException.fromDioError(original);
      expect(result, same(original));
    });
  });
}