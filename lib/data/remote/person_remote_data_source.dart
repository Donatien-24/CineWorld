import '../../core/network/dio_client.dart';
import '../../core/config/constants.dart';
import '../models/person_model.dart';
import '../models/paginated_response.dart';

abstract class PersonRemoteDataSource {
  Future<PaginatedResponse<PersonModel>> getPopularPeople(int page);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final DioClient _dioClient;

  PersonRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PaginatedResponse<PersonModel>> getPopularPeople(int page) async {
    final response = await _dioClient.get(
      AppConstants.popularPeopleEndpoint,
      queryParameters: {
        'page': page,
        'api_key': _getApiKey(),
      },
    );
    
    return PaginatedResponse<PersonModel>.fromJson(
      response.data,
      (json) => PersonModel.fromJson(json as Map<String, dynamic>),
    );
  }

  String _getApiKey() {
    return const String.fromEnvironment('TMDB_API_KEY', defaultValue: 'YOUR_API_KEY');
  }
}