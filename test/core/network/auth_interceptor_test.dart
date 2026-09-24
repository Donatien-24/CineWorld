import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tmdb_app/core/network/auth_interceptor.dart';
import 'package:flutter_tmdb_app/data/local/local_storage_service.dart';

@GenerateMocks([LocalStorageService])
import 'auth_interceptor_test.mocks.dart';

void main() {
  late AuthInterceptor interceptor;
  late MockLocalStorageService<String> mockTokenStorage;

  setUp(() {
    mockTokenStorage = MockLocalStorageService<String>();
    interceptor = AuthInterceptor(mockTokenStorage);
  });

  group('AuthInterceptor', () {
    test('should add authorization header when token exists', () async {
      when(mockTokenStorage.get(any)).thenReturn('test_token');

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test_token');
    });

    test('should not add authorization header when token is null', () async {
      when(mockTokenStorage.get(any)).thenReturn(null);

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], isNull);
    });
  });
}