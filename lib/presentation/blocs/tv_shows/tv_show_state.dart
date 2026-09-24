import 'package:equatable/equatable.dart';
import '../../../domain/entities/tv_show.dart';

abstract class TVShowState extends Equatable {
  const TVShowState();

  @override
  List<Object?> get props => [];
}

class TVShowInitial extends TVShowState {
  const TVShowInitial();
}

class TVShowLoading extends TVShowState {
  const TVShowLoading();
}

class TVShowLoaded extends TVShowState {
  final List<TVShow> tvShows;
  final int currentPage;
  final bool hasReachedMax;
  final bool isOffline;

  const TVShowLoaded({
    required this.tvShows,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isOffline = false,
  });

  TVShowLoaded copyWith({
    List<TVShow>? tvShows,
    int? currentPage,
    bool? hasReachedMax,
    bool? isOffline,
  }) {
    return TVShowLoaded(
      tvShows: tvShows ?? this.tvShows,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [tvShows, currentPage, hasReachedMax, isOffline];
}

class TVShowLoadingMore extends TVShowLoaded {
  const TVShowLoadingMore({
    required super.tvShows,
    super.currentPage,
    super.hasReachedMax,
    super.isOffline,
  });
}

class TVShowError extends TVShowState {
  final String message;
  final List<TVShow> cachedTVShows;

  const TVShowError({
    required this.message,
    this.cachedTVShows = const [],
  });

  @override
  List<Object?> get props => [message, cachedTVShows];
}
