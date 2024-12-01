import 'package:flutter/material.dart';
import 'package:movie_technical_test/src/core/translations/l10n.dart';

import '../../../core/styles/app_colors.dart';
import '../../../features/favorite/presentation/pages/favorite_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  static final List<Widget> _widgetOptions = [
    const HomePage(),
    const FavoritePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    List<({String title, Icon icon})> navigationItem = [
      (title: S.of(context).home, icon: const Icon(Icons.home_rounded)),
      (title: S.of(context).favorite, icon: const Icon(Icons.favorite)),
      (title: S.of(context).user, icon: const Icon(Icons.account_circle_rounded)),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),

            // Bottom Navigation Bar
            BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.black.withOpacity(.1),
              onTap: _onItemTapped,
              showUnselectedLabels: true,
              items: navigationItem.map(
                (e) {
                  return BottomNavigationBarItem(
                    icon: e.icon,
                    label: e.title,
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
