import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_tmdb_app/data/repositories/movie_repository_impl.dart';
import 'package:flutter_tmdb_app/data/remote/movie_remote_data_source.dart';
import 'package:flutter_tmdb_app/data/models/movie_model.dart';
import 'package:flutter_tmdb_app/data/models/paginated_response.dart';
import 'package:flutter_tmdb_app/core/network/network_info.dart';
import 'package:flutter_tmdb_app/data/local/cache_service.dart';

@GenerateMocks([
  MovieRemoteDataSource,
  NetworkInfo,
  CacheService,
])
import 'movie_repository_impl_test.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockCacheService mockCacheService;

  const tMovieModel = MovieModel(
    id: 1,
    title: 'Test Movie',
    posterPath: '/test.jpg',
    overview: 'Test overview',
    releaseDate: '2024-01-01',
    voteAverage: 8.5,
    voteCount: 100,
  );

  const tPaginatedResponse = PaginatedResponse<MovieModel>(
    page: 1,
    results: [tMovieModel],
    totalPages: 1,
    totalResults: 1,
  );

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockCacheService = MockCacheService();
    repository = MovieRepositoryImpl(
      mockRemoteDataSource,
      mockNetworkInfo,
      mockCacheService,
    );
  });

  group('getPopularMovies', () {
    test('should return remote data when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularMovies(1))
          .thenAnswer((_) async => tPaginatedResponse);
      when(mockCacheService.cacheData(any, any)).thenAnswer((_) async {});

      final result = await repository.getPopularMovies();

      expect(result.length, 1);
      expect(result.first.title, 'Test Movie');
      verify(mockRemoteDataSource.getPopularMovies(1));
    });

    test('should return cached data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockCacheService.getCachedData(any)).thenAnswer((_) async => {'results': []});

      final result = await repository.getPopularMovies();

      expect(result, isEmpty);
      verifyNever(mockRemoteDataSource.getPopularMovies(any));
      verify(mockCacheService.getCachedData('popular_movies_page_1'));
    });

    test('should cache data after successful fetch', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularMovies(1))
          .thenAnswer((_) async => tPaginatedResponse);
      when(mockCacheService.cacheData(any, any)).thenAnswer((_) async {});

      await repository.getPopularMovies();

      verify(mockCacheService.cacheData('popular_movies_page_1', any));
    });

    test('should throw exception when online and fetch fails with no cache', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularMovies(1))
          .thenThrow(Exception('Server error'));
      when(mockCacheService.getCachedData(any)).thenAnswer((_) async => null);

      expect(() => repository.getPopularMovies(), throwsA(isA<Exception>()));
    });
  });
}