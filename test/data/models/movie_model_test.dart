import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tmdb_app/data/models/movie_model.dart';

void main() {
  group('MovieModel', () {
    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'poster_path': '/test.jpg',
        'backdrop_path': '/backdrop.jpg',
        'overview': 'Test overview',
        'release_date': '2024-01-01',
        'vote_average': 8.5,
        'vote_count': 100,
      };

      final model = MovieModel.fromJson(json);
      
      expect(model.id, 1);
      expect(model.title, 'Test Movie');
      expect(model.posterPath, '/test.jpg');
      expect(model.voteAverage, 8.5);
    });

    test('should serialize to JSON correctly', () {
      final model = const MovieModel(
        id: 1,
        title: 'Test Movie',
        posterPath: '/test.jpg',
      );

      final json = model.toJson();
      
      expect(json['id'], 1);
      expect(json['title'], 'Test Movie');
      expect(json['poster_path'], '/test.jpg');
    });

    test('should generate full poster URL', () {
      final model = const MovieModel(
        id: 1,
        title: 'Test Movie',
        posterPath: '/test.jpg',
      );

      expect(model.fullPosterUrl, contains('/w500/test.jpg'));
    });

    test('should return placeholder URL when poster is null', () {
      final model = const MovieModel(
        id: 1,
        title: 'Test Movie',
      );

      expect(model.fullPosterUrl, contains('via.placeholder.com'));
    });
  });
}