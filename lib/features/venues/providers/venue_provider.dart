import 'package:aamusted_timetable_generator/core/data/table_model.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/venues/data/venue_model.dart';
import 'package:aamusted_timetable_generator/features/venues/usecase/venue_usecase.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_app_file/open_app_file.dart';

final venueProvider =
    StateNotifierProvider<VenueNotifier, TableModel<VenueModel>>((ref) {
  return VenueNotifier(ref.watch(venuesDataProvider));
});

class VenueNotifier extends StateNotifier<TableModel<VenueModel>> {
  VenueNotifier(this.venues)
      : super(TableModel(
          currentPage: 0,
          pageSize: 10,
          selectedRows: [],
          pages: [],
          currentPageItems: [],
          items: venues,
          hasNextPage: false,
          hasPreviousPage: false,
        )) {
    init();
  }

  final List<VenueModel> venues;

  void init() {
    List<List<VenueModel>> pages = [];
    state = state.copyWith(
        items: venues,
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

  void selectRow(VenueModel row) {
    state = state.copyWith(selectedRows: [...state.selectedRows, row]);
  }

  void unselectRow(VenueModel row) {
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
              element.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      List<List<VenueModel>> pages = [];
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

  void deleteVenue(VenueModel item) {}

  void editVenue(VenueModel item) {}
}

final venueItemHovered = StateProvider<VenueModel?>((ref) => null);

final venueDataImportProvider =
    StateNotifierProvider<VenueDataImport, void>((ref) => VenueDataImport());

class VenueDataImport extends StateNotifier<void> {
  VenueDataImport() : super(null);

  void importData(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Importing Venues....');
    //open file picker
    String? pickedFilePath = await AppUtils.pickExcelFIle();
    var (success, message, venues) =
        await VenueUseCase().importVenues(pickedFilePath);
    if (success) {
      //save to db
      var (success, message) = await VenueUseCase().addVenues(venues!);
      if (success) {
        ref.read(venuesDataProvider.notifier).addVenues(venues);
      }
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: message);
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message);
    }
    }

  void downloadTemplate() async {
    CustomDialog.showLoading(message: 'Downloading Venues Template....');
    var (success, message) = await VenueUseCase().downloadTemplate();
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
    //
  }
}
