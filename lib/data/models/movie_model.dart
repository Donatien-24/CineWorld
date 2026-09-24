import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/config/app_config.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Equatable {
  final int id;
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'overview')
  final String? overview;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;

  const MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
  });

  String get fullPosterUrl => posterPath != null 
      ? '${AppConfig.imageBaseUrl}/w500$posterPath' 
      : 'https://via.placeholder.com/500x750';

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        backdropPath,
        overview,
        releaseDate,
        voteAverage,
        voteCount,
      ];
}