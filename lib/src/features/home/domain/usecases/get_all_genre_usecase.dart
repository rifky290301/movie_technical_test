import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../../data/models/detail_movie_model.dart';
import '../repositories/abstrac_home_repository.dart';

class GetAllGenreUsecase extends Usecase<List<Genre>, NoParams> {
  final AbstracHomeRepository repository;

  GetAllGenreUsecase(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) async {
    final result = await repository.getAllGenre();
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
