import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';

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

final tablePairProvider = StateNotifierProvider<TablePairProvider, TablePairModel>((ref) {
  return TablePairProvider();
});

class TablePairProvider extends StateNotifier<TablePairModel> {
  TablePairProvider() : super(TablePairModel());

  void setTable1(TablesModel? table) {
    state = state.copyWith(table1:()=> table);
  }

  void setTable2(TablesModel? table,WidgetRef ref) {
    state = state.copyWith(table2: () => table);
    if(table!=null){
      
    }

  }
}
