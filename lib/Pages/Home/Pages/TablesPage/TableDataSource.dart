import 'dart:convert';

import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableDataSource extends DataTableSource {
  final BuildContext context;

  TableDataSource(this.context);
  @override
  DataRow? getRow(int index) {
    var data = Provider.of<HiveListener>(context, listen: false)
        .getTables!
        .where((element) => element.day == 'Monday')
        .toList();
    var table = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(table.venue!)),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount =>
      Provider.of<HiveListener>(context, listen: false).getTables!.length;

  @override
  int get selectedRowCount => 0;
}
