import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
  @override
  List<Object> get props => [];
}

class LoadMovies extends MovieEvent {
  final bool refresh;
  const LoadMovies({this.refresh = false});
  @override
  List<Object> get props => [refresh];
}

class LoadMoreMovies extends MovieEvent {}
