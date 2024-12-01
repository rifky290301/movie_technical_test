import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_technical_test/src/core/styles/app_colors.dart';
import '../../../core/helper/datetime_format.dart';
import '../../../core/utils/constant/app_constants.dart';
import '../../../core/utils/injections.dart';
import '../../../core/utils/log/app_logger.dart';
import '../../../features/favorite/domain/usecases/add_favorite_local_usecase.dart';
import '../../../features/favorite/domain/usecases/get_list_id_favorite_usecase.dart';
import '../../../features/favorite/domain/usecases/remove_favorite_local_usecase.dart';
import '../../../features/home/data/models/movie_model.dart';
import '../bloc/detail_bloc.dart';

class DetailMoviePage extends StatelessWidget {
  final Result movie;
  const DetailMoviePage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    List<int> listIdMovieFavorite = [];
    DetailBloc bloc = DetailBloc(
      sl<AddFavoriteLocalUsecase>(),
      sl<GetListIdFavoriteUsecase>(),
      sl<RemoveFavoriteLocalUsecase>(),
    );
    bloc.add(GetIdFavoriteMovies());
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: movie.id.toString(),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: '$networkImages${movie.backdropPath}',
                      placeholder: (context, url) => const UnconstrainedBox(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      height: 300,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: BlocConsumer<DetailBloc, DetailState>(
                      bloc: bloc,
                      listener: (context, state) {
                        if (state is FavoriteLoadingDetail) {
                        } else if (state is SuccesGetIdFavorite) {
                          listIdMovieFavorite = state.listIdFavorite;
                        } else if (state is FavoriteSuccessDetail) {
                        } else if (state is FavoriteFailure) {
                          logger.shout(state.error);
                        }
                      },
                      builder: (context, state) {
                        bool isFavorite = listIdMovieFavorite.contains(movie.id);
                        return FloatingActionButton(
                          backgroundColor: Colors.black.withOpacity(0.7),
                          child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                          onPressed: () {
                            if (isFavorite) {
                              bloc.add(RemoveFavoriteMovieDetailEvent(movie: movie));
                            } else {
                              bloc.add(AddFavoriteMovieDetailEvent(movie: movie));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.originalTitle ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "4K",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${movie.voteCount} votes",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${movie.voteAverage} (IMDb)",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Release date", style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(movie.releaseDate?.edm5y ?? '', style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Genre", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            // Row(
                            //   children: movie.genres!.map(
                            //     (e) {
                            //       return Padding(
                            //         padding: const EdgeInsets.only(left: 8),
                            //         child: Chip(
                            //           label: Text(e.name ?? ''),
                            //           backgroundColor: Colors.black,
                            //           labelStyle: const TextStyle(color: Colors.white),
                            //         ),
                            //       );
                            //     },
                            //   ).toList(),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Overview",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Production Companies",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // SizedBox(
                    //   height: 150,
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: movie.productionCompanies?.map((e) {
                    //           return buildRelatedMovieCard(
                    //             e.name ?? '',
                    //             e.logoPath ?? '',
                    //           );
                    //         }).toList() ??
                    //         [],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRelatedMovieCard(String title, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Image.network(
            '$networkImages$imageUrl',
            height: 100,
            width: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
