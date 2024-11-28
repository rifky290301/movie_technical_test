import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../repositories/abstrac_favorite_repository.dart';

class RemoveFavoriteLocalUsecase extends Usecase<NoParams, String> {
  final AbstracFavoriteRepository repository;

  RemoveFavoriteLocalUsecase(this.repository);

  @override
  Future<Either<Failure, NoParams>> call(String params) async {
    final result = await repository.removeFavoritesLocal(params);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
