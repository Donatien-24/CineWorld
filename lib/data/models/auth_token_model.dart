import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_token_model.g.dart';

@JsonSerializable()
class AuthTokenModel extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  const AuthTokenModel({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType, expiresIn];
}