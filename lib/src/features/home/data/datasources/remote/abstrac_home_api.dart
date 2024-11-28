import 'package:movie_technical_test/src/features/home/data/models/detail_movie_model.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';
import 'package:movie_technical_test/src/features/home/data/models/search_movie_model.dart';

abstract class AbstracHomeApi {
  Future<MovieModel> getMoviesNowPlaying(String params);
  Future<DetailMovieModel> getDetailMovie(String params);
  Future<MovieModel> getSearchMovies(SearchMovieModel params);
  Future<MovieModel> getMoviesUpcomming(String params);
  Future<List<Genre>> getAllGenre();
}
