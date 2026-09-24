import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tmdb_app/domain/entities/movie.dart';

void main() {
  group('Movie', () {
    test('should format rating correctly', () {
      const movie = Movie(
        id: 1,
        title: 'Test Movie',
        voteAverage: 8.5,
      );

      expect(movie.formattedRating, '8.5/10');
    });

    test('should return N/A when rating is null', () {
      const movie = Movie(
        id: 1,
        title: 'Test Movie',
      );

      expect(movie.formattedRating, 'N/A');
    });

    test('should implement Equatable', () {
      const movie1 = Movie(id: 1, title: 'Test Movie');
      const movie2 = Movie(id: 1, title: 'Test Movie');
      const movie3 = Movie(id: 2, title: 'Test Movie');

      expect(movie1, equals(movie2));
      expect(movie1, isNot(equals(movie3)));
    });
  });
}