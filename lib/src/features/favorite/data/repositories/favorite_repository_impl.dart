import 'package:dartz/dartz.dart';
import 'package:movie_technical_test/src/core/network/error/failures.dart';
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
}
