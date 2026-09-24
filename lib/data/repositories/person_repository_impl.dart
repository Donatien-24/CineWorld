import 'package:injectable/injectable.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/person_repository.dart';
import '../local/cache_service.dart';
import '../remote/person_remote_data_source.dart';
import '../models/person_model.dart';

@Injectable(as: PersonRepository)
class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final CacheService _cacheService;

  PersonRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
    this._cacheService,
  );

  @override
  Future<List<Person>> getPopularPeople({int page = 1}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getPopularPeople(page);
        final people = response.results.map(_mapToEntity).toList();
        
        await _cacheService.cacheData(
          'popular_people_page_$page',
          {'results': response.results.map((m) => m.toJson()).toList()},
        );
        
        return people;
      } catch (e) {
        final cached = await _getCachedPeople('popular_people_page_$page');
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    } else {
      return await _getCachedPeople('popular_people_page_$page');
    }
  }

  @override
  Future<List<Person>> getCachedPopularPeople() async {
    return await _getCachedPeople('popular_people_page_1');
  }

  @override
  Future<void> cachePopularPeople(List<Person> people) async {
    final models = people.map((e) => PersonModel(
      id: e.id,
      name: e.name,
      profilePath: e.profileUrl?.split('/').last,
      knownForDepartment: e.knownForDepartment,
      popularity: e.popularity,
    )).toList();
    
    await _cacheService.cacheData(
      'popular_people_page_1',
      {'results': models.map((m) => m.toJson()).toList()},
    );
  }

  Future<List<Person>> _getCachedPeople(String key) async {
    final cached = await _cacheService.getCachedData(key);
    if (cached == null) return [];
    
    final results = cached['results'] as List<dynamic>;
    return results
        .map((json) => _mapToEntity(PersonModel.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  Person _mapToEntity(PersonModel model) {
    return Person(
      id: model.id,
      name: model.name,
      profileUrl: model.fullProfileUrl,
      knownForDepartment: model.knownForDepartment,
      popularity: model.popularity,
    );
  }
}
