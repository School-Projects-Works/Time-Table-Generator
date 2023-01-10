import 'dart:io';
import 'package:aamusted_timetable_generator/Constants/Constant.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';

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
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return null;
  }
}

class ImportServices {
  static Future<List<CourseModel>?> importCourses(Excel? excel) async {
    var rows = excel!.tables[excel.getDefaultSheet()]!.rows;

    List<CourseModel> courses = rows.skip(1).map((row) {
      return CourseModel(
        code: row[0]!.value.toString(),
        title: row[1]!.value.toString(),
        creditHours: row[2]!.value.toString(),
        specialVenue: row[3]!.value.toString(),
        lecturerName: row[4]!.value.toString(),
        lecturerEmail: row[5]!.value.toString(),
        lecturerPhone: row[6]!.value.toString(),
        department: row[7]!.value.toString(),
        id: row[0]!.value.toString(),
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
        name: row[0]!.value.toString(),
        capacity: row[1]!.value.toString(),
        isDisabilityAccessible: row[2]!.value.toString(),
        id: row[0]!.value.toString(),
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
        level: row[0]!.value.toString(),
        type: row[1]!.value.toString(),
        name: row[2]!.value.toString(),
        size: row[3]!.value.toString(),
        hasDisability: row[4]!.value.toString(),
        // courses: row[5]!.value.toString(),
      );
    }) as List<ClassModel>;

    return venues;
  }

  static Future<File> tamplateCourses() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Courses'];
    CellStyle cellStyle = CellStyle(
      bold: true,
      fontSize: 12,
      fontColorHex: '#000000',
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

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
}
