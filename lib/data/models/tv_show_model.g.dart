// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TVShowModel _$TVShowModelFromJson(Map<String, dynamic> json) => TVShowModel(
      id: (json['id'] as num).toInt(),
      title: json['name'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TVShowModelToJson(TVShowModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'first_air_date': instance.firstAirDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
