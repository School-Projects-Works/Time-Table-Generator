import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';

abstract class TableGenRepo {
  Future<List<TablesModel>> getTables(String year, String semester);
  Future<List<TablesModel>> saveTables(List<TablesModel> tables);
  Future<List<TablesModel>> swapTables({required TablesModel table1, required TablesModel table2});

}