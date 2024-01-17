


class TableModel<TResults extends Object> {
  int pageSize;
  int currentPage;
  List<List<TResults>> pages;
  List<TResults> currentPageItems;
  List<TResults> selectedRows;
  List<TResults> items;
  bool hasNextPage;
  bool hasPreviousPage;
  TableModel({
    required this.pageSize,
    required this.currentPage,
    required this.pages,
    required this.currentPageItems,
    required this.selectedRows,
    required this.items,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  TableModel<TResults> copyWith({
    int? pageSize,
    int? currentPage,
    List<List<TResults>>? pages,
    List<TResults>? currentPageItems,
    List<TResults>? selectedRows,
    List<TResults>? items,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return TableModel(
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      pages: pages ?? this.pages,
      currentPageItems: currentPageItems ?? this.currentPageItems,
      selectedRows: selectedRows ?? this.selectedRows,
      items: items ?? this.items,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  

}
