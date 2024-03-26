import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredTableProvider =
    StateNotifierProvider<FilteredTableProvider, List<TablesModel>>(
        (ref) => FilteredTableProvider(ref.watch(tableDataProvider)));

class FilteredTableProvider extends StateNotifier<List<TablesModel>> {
  FilteredTableProvider(this.tables) : super(tables);
  final List<TablesModel> tables;
  void filter(String? query, WidgetRef ref) {
    var filterParent = ref.read(filterProvider);
    if (filterParent == null || filterParent.toLowerCase() == "all") {
      state = tables;
      return;
    } else {
      var filter = query.toString().toLowerCase();
      if (filterParent.toLowerCase() == 'lecturer'&&filter.isNotEmpty) {
        state = tables
            .where((element) =>
                element.lecturerId.toString().toLowerCase().contains(filter) ||
                element.lecturerName.toLowerCase().contains(filter))
            .toList();
      } else if (filterParent.toLowerCase() == 'class' && filter.isNotEmpty) {
        state = tables
            .where((element) =>
                element.classId.toString().toLowerCase().contains(filter) ||
                element.className.toLowerCase().contains(filter))
            .toList();
      } else if (filterParent.toLowerCase() == 'course' && filter.isNotEmpty) {
        state = tables
            .where((element) =>
                element.courseCode.toString().toLowerCase().contains(filter) ||
                element.courseTitle.toLowerCase().contains(filter))
            .toList();
      } else if (filterParent.toLowerCase() == 'venue' && filter.isNotEmpty) {
        state = tables
            .where((element) =>
                element.venueId.toString().toLowerCase().contains(filter) ||
                element.venueName.toLowerCase().contains(filter))
            .toList();
      } else if (filterParent.toLowerCase() == 'day' && filter.isNotEmpty) {
        state = tables.where((element) => element.day == filter).toList();
      } else {
        state = tables;
      }
    }
  }
}

final filterProvider = StateProvider<String?>((ref) => 'All');
