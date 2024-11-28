part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetMoviesHomeEvent extends HomeEvent {
  final String? page;
  const GetMoviesHomeEvent({this.page});
}

class GetMoviesUpcommingHomeEvent extends HomeEvent {
  final String? page;
  const GetMoviesUpcommingHomeEvent({this.page});
}

class GetGenreHomeEvent extends HomeEvent {
  const GetGenreHomeEvent();
}

class GetSearchMoviesHomeEvent extends HomeEvent {
  final SearchMovieModel query;
  const GetSearchMoviesHomeEvent({
    required this.query,
  });
}
