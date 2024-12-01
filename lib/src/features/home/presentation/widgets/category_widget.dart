part of '../pages/home_page.dart';

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
            padding: const EdgeInsets.only(left: 16.0),
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
