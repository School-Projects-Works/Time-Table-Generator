//! here i create a provider for a list of table model for unsaved tables
import 'package:riverpod/riverpod.dart';
import '../data/tables_model.dart';

final unsavedTableProvider = StateNotifierProvider<UnsavedTableProvider, List<TablesModel>>(
    (ref) => UnsavedTableProvider());


class UnsavedTableProvider extends StateNotifier<List<TablesModel>> {
  UnsavedTableProvider() : super([]);

  void setTables(List<TablesModel> tables) {
    state = tables;
  }

  void addTable(List<TablesModel> tables) {
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
}