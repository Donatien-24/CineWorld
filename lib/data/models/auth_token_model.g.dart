// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokenModel _$AuthTokenModelFromJson(Map<String, dynamic> json) =>
    AuthTokenModel(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['tokenType'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AuthTokenModelToJson(AuthTokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
    };
