import '../../core/network/dio_client.dart';
import '../models/auth_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login(String username, String password);
  Future<AuthTokenModel> requestToken();
  Future<AuthTokenModel> createSession(String requestToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthTokenModel> login(String username, String password) async {
    final response = await _dioClient.post(
      '/authentication/token/validate_with_login',
      data: {
        'username': username,
        'password': password,
        'request_token': await _getRequestToken(),
      },
    );
    return AuthTokenModel.fromJson(response.data);
  }

  @override
  Future<AuthTokenModel> requestToken() async {
    final response = await _dioClient.post('/authentication/token/new');
    return AuthTokenModel.fromJson(response.data);
  }

  @override
  Future<AuthTokenModel> createSession(String requestToken) async {
    final response = await _dioClient.post(
      '/authentication/session/new',
      data: {'request_token': requestToken},
    );
    return AuthTokenModel.fromJson(response.data);
  }

  Future<String> _getRequestToken() async {
    final token = await requestToken();
    return token.accessToken ?? '';
  }
}