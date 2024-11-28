import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/intro/presentation/pages/onboarding_page.dart';
import '../../features/intro/presentation/pages/splash_screen_page.dart';
import '../../shared/presentation/widgets/app_navigation.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  // refreshListenable: authService, // Refresh saat status login berubah
  // redirect: (context, state) {
  //   logger.info('-------------> ${state.matchedLocation}');
  //   if (state.matchedLocation != '/' && state.matchedLocation != AppRoute.onBoarding) {
  //     final isLogin = authService.isLoggedIn;
  //     final isLocationLoginPage = state.matchedLocation == AppRoute.login;
  //     final isLocationRegisterPage = state.matchedLocation == AppRoute.register;

  //     // Jika belum login dan rute di register
  //     if (!isLogin && isLocationRegisterPage) return AppRoute.register;

  //     // Jika belum login dan bukan di halaman login, arahkan ke /login
  //     if (!isLogin && !isLocationLoginPage) return AppRoute.login;

  //     // Jika sudah login dan mencoba ke /login, arahkan ke home
  //     if (isLogin && isLocationLoginPage) return AppRoute.home;

  //     return null; // Tidak ada redirect
  //   }
  //   return null;
  // },
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
      path: AppRoute.home,
      builder: (context, state) => const AppNavigation(),
    ),
  ],
);
