part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSearching extends FavoriteState {
  final List<Result> listFavoriteMovie;
  const FavoriteSearching(this.listFavoriteMovie);

  @override
  List<Object> get props => [listFavoriteMovie];
}

class FavoriteSuccess extends FavoriteState {
  final List<Result> listFavoriteMovie;
  const FavoriteSuccess(this.listFavoriteMovie);

  @override
  List<Object> get props => [listFavoriteMovie];
}

class FavoriteFailure extends FavoriteState {
  final String error;
  const FavoriteFailure({required this.error});

  @override
  List<Object> get props => [error];
}
