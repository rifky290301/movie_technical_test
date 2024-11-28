import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../repositories/abstrac_favorite_repository.dart';

class GetListIdFavoriteUsecase extends Usecase<List<int>, NoParams> {
  final AbstracFavoriteRepository repository;

  GetListIdFavoriteUsecase(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(NoParams params) async {
    final result = await repository.getListIdFavorite();
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
