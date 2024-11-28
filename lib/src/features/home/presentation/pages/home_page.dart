import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_technical_test/src/core/styles/app_colors.dart';
import 'package:movie_technical_test/src/core/utils/constant/app_constants.dart';
import 'package:movie_technical_test/src/core/utils/injections.dart';
import 'package:movie_technical_test/src/core/utils/log/app_logger.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';
import 'package:movie_technical_test/src/features/home/domain/usecases/get_movies_now_playing_usecase.dart';
import 'package:movie_technical_test/src/features/home/domain/usecases/get_search_movies_usecase.dart';
import 'package:movie_technical_test/src/features/home/presentation/bloc/home_bloc.dart';

import '../../data/models/search_movie_model.dart';
import '../../domain/usecases/get_movies_upcoming_usecase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _textController;
  bool _isSearchActive = false;
  Timer? _debounce; // Timer untuk debouncer
  late FocusNode _focusNode;

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
    _debounce?.cancel(); // Jangan lupa cancel debounce
    _focusNode.dispose();

    super.dispose();
  }

  void _onTextChanged(String text) {
    // Batalkan timer jika masih aktif
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Set timer baru
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Eksekusi logika setelah user berhenti mengetik selama 500ms
      print("User mengetik: $text");
      // Lakukan tindakan seperti API call atau pencarian di sini
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            controller: _textController,
            onTap: () {
              setState(() {
                _isSearchActive = true;
              });
            },
          ),
        ),
        TextButton(
          child: const Text('Cencel'),
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _isSearchActive = true;
            });
          },
        ),
      ]),
      Expanded(
        child: _isSearchActive
            ? ContentTab(
                indexTab: 99,
                query: _textController.text,
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
                  body: const TabBarView(
                    children: [
                      ContentTab(
                        indexTab: 0,
                      ),
                      ContentTab(
                        indexTab: 1,
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
  const ContentTab({super.key, required this.indexTab, this.query});

  @override
  Widget build(BuildContext context) {
    MovieModel? movieModel;
    HomeBloc bloc = HomeBloc(sl<GetMoviesNowPlayingUsecase>(), sl<GetSearchMoviesUsecase>(), sl<GetMoviesUpcomingUsecase>());
    if (indexTab == 0) {
      bloc.add(const GetMoviesHomeEvent());
    } else if (indexTab == 1) {
      bloc.add(const GetMoviesUpcommingHomeEvent());
    } else {
      bloc.add(GetSearchMoviesHomeEvent(query: SearchMovieModel(query: query)));
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
                      return Card(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: movieModel != null ? '$networkImages${movieModel?.results?[index].backdropPath}' : defaultNullImage,
                          placeholder: (context, url) => const UnconstrainedBox(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
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
                          bloc.add(GetSearchMoviesHomeEvent(query: SearchMovieModel(query: query)));
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
