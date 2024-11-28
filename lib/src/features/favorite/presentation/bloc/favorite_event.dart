part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class GetFavoriteMovies extends FavoriteEvent {
  const GetFavoriteMovies();
}

class GetSearchFavoriteMovieEvent extends FavoriteEvent {
  final String query;
  const GetSearchFavoriteMovieEvent({
    required this.query,
  });
}
