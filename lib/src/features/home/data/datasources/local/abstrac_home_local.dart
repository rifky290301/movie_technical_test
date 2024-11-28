import 'package:movie_technical_test/src/features/home/data/models/detail_movie_model.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';

abstract class AbstracHomeLocal {
  Future<MovieModel?> getMovilesLocal();
  Future<DetailMovieModel?> getDetailMovileLocal(String param);
}
