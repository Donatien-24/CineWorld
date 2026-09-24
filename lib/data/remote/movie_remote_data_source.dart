import '../../core/network/dio_client.dart';
import '../../core/config/constants.dart';
import '../models/movie_model.dart';
import '../models/paginated_response.dart';

abstract class MovieRemoteDataSource {
  Future<PaginatedResponse<MovieModel>> getPopularMovies(int page);
  Future<PaginatedResponse<MovieModel>> getTopRatedMovies(int page);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient _dioClient;

  MovieRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PaginatedResponse<MovieModel>> getPopularMovies(int page) async {
    final response = await _dioClient.get(
      AppConstants.popularMoviesEndpoint,
      queryParameters: {
        'page': page,
        'api_key': _getApiKey(),
      },
    );
    
    return PaginatedResponse<MovieModel>.fromJson(
      response.data,
      (json) => MovieModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<PaginatedResponse<MovieModel>> getTopRatedMovies(int page) async {
    final response = await _dioClient.get(
      AppConstants.topRatedMoviesEndpoint,
      queryParameters: {
        'page': page,
        'api_key': _getApiKey(),
      },
    );
    
    return PaginatedResponse<MovieModel>.fromJson(
      response.data,
      (json) => MovieModel.fromJson(json as Map<String, dynamic>),
    );
  }

  String _getApiKey() {
    return const String.fromEnvironment('TMDB_API_KEY', defaultValue: 'YOUR_API_KEY');
  }
}