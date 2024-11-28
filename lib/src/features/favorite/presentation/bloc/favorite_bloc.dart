import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/add_favorite_local_usecase.dart';
import '../../domain/usecases/get_list_id_favorite_usecase.dart';
import '../../domain/usecases/remove_favorite_local_usecase.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../../../home/data/models/movie_model.dart';

import '../../domain/usecases/get_favorites_local_usecase.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesLocalUsecase getFavoritesLocalUsecase;
  // final AddFavoriteLocalUsecase addFavoriteLocalUsecase;
  final GetListIdFavoriteUsecase getListIdFavoriteUsecase;
  final RemoveFavoriteLocalUsecase removeFavoriteLocalUsecase;

  List<Result> listMovieFavorite = [];
  // List<int> listIdMovieFavorite = [];

  FavoriteBloc(
    this.getFavoritesLocalUsecase,
    // this.addFavoriteLocalUsecase,
    this.getListIdFavoriteUsecase,
    this.removeFavoriteLocalUsecase,
  ) : super(FavoriteInitial()) {
    on<GetFavoriteMovies>(_getMoviesFavorite);
    on<GetSearchFavoriteMovieEvent>(_onSearchingEvent);
    // on<AddFavoriteMovieEvent>(_addMoviesFavorite);
    on<RemoveFavoriteMovieEvent>(_removeMoviesFavorite);
  }

  _getMoviesFavorite(GetFavoriteMovies event, Emitter<FavoriteState> emit) async {
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

  _removeMoviesFavorite(RemoveFavoriteMovieEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final result = await removeFavoriteLocalUsecase.call(event.movie.id.toString());
      result.fold((l) {
        emit(const FavoriteFailure(error: 'Gagal menghapus favorite.'));
      }, (r) {
        listMovieFavorite.remove(event.movie);
        emit(FavoriteSuccess(listMovieFavorite));
      });
    } catch (e) {
      emit(FavoriteFailure(error: e.toString()));
    }
  }

  _onSearchingEvent(GetSearchFavoriteMovieEvent event, Emitter<FavoriteState> emit) {
    emit(FavoriteSearching(_runFilter(event.query)));
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
