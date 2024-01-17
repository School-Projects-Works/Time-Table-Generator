import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDataTableState<TResult extends Object> extends ChangeNotifier {
  final List<TResult> items;
  int pageSize = 10;
  int currentPage = 0;
  List<List<TResult>> pages = [];
  List<TResult> currentPageItems = [];
  final List<TResult> selectedRows = [];
  CustomDataTableState(this.items) {
    init();
  }

  void init() {
    if (items.isNotEmpty) {
      var pagesCount = (items.length / pageSize).ceil();
      for (var i = 0; i < pagesCount; i++) {
        var page = items.skip(i * pageSize).take(pageSize).toList();
        pages.add(page);
      }
    } else {
      pages.add([]);
    }
    currentPageItems = pages[currentPage];
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < pages.length - 1) {
      currentPage++;
      currentPageItems = pages[currentPage];
      notifyListeners();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      currentPageItems = pages[currentPage];
      notifyListeners();
    }
  }

  void selectAllRows() {
    selectedRows.clear();
    selectedRows.addAll(items);
    notifyListeners();
  }

  void unselectAllRows() {
    selectedRows.clear();
    notifyListeners();
  }

  void selectRow(
    row,
  ) {
    selectedRows.add(row);
    notifyListeners();
  }

  void unselectRow(
    row,
  ) {
    selectedRows.remove(row);
    notifyListeners();
  }

  bool hasNextPage() {
    return currentPage < pages.length - 1;
  }

  bool hasPreviousPage() {
    return currentPage > 0;
  }

  void onPageSizeChange() {
    init();
  }
}

final customTableDataStateProvider = StateProvider<List<Object>>((ref) => []);

final customTableStateProvider =
    ChangeNotifierProvider.family<CustomDataTableState<dynamic>, List<Object>>(
        (ref, data) {
  return CustomDataTableState(data);
});

class CustomTablePaging<TResult extends Object> {
  int pageSize;
  int currentPage;
  List<List<TResult>> pages;
  List<TResult> currentPageItems;
  List<TResult> selectedRows;
  List<TResult> items;
  bool hasNextPage;
  bool hasPreviousPage;

  CustomTablePaging({
    this.pageSize = 10,
    this.currentPage = 0,
    this.pages = const [],
    this.currentPageItems = const [],
    this.selectedRows = const [],
    this.items = const [],
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  CustomTablePaging<TResult> copyWith({
    ValueGetter<int?>? pageSize,
    ValueGetter<int?>? currentPage,
    ValueGetter<List<List<TResult>>?>? pages,
    ValueGetter<List<TResult>?>? currentPageItems,
    ValueGetter<List<TResult>?>? selectedRows,
    ValueGetter<List<TResult>?>? items,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return CustomTablePaging<TResult>(
      pageSize: pageSize?.call() ?? this.pageSize,
      currentPage: currentPage?.call() ?? this.currentPage,
      pages: pages?.call() ?? this.pages,
      currentPageItems: currentPageItems?.call() ?? this.currentPageItems,
      selectedRows: selectedRows?.call() ?? this.selectedRows,
      items: items?.call() ?? this.items,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}

final customTableProvider =
    StateNotifierProvider<CustomTableProvider, CustomTablePaging>((ref) {
  var data = ref.watch(customTableDataStateProvider);
  return CustomTableProvider(data);
});

class CustomTableProvider extends StateNotifier<CustomTablePaging> {
  CustomTableProvider(this.items)
      : super(CustomTablePaging(
            currentPage: 0,
            pageSize: 10,
            selectedRows: [],
            pages: [],
            currentPageItems: []));

  final List<Object> items;

  void init() {
    List<List<Object>> pages = [];
    state = state.copyWith(items: () => items,
        selectedRows: () => [],
        currentPage: () => 0,
        pages: () => pages,
        currentPageItems: () => [],
        hasNextPage: false,
        hasPreviousPage: false
    );
    if (items.isNotEmpty) {
      var pagesCount = (items.length / state.pageSize).ceil();
      for (var i = 0; i < pagesCount; i++) {
        var page =
            items.skip(i * state.pageSize).take(state.pageSize).toList();

        pages.add(page);
        state = state.copyWith(pages: () => pages);
      }
    } else {
      pages.add([]);
      state = state.copyWith(pages: () => pages);
    }
    state = state.copyWith(
        currentPageItems: () => state.pages[state.currentPage],
        hasNextPage: state.currentPage < state.pages.length - 1,
        hasPreviousPage: state.currentPage > 0);
  }

  void onPageSizeChange(int newValue) {
    state = state.copyWith(pageSize: () => newValue);
    init();
  }

  void selectRow(Object row) {
    state = state.copyWith(
        selectedRows: () => [...state.selectedRows, row], items: () => items);
  }

  void unselectRow(Object row) {
    state = state.copyWith(
        selectedRows: () => [...state.selectedRows..remove(row)],
        items: () => items);
  }

  void nextPage() {
    if (state.hasNextPage && state.currentPage < state.pages.length - 1) {
      state = state.copyWith(currentPage: () => state.currentPage + 1);
      state = state.copyWith(
          currentPageItems: () => state.pages[state.currentPage]);
      state = state.copyWith(
        hasNextPage: state.currentPage < state.pages.length - 1,
      );
      state = state.copyWith(hasPreviousPage: state.currentPage > 0);
    }
  }

  void previousPage() {
    if (state.hasPreviousPage && state.currentPage > 0) {
      state = state.copyWith(currentPage: () => state.currentPage - 1);
      state = state.copyWith(
          currentPageItems: () => state.pages[state.currentPage]);
      state = state.copyWith(hasPreviousPage: state.currentPage > 0);
      state = state.copyWith(
        hasNextPage: state.currentPage < state.pages.length - 1,
      );
    }
  }
}
