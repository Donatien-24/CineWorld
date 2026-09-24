import 'package:equatable/equatable.dart';

class TVShow extends Equatable {
  final int id;
  final String title;
  final String? posterUrl;
  final String? backdropUrl;
  final String? overview;
  final String? firstAirDate;
  final double? voteAverage;
  final int? voteCount;

  const TVShow({
    required this.id,
    required this.title,
    this.posterUrl,
    this.backdropUrl,
    this.overview,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
  });

  String get formattedRating => voteAverage != null 
      ? '${voteAverage!.toStringAsFixed(1)}/10' 
      : 'N/A';

  @override
  List<Object?> get props => [
        id,
        title,
        posterUrl,
        backdropUrl,
        overview,
        firstAirDate,
        voteAverage,
        voteCount,
      ];
}