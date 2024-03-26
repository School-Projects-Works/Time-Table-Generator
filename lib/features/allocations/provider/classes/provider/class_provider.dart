import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../../core/data/table_model.dart';

final classesProvider =
    StateNotifierProvider<ClassesNotifier, TableModel<ClassModel>>((ref) {
  return ClassesNotifier(ref.watch(classesDataProvider));
});

class ClassesNotifier extends StateNotifier<TableModel<ClassModel>> {
  ClassesNotifier(this.staffs)
      : super(TableModel(
          currentPage: 0,
          pageSize: 10,
          selectedRows: [],
          pages: [],
          currentPageItems: [],
          items: staffs,
          hasNextPage: false,
          hasPreviousPage: false,
        )) {
    init();
  }

  final List<ClassModel> staffs;

  void init() {
    List<List<ClassModel>> pages = [];
    state = state.copyWith(
        items: staffs,
        selectedRows: [],
        currentPage: 0,
        pages: pages,
        currentPageItems: [],
        hasNextPage: false,
        hasPreviousPage: false);
    if (state.items.isNotEmpty) {
      var pagesCount = (state.items.length / state.pageSize).ceil();
      for (var i = 0; i < pagesCount; i++) {
        var page =
            state.items.skip(i * state.pageSize).take(state.pageSize).toList();

        pages.add(page);
        state = state.copyWith(pages: pages);
      }
    } else {
      pages.add([]);
      state = state.copyWith(pages: pages);
    }
    state = state.copyWith(
        currentPageItems: state.pages[state.currentPage],
        hasNextPage: state.currentPage < state.pages.length - 1,
        hasPreviousPage: state.currentPage > 0);
  }

  void onPageSizeChange(int newValue) {
    state = state.copyWith(pageSize: newValue);
    init();
  }

  void selectRow(ClassModel row) {
    state = state.copyWith(selectedRows: [...state.selectedRows, row]);
  }

  void unselectRow(ClassModel row) {
    state = state.copyWith(selectedRows: [...state.selectedRows..remove(row)]);
  }

  void nextPage() {
    if (state.hasNextPage && state.currentPage < state.pages.length - 1) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      state = state.copyWith(currentPageItems: state.pages[state.currentPage]);
      state = state.copyWith(
        hasNextPage: state.currentPage < state.pages.length - 1,
      );
      state = state.copyWith(hasPreviousPage: state.currentPage > 0);
    }
  }

  void previousPage() {
    if (state.hasPreviousPage && state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
      state = state.copyWith(currentPageItems: state.pages[state.currentPage]);
      state = state.copyWith(hasPreviousPage: state.currentPage > 0);
      state = state.copyWith(
        hasNextPage: state.currentPage < state.pages.length - 1,
      );
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      init();
    } else {
      var data = state.items
          .where((element) =>
              element.name!.toLowerCase().contains(query.toLowerCase()) ||
              element.level.toLowerCase().contains(query.toLowerCase()) ||
              element.id!.toLowerCase().contains(query.toLowerCase()) ||
              element.department!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      List<List<ClassModel>> pages = [];
      state = state.copyWith(
          items: data,
          selectedRows: [],
          currentPage: 0,
          pages: pages,
          currentPageItems: [],
          hasNextPage: false,
          hasPreviousPage: false);
      if (data.isNotEmpty) {
        var pagesCount = (data.length / state.pageSize).ceil();
        for (var i = 0; i < pagesCount; i++) {
          var page =
              data.skip(i * state.pageSize).take(state.pageSize).toList();

          pages.add(page);
          state = state.copyWith(pages: pages);
        }
      } else {
        pages.add([]);
        state = state.copyWith(pages: pages);
      }
      state = state.copyWith(
          currentPageItems: state.pages[state.currentPage],
          hasNextPage: state.currentPage < state.pages.length - 1,
          hasPreviousPage: state.currentPage > 0);
    }
  }

  void deleteClass(ClassModel item) {}

  void editClass(ClassModel item) {}
}

final classItemHovered = StateProvider<ClassModel?>((ref) {
  return null;
});
