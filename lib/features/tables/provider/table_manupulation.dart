import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/usecase/tables_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import '../../database/provider/database_provider.dart';

class TablePairModel {
  TablesModel? table1;
  TablesModel? table2;
  TablePairModel({
    this.table1,
    this.table2,
  });

  TablePairModel copyWith({
    ValueGetter<TablesModel?>? table1,
    ValueGetter<TablesModel?>? table2,
  }) {
    return TablePairModel(
      table1: table1 != null ? table1() : this.table1,
      table2: table2 != null ? table2() : this.table2,
    );
  }
}

final tablePairProvider =
    StateNotifierProvider<TablePairProvider, TablePairModel>((ref) {
  return TablePairProvider();
});

class TablePairProvider extends StateNotifier<TablePairModel> {
  TablePairProvider() : super(TablePairModel());

  void setTable1(TablesModel? table) {
    state = state.copyWith(table1: () => table);
  }

  void setTable2(TablesModel? table, WidgetRef ref) async {
    state = state.copyWith(table2: () => table);
    if (table != null) {
      CustomDialog.showLoading(message: 'Swapping tables...');
      //swap venue, period and day of the two tables
      var table1 = state.table1;
      var table2 = state.table2;
      TablesModel newTable1 = table1!.copyWith(
        venueName: table2!.venueName,
        venueCapacity: table2.venueCapacity,
        period: table2.period,
        day: table2.day,
        venueId: table2.venueId,
      );
      TablesModel newTable2 = table2.copyWith(
        venueName: table1.venueName,
        venueCapacity: table1.venueCapacity,
        period: table1.period,
        day: table1.day,
        venueId: table1.venueId,
      );
      var (data1, data2, message) = await TableGenUsecase(db: ref.watch(dbProvider))
          .swapTables(table1: newTable1, table2: newTable2);
      if (data1 != null && data2 != null) {
        ref.read(tableDataProvider.notifier).updateTable([data1, data2]);
        state = state.copyWith(table2: () => null, table1: () => null);
        CustomDialog.dismiss();
        CustomDialog.showSuccess(message: message);
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message);
      }
    }
  }

  void changeLecturer(
      {TablesModel? table,
      required String id,
      required String name,
      required WidgetRef ref,
     }) async{
    if (table != null) {
      CustomDialog.dismiss();
      CustomDialog.showInfo(message: 'Are you sure you want to change lecturer?',
      buttonText: 'Yes',
          onPressed: () {
            update(table: table, id: id, name: name, ref: ref, );
      });
    
    }
  }
  
  void update(
      {TablesModel? table,
      required String id,
      required String name,
      required WidgetRef ref,
     })async {
     CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Changing lecturer...');
    var newTable = table!.copyWith(lecturerId: id, lecturerName: name);
    var (data, message) = await TableGenUsecase(db: ref.watch(dbProvider)).updateItem(newTable);
    if (data != null) {
      ref.read(tableDataProvider.notifier).updateTable([data]);
     // form.currentState!.reset();
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: message);
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message);
    }
  }
}
