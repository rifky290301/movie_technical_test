import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failures.dart';
import '../datasources/local/home_impl_local.dart';
import '../datasources/remote/home_impl_api.dart';
import '../models/detail_movie_model.dart';
import '../models/movie_model.dart';
import '../models/search_movie_model.dart';
import '../../domain/repositories/abstrac_home_repository.dart';

import '../../../../core/network/error/exceptions.dart';

class HomeRepositoryImpl extends AbstracHomeRepository {
  final HomeImplApi homeApi;
  final HomeImplLocal homeLocal;

  HomeRepositoryImpl(this.homeApi, this.homeLocal);
  @override
  Future<Either<Failure, DetailMovieModel>> getDetailMovie(String params) async {
    try {
      final result = await homeApi.getDetailMovie(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, MovieModel>> getMoviesNowPlaying(String params) async {
    try {
      final result = await homeApi.getMoviesNowPlaying(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, MovieModel>> getSearchMovies(SearchMovieModel params) async {
    try {
      final result = await homeApi.getSearchMovies(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, MovieModel>> getMoviesUpcomming(String params) async {
    try {
      final result = await homeApi.getMoviesUpcomming(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }
}
