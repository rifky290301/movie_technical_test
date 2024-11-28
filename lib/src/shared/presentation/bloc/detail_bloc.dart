import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/utils/usecase/usecase.dart';
import '../../../features/favorite/domain/usecases/add_favorite_local_usecase.dart';
import '../../../features/favorite/domain/usecases/get_list_id_favorite_usecase.dart';
import '../../../features/favorite/domain/usecases/remove_favorite_local_usecase.dart';
import '../../../features/home/data/models/movie_model.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final AddFavoriteLocalUsecase addFavoriteLocalUsecase;
  final GetListIdFavoriteUsecase getListIdFavoriteUsecase;
  final RemoveFavoriteLocalUsecase removeFavoriteLocalUsecase;

  List<int> listIdMovieFavorite = [];

  DetailBloc(
    this.addFavoriteLocalUsecase,
    this.getListIdFavoriteUsecase,
    this.removeFavoriteLocalUsecase,
  ) : super(DetailInitial()) {
    on<GetIdFavoriteMovies>(_getListIdFavorite);
    on<AddFavoriteMovieDetailEvent>(_addMoviesFavorite);
    on<RemoveFavoriteMovieDetailEvent>(_removeMoviesFavorite);
  }

  _addMoviesFavorite(AddFavoriteMovieDetailEvent event, Emitter<DetailState> emit) async {
    emit(FavoriteLoadingDetail());
    try {
      final result = await addFavoriteLocalUsecase.call(event.movie);
      result.fold((l) {
        emit(const FavoriteFailure(error: 'Gagal menambahkan ke favorite.'));
      }, (r) {
        listIdMovieFavorite.add(event.movie.id ?? 0);
        emit(SuccesGetIdFavorite(listIdFavorite: listIdMovieFavorite));
      });
    } catch (e) {
      emit(FavoriteFailure(error: e.toString()));
    }
  }

  _getListIdFavorite(GetIdFavoriteMovies event, Emitter<DetailState> emit) async {
    emit(FavoriteLoadingDetail());
    try {
      final result = await getListIdFavoriteUsecase.call(NoParams());
      result.fold((l) {
        emit(const FavoriteFailure(error: 'Gagal menambahkan mengambil id favorite.'));
      }, (r) {
        listIdMovieFavorite = r;
        emit(SuccesGetIdFavorite(
          listIdFavorite: r,
        ));
      });
    } catch (e) {
      emit(FavoriteFailure(error: e.toString()));
    }
  }

  _removeMoviesFavorite(RemoveFavoriteMovieDetailEvent event, Emitter<DetailState> emit) async {
    emit(FavoriteLoadingDetail());
    try {
      final result = await removeFavoriteLocalUsecase.call(event.movie.id.toString());
      result.fold((l) {
        emit(const FavoriteFailure(error: 'Gagal menghapus favorite.'));
      }, (r) {
        if (listIdMovieFavorite.remove(event.movie.id)) {
          emit(SuccesGetIdFavorite(listIdFavorite: listIdMovieFavorite));
        }
      });
    } catch (e) {
      emit(FavoriteFailure(error: e.toString()));
    }
  }
}
