import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../../data/models/movie_model.dart';
import '../repositories/abstrac_home_repository.dart';

class GetMoviesUpcomingUsecase extends Usecase<MovieModel, String> {
  final AbstracHomeRepository repository;

  GetMoviesUpcomingUsecase(this.repository);

  @override
  Future<Either<Failure, MovieModel>> call(String params) async {
    final result = await repository.getMoviesUpcomming(params);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
