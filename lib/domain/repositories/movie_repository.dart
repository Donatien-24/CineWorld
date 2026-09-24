import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> getTopRatedMovies({int page = 1});
  Future<List<Movie>> getCachedPopularMovies();
  Future<void> cachePopularMovies(List<Movie> movies);
}