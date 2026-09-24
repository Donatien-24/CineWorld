import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/config/app_config.dart';

part 'tv_show_model.g.dart';

@JsonSerializable()
class TVShowModel extends Equatable {
  final int id;
  @JsonKey(name: 'name')
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'overview')
  final String? overview;
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;

  const TVShowModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
  });

  String get fullPosterUrl => posterPath != null 
      ? '${AppConfig.imageBaseUrl}/w500$posterPath' 
      : 'https://via.placeholder.com/500x750';

  factory TVShowModel.fromJson(Map<String, dynamic> json) =>
      _$TVShowModelFromJson(json);

  Map<String, dynamic> toJson() => _$TVShowModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        backdropPath,
        overview,
        firstAirDate,
        voteAverage,
        voteCount,
      ];
}