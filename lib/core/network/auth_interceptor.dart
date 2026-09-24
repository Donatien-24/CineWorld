import 'package:dio/dio.dart';
import '../../../data/local/local_storage_service.dart';
import '../config/constants.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorageService<String> _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _tokenStorage.get(AppConstants.accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          final response = await Dio().fetch(opts);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // Refresh failed, proceed with error
      }
    }
    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    final refreshToken = _tokenStorage.get(AppConstants.refreshTokenKey);
    if (refreshToken == null) return null;

    try {
      // Implement refresh token logic here
      // For now, return null as TMDB doesn't support refresh tokens
      return null;
    } catch (e) {
      return null;
    }
  }
}