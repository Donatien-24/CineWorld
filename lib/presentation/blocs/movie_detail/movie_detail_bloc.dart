import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/local/local_storage_service.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final LocalStorageService<Map> _storage;
  static const String _favoritesKey = 'favorite_movies';

  MovieDetailBloc(this._storage) : super(const MovieDetailInitial()) {
    on<LoadMovieDetail>(_onLoadMovieDetail);
    on<ToggleFavoriteMovie>(_onToggleFavorite);
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(const MovieDetailLoading());

    try {
      final rawFavorites = _storage.get(_favoritesKey) ?? <dynamic, dynamic>{};
      final isFavorite = rawFavorites.containsKey(event.movie.id.toString());

      emit(MovieDetailLoaded(
        movie: event.movie,
        isFavorite: isFavorite,
      ));
    } catch (_) {
      emit(MovieDetailLoaded(
        movie: event.movie,
        isFavorite: false,
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteMovie event,
    Emitter<MovieDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MovieDetailLoaded) return;

    try {
      final rawFavorites = _storage.get(_favoritesKey) ?? <dynamic, dynamic>{};
      final updatedFavorites = Map<String, dynamic>.from(rawFavorites);
      final movieId = event.movie.id.toString();

      final newStatus = !currentState.isFavorite;

      if (newStatus) {
        updatedFavorites[movieId] = {
          'id': event.movie.id,
          'title': event.movie.title,
          'posterUrl': event.movie.posterUrl,
          'voteAverage': event.movie.voteAverage,
          'savedAt': DateTime.now().toIso8601String(),
        };
      } else {
        updatedFavorites.remove(movieId);
      }

      await _storage.put(_favoritesKey, updatedFavorites);
      emit(currentState.copyWith(isFavorite: newStatus));
    } catch (_) {
      // Échec silencieux ou maintien de l'état
    }
  }
}
