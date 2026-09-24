import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

class MovieDetailLoaded extends MovieDetailState {
  final Movie movie;
  final bool isFavorite;
  final bool isOffline;

  const MovieDetailLoaded({
    required this.movie,
    required this.isFavorite,
    this.isOffline = false,
  });

  MovieDetailLoaded copyWith({
    Movie? movie,
    bool? isFavorite,
    bool? isOffline,
  }) {
    return MovieDetailLoaded(
      movie: movie ?? this.movie,
      isFavorite: isFavorite ?? this.isFavorite,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [movie, isFavorite, isOffline];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
