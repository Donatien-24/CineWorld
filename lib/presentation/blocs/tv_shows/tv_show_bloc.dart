import 'package:flutter_bloc/flutter_bloc.dart';
import 'tv_show_event.dart';
import 'tv_show_state.dart';
import '../../../domain/repositories/tv_show_repository.dart';
import '../../../core/network/app_exception.dart';

class TVShowBloc extends Bloc<TVShowEvent, TVShowState> {
  final TVShowRepository tvShowRepository;

  TVShowBloc(this.tvShowRepository) : super(const TVShowInitial()) {
    on<LoadTVShows>(_onLoadTVShows);
    on<LoadMoreTVShows>(_onLoadMoreTVShows);
  }

  Future<void> _onLoadTVShows(LoadTVShows event, Emitter<TVShowState> emit) async {
    if (!event.refresh && state is TVShowLoaded) return;

    emit(const TVShowLoading());

    try {
      final tvShows = await tvShowRepository.getPopularTVShows(page: 1);
      emit(TVShowLoaded(
        tvShows: tvShows,
        currentPage: 1,
        hasReachedMax: tvShows.isEmpty,
        isOffline: false,
      ));
    } on AppException catch (e) {
      try {
        final cached = await tvShowRepository.getCachedPopularTVShows();
        if (cached.isNotEmpty) {
          emit(TVShowLoaded(
            tvShows: cached,
            currentPage: 1,
            hasReachedMax: true,
            isOffline: true,
          ));
        } else {
          emit(TVShowError(message: e.message));
        }
      } catch (_) {
        emit(TVShowError(message: e.message));
      }
    } catch (_) {
      try {
        final cached = await tvShowRepository.getCachedPopularTVShows();
        if (cached.isNotEmpty) {
          emit(TVShowLoaded(
            tvShows: cached,
            currentPage: 1,
            hasReachedMax: true,
            isOffline: true,
          ));
        } else {
          emit(const TVShowError(
            message: 'Impossible de charger les séries. Vérifiez votre connexion.',
          ));
        }
      } catch (_) {
        emit(const TVShowError(
          message: 'Impossible de charger les séries. Vérifiez votre connexion.',
        ));
      }
    }
  }

  Future<void> _onLoadMoreTVShows(
    LoadMoreTVShows event,
    Emitter<TVShowState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TVShowLoaded) return;
    if (currentState.hasReachedMax || currentState.isOffline) return;

    emit(TVShowLoadingMore(
      tvShows: currentState.tvShows,
      currentPage: currentState.currentPage,
    ));

    try {
      final nextPage = currentState.currentPage + 1;
      final newShows = await tvShowRepository.getPopularTVShows(page: nextPage);

      if (newShows.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        emit(TVShowLoaded(
          tvShows: [...currentState.tvShows, ...newShows],
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
