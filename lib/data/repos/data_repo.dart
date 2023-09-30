import 'dart:io';

import 'package:aamusted_timetable_generator/data/models/classes/classes_model.dart';
import 'package:aamusted_timetable_generator/data/models/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/data/models/lecturers/lecturer_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

abstract class ExcelFileRepo {
  Future<File?> generateAllocationExcelFile(BuildContext context);
  Future<File?> generateLiberalExcelFile(BuildContext context);
  Future<(List<ClassesModel>, List<CoursesModel>, List<LecturersModel>)>
      readAllocationExcelFile(BuildContext context);
}
