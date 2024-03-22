import 'dart:io';

import 'package:aamusted_timetable_generator/core/data/constants/instructions.dart';
import 'package:aamusted_timetable_generator/features/liberal/data/liberal/liberal_model.dart';
import 'package:aamusted_timetable_generator/features/liberal/repo/liberal_repo.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../core/data/constants/excel_headings.dart';
import '../../../core/functions/excel_settings.dart';
import '../../allocations/data/lecturers/lecturer_model.dart';

class LiberalUseCase extends LiberalRepo {
  @override
  Future<(bool, String)> addLiberals(List<LiberalModel> liberals) async {
    try {
      final Box<LiberalModel> liberalBox =
          await Hive.openBox<LiberalModel>('liberal');
      //check if box is open
      if (!liberalBox.isOpen) {
        await Hive.openBox('liberal');
      }
      for (var liberal in liberals) {
        liberalBox.put(liberal.id, liberal);
      }
      return Future.value((true, 'Liberal Courses added successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String)> deleteAllLiberals() {
    // TODO: implement deleteAllLiberals
    throw UnimplementedError();
  }

  @override
  Future<(bool, String, LiberalModel?)> deleteLiberal(String id) {
    // TODO: implement deleteLiberal
    throw UnimplementedError();
  }

  @override
  Future<(bool, String?)> downloadTemplate() async {
    try {
      final Workbook workbook = Workbook();
      ExcelSettings(
              book: workbook,
              sheetName: 'Regular-Liberal',
              columnCount: liberalHeader.length,
              headings: liberalHeader,
              sheetAt: 0,
              instructions: liberalInstructions)
          .sheetSettings();
      ExcelSettings(
              book: workbook,
              sheetName: 'Evening-Liberal',
              columnCount: liberalHeader.length,
              headings: liberalHeader,
              sheetAt: 1,
              instructions: liberalInstructions)
          .sheetSettings();
      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/Liberal_Courses_template.xlsx';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        file.deleteSync();
        file.createSync();
      }
      file.writeAsBytesSync(workbook.saveAsStream());
      // workbook.dispose();
      if (file.existsSync()) {
        return Future.value((true, file.path));
      } else {
        return Future.value((false, 'Error downloading template'));
      }
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<List<LiberalModel>> getLiberals(
      {required String year, required String sem}) async {
    try {
      final Box<LiberalModel> liberalBox =
          await Hive.openBox<LiberalModel>('liberal');
      //check if box is open
      if (!liberalBox.isOpen) {
        await Hive.openBox('liberal');
      }

      var allLiberals = liberalBox.values.toList();
      return allLiberals
          .where((element) => element.year == year && element.semester == sem)
          .toList();
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<(bool, String, List<LiberalModel>?, List<LecturerModel>?)>
      importLiberal(
          {required String path,
          required String academicYear,
          required String semester}) {
    try {
      var bytes = File(path).readAsBytesSync();
      Excel excel = Excel.decodeBytes(List<int>.from(bytes));
      List<LiberalModel> liberals = [];
      List<LecturerModel> lecturers = [];
      var (regCourses, regLecturers) =
          getRegularLib(excel, academicYear, semester);
      if (regCourses.isEmpty && regLecturers.isEmpty) {
        return Future.value((false, 'Invalid Excel file', null, null));
      }
      var (evCourses, evLecturers) =
          getEveningLib(excel, academicYear, semester);
      liberals.addAll(regCourses);
      liberals.addAll(evCourses);
      lecturers.addAll(regLecturers);
      //check if lecturers do not exist in the list else add course to lecturer
      for (var lecturer in evLecturers) {
        var existingLecturer = lecturers
            .where((element) => element.id == lecturer.id)
            .toList()
            .firstOrNull;
        if (existingLecturer != null) {
          existingLecturer.courses!.addAll(lecturer.courses!);
          //remove lecturer and add the updated one
          lecturers.removeWhere((element) => element.id == lecturer.id);
          lecturers.add(existingLecturer);
        } else {
          lecturers.add(lecturer);
        }
      }
      return Future.value(
          (true, 'Liberal Imported successfully', liberals, lecturers));
    } catch (e) {
      return Future.value((false, e.toString(), null, null));
    }
  }

  @override
  Future<(bool, String, LiberalModel?)> updateLiberal(LiberalModel venue) {
    // TODO: implement updateLiberal
    throw UnimplementedError();
  }

  (List<LiberalModel>, List<LecturerModel>) getRegularLib(
      Excel excel, String academicYear, String semester) {
    var regularSheet = excel.tables['Regular-Liberal'];
    if (regularSheet == null) {
      return ([], []);
    }
    List<LiberalModel> regularCourses = [];
    List<LecturerModel> regularLecturers = [];
    var headingRow = regularSheet.row(liberalInstructions.length + 2);

    if (AppUtils.validateExcel(headingRow, liberalHeader)) {
      var rowStart = liberalInstructions.length + 3;
      for (int i = rowStart; i < regularSheet.maxRows; i++) {
        var row = regularSheet.row(i);
        if (validateLiberalRow(row)) {
          var id = row[0]!.value.toString();
          var code = row[0]!.value.toString();
          var title = row[1]!.value.toString();
          var lecturerId = row[2]!.value.toString();
          var lecturerName = row[3]!.value.toString();
          var lecturerEmail =
              row[4]!.value != null ? row[4]!.value.toString().trim() : '';
          var lb = LiberalModel()
            ..code = code
            ..id = id
            ..title = title
            ..lecturerId = lecturerId
            ..lecturerName = lecturerName
            ..lecturerEmail = lecturerEmail
            ..year = academicYear
            ..semester = semester
            ..studyMode = 'Regular';
          //   print(lb);
          regularCourses.add(lb);
        }
        //? extract lecturers
        var lecturerId =
            row[2]!.value.toString().trim().replaceAll(' ', '').toLowerCase();
        var lecturerName = row[3]!.value.toString();
        var course = row[0]!.value.toString().toLowerCase();
        var lecturerEmail =
            row[4]!.value != null ? row[4]!.value.toString().trim() : '';
        regularLecturers.add(LecturerModel(
            id: lecturerId,
            lecturerName: lecturerName,
            lecturerEmail: lecturerEmail,
            year: academicYear,
            courses: [course],
            semester: semester));
      }
      return (regularCourses, regularLecturers);
    } else {
      return ([], []);
    }
  }

  (List<LiberalModel>, List<LecturerModel>) getEveningLib(
      Excel excel, String academicYear, String semester) {
    var eveningSheet = excel.tables['Evening-Liberal']!;
    List<LiberalModel> regularCourses = [];
    List<LecturerModel> regularLecturers = [];
    var headingRow = eveningSheet.row(liberalInstructions.length + 2);

    if (AppUtils.validateExcel(headingRow, liberalHeader)) {
      var rowStart = liberalInstructions.length + 3;
      for (int i = rowStart; i < eveningSheet.maxRows; i++) {
        var row = eveningSheet.row(i);
        if (validateLiberalRow(row)) {
          var id = 'E${row[0]!.value.toString().toLowerCase()}';
          var code = row[0]!.value.toString();
          var title = row[1]!.value.toString();
          var lecturerId = row[2]!.value.toString();
          var lecturerName = row[3]!.value.toString();
          var lecturerEmail =
              row[4]!.value != null ? row[4]!.value.toString().trim() : '';
          regularCourses.add(LiberalModel(
              id: id,
              code: code,
              title: title,
              studyMode: 'Evening',
              lecturerId: lecturerId,
              lecturerName: lecturerName,
              lecturerEmail: lecturerEmail,
              year: academicYear,
              semester: semester));
        }
        //? extract lecturers
        var lecturerId =
            row[2]!.value.toString().trim().replaceAll(' ', '').toLowerCase();
        var lecturerName = row[3]!.value.toString();
        var course = row[0]!.value.toString().toLowerCase();
        var lecturerEmail =
            row[4]!.value != null ? row[4]!.value.toString().trim() : '';
        regularLecturers.add(LecturerModel(
            id: lecturerId,
            lecturerName: lecturerName,
            lecturerEmail: lecturerEmail,
            year: academicYear,
            courses: [course],
            semester: semester));
      }
      return (regularCourses, regularLecturers);
    } else {
      return ([], []);
    }
  }

  bool validateLiberalRow(List<Data?> row) {
    var code = row[0]?.value;
    var title = row[1]?.value;
    var lecturerId = row[2]?.value;
    var lecturerName = row[3]?.value;
    return code != null &&
        title != null &&
        lecturerId != null &&
        lecturerName != null;
  }
}
