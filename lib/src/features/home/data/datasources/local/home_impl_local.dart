import 'dart:convert';

import 'package:movie_technical_test/src/core/utils/constant/local_storage_constants.dart';
import 'package:movie_technical_test/src/features/home/data/models/detail_movie_model.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'abstrac_home_local.dart';

class HomeImplLocal extends AbstracHomeLocal {
  final SharedPreferences _preferences;

  HomeImplLocal(this._preferences);

  @override
  Future<MovieModel?> getMovilesLocal() async {
    final result = _preferences.getString(LocalStorageConstants.movie);
    if (result != null) {
      var json = jsonDecode(result);
      return MovieModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<DetailMovieModel?> getDetailMovileLocal(String param) {
    // TODO: implement getDetailMovileLocal
    throw UnimplementedError();
  }
}
