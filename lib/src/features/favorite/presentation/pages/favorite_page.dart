import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_technical_test/main.dart';
import 'package:movie_technical_test/src/core/helper/ui_theme_extention.dart';
import 'package:movie_technical_test/src/core/translations/l10n.dart';
import 'package:movie_technical_test/src/shared/presentation/widgets/app_loading.dart';
import '../../../../core/helper/datetime_format.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/log/app_logger.dart';
import '../../domain/usecases/get_favorites_local_usecase.dart';
import '../../domain/usecases/get_list_id_favorite_usecase.dart';
import '../../domain/usecases/remove_favorite_local_usecase.dart';
import '../bloc/favorite_bloc.dart';
import '../../../home/data/models/movie_model.dart';
import '../../../../shared/presentation/widgets/input_decoration_custom.dart';

part '../widgets/movie_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    FavoriteBloc bloc = FavoriteBloc(
      sl<GetFavoritesLocalUsecase>(),
      sl<GetListIdFavoriteUsecase>(),
      sl<RemoveFavoriteLocalUsecase>(),
    );
    bloc.add(const GetFavoriteMovies());
    List<Result> listMovieFavorite = [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(
              color: Colors.white,
            ),
            onChanged: (value) {
              bloc.add(GetSearchFavoriteMovieEvent(query: value));
            },
            decoration: inputDecorationCustom(context),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocConsumer<FavoriteBloc, FavoriteState>(
              bloc: bloc,
              listener: (context, state) {
                if (state is FavoriteSuccess) {
                  listMovieFavorite = state.listFavoriteMovie;
                } else if (state is FavoriteSearching) {
                  listMovieFavorite = state.listFavoriteMovie;
                }
              },
              builder: (context, state) {
                if (state is FavoriteLoading) return const AppLoading();
                if (state is FavoriteSuccess && state.listFavoriteMovie.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('$assets/undraw/no_data.svg', height: 150),
                      const SizedBox(height: 12),
                      Text(
                        S.of(context).empty_data,
                        style: context.regular.copyWith(color: Colors.white),
                      ),
                    ],
                  );
                }
                if (state is FavoriteFailure) {
                  return SvgPicture.asset('$assets/undraw/error.svg', height: 150);
                }
                return Column(
                  children: listMovieFavorite.map((e) {
                    return MovieCard(
                      movie: e,
                      bloc: bloc,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
