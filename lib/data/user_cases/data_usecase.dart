// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:aamusted_timetable_generator/data/models/classes/classes_model.dart';
import 'package:aamusted_timetable_generator/data/models/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/data/models/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/data/models/liberal/liberal_corurses_model.dart';
import 'package:aamusted_timetable_generator/data/models/venues/venues_model.dart';
import 'package:aamusted_timetable_generator/data/repos/data_repo.dart';
import 'package:aamusted_timetable_generator/global/constants/constant_list.dart';
import 'package:aamusted_timetable_generator/global/functions/validate_excel_file.dart';
import 'package:aamusted_timetable_generator/global/widgets/custom_dialog.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../Services/file_service.dart';
import '../../global/functions/excell_settings.dart';

class DataUseCase extends ExcelFileRepo {
  @override
  Future<File?> generateAllocationExcelFile(BuildContext context) async {
    MyDialog myDialog = MyDialog(
        context: context, title: 'Generating', message: 'Please wait..');
    try {
      myDialog.loading();
      final Workbook workbook = Workbook();
      ExcelSettings(
          book: workbook,
          sheetName: 'Classes',
          columnCount: classHeader.length,
          headings: classHeader,
          sheetAt: 0,
          instructions:classInstructions ).sheetSettings();
      ExcelSettings(
          book: workbook,
          sheetName: 'Allocations',
          columnCount: courseAllocationHeader.length,
          headings: courseAllocationHeader,
          sheetAt: 1,
          instructions: courseInstructions
          ).sheetSettings();

      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/AllocationTemplate.xlsx';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        file.deleteSync();
        file.createSync();
      }
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      myDialog.closeLoading();
      return file;
    } catch (e) {
      myDialog.closeLoading();
      myDialog
        ..message = e.toString()
        ..title = 'Error'
        ..error();
      return null;
    }
  }

  @override
  Future<File?> generateLiberalExcelFile(BuildContext context) async {
    try {
      final Workbook workbook = Workbook();
      ExcelSettings(
        book: workbook,
        sheetName: 'Liberal',
        columnCount: liberalAllocationHeader.length,
        headings: liberalAllocationHeader,
        instructions: [
          'Please do not tamper with this sheet headers',
          'Please specify the level of students for the set of courses eg. 100,200,300,400, Masters, PhD',
          'Please specify the study mode for the set of courses eg. Regular, Weekend, Evening, Sandwich, Distance Learning',
        ],
        sheetAt: 0,
      ).sheetSettings();
      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/LiberalTemplate.xlsx';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        file.deleteSync();
        file.createSync();
      }
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      return file;
    } catch (e) {
      MyDialog(context: context, title: 'Error', message: e.toString()).error();
      return null;
    }
  }

  @override
  Future<(List<ClassesModel>, List<CoursesModel>, List<LecturersModel>)>
      readAllocationExcelFile(BuildContext context) async {
    try {
      String? pickedFilePath = await FileService.pickExcelFIle();
      List<ClassesModel> classes = [];
      List<CoursesModel> courses = [];
      List<LecturersModel> lecturers = [];
      if (pickedFilePath != null) {
        var bytes = File(pickedFilePath).readAsBytesSync();
        Excel excel = Excel.decodeBytes(List<int>.from(bytes));
        // get classes sheet
        var classesSheet = excel.tables['Classes']!;
        if (validateExcel(classesSheet, classHeader)) {}
        // get allocations sheet
        var allocationsSheet = excel.tables['Allocations']!;
        if (validateExcel(allocationsSheet, courseAllocationHeader)) {}
        return Future.value((classes, courses, lecturers));
      } else {
        return Future.value((
          List<ClassesModel>.empty(),
          List<CoursesModel>.empty(),
          List<LecturersModel>.empty()
        ));
      }
    } catch (e) {
      MyDialog(context: context, title: 'Error', message: e.toString()).error();
      return Future.value((
        List<ClassesModel>.empty(),
        List<CoursesModel>.empty(),
        List<LecturersModel>.empty()
      ));
    }
  }

  @override
  Future<File?> generateVenueExcelFile(BuildContext context)async {
   try {
      final Workbook workbook = Workbook();
      ExcelSettings(
        book: workbook,
        sheetName: 'Venues',
        columnCount: venueHeader.length,
        headings: venueHeader,
        instructions: [
          'Please do not tamper with this sheet headers',
          'Specify yes/no for venue disablity friendly',
          'Specify yes if the venue is a special venue (Computer lap, drawing lab, etc). Leave blank if not',
        ],
        sheetAt: 0,
      ).sheetSettings();
      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/venue.xlsx';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        file.deleteSync();
        file.createSync();
      }
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      return file;
    } catch (e) {
      MyDialog(context: context, title: 'Error', message: e.toString()).error();
      return null;
    }
  }

  @override
  Future<List<LiberalCoursesModel>> readLiberalExcelFile(BuildContext context)async {
    // TODO: implement readLiberalExcelFile
    return [];
  }

  @override
  Future<List<VenuesModel>> readVenueExcelFile(BuildContext context)async {
    // TODO: implement readVenueExcelFile
    return [];
  }
}
