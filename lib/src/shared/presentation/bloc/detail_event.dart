part of 'detail_bloc.dart';

sealed class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class GetIdFavoriteMovies extends DetailEvent {
  // final List<int> listIdFavorite;
  // const GetIdFavoriteMovies({
  //   required this.listIdFavorite,
  // });
}

class AddFavoriteMovieDetailEvent extends DetailEvent {
  final Result movie;
  const AddFavoriteMovieDetailEvent({
    required this.movie,
  });
}

class RemoveFavoriteMovieDetailEvent extends DetailEvent {
  final Result movie;
  const RemoveFavoriteMovieDetailEvent({
    required this.movie,
  });
}
