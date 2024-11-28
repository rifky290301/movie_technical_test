part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSearching extends HomeState {
  final MovieModel movieModel;
  const HomeSearching(this.movieModel);

  @override
  List<Object> get props => [movieModel];
}

class HomeSuccess extends HomeState {
  final MovieModel movieModel;
  const HomeSuccess(this.movieModel);

  @override
  List<Object> get props => [movieModel];
}

class HomeFailure extends HomeState {
  final String error;
  const HomeFailure({required this.error});

  @override
  List<Object> get props => [error];
}
