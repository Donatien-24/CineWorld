import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../local/local_storage_service.dart';
import '../remote/auth_remote_data_source.dart';
import '../models/auth_token_model.dart';
import '../../core/config/constants.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final LocalStorageService<String> _tokenStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  @override
  Future<AuthToken> login(String username, String password) async {
    final tokenModel = await _remoteDataSource.login(username, password);
    
    await _tokenStorage.put(AppConstants.accessTokenKey, tokenModel.accessToken ?? '');
    await _tokenStorage.put(AppConstants.refreshTokenKey, tokenModel.refreshToken ?? '');
    
    return _mapToEntity(tokenModel);
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.delete(AppConstants.accessTokenKey);
    await _tokenStorage.delete(AppConstants.refreshTokenKey);
  }

  @override
  Future<AuthToken?> getSavedToken() async {
    final accessToken = _tokenStorage.get(AppConstants.accessTokenKey);
    final refreshToken = _tokenStorage.get(AppConstants.refreshTokenKey);
    
    if (accessToken == null) return null;
    
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getSavedToken();
    return token?.isValid ?? false;
  }

  AuthToken _mapToEntity(AuthTokenModel model) {
    return AuthToken(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      tokenType: model.tokenType,
      expiresIn: model.expiresIn,
    );
  }
}
