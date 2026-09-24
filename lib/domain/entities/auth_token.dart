import 'package:equatable/equatable.dart';

class AuthToken extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  const AuthToken({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  bool get isValid => accessToken != null && accessToken!.isNotEmpty;

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType, expiresIn];
}