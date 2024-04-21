import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:aamusted_timetable_generator/features/tables/repo/table_gen_repo.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TableGenUsecase extends TableGenRepo {
  final Db db;

  TableGenUsecase({required this.db});
  @override
  Future<List<TablesModel>> getTables(String year, String semester) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }

      // get all tables
      var tables = await db
          .collection('tables')
          .find({'year': year, 'semester': semester}).toList();

      return tables.map((e) => TablesModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TablesModel>> saveTables(List<TablesModel> tables) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //delete all tables where year and semester is the same
      await db.collection('tables').remove(
          {'year': tables.first.year, 'semester': tables.first.semester});
      await db
          .collection('tables')
          .insertAll(tables.map((e) => e.toMap()).toList());
      return tables;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<(TablesModel?, TablesModel?, String)> swapTables(
      {required TablesModel table1, required TablesModel table2}) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //replace table1 and table2
      await db.collection('tables').update({'id': table1.id}, table1.toMap());
      await db.collection('tables').update({'id': table2.id}, table2.toMap());
      return (table1, table2, 'Tables swapped successfully');
    } catch (e) {
      return (null, null, 'Failed to swap tables');
    }
  }

  Future<(TablesModel?, String)> updateItem(TablesModel newTable) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      await db
          .collection('tables')
          .update({'id': newTable.id}, newTable.toMap());

      return (newTable, 'Table updated successfully');
    } catch (e) {
      return (null, 'Failed to update table');
    }
  }

  Future<TablesModel?> appendTable(TablesModel table) async{
      if (db.state != State.open) {
        await db.open();
      }
     await db
        .collection('tables')
        .insert(table.toMap());
      return table;
  }
}
