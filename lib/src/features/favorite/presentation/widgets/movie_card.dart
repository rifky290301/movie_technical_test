part of '../pages/favorite_page.dart';

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
