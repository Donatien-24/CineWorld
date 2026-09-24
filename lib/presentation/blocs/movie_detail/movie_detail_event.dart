import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovieDetail extends MovieDetailEvent {
  final Movie movie;

  const LoadMovieDetail(this.movie);

  @override
  List<Object?> get props => [movie];
}

class ToggleFavoriteMovie extends MovieDetailEvent {
  final Movie movie;

  const ToggleFavoriteMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}
