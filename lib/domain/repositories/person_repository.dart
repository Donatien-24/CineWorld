import '../entities/person.dart';

abstract class PersonRepository {
  Future<List<Person>> getPopularPeople({int page = 1});
  Future<List<Person>> getCachedPopularPeople();
  Future<void> cachePopularPeople(List<Person> people);
}