import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesDataScource extends DataTableSource {
  final BuildContext context;
  CoursesDataScource(this.context);
  @override
  DataRow? getRow(int index) {
    var data = Provider.of<HiveListener>(context).getFilterdCourses;
    if (index >= data.length) return null;
    var course = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(course.code!)),
        DataCell(Text(course.title!)),
        DataCell(Text(course.creditHours!)),
        DataCell(Text(course.specialVenue!)),
        DataCell(Text(course.department!)),
        DataCell(Text(course.lecturerName!)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount =>
      Provider.of<HiveListener>(context).getFilterdCourses.length;

  @override
  int get selectedRowCount => 0;
}
