import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_technical_test/src/core/translations/l10n.dart';
import 'package:movie_technical_test/src/shared/presentation/widgets/app_error.dart';
import 'package:movie_technical_test/src/shared/presentation/widgets/input_decoration_custom.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/injections.dart';
import '../../../../shared/presentation/widgets/app_loading.dart';
import '../../data/models/detail_movie_model.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/search_movie_model.dart';
import '../../domain/usecases/get_all_genre_usecase.dart';
import '../../domain/usecases/get_movies_now_playing_usecase.dart';
import '../../domain/usecases/get_movies_upcoming_usecase.dart';
import '../../domain/usecases/get_search_movies_usecase.dart';
import '../bloc/home_bloc.dart';

part '../widgets/category_widget.dart';
part '../widgets/content_tab.dart';
part '../widgets/flexible_pagination_widget.dart';
part '../widgets/tab_bar_custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  bool _isGenreActive = true;
  Timer? _debounce;
  final GlobalKey _keyTabBar1 = GlobalKey<_TabBarCustomState>();
  final GlobalKey _keyTabBar2 = GlobalKey<_TabBarCustomState>();
  final GlobalKey _categoryWidget = GlobalKey<_CategoryWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: inputDecorationCustom(context),
              controller: _textController,
            ),
          ),
        ),
        if (_isSearchActive)
          TextButton(
            child: const Text('Cencel', style: TextStyle(color: Colors.white)),
            onPressed: () {
              _textController.clear();
              FocusScope.of(context).unfocus();
              setState(() {
                _isSearchActive = false;
                _isGenreActive = true;
              });
            },
          ),
      ]),
      const SizedBox(height: 16),
      if (_isGenreActive)
        BlocConsumer<HomeBloc, HomeState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is GenresSuccess) {
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
      const SizedBox(height: 8),
      Expanded(
        child: _isSearchActive
            ? ContentTab(
                indexTab: 99,
                query: _textController.text,
                bloc: bloc,
                listIdGenre: listIdGenreSelected,
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.scaffoldBackgroundColorLight,
                  elevation: 0,
                  title: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
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
                      TabBarCustom(
                        key: _keyTabBar1,
                        tabController: _tabController,
                        indexTabBar: 0,
                        title: S.of(context).now_playing,
                      ),
                      TabBarCustom(
                        key: _keyTabBar2,
                        tabController: _tabController,
                        indexTabBar: 1,
                        title: S.of(context).upcomming,
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
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
    ]);
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    _tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc.add(const GetGenreHomeEvent());

    _focusNode = FocusNode();
    _textController = TextEditingController();

    // Listener untuk perubahan teks
    _textController.addListener(() {
      if (_textController.text.isEmpty) return;
      // Batalkan timer jika masih aktif
      if (_debounce?.isActive ?? false) _debounce?.cancel();

      // Set timer baru
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _onTextChanged(_textController.text);
      });
    });

    // Inisialisasi TabController
    _tabController = TabController(length: 2, vsync: this);

    // Listener untuk memantau perubahan tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _keyTabBar1.currentState?.setState(() {});
        _keyTabBar2.currentState?.setState(() {});
      }
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
    _isGenreActive = true;
    setState(() {});
  }

  void _onTextChanged(String text) {
    // Bersihkan genre yang terselect
    if (listIdGenreSelected.isNotEmpty) {
      listIdGenreSelected.clear();
      _categoryWidget.currentState?.setState(() {});
    }

    setState(() {
      _isSearchActive = true;
      _isGenreActive = false;
    });
  }
}
