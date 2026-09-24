import 'package:injectable/injectable.dart';
import '../../core/network/network_info.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../local/cache_service.dart';
import '../remote/movie_remote_data_source.dart';
import '../models/movie_model.dart';
import '../../core/config/app_config.dart';

@Injectable(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final CacheService _cacheService;

  MovieRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
    this._cacheService,
  );

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getPopularMovies(page);
        final movies = response.results.map(_mapToEntity).toList();
        
        await _cacheService.cacheData(
          'popular_movies_page_$page',
          {'results': response.results.map((m) => m.toJson()).toList()},
        );
        
        return movies;
      } catch (e) {
        final cached = await _getCachedMovies('popular_movies_page_$page');
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    } else {
      return await _getCachedMovies('popular_movies_page_$page');
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getTopRatedMovies(page);
        return response.results.map(_mapToEntity).toList();
      } catch (e) {
        throw AppException(message: 'Failed to fetch top rated movies');
      }
    } else {
      throw AppException(message: 'No internet connection');
    }
  }

  @override
  Future<List<Movie>> getCachedPopularMovies() async {
    return await _getCachedMovies('popular_movies_page_1');
  }

  @override
  Future<void> cachePopularMovies(List<Movie> movies) async {
    final models = movies.map((e) => MovieModel(
      id: e.id,
      title: e.title,
      posterPath: e.posterUrl?.split('/').last,
      backdropPath: e.backdropUrl?.split('/').last,
      overview: e.overview,
      releaseDate: e.releaseDate,
      voteAverage: e.voteAverage,
      voteCount: e.voteCount,
    )).toList();
    
    await _cacheService.cacheData(
      'popular_movies_page_1',
      {'results': models.map((m) => m.toJson()).toList()},
    );
  }

  Future<List<Movie>> _getCachedMovies(String key) async {
    final cached = await _cacheService.getCachedData(key);
    if (cached == null) return [];
    
    final results = cached['results'] as List<dynamic>;
    return results
        .map((json) => _mapToEntity(MovieModel.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  Movie _mapToEntity(MovieModel model) {
    return Movie(
      id: model.id,
      title: model.title,
      posterUrl: model.fullPosterUrl,
      backdropUrl: model.backdropPath != null 
          ? '${AppConfig.imageBaseUrl}/w780${model.backdropPath}' 
          : null,
      overview: model.overview,
      releaseDate: model.releaseDate,
      voteAverage: model.voteAverage,
      voteCount: model.voteCount,
    );
  }
}
