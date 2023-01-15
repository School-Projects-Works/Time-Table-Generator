// ignore_for_file: file_names

import 'dart:io';
import 'package:aamusted_timetable_generator/Constants/Constant.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
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

    // Validate the name column names
    return listEquals(fileColumns, columns);
  }

  static Future<Excel?> readExcelFile() async {
    try {
      String? pickedFilePath = await FileService.pickExcelFIle();
      if (pickedFilePath != null) {
        var bytes = File(pickedFilePath).readAsBytesSync();
        var excel = Excel.decodeBytes(List<int>.from(bytes));
        return excel;
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
        lecturerName: row[4] != null ? row[4]!.value.toString() : '',
        lecturerEmail: row[5] != null ? row[5]!.value.toString() : '',
        department: row[6] != null ? row[6]!.value.toString() : '',
        id: row[0] != null ? row[0]!.value.toString().trimToLowerCase() : '',
      );
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
        id: row[2] != null ? row[2]!.value.toString().trimToLowerCase() : '',
        level: row[0] != null ? row[0]!.value.toString() : '',
        type: row[1] != null ? row[1]!.value.toString() : 'Regular',
        name: row[2] != null ? row[2]!.value.toString() : '',
        size: row[3] != null ? row[3]!.value.toString() : '1',
        hasDisability: row[4] != null ? row[4]!.value.toString() : 'No',
        courses: row[5] != null ? row[5]!.value.toString().split(',') : [],
      );
    }).toList();

    return classes
        .where((element) =>
            element.id!.isNotEmpty &&
            element.courses!.isNotEmpty &&
            element.name!.isNotEmpty)
        .toList();
  }

  static Future<File> templateCourses() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Courses'];
    excel.setDefaultSheet('Courses');
    CellStyle cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        fontColorHex: '#000000',
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        textWrapping: TextWrapping.WrapText);

    sheetObject.appendRow(Constant.courseExcelHeaderOrder);
    sheetObject.row(0).forEach((element) {
      element?.cellStyle = cellStyle;
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/courses.xlsx';
    File file = File(fileName);
    file.writeAsBytesSync(excel.encode()!);
    file.createSync();
    return file;
  }

  static templateClasses() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Classes'];
    excel.setDefaultSheet('Classes');
    CellStyle cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        fontColorHex: '#000000',
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        textWrapping: TextWrapping.WrapText);

    sheetObject.appendRow(Constant.classExcelHeaderOrder);
    sheetObject.row(0).forEach((element) {
      element?.cellStyle = cellStyle;
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/classes.xlsx';
    File file = File(fileName);
    file.writeAsBytesSync(excel.encode()!);
    file.createSync();
    return file;
  }

  static templateVenue() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Venues'];
    excel.setDefaultSheet('Venues');
    CellStyle cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        fontColorHex: '#000000',
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        textWrapping: TextWrapping.WrapText);

    sheetObject.appendRow(Constant.venueExcelHeaderOrder);
    sheetObject.row(0).forEach((element) {
      element?.cellStyle = cellStyle;
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/venues.xlsx';
    File file = File(fileName);
    file.writeAsBytesSync(excel.encode()!);
    file.createSync();
    return file;
  }

  static templateLiberal() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Liberal'];
    excel.setDefaultSheet('Liberal');
    CellStyle cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        fontColorHex: '#000000',
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        textWrapping: TextWrapping.WrapText);

    sheetObject.appendRow(Constant.liberalExcelHeaderOrder);
    sheetObject.row(0).forEach((element) {
      element?.cellStyle = cellStyle;
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/liberal.xlsx';
    File file = File(fileName);
    file.writeAsBytesSync(excel.encode()!);
    file.createSync();
    return file;
  }

  static Future<List<LiberalModel>> importLiberal(Excel excel) async {
    var rows = excel.tables[excel.getDefaultSheet()]!.rows;
    List<LiberalModel> liberals = rows.skip(1).map<LiberalModel>((row) {
      return LiberalModel(
        id: row[0] != null ? row[0]!.value.toString().trimToLowerCase() : '',
        code: row[0] != null ? row[0]!.value.toString() : '',
        title: row[1] != null ? row[1]!.value.toString() : '',
        lecturerName: row[2] != null ? row[2]!.value.toString() : '',
        lecturerEmail: row[3] != null ? row[3]!.value.toString() : '',
      );
    }).toList();

    return liberals.where((element) => element.id!.isNotEmpty).toList();
  }
}
