import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/data/table_model.dart';

final courseProvider =
    StateNotifierProvider<CourseNotifier, TableModel<CourseModel>>((ref) {
  return CourseNotifier(ref.watch(coursesDataProvider));
});

class CourseNotifier extends StateNotifier<TableModel<CourseModel>> {
  CourseNotifier(this.courses)
      : super(TableModel(
          currentPage: 0,
          pageSize: 10,
          selectedRows: [],
          pages: [],
          currentPageItems: [],
          items: courses,
          hasNextPage: false,
          hasPreviousPage: false,
        )) {
    init();
  }

  final List<CourseModel> courses;

  void init() {
    List<List<CourseModel>> pages = [];
    state = state.copyWith(
        items: courses,
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

  void selectRow(CourseModel row) {
    state = state.copyWith(selectedRows: [...state.selectedRows, row]);
  }

  void unselectRow(CourseModel row) {
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
              element.code.toLowerCase().contains(query.toLowerCase()) ||
              element.level.toLowerCase().contains(query.toLowerCase()) ||
              element.id.toLowerCase().contains(query.toLowerCase()) ||
              element.title.toLowerCase().contains(query.toLowerCase()) ||
              element.department.toLowerCase().contains(query.toLowerCase()))
          .toList();
      List<List<CourseModel>> pages = [];
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

  void filterCoursesWithSpecialVenues(WidgetRef ref) {
    init();
    var data = state.items
        .where((element) =>
            element.specialVenue != null && element.specialVenue!.isNotEmpty&&
                            element.specialVenue!
                                    .toLowerCase() !=
                                'no')
        .toList();

   
    List<List<CourseModel>> pages = [];
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
        var page = data.skip(i * state.pageSize).take(state.pageSize).toList();

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

        ref.read(isFilteredProvider.notifier).state = true;
   
  }

  void removeFilter(WidgetRef ref) {
    init();
    ref.read(isFilteredProvider.notifier).state = false;
  }
}

final courseItemHovered = StateProvider<CourseModel?>((ref) => null);


final isFilteredProvider = StateProvider<bool>((ref) => false);