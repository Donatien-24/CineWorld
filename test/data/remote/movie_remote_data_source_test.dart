import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tmdb_app/core/network/dio_client.dart';
import 'package:flutter_tmdb_app/data/remote/movie_remote_data_source.dart';
import 'package:flutter_tmdb_app/data/models/movie_model.dart';

@GenerateMocks([DioClient])
import 'movie_remote_data_source_test.mocks.dart';

void main() {
  late MovieRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = MovieRemoteDataSourceImpl(mockDioClient);
  });

  group('getPopularMovies', () {
    final tPage = 1;
    final tResponseData = {
      'page': 1,
      'results': [
        {
          'id': 1,
          'title': 'Test Movie',
          'poster_path': '/test.jpg',
          'overview': 'Test overview',
          'release_date': '2024-01-01',
          'vote_average': 8.5,
          'vote_count': 100,
        }
      ],
      'total_pages': 1,
      'total_results': 1,
    };

    test('should return popular movies when call is successful', () async {
      when(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await dataSource.getPopularMovies(tPage);

      expect(result.results.length, 1);
      expect(result.results.first.title, 'Test Movie');
      verify(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')));
    });

    test('should throw exception when call fails', () async {
      when(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(Exception('Network error'));

      expect(() => dataSource.getPopularMovies(tPage), throwsException);
    });
  });
}