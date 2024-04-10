//! here i create a provider for a list of table model for unsaved tables
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/usecase/tables_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widget/custom_dialog.dart';
import '../data/tables_model.dart';
import 'class_course/lecturer_course_class_pair.dart';

final unsavedTableProvider =
    StateNotifierProvider<UnsavedTableProvider, List<TablesModel>>(
        (ref) => UnsavedTableProvider());

class UnsavedTableProvider extends StateNotifier<List<TablesModel>> {
  UnsavedTableProvider() : super([]);

  void setTables(List<TablesModel> tables) {
    state = tables;
  }

  void addTable(List<TablesModel> tables) {
    //check if table already exist
    for (var element in tables) {
      if (state.any((e) => e.id == element.id)) {
        //replace
        state = state.map((e) {
          if (e.id == element.id) {
            return element;
          }
          return e;
        }).toList();
        continue;
      }
    }

    state = [...state, ...tables];
  }

  void deleteTable(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void updateTable(TablesModel tables) {
    state = state.map((e) {
      if (e.id == tables.id) {
        return tables;
      }
      return e;
    }).toList();
  }

  void saveTables(WidgetRef ref) async {
    var savedTables = await TableGenUsecase().saveTables(state);
    //save all lccp
    ref.read(lecturerCourseClassPairProvider.notifier).saveData();
    if (savedTables.isNotEmpty) {
      ref.read(tableDataProvider.notifier).addTable(savedTables);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Tables Generated Successfully');
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Failed to Generate Tables');
    }
    state = [];
  }
}
