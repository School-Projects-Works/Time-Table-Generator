import 'dart:io';
import 'package:aamusted_timetable_generator/Constants/Constant.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import '../Models/Class/ClassModel.dart';
import '../Models/Course/CourseModel.dart';

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
    List<String> fileColumns = headerRow.map((e) => e?.value) as List<String>;

    // Validate the name column names
    return const ListEquality().equals(fileColumns, columns);
  }

  static Future<Excel?> readExcelFile() async {
    try {
      String? pickedFilePath = await FileService.pickExcelFIle();
      if (pickedFilePath != null) {
        var bytes = File(pickedFilePath).readAsBytesSync();
        var excel = Excel.decodeBytes(List<int>.from(bytes));
        return excel;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return null;
  }
}

class ImportServices {
  static Future<List<CourseModel>> importCourses() async {
    Excel? excel = await ExcelService.readExcelFile();
    bool isFIleValid = ExcelService.validateExcelFIleByColumns(
      excel,
      Constant.courseExcelHeaderOrder,
    );
    if (!isFIleValid) throw ('Error Occurred');

    var rows = excel!.tables[excel.getDefaultSheet()]!.rows;

    List<CourseModel> courses = rows.skip(1).map((row) {
      return CourseModel(
        code: row[0]!.value,
        title: row[1]!.value,
        creditHours: row[2]!.value,
        specialVenue: row[3]!.value,
        lecturerName: row[4]!.value,
        lecturerEmail: row[5]!.value,
        lecturerPhone: row[6]!.value,
        department: row[7]!.value,
        id: row[0]!.value,
      );
    }) as List<CourseModel>;

    return courses;
  }

  static Future<List<VenueModel>> importVenues() async {
    Excel? excel = await ExcelService.readExcelFile();
    bool isFIleValid = ExcelService.validateExcelFIleByColumns(
      excel,
      Constant.venueExcelHeaderOrder,
    );
    if (!isFIleValid) throw ('Error Occurred');

    var rows = excel!.tables[excel.getDefaultSheet()]!.rows;

    List<VenueModel> venues = rows.skip(1).map((row) {
      return VenueModel(
        name: row[0]!.value,
        capacity: row[1]!.value,
        isDisabilityAccessible: row[2]!.value,
        id: row[0]!.value,
      );
    }) as List<VenueModel>;

    return venues;
  }

  static Future<List<ClassModel>> importClasses() async {
    Excel? excel = await ExcelService.readExcelFile();
    bool isFIleValid = ExcelService.validateExcelFIleByColumns(
      excel,
      Constant.venueExcelHeaderOrder,
    );
    if (!isFIleValid) throw ('Error Occurred');

    var rows = excel!.tables[excel.getDefaultSheet()]!.rows;

    List<ClassModel> venues = rows.skip(1).map((row) {
      return ClassModel(
        id: row[2]!.value.toString().trimToLowerCase(),
        level: row[0]!.value,
        type: row[1]!.value,
        name: row[2]!.value,
        size: row[3]!.value,
        hasDisability: row[4]!.value,
        courses: row[5]!.value,
      );
    }) as List<ClassModel>;

    return venues;
  }
}
