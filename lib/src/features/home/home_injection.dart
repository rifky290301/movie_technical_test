import '../../core/utils/injections.dart';
import 'data/datasources/local/abstrac_home_local.dart';
import 'data/datasources/local/home_impl_local.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/abstrac_home_repository.dart';

import '../../core/network/dio_network.dart';
import 'data/datasources/remote/home_impl_api.dart';
import 'domain/usecases/get_detail_movie_usecase.dart';
import 'domain/usecases/get_movies_now_playing_usecase.dart';
import 'domain/usecases/get_movies_upcoming_usecase.dart';
import 'domain/usecases/get_search_movies_usecase.dart';

initHomeInjection() {
  sl.registerSingleton<HomeImplApi>(HomeImplApi(DioNetwork.appAPI));
  sl.registerSingleton<HomeImplLocal>(HomeImplLocal(sl()));
  sl.registerSingleton<AbstracHomeLocal>(HomeImplLocal(sl()));
  sl.registerSingleton<AbstracHomeRepository>(HomeRepositoryImpl(sl(), sl()));
  sl.registerSingleton<GetSearchMoviesUsecase>(GetSearchMoviesUsecase(sl()));
  sl.registerSingleton<GetMoviesNowPlayingUsecase>(GetMoviesNowPlayingUsecase(sl()));
  sl.registerSingleton<GetMoviesUpcomingUsecase>(GetMoviesUpcomingUsecase(sl()));
  sl.registerSingleton<GetDetailMovieUsecase>(GetDetailMovieUsecase(sl()));
}
