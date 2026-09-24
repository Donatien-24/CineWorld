import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import '../../../domain/repositories/movie_repository.dart';
import '../../../core/network/app_exception.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc(this.movieRepository) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    if (!event.refresh && state is MovieLoaded) return;

    emit(MovieLoading());

    try {
      final movies = await movieRepository.getPopularMovies(page: 1);
      emit(MovieLoaded(
        movies: movies,
        currentPage: 1,
        hasReachedMax: movies.isEmpty,
        isOffline: false,
      ));
    } on AppException catch (e) {
      // Réseau ko — on tente les données cachées
      try {
        final cached = await movieRepository.getCachedPopularMovies();
        if (cached.isNotEmpty) {
          emit(MovieLoaded(
            movies: cached,
            currentPage: 1,
            hasReachedMax: true,
            isOffline: true,
          ));
        } else {
          emit(MovieError(message: e.message));
        }
      } catch (_) {
        emit(MovieError(message: e.message));
      }
    } catch (e) {
      // Pas de réseau → tenter le cache
      try {
        final cached = await movieRepository.getCachedPopularMovies();
        if (cached.isNotEmpty) {
          emit(MovieLoaded(
            movies: cached,
            currentPage: 1,
            hasReachedMax: true,
            isOffline: true,
          ));
        } else {
          emit(const MovieError(message: 'Impossible de charger les films. Vérifiez votre connexion.'));
        }
      } catch (_) {
        emit(const MovieError(message: 'Impossible de charger les films. Vérifiez votre connexion.'));
      }
    }
  }

  Future<void> _onLoadMoreMovies(LoadMoreMovies event, Emitter<MovieState> emit) async {
    final currentState = state;
    if (currentState is! MovieLoaded) return;
    if (currentState.hasReachedMax || currentState.isOffline) return;

    emit(MovieLoadingMore(
      movies: currentState.movies,
      currentPage: currentState.currentPage,
    ));

    try {
      final nextPage = currentState.currentPage + 1;
      final newMovies = await movieRepository.getPopularMovies(page: nextPage);

      if (newMovies.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        emit(MovieLoaded(
          movies: [...currentState.movies, ...newMovies],
          currentPage: nextPage,
          hasReachedMax: false,
          isOffline: false,
        ));
      }
    } catch (_) {
      emit(currentState.copyWith(hasReachedMax: true));
    }
  }
}
