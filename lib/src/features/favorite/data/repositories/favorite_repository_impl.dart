import 'package:dartz/dartz.dart';
import 'package:movie_technical_test/src/core/network/error/failures.dart';
import 'package:movie_technical_test/src/core/utils/log/app_logger.dart';
import 'package:movie_technical_test/src/core/utils/usecase/usecase.dart';
import 'package:movie_technical_test/src/features/favorite/data/datasources/local/favorite_impl_local.dart';
import 'package:movie_technical_test/src/features/favorite/domain/repositories/abstrac_favorite_repository.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';

class FavoriteRepositoryImpl extends AbstracFavoriteRepository {
  final FavoriteImplLocal favoriteImplLocal;

  FavoriteRepositoryImpl(this.favoriteImplLocal);
  @override
  Future<Either<Failure, List<Result>>> getFavoritesLocal() async {
    try {
      final result = await favoriteImplLocal.getFavoritesLocal();
      return Right(result);
    } catch (e) {
      return Left(UnknowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoParams>> addFavoritesLocal(Result params) async {
    try {
      await favoriteImplLocal.addFavoritesLocal(params);
      return Right(NoParams());
    } catch (e) {
      return Left(UnknowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getListIdFavorite() async {
    try {
      final result = await favoriteImplLocal.getListIdFavorite();
      logger.warning('37');
      return Right(result);
    } catch (e) {
      logger.warning('40');
      return Left(UnknowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoParams>> removeFavoritesLocal(String params) async {
    try {
      await favoriteImplLocal.removeFavoritesLocal(params);
      return Right(NoParams());
    } catch (e) {
      return Left(UnknowFailure(e.toString()));
    }
  }
}
