import 'dart:async' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:flutter_tmdb_app/domain/entities/tv_show.dart' as _i3;
import 'package:flutter_tmdb_app/domain/repositories/tv_show_repository.dart' as _i2;

// ignore_for_file: type=lint

class MockTVShowRepository extends _i1.Mock implements _i2.TVShowRepository {
  MockTVShowRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i3.TVShow>> getPopularTVShows({int? page = 1}) =>
      (super.noSuchMethod(
        Invocation.method(#getPopularTVShows, [], {#page: page}),
        returnValue: _i4.Future<List<_i3.TVShow>>.value(<_i3.TVShow>[]),
      ) as _i4.Future<List<_i3.TVShow>>);

  @override
  _i4.Future<List<_i3.TVShow>> getCachedPopularTVShows() =>
      (super.noSuchMethod(
        Invocation.method(#getCachedPopularTVShows, []),
        returnValue: _i4.Future<List<_i3.TVShow>>.value(<_i3.TVShow>[]),
      ) as _i4.Future<List<_i3.TVShow>>);

  @override
  _i4.Future<void> cachePopularTVShows(List<_i3.TVShow>? tvShows) =>
      (super.noSuchMethod(
        Invocation.method(#cachePopularTVShows, [tvShows]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
