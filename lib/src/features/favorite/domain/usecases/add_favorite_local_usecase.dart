import 'package:dartz/dartz.dart';
import '../repositories/abstrac_favorite_repository.dart';
import '../../../home/data/models/movie_model.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';

class AddFavoriteLocalUsecase extends Usecase<NoParams, Result> {
  final AbstracFavoriteRepository repository;

  AddFavoriteLocalUsecase(this.repository);

  @override
  Future<Either<Failure, NoParams>> call(Result params) async {
    final result = await repository.addFavoritesLocal(params);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
