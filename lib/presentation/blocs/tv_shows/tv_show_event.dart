import 'package:equatable/equatable.dart';

abstract class TVShowEvent extends Equatable {
  const TVShowEvent();

  @override
  List<Object?> get props => [];
}

class LoadTVShows extends TVShowEvent {
  final bool refresh;

  const LoadTVShows({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreTVShows extends TVShowEvent {}
