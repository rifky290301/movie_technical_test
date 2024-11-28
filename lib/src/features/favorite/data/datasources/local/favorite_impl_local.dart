import 'dart:convert';

import 'package:movie_technical_test/src/core/utils/constant/local_storage_constants.dart';
import 'package:movie_technical_test/src/features/favorite/data/datasources/local/abstrac_favorite_local.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteImplLocal extends AbstracFavoriteLocal {
  final SharedPreferences _preferences;

  FavoriteImplLocal(this._preferences);

  @override
  Future<List<Result>> getFavoritesLocal() async {
    final result = _preferences.getString(LocalStorageConstants.favoriteMovie);
    if (result != null) {
      List<Result> favorites = [];
      List list = jsonDecode(result);
      for (Result e in list) {
        favorites.add(e);
      }
      return favorites;
    }
    return [];
  }
}
