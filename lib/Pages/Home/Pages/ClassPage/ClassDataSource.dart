import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/HiveListener.dart';

class ClassDataSource extends DataTableSource {
  final BuildContext context;

  ClassDataSource(this.context);
  @override
  DataRow? getRow(int index) {
    final classList =
        Provider.of<HiveListener>(context, listen: false).getFilteredClass;
    if (index >= classList.length) return null;
    final classItem = classList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(classItem.level!)),
        DataCell(Text(classItem.type!)),
        DataCell(Text(classItem.name!)),
        DataCell(Text(classItem.size!)),
        DataCell(Text(classItem.hasDisability!)),
        DataCell(Text(classItem.courses!.join(', '))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount =>
      Provider.of<HiveListener>(context, listen: false).getFilteredClass.length;

  @override
  int get selectedRowCount => 0;
}
