import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:aamusted_timetable_generator/features/tables/repo/table_gen_repo.dart';
import 'package:hive/hive.dart';

class TableGenUsecase extends TableGenRepo {
  @override
  Future<List<TablesModel>> getTables(String year, String semester) async {
    try {
      final Box<TablesModel> tableBox =
          await Hive.openBox<TablesModel>('tables');
      //check if box is open
      if (!tableBox.isOpen) {
        await Hive.openBox('tables');
      }

      List<TablesModel> tables = tableBox.values
          .where(
              (element) => element.year == year && element.semester == semester)
          .toList();
      return tables;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TablesModel>> saveTables(List<TablesModel> tables) async {
    try {
      final Box<TablesModel> tableBox =
          await Hive.openBox<TablesModel>('tables');
      //check if box is open
      if (!tableBox.isOpen) {
        await Hive.openBox('tables');
      }
      var toDelete = tableBox.values
          .where((element) =>
              element.year == tables.first.year &&
              element.semester == tables.first.semester)
          .toList();
      //delete all tables where year and semester is the same
      await tableBox.deleteAll(toDelete.map((e) => e.id).toList());
      await tableBox.putAll({for (var e in tables) e.id: e});
      tables = tableBox.values
          .where((element) =>
              element.year == tables.first.year &&
              element.semester == tables.first.semester)
          .toList();
      return tables;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<(TablesModel?, TablesModel?, String)> swapTables(
      {required TablesModel table1, required TablesModel table2}) async {
    try {
      final Box<TablesModel> tableBox =
          await Hive.openBox<TablesModel>('tables');
      //check if box is open
      if (!tableBox.isOpen) {
        await Hive.openBox('tables');
      }
      await tableBox.put(table1.id, table1);
      await tableBox.put(table2.id, table2);
      return (table1, table2, 'Tables swapped successfully');
    } catch (e) {
      return (null, null, 'Failed to swap tables');
    }
  }

 Future<(TablesModel?, String)>  updateItem(TablesModel newTable)async {
    try {
      final Box<TablesModel> tableBox =
          await Hive.openBox<TablesModel>('tables');
      //check if box is open
      if (!tableBox.isOpen) {
        await Hive.openBox('tables');
      }
      await tableBox.put(newTable.id, newTable);
      return (newTable, 'Table updated successfully');
    } catch (e) {
      return (null, 'Failed to update table');
    }
 }
}
