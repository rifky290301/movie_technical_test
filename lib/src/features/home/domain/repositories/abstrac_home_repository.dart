import 'package:dartz/dartz.dart';
import 'package:movie_technical_test/src/core/network/error/failures.dart';

import '../../data/models/detail_movie_model.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/search_movie_model.dart';

abstract class AbstracHomeRepository {
  Future<Either<Failure, MovieModel>> getMoviesNowPlaying(String params);
  Future<Either<Failure, DetailMovieModel>> getDetailMovie(String params);
  Future<Either<Failure, MovieModel>> getSearchMovies(SearchMovieModel params);
  Future<Either<Failure, MovieModel>> getMoviesUpcomming(String params);
}
