import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';
import 'package:movie_technical_test/src/shared/presentation/pages/detail_movie_page.dart';

import '../../features/intro/presentation/pages/onboarding_page.dart';
import '../../features/intro/presentation/pages/splash_screen_page.dart';
import '../../shared/presentation/widgets/app_navigation.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreenPage(),
    ),
    GoRoute(
      path: AppRoute.onBoarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoute.detailMovie,
      builder: (context, state) {
        Result movie = state.extra as Result;
        return DetailMoviePage(movie: movie);
      },
    ),
    GoRoute(
      path: AppRoute.home,
      builder: (context, state) => const AppNavigation(),
    ),
  ],
);
