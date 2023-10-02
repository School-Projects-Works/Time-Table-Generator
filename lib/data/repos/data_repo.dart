import 'dart:io';

import 'package:aamusted_timetable_generator/data/models/classes/classes_model.dart';
import 'package:aamusted_timetable_generator/data/models/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/data/models/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/data/models/liberal/liberal_corurses_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../models/venues/venues_model.dart';

abstract class ExcelFileRepo {
  Future<File?> generateAllocationExcelFile(BuildContext context);
  Future<File?> generateLiberalExcelFile(BuildContext context);
  Future<(List<ClassesModel>, List<CoursesModel>, List<LecturersModel>)>
      readAllocationExcelFile(BuildContext context);
  Future<List<LiberalCoursesModel>> readLiberalExcelFile(BuildContext context);
  Future<File?> generateVenueExcelFile(BuildContext context);
  Future<List<VenuesModel>> readVenueExcelFile(BuildContext context);
}
