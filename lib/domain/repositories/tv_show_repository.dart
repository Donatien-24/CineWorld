import '../entities/tv_show.dart';

abstract class TVShowRepository {
  Future<List<TVShow>> getPopularTVShows({int page = 1});
  Future<List<TVShow>> getCachedPopularTVShows();
  Future<void> cachePopularTVShows(List<TVShow> tvShows);
}