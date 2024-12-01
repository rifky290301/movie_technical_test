part of '../pages/home_page.dart';

class TabBarCustom extends StatefulWidget {
  final int indexTabBar;
  final String title;
  const TabBarCustom({
    super.key,
    required TabController tabController,
    required this.indexTabBar,
    required this.title,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  State<TabBarCustom> createState() => _TabBarCustomState();
}

class _TabBarCustomState extends State<TabBarCustom> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary, // Outline untuk tab tidak aktif
            width: 2,
          ),
          color: widget._tabController.index == widget.indexTabBar ? AppColors.primary : Colors.black, // Background tab tidak aktif
        ),
        alignment: Alignment.center,
        child: Text(widget.title),
      ),
    );
  }
}
