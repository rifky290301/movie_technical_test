import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../datasources/local/favorite_impl_local.dart';
import '../../domain/repositories/abstrac_favorite_repository.dart';
import '../../../home/data/models/movie_model.dart';

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
      return Right(result);
    } catch (e) {
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
