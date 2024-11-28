import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_technical_test/src/core/helper/datetime_format.dart';
import 'package:movie_technical_test/src/core/router/app_routes.dart';
import 'package:movie_technical_test/src/core/utils/constant/app_constants.dart';
import 'package:movie_technical_test/src/core/utils/injections.dart';
import 'package:movie_technical_test/src/core/utils/log/app_logger.dart';
import 'package:movie_technical_test/src/features/favorite/domain/usecases/add_favorite_local_usecase.dart';
import 'package:movie_technical_test/src/features/favorite/domain/usecases/get_favorites_local_usecase.dart';
import 'package:movie_technical_test/src/features/favorite/domain/usecases/get_list_id_favorite_usecase.dart';
import 'package:movie_technical_test/src/features/favorite/domain/usecases/remove_favorite_local_usecase.dart';
import 'package:movie_technical_test/src/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';

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
    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            bloc.add(GetSearchFavoriteMovieEvent(query: value));
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            fillColor: Colors.white,
          ),
        ),
        Expanded(
          child: BlocConsumer<FavoriteBloc, FavoriteState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is FavoriteLoading) {
                logger.warning('loadinggg favorite');
              } else if (state is FavoriteSuccess) {
                listMovieFavorite = state.listFavoriteMovie;
                logger.warning('success ${listMovieFavorite.length}');
              } else if (state is FavoriteFailure) {
                logger.shout(state.error);
              } else if (state is FavoriteSearching) {
                listMovieFavorite = state.listFavoriteMovie;
              }
            },
            builder: (context, state) {
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
    );
  }
}

class MovieCard extends StatelessWidget {
  final Result movie;
  final FavoriteBloc bloc;

  const MovieCard({
    super.key,
    required this.movie,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AppRoute.detailMovie, extra: movie);
      },
      child: Card(
        color: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Gambar film
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: movie.id.toString(),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: 120,
                    width: 80,
                    imageUrl: '$networkImages${movie.posterPath}',
                    placeholder: (context, url) => const UnconstrainedBox(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Detail film
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.originalTitle ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    // Teks progress
                    Text(
                      movie.releaseDate!.edm5y,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Info ukuran & tombol hapus
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${movie.voteAverage} (IMDb)",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    onPressed: () {
                      bloc.add(RemoveFavoriteMovieEvent(movie: movie));
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
