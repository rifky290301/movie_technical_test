import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecase/usecase.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/search_movie_model.dart';
import '../repositories/abstrac_home_repository.dart';

class GetSearchMoviesUsecase extends Usecase<MovieModel, SearchMovieModel> {
  final AbstracHomeRepository repository;

  GetSearchMoviesUsecase(this.repository);

  @override
  Future<Either<Failure, MovieModel>> call(SearchMovieModel params) async {
    final result = await repository.getSearchMovies(params);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
