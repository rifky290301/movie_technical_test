import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_technical_test/src/core/utils/usecase/usecase.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';

import '../../domain/usecases/get_favorites_local_usecase.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesLocalUsecase getFavoritesLocalUsecase;

  List<Result> listMovieFavorite = [];

  FavoriteBloc(this.getFavoritesLocalUsecase) : super(FavoriteInitial()) {
    on<GetFavoriteMovies>(_getMoviesFavorite);
    on<GetSearchFavoriteMovieEvent>(_onSearchingEvent);
  }

  _getMoviesFavorite(GetFavoriteMovies evenet, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final result = await getFavoritesLocalUsecase.call(NoParams());
      result.fold((l) {
        emit(const FavoriteFailure(error: 'Gagal ambil data favorite movie.'));
      }, (r) {
        listMovieFavorite = r;
        emit(FavoriteSuccess(r));
      });
    } catch (e) {
      emit(FavoriteFailure(error: e.toString()));
    }
  }

  _onSearchingEvent(GetSearchFavoriteMovieEvent evenet, Emitter<FavoriteState> emit) {
    emit(FavoriteSearching(_runFilter(evenet.query)));
  }

  // This function is called whenever the text field changes
  List<Result> _runFilter(
    String text,
  ) {
    List<Result> results = [];
    if (text.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = List.from(listMovieFavorite);
    } else {
      results = listMovieFavorite.where((user) {
        return (user.title ?? '').toLowerCase().contains(text.toLowerCase());
      }).toList();
    }
    return results;
  }
}
