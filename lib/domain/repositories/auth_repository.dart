import '../entities/auth_token.dart';

abstract class AuthRepository {
  Future<AuthToken> login(String username, String password);
  Future<void> logout();
  Future<AuthToken?> getSavedToken();
  Future<bool> isLoggedIn();
}