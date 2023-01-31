// ignore_for_file: file_names

import 'dart:io';
import 'package:aamusted_timetable_generator/Constants/Constant.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:aamusted_timetable_generator/Services/ExcelSheetSettings.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../Models/Class/ClassModel.dart';
import '../Models/Course/CourseModel.dart';
import '../Models/Course/LiberalModel.dart';

class FileService {
  static Future<String?> pickExcelFIle() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
      allowMultiple: false,
    );
    return result?.files.single.path;
  }
}

class ExcelService {
  static bool validateExcelFIleByColumns(Excel? excel, List<String> columns) {
    if (excel == null) return false;
    // GEt the header row
    List<Data?> headerRow = excel.tables[excel.getDefaultSheet()]!.row(0);
    List<String> fileColumns =
        headerRow.map<String>((data) => data!.value.toString()).toList();
    return listEquals(fileColumns, columns);
  }

  static Future<Excel?> readExcelFile() async {
    try {
      String? pickedFilePath = await FileService.pickExcelFIle();
      if (pickedFilePath != null) {
        var bytes = File(pickedFilePath).readAsBytesSync();
        return Excel.decodeBytes(List<int>.from(bytes));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

class ImportServices {
  static Future<List<CourseModel>?> importCourses(Excel? excel) async {
    var rows = excel!.tables[excel.getDefaultSheet()]!.rows;
    List<CourseModel> courses = rows.skip(1).map<CourseModel>((row) {
      return CourseModel(
          code: row[0] != null ? row[0]!.value.toString() : '',
          title: row[1] != null ? row[1]!.value.toString() : '',
          creditHours: row[2] != null ? row[2]!.value.toString() : '3',
          specialVenue: row[3] != null ? row[3]!.value.toString() : 'No',
          department: row[4] != null ? row[4]!.value.toString() : '',
          level: row[5] != null ? row[5]!.value.toString() : '',
          lecturerName: row[6] != null ? row[6]!.value.toString() : '',
          lecturerEmail: row[7] != null ? row[7]!.value.toString() : '',
          id: row[0] != null && row[4] != null
              ? '${row[0]!.value.toString().trimToLowerCase()}_${row[4]!.value.toString().getInitials()}'
              : '',
          venues: []);
    }).toList();

    return courses.where((element) => element.id!.isNotEmpty).toList();
  }

  static Future<List<VenueModel>?> importVenues(Excel? excel) async {
    var rows = excel!.tables[excel.getDefaultSheet()]!.rows;
    List<VenueModel> venues = rows.skip(1).map<VenueModel>((row) {
      return VenueModel(
        name: row[0] != null ? row[0]!.value.toString() : '',
        capacity: row[1] != null ? row[1]!.value.toString() : '100',
        isDisabilityAccessible:
            row[2] != null ? row[2]!.value.toString() : 'No',
        id: row[0] != null ? row[0]!.value.toString().trimToLowerCase() : '',
        isSpecialVenue: row[3] != null ? row[3]!.value.toString() : 'No',
      );
    }).toList();

    return venues
        .where((element) => element.id!.isNotEmpty && element.name!.isNotEmpty)
        .toList();
  }

  static Future<List<ClassModel>?> importClasses(Excel? excel) async {
    var rows = excel!.tables[excel.getDefaultSheet()]!.rows;
    List<ClassModel> classes = rows.skip(1).map<ClassModel>((row) {
      return ClassModel(
        level: row[0] != null ? row[0]!.value.toString() : '',
        targetStudents: row[1] != null ? row[1]!.value.toString() : '',
        name: row[2] != null ? row[2]!.value.toString() : '',
        department: row[3] != null ? row[3]!.value.toString() : '',
        size: row[4] != null ? row[4]!.value.toString() : '10',
        hasDisability: row[5] != null ? row[5]!.value.toString() : 'No',
        id: row[2] != null && row[3] != null
            ? '${row[2]!.value.toString().trimToLowerCase()}_${row[3]!.value.toString().getInitials()}'
            : '',
      );
    }).toList();
    return classes
        .where((element) => element.id!.isNotEmpty && element.name!.isNotEmpty)
        .toList();
  }

  static Future<File> templateCourses(File file) async {
    try {
      final Workbook workbook = Workbook();
      ExcelSheetSettings(
        book: workbook,
        sheetName: 'Courses',
        columnCount: Constant.courseExcelHeaderOrder.length,
        headings: Constant.courseExcelHeaderOrder,
      ).sheetSettings();
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      return file;
    } catch (e) {
      print('Error=====$e');
    }
    return file;
  }

  static templateClasses(File file) async {
    try {
      final Workbook workbook = Workbook();
      ExcelSheetSettings(
        book: workbook,
        sheetName: 'Students Classes',
        columnCount: Constant.classExcelHeaderOrder.length,
        headings: Constant.classExcelHeaderOrder,
      ).sheetSettings();
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      return file;
    } catch (e) {
      print('Error=====$e');
    }
    return file;
  }

  static templateVenue() async {
    try {
      final Workbook workbook = Workbook();
      ExcelSheetSettings(
        book: workbook,
        sheetName: 'Venues',
        columnCount: Constant.venueExcelHeaderOrder.length,
        headings: Constant.venueExcelHeaderOrder,
      ).sheetSettings();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String fileName = '${appDocDir.path}/venues.xlsx';
      File file = File(fileName);
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      return file;
    } catch (e) {
      print('Error=====$e');
    }
  }

  static templateLiberal(File file) async {
    try {
      final Workbook workbook = Workbook();
      ExcelSheetSettings(
        book: workbook,
        sheetName: 'Liberal Courses',
        columnCount: Constant.liberalExcelHeaderOrder.length,
        headings: Constant.liberalExcelHeaderOrder,
      ).sheetSettings();
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      return file;
    } catch (e) {
      print('Error=====$e');
    }
  }

  static Future<List<LiberalModel>> importLiberal(Excel excel) async {
    var rows = excel.tables[excel.getDefaultSheet()]!.rows;
    List<LiberalModel> liberals = rows.skip(1).map<LiberalModel>((row) {
      return LiberalModel(
        id: row[0] != null ? row[0]!.value.toString().trimToLowerCase() : '',
        code: row[0] != null ? row[0]!.value.toString() : '',
        title: row[1] != null ? row[1]!.value.toString() : '',
        level: row[2] != null ? row[2]!.value.toString() : '',
        lecturerName: row[3] != null ? row[3]!.value.toString() : '',
        lecturerEmail: row[4] != null ? row[4]!.value.toString() : '',
      );
    }).toList();
    return liberals.where((element) => element.id!.isNotEmpty).toList();
  }
}
