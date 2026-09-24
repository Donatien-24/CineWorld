import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedMax;
  final bool isOffline;

  const MovieLoaded({
    required this.movies,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isOffline = false,
  });

  MovieLoaded copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? hasReachedMax,
    bool? isOffline,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [movies, currentPage, hasReachedMax, isOffline];
}

class MovieLoadingMore extends MovieLoaded {
  const MovieLoadingMore({
    required super.movies,
    super.currentPage,
    super.hasReachedMax,
    super.isOffline,
  });
}

class MovieError extends MovieState {
  final String message;
  final List<Movie> cachedMovies;

  const MovieError({required this.message, this.cachedMovies = const []});

  @override
  List<Object?> get props => [message, cachedMovies];
}
