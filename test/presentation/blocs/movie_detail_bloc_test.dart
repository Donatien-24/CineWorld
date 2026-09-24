import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tmdb_app/data/local/local_storage_service.dart';
import 'package:flutter_tmdb_app/domain/entities/movie.dart';
import 'package:flutter_tmdb_app/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_tmdb_app/presentation/blocs/movie_detail/movie_detail_event.dart';
import 'package:flutter_tmdb_app/presentation/blocs/movie_detail/movie_detail_state.dart';

class FakeLocalStorageService implements LocalStorageService<Map> {
  final Map<String, Map> _store = {};

  @override
  Future<void> init() async {}

  @override
  Map? get(String key) => _store[key];

  @override
  Future<void> put(String key, Map value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  @override
  Future<bool> containsKey(String key) async => _store.containsKey(key);
}

void main() {
  late FakeLocalStorageService fakeStorage;
  late MovieDetailBloc bloc;

  const tMovie = Movie(
    id: 101,
    title: 'Inception',
    overview: 'A mind-bending thriller',
    voteAverage: 8.8,
    voteCount: 35000,
  );

  setUp(() {
    fakeStorage = FakeLocalStorageService();
    bloc = MovieDetailBloc(fakeStorage);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be MovieDetailInitial', () {
    expect(bloc.state, const MovieDetailInitial());
  });

  test('LoadMovieDetail should emit MovieDetailLoading then MovieDetailLoaded', () async {
    final expectedStates = [
      const MovieDetailLoading(),
      const MovieDetailLoaded(movie: tMovie, isFavorite: false),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(const LoadMovieDetail(tMovie));
  });

  test('ToggleFavoriteMovie should toggle favorite and persist in storage', () async {
    // Premier chargement
    bloc.add(const LoadMovieDetail(tMovie));
    await pumpEventQueue();

    expect(bloc.state, const MovieDetailLoaded(movie: tMovie, isFavorite: false));

    // Toggle favori -> true
    bloc.add(const ToggleFavoriteMovie(tMovie));
    await pumpEventQueue();

    expect(bloc.state, const MovieDetailLoaded(movie: tMovie, isFavorite: true));
    final saved = fakeStorage.get('favorite_movies');
    expect(saved, isNotNull);
    expect(saved!['101']['title'], 'Inception');

    // Toggle favori à nouveau -> false
    bloc.add(const ToggleFavoriteMovie(tMovie));
    await pumpEventQueue();

    expect(bloc.state, const MovieDetailLoaded(movie: tMovie, isFavorite: false));
  });
}
