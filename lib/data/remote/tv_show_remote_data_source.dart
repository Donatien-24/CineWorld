import '../../core/network/dio_client.dart';
import '../../core/config/constants.dart';
import '../models/tv_show_model.dart';
import '../models/paginated_response.dart';

abstract class TVShowRemoteDataSource {
  Future<PaginatedResponse<TVShowModel>> getPopularTVShows(int page);
}

class TVShowRemoteDataSourceImpl implements TVShowRemoteDataSource {
  final DioClient _dioClient;

  TVShowRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PaginatedResponse<TVShowModel>> getPopularTVShows(int page) async {
    final response = await _dioClient.get(
      AppConstants.popularTVShowsEndpoint,
      queryParameters: {
        'page': page,
        'api_key': _getApiKey(),
      },
    );
    
    return PaginatedResponse<TVShowModel>.fromJson(
      response.data,
      (json) => TVShowModel.fromJson(json as Map<String, dynamic>),
    );
  }

  String _getApiKey() {
    return const String.fromEnvironment('TMDB_API_KEY', defaultValue: 'YOUR_API_KEY');
  }
}