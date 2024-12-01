part of '../pages/home_page.dart';

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
  void initState() {
    totalPages = widget.totalPages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<int> visiblePages = _generateVisiblePages();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.7),
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
