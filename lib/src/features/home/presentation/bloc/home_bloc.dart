import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  HomeBloc(
    this.getMoviesNowPlayingUsecase,
    this.getSearchMoviesUsecase,
    this.getMoviesUpcomingUsecase,
  ) : super(HomeInitial()) {
    on<GetMoviesHomeEvent>(_getMoviesNowPlaying);
    on<GetMoviesUpcommingHomeEvent>(_getMoviesUpcoming);
    on<GetSearchMoviesHomeEvent>(_getSearchMovie);
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
