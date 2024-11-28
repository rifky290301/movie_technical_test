import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../../data/models/detail_movie_model.dart';
import '../repositories/abstrac_home_repository.dart';

class GetDetailMovieUsecase extends Usecase<DetailMovieModel, String> {
  final AbstracHomeRepository repository;

  GetDetailMovieUsecase(this.repository);

  @override
  Future<Either<Failure, DetailMovieModel>> call(String params) async {
    final result = await repository.getDetailMovie(params);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
