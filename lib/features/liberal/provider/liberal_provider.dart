import 'dart:math';

import 'package:aamusted_timetable_generator/core/data/table_model.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/liberal/data/liberal/liberal_model.dart';
import 'package:aamusted_timetable_generator/features/liberal/usecase/liberal_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_app_file/open_app_file.dart';

import '../../../utils/app_utils.dart';
import '../../allocations/provider/lecturer/usecase/lecturer_usecase.dart';
import '../../main/provider/main_provider.dart';

final liberalProvider =
    StateNotifierProvider<LiberalNotifier, TableModel<LiberalModel>>((ref) {
  return LiberalNotifier(ref.watch(liberalsDataProvider));
});

class LiberalNotifier extends StateNotifier<TableModel<LiberalModel>> {
  LiberalNotifier(this.liberal)
      : super(TableModel(
          currentPage: 0,
          pageSize: 10,
          selectedRows: [],
          pages: [],
          currentPageItems: [],
          items: liberal,
          hasNextPage: false,
          hasPreviousPage: false,
        )) {
    init();
  }

  final List<LiberalModel> liberal;

  void init() {
    List<List<LiberalModel>> pages = [];
    state = state.copyWith(
        items: liberal,
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

  void selectRow(LiberalModel row) {
    state = state.copyWith(selectedRows: [...state.selectedRows, row]);
  }

  void unselectRow(LiberalModel row) {
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
              element.code!.toLowerCase().contains(query.toLowerCase()) ||
              element.title!.toLowerCase().contains(query.toLowerCase()) ||
              element.lecturerName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      List<List<LiberalModel>> pages = [];
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

  void deleteLiberal(LiberalModel item) {}

  void editLiberal(LiberalModel item) {}
}

final liberalItemHovered = StateProvider<LiberalModel?>((ref) => null);

final liberalDataImportProvider =
    StateNotifierProvider<LiberalDataImport, void>((ref) {
  return LiberalDataImport();
});

class LiberalDataImport extends StateNotifier<void> {
  LiberalDataImport() : super(null);

  void importData(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Importing Liberal Courses....');
    var academicYear = ref.watch(academicYearProvider);
    var academicSemester = ref.watch(semesterProvider);
    //open file picker
    String? pickedFilePath = await AppUtils.pickExcelFIle();
    if (pickedFilePath != null) {
      var (success, message, liberal, lecturers) = await LiberalUseCase()
          .importLiberal(
              path: pickedFilePath,
              academicYear: academicYear,
              semester: academicSemester);
      if (success) {
        //save to db
        var (success, message) = await LiberalUseCase().addLiberals(liberal!);
        if (success) {
          ref.read(liberalsDataProvider.notifier).addLiberal(liberal);
        }
        var (newSuccess, newMessage) = await LecturerUseCase().appendLectuers(
            list: lecturers!, year: academicYear, semester: academicSemester);
        if (newSuccess) {
          ref.read(lecturersDataProvider.notifier).addLecturers(lecturers);
        }
        CustomDialog.dismiss();
        CustomDialog.showSuccess(message: message);
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message);
      }
    } else {
      CustomDialog.dismiss();
    }
  }

  void downloadTemplate() async {
    CustomDialog.showLoading(message: 'Downloading template...');
    var (success, message) = await LiberalUseCase().downloadTemplate();
    if (success) {
      CustomDialog.dismiss();
      //open file
      if (message != null) {
        await OpenAppFile.open(message);
      }
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message!);
    }
  }
}
