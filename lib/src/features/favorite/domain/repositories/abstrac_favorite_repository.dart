import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../home/data/models/movie_model.dart';

abstract class AbstracFavoriteRepository {
  Future<Either<Failure, List<Result>>> getFavoritesLocal();
}
