import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';

abstract class AbstracFavoriteLocal {
  Future<List<Result>> getFavoritesLocal();
  Future<List<int>> getListIdFavorite();
  Future addFavoritesLocal(Result params);
  Future removeFavoritesLocal(String params);
}
