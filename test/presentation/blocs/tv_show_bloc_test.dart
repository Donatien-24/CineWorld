import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_tmdb_app/domain/entities/tv_show.dart';
import 'package:flutter_tmdb_app/domain/repositories/tv_show_repository.dart';
import 'package:flutter_tmdb_app/presentation/blocs/tv_shows/tv_show_bloc.dart';
import 'package:flutter_tmdb_app/presentation/blocs/tv_shows/tv_show_event.dart';
import 'package:flutter_tmdb_app/presentation/blocs/tv_shows/tv_show_state.dart';

@GenerateMocks([TVShowRepository])
import 'tv_show_bloc_test.mocks.dart';

void main() {
  late MockTVShowRepository mockRepository;
  late TVShowBloc bloc;

  const tTVShow = TVShow(
    id: 1399,
    title: 'Game of Thrones',
    overview: 'Nine noble families fight for control over the lands of Westeros.',
    voteAverage: 8.4,
    voteCount: 22000,
  );

  setUp(() {
    mockRepository = MockTVShowRepository();
    bloc = TVShowBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be TVShowInitial', () {
    expect(bloc.state, const TVShowInitial());
  });

  test('LoadTVShows should emit TVShowLoaded with remote data when successful', () async {
    when(mockRepository.getPopularTVShows(page: 1))
        .thenAnswer((_) async => [tTVShow]);

    final expected = [
      const TVShowLoading(),
      const TVShowLoaded(
        tvShows: [tTVShow],
        currentPage: 1,
        hasReachedMax: false,
        isOffline: false,
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(const LoadTVShows());
  });

  test('LoadTVShows should emit TVShowLoaded with cached data when remote call fails and cache exists', () async {
    when(mockRepository.getPopularTVShows(page: 1))
        .thenThrow(Exception('No internet'));
    when(mockRepository.getCachedPopularTVShows())
        .thenAnswer((_) async => [tTVShow]);

    final expected = [
      const TVShowLoading(),
      const TVShowLoaded(
        tvShows: [tTVShow],
        currentPage: 1,
        hasReachedMax: true,
        isOffline: true,
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(const LoadTVShows());
  });

  test('LoadTVShows should emit TVShowError when both remote and cache fail', () async {
    when(mockRepository.getPopularTVShows(page: 1))
        .thenThrow(Exception('No internet'));
    when(mockRepository.getCachedPopularTVShows())
        .thenAnswer((_) async => []);

    final expected = [
      const TVShowLoading(),
      const TVShowError(message: 'Impossible de charger les séries. Vérifiez votre connexion.'),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(const LoadTVShows());
  });
}
