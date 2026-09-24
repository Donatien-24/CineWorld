import 'package:injectable/injectable.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/repositories/tv_show_repository.dart';
import '../local/cache_service.dart';
import '../remote/tv_show_remote_data_source.dart';
import '../models/tv_show_model.dart';
import '../../core/config/app_config.dart';

@Injectable(as: TVShowRepository)
class TVShowRepositoryImpl implements TVShowRepository {
  final TVShowRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final CacheService _cacheService;

  TVShowRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
    this._cacheService,
  );

  @override
  Future<List<TVShow>> getPopularTVShows({int page = 1}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getPopularTVShows(page);
        final tvShows = response.results.map(_mapToEntity).toList();
        
        await _cacheService.cacheData(
          'popular_tv_shows_page_$page',
          {'results': response.results.map((m) => m.toJson()).toList()},
        );
        
        return tvShows;
      } catch (e) {
        final cached = await _getCachedTVShows('popular_tv_shows_page_$page');
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    } else {
      return await _getCachedTVShows('popular_tv_shows_page_$page');
    }
  }

  @override
  Future<List<TVShow>> getCachedPopularTVShows() async {
    return await _getCachedTVShows('popular_tv_shows_page_1');
  }

  @override
  Future<void> cachePopularTVShows(List<TVShow> tvShows) async {
    final models = tvShows.map((e) => TVShowModel(
      id: e.id,
      title: e.title,
      posterPath: e.posterUrl?.split('/').last,
      backdropPath: e.backdropUrl?.split('/').last,
      overview: e.overview,
      firstAirDate: e.firstAirDate,
      voteAverage: e.voteAverage,
      voteCount: e.voteCount,
    )).toList();
    
    await _cacheService.cacheData(
      'popular_tv_shows_page_1',
      {'results': models.map((m) => m.toJson()).toList()},
    );
  }

  Future<List<TVShow>> _getCachedTVShows(String key) async {
    final cached = await _cacheService.getCachedData(key);
    if (cached == null) return [];
    
    final results = cached['results'] as List<dynamic>;
    return results
        .map((json) => _mapToEntity(TVShowModel.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  TVShow _mapToEntity(TVShowModel model) {
    return TVShow(
      id: model.id,
      title: model.title,
      posterUrl: model.fullPosterUrl,
      backdropUrl: model.backdropPath != null 
          ? '${AppConfig.imageBaseUrl}/w780${model.backdropPath}' 
          : null,
      overview: model.overview,
      firstAirDate: model.firstAirDate,
      voteAverage: model.voteAverage,
      voteCount: model.voteCount,
    );
  }
}
