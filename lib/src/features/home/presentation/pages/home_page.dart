import 'dart:async';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/models/detail_movie_model.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/log/app_logger.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/search_movie_model.dart';
import '../../domain/usecases/get_all_genre_usecase.dart';
import '../../domain/usecases/get_movies_now_playing_usecase.dart';
import '../../domain/usecases/get_movies_upcoming_usecase.dart';
import '../../domain/usecases/get_search_movies_usecase.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc bloc = HomeBloc(
    sl<GetMoviesNowPlayingUsecase>(),
    sl<GetSearchMoviesUsecase>(),
    sl<GetMoviesUpcomingUsecase>(),
    sl<GetAllGenreUsecase>(),
  );

  List<Genre> listGenre = [];
  List<int> listIdGenreSelected = [];
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _isSearchActive = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController();

    // Listener untuk perubahan teks
    _textController.addListener(() {
      _onTextChanged(_textController.text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    _focusNode.dispose();

    super.dispose();
  }

  void _onTextChanged(String text) {
    // Bersihkan genre yang terselect
    listIdGenreSelected.clear();

    // Batalkan timer jika masih aktif
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Set timer baru
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Eksekusi logika setelah user berhenti mengetik selama 500ms
      setState(() {
        if (text == '') {
          _isSearchActive = false;
        } else {
          _isSearchActive = true;
        }
      });
    });
  }

  void _onFilterWithGenre(List<int> value) {
    _textController.clear();

    listIdGenreSelected = value;
    if (value.isEmpty) {
      _isSearchActive = false;
    } else {
      _isSearchActive = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bloc.add(const GetGenreHomeEvent());
    return Column(children: [
      Row(children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Colors.white,
            ),
            controller: _textController,
          ),
        ),
        if (_isSearchActive)
          TextButton(
            child: const Text('Cencel', style: TextStyle(color: Colors.white)),
            onPressed: () {
              FocusScope.of(context).unfocus();
              _textController.clear();
              setState(() {
                _isSearchActive = false;
              });
            },
          ),
      ]),
      BlocConsumer<HomeBloc, HomeState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is GenreLoading) {
            logger.info('Genre Loading');
          } else if (state is GenresSuccess) {
            listGenre = state.listGenre;
          }
        },
        builder: (context, state) {
          return CategoryWidget(
            listGenre: listGenre,
            listSelected: _onFilterWithGenre,
          );
        },
      ),
      Expanded(
        child: _isSearchActive
            ? ContentTab(
                indexTab: 99,
                query: _textController.text,
                bloc: bloc,
                listIdGenre: listIdGenreSelected,
              )
            : DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    title: TabBar(
                      indicator: const BoxDecoration(
                        color: Colors.red, // Warna tab aktif
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white, // Warna teks tab aktif
                      unselectedLabelColor: Colors.white, // Warna teks tab tidak aktif
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red, // Outline untuk tab tidak aktif
                                width: 2,
                              ),
                              color: Colors.black, // Background tab tidak aktif
                            ),
                            alignment: Alignment.center,
                            child: const Text('Now Playing'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                              color: Colors.black,
                            ),
                            alignment: Alignment.center,
                            child: const Text('Upcoming'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      ContentTab(
                        indexTab: 0,
                        bloc: bloc,
                      ),
                      ContentTab(
                        indexTab: 1,
                        bloc: bloc,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    ]);
  }
}

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

  @override
  Widget build(BuildContext context) {
    MovieModel? movieModel;
    if (indexTab == 0) {
      bloc.add(const GetMoviesHomeEvent());
    } else if (indexTab == 1) {
      bloc.add(const GetMoviesUpcommingHomeEvent());
    } else {
      bloc.add(GetSearchMoviesHomeEvent(query: SearchMovieModel(query: query, genre: listIdGenre)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Newest',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: BlocConsumer<HomeBloc, HomeState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is HomeLoading) {
                logger.info('Home Loading');
              } else if (state is HomeSuccess) {
                movieModel = state.movieModel;
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 64),

                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 kolom
                      crossAxisSpacing: 8, // Jarak horizontal antar item
                      mainAxisSpacing: 8, // Jarak vertikal antar item
                      childAspectRatio: 0.7, // Menentukan rasio tinggi dan lebar item
                    ),
                    itemCount: movieModel?.results?.length, // Jumlah item di grid
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
                              query: SearchMovieModel(query: query, page: page),
                            ),
                          );
                        }
                      },
                      totalPages: movieModel?.totalPages ?? 0,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class FlexiblePaginationWidget extends StatefulWidget {
  final int totalPages;
  final void Function(int)? currentPage;
  const FlexiblePaginationWidget({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  State<FlexiblePaginationWidget> createState() => _FlexiblePaginationWidgetState();
}

class _FlexiblePaginationWidgetState extends State<FlexiblePaginationWidget> {
  int currentPage = 1; // Halaman saat ini
  int totalPages = 1; // Total jumlah halaman
  final int maxVisiblePages = 3; // Jumlah maksimum halaman yang terlihat di sekitar halaman aktif

  @override
  void didUpdateWidget(covariant FlexiblePaginationWidget oldWidget) {
    totalPages = widget.totalPages;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<int> visiblePages = _generateVisiblePages();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: currentPage > 1
                ? () {
                    setState(() {
                      currentPage--;
                    });
                    widget.currentPage?.call(currentPage);

                    // updateActivePage(currentPage--);
                  }
                : null,
            icon: const Icon(Icons.arrow_left),
            color: Colors.grey,
            disabledColor: Colors.grey.shade300,
          ),
          // Halaman
          ...visiblePages.map((page) {
            return page == -1
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "...",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = page;
                      });
                      widget.currentPage?.call(currentPage);

                      // updateActivePage(page);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: currentPage == page ? AppColors.primary : Colors.grey.shade300,
                          width: 2,
                        ),
                        color: currentPage == page ? Colors.red.shade50 : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          page.toString(),
                          style: TextStyle(
                            color: currentPage == page ? AppColors.primary : Colors.black,
                            fontWeight: currentPage == page ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
          }),
          // Tombol "Next"
          IconButton(
            onPressed: currentPage < totalPages
                ? () {
                    setState(() {
                      currentPage++;
                    });
                    widget.currentPage?.call(currentPage);

                    // updateActivePage(currentPage++);
                  }
                : null,
            icon: const Icon(Icons.arrow_right),
            color: Colors.grey,
            disabledColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  List<int> _generateVisiblePages() {
    List<int> pages = [];

    // Tambahkan halaman pertama
    pages.add(1);

    // Jika halaman pertama terlalu jauh dari halaman aktif, tambahkan "..."
    if (currentPage - maxVisiblePages / 2 > 2) {
      pages.add(-1); // -1 digunakan sebagai tanda untuk "..."
    }

    // Tambahkan halaman di sekitar halaman aktif
    for (int i = currentPage - (maxVisiblePages ~/ 2); i <= currentPage + (maxVisiblePages ~/ 2); i++) {
      if (i > 1 && i < totalPages) {
        pages.add(i);
      }
    }

    // Jika halaman terakhir terlalu jauh dari halaman aktif, tambahkan "..."
    if (currentPage + maxVisiblePages / 2 < totalPages - 1) {
      pages.add(-1); // -1 digunakan sebagai tanda untuk "..."
    }

    // Tambahkan halaman terakhir
    if (totalPages > 1) {
      pages.add(totalPages);
    }

    return pages;
  }
}

class CategoryWidget extends StatefulWidget {
  final List<Genre> listGenre;
  final void Function(List<int> list) listSelected;
  const CategoryWidget({
    super.key,
    required this.listGenre,
    required this.listSelected,
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  List<int> selectedIndex = []; // Index dari kategori yang dipilih

  List<Genre> categories = [];

  @override
  void didUpdateWidget(covariant CategoryWidget oldWidget) {
    categories = widget.listGenre;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex.contains(categories[index].id)) {
                    selectedIndex.remove(categories[index].id);
                  } else {
                    selectedIndex.add(categories[index].id ?? 0);
                  }
                });
                widget.listSelected.call(selectedIndex);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedIndex.contains(categories[index].id) ? Colors.white : Colors.black,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  categories[index].name ?? '',
                  style: TextStyle(
                    color: selectedIndex.contains(categories[index].id) ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
