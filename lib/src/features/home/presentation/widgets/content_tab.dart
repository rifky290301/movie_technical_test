part of '../pages/home_page.dart';

class ContentTab extends StatelessWidget {
  final int indexTab;
  final String? query;
  final List<int>? listIdGenre;
  final HomeBloc bloc;
  const ContentTab({
    super.key,
    required this.indexTab,
    this.query,
    this.listIdGenre,
    required this.bloc,
  });

  void getData() {
    if (indexTab == 0) {
      bloc.add(const GetMoviesHomeEvent());
    } else if (indexTab == 1) {
      bloc.add(const GetMoviesUpcommingHomeEvent());
    } else {
      bloc.add(GetSearchMoviesHomeEvent(query: SearchMovieModel(query: query, genre: listIdGenre)));
    }
  }

  @override
  Widget build(BuildContext context) {
    MovieModel? movieModel;
    getData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BlocConsumer<HomeBloc, HomeState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is HomeSuccess) {
                movieModel = state.movieModel;
              }
            },
            builder: (context, state) {
              if (state is HomeLoading) return const AppLoading();
              if (state is HomeFailure) return SvgPicture.asset('$assets/undraw/error.svg', height: 150);
              return Stack(children: [
                GridView.builder(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 64),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: movieModel?.results?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => context.push(AppRoute.detailMovie, extra: movieModel?.results?[index]),
                      child: Hero(
                        tag: movieModel?.results?[index].id.toString() ?? '',
                        child: Card(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: movieModel != null ? '$networkImages${movieModel?.results?[index].posterPath}' : defaultNullImage,
                            placeholder: (context, url) => const UnconstrainedBox(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlexiblePaginationWidget(
                    currentPage: (page) {
                      if (indexTab == 0) {
                        bloc.add(GetMoviesHomeEvent(page: page.toString()));
                      } else if (indexTab == 1) {
                        bloc.add(GetMoviesUpcommingHomeEvent(page: page.toString()));
                      } else {
                        bloc.add(
                          GetSearchMoviesHomeEvent(
                            query: SearchMovieModel(query: query, page: page, genre: listIdGenre),
                          ),
                        );
                      }
                    },
                    totalPages: movieModel?.totalPages ?? 0,
                  ),
                ),
              ]);
            },
          ),
        ),
      ],
    );
  }
}
