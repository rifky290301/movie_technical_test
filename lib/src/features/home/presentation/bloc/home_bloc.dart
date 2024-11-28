import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_technical_test/src/core/utils/usecase/usecase.dart';
import 'package:movie_technical_test/src/features/home/data/models/detail_movie_model.dart';
import 'package:movie_technical_test/src/features/home/domain/usecases/get_all_genre_usecase.dart';
import '../../data/models/movie_model.dart';

import '../../../../core/network/error/failures.dart';
import '../../data/models/search_movie_model.dart';
import '../../domain/usecases/get_movies_now_playing_usecase.dart';
import '../../domain/usecases/get_movies_upcoming_usecase.dart';
import '../../domain/usecases/get_search_movies_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMoviesNowPlayingUsecase getMoviesNowPlayingUsecase;
  final GetMoviesUpcomingUsecase getMoviesUpcomingUsecase;
  final GetSearchMoviesUsecase getSearchMoviesUsecase;
  final GetAllGenreUsecase getAllGenreUsecase;

  HomeBloc(
    this.getMoviesNowPlayingUsecase,
    this.getSearchMoviesUsecase,
    this.getMoviesUpcomingUsecase,
    this.getAllGenreUsecase,
  ) : super(HomeInitial()) {
    on<GetMoviesHomeEvent>(_getMoviesNowPlaying);
    on<GetMoviesUpcommingHomeEvent>(_getMoviesUpcoming);
    on<GetSearchMoviesHomeEvent>(_getSearchMovie);
    on<GetGenreHomeEvent>(_getAllGenre);
  }

  _getMoviesNowPlaying(GetMoviesHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final result = await getMoviesNowPlayingUsecase.call(event.page ?? '1');
      result.fold((l) {
        if (l is CancelTokenFailure) {
          emit(HomeLoading());
        } else {
          emit(const HomeFailure(error: 'Gagal ambil data film'));
        }
      }, (r) {
        emit(HomeSuccess(r));
      });
    } catch (e) {
      emit(HomeFailure(error: e.toString()));
    }
  }

  _getMoviesUpcoming(GetMoviesUpcommingHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final result = await getMoviesUpcomingUsecase.call(event.page ?? '1');
      result.fold((l) {
        if (l is CancelTokenFailure) {
          emit(HomeLoading());
        } else {
          emit(const HomeFailure(error: 'Gagal ambil data film'));
        }
      }, (r) {
        emit(HomeSuccess(r));
      });
    } catch (e) {
      emit(HomeFailure(error: e.toString()));
    }
  }

  _getAllGenre(GetGenreHomeEvent event, Emitter<HomeState> emit) async {
    emit(GenreLoading());
    try {
      final result = await getAllGenreUsecase.call(NoParams());
      result.fold((l) {
        if (l is CancelTokenFailure) {
          emit(GenreLoading());
        } else {
          emit(const HomeFailure(error: 'Gagal ambil data genre'));
        }
      }, (r) {
        emit(GenresSuccess(r));
      });
    } catch (e) {
      emit(HomeFailure(error: e.toString()));
    }
  }

  _getSearchMovie(GetSearchMoviesHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final result = await getSearchMoviesUsecase.call(event.query);
      result.fold((l) {
        if (l is CancelTokenFailure) {
          emit(HomeLoading());
        } else {
          emit(const HomeFailure(error: 'Gagal ambil data film'));
        }
      }, (r) {
        emit(HomeSuccess(r));
      });
    } catch (e) {
      emit(HomeFailure(error: e.toString()));
    }
  }
}
