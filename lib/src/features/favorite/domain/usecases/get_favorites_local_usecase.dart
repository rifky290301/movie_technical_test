import 'package:dartz/dartz.dart';
import '../repositories/abstrac_favorite_repository.dart';
import '../../../home/data/models/movie_model.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';

class GetFavoritesLocalUsecase extends Usecase<List<Result>, NoParams> {
  final AbstracFavoriteRepository repository;

  GetFavoritesLocalUsecase(this.repository);

  @override
  Future<Either<Failure, List<Result>>> call(NoParams params) async {
    final result = await repository.getFavoritesLocal();
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
