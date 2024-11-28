import 'package:dartz/dartz.dart';
import 'package:movie_technical_test/src/core/utils/usecase/usecase.dart';

import '../../../../core/network/error/failures.dart';
import '../../../home/data/models/movie_model.dart';

abstract class AbstracFavoriteRepository {
  Future<Either<Failure, List<Result>>> getFavoritesLocal();
  Future<Either<Failure, List<int>>> getListIdFavorite();
  Future<Either<Failure, NoParams>> addFavoritesLocal(Result params);
  Future<Either<Failure, NoParams>> removeFavoritesLocal(String params);
}
