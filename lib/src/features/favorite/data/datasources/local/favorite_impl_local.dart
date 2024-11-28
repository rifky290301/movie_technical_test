import 'dart:async';
import 'dart:convert';

import 'package:movie_technical_test/src/core/utils/constant/local_storage_constants.dart';
import 'package:movie_technical_test/src/core/utils/log/app_logger.dart';
import 'package:movie_technical_test/src/features/favorite/data/datasources/local/abstrac_favorite_local.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteImplLocal extends AbstracFavoriteLocal {
  final SharedPreferences _preferences;

  FavoriteImplLocal(this._preferences);

  @override
  Future<List<Result>> getFavoritesLocal() async {
    try {
      final result = _preferences.getString(LocalStorageConstants.favoriteMovie);
      if (result != null) {
        List<Result> favorites = [];
        var list = jsonDecode(result);
        for (var e in list) {
          favorites.add(Result.fromJson(e));
        }
        return favorites;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Future addFavoritesLocal(Result params) async {
    try {
      List<Result> listMovie = await getFavoritesLocal();
      listMovie.add(params);
      _preferences.setString(LocalStorageConstants.favoriteMovie, jsonEncode(listMovie));
      List<String> preListFavorite = (await getListIdFavorite()).map((e) => e.toString()).toList();
      _preferences.setStringList(LocalStorageConstants.favoriteMovieId, [params.id.toString(), ...preListFavorite]);
    } catch (e) {
      logger.warning('addFavoritesLocal $e');
    }
  }

  @override
  Future<List<int>> getListIdFavorite() async {
    try {
      List<String>? result = _preferences.getStringList(LocalStorageConstants.favoriteMovieId);
      return result?.map((e) => int.parse(e)).toList() ?? [];
    } catch (e) {
      logger.warning('getListIdFavorite  $e');
      return [];
    }
  }

  @override
  Future removeFavoritesLocal(String params) async {
    List<Result> listMovie = await getFavoritesLocal();
    logger.warning('beforeee listMovie ${listMovie.length}');

    listMovie.removeWhere((e) => e.id.toString() == params);

    logger.warning('removeee listMovie ${listMovie.length}');
    unawaited(_preferences.setString(LocalStorageConstants.favoriteMovie, jsonEncode(listMovie)));
    List<String> listIdFavorite = listMovie.map((e) => e.id.toString()).toList();
    logger.warning('removeee listIdFavorite $listIdFavorite');
    _preferences.setStringList(LocalStorageConstants.favoriteMovieId, listIdFavorite);
  }
}
