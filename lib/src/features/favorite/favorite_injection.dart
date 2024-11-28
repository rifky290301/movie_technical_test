import '../../core/utils/injections.dart';
import 'data/datasources/local/abstrac_favorite_local.dart';
import 'data/datasources/local/favorite_impl_local.dart';
import 'data/repositories/favorite_repository_impl.dart';
import 'domain/repositories/abstrac_favorite_repository.dart';
import 'domain/usecases/get_favorites_local_usecase.dart';

initFavoriteInjection() {
  sl.registerSingleton<FavoriteImplLocal>(FavoriteImplLocal(sl()));
  sl.registerSingleton<AbstracFavoriteLocal>(FavoriteImplLocal(sl()));
  sl.registerSingleton<AbstracFavoriteRepository>(FavoriteRepositoryImpl(sl()));
  sl.registerSingleton<GetFavoritesLocalUsecase>(GetFavoritesLocalUsecase(sl()));
}
