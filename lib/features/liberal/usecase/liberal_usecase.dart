import 'dart:io';
import 'package:aamusted_timetable_generator/core/data/constants/instructions.dart';
import 'package:aamusted_timetable_generator/features/liberal/data/liberal/liberal_model.dart';
import 'package:aamusted_timetable_generator/features/liberal/repo/liberal_repo.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:excel/excel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../core/data/constants/excel_headings.dart';
import '../../../core/functions/excel_settings.dart';

class LiberalUseCase extends LiberalRepo {
  final Db db;

  LiberalUseCase({required this.db});
  @override
  Future<(bool, String)> addLiberals(List<LiberalModel> liberals) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //delete all liberals where year and semester is the same
      await db
          .collection('liberals')
          .remove({'year': liberals[0].year, 'semester': liberals[0].semester});
      // add liberals to d
      for (var liberal in liberals) {
        await db.collection('liberals').insert(liberal.toMap());
      }
      return Future.value((true, 'Liberal Courses added successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String?)> downloadTemplate() async {
    try {
     var workbook = ExcelSettings.generateLiberalTem();
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
      if (db.state != State.open) {
        await db.open();
      }
      //get all liberals where year and semester is the same
      var allLiberals = await db
          .collection('liberals')
          .find({'year': year, 'semester': sem}).toList();
      return allLiberals.map((e) => LiberalModel.fromMap(e)).toList();
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<(bool, String, List<LiberalModel>?)> importLiberal(
      {required String path,
      required String academicYear,
      required String semester}) {
    try {
      var bytes = File(path).readAsBytesSync();
      Excel excel = Excel.decodeBytes(List<int>.from(bytes));
      List<LiberalModel> liberals = [];
      var (regCourses) = getRegularLib(excel, academicYear, semester);
      if (regCourses.isEmpty) {
        return Future.value((false, 'Invalid Excel file', null));
      }
      var evCourses = getEveningLib(excel, academicYear, semester);
      liberals.addAll(regCourses);
      liberals.addAll(evCourses);
      return Future.value((true, 'Liberal Imported successfully', liberals));
    } catch (e) {
      return Future.value((false, e.toString(), null));
    }
  }

  @override
  Future<(bool, String, LiberalModel?)> updateLiberal(LiberalModel venue) {
    // TODO: implement updateLiberal
    throw UnimplementedError();
  }

  List<LiberalModel> getRegularLib(
      Excel excel, String academicYear, String semester) {
    var regularSheet = excel.tables['Regular-Liberal'];
    if (regularSheet == null) {
      return [];
    }
    List<LiberalModel> regularCourses = [];
    var headingRow = regularSheet.row(liberalInstructions.length + 2);

    if (AppUtils.validateExcel(headingRow, liberalHeader)) {
      var rowStart = liberalInstructions.length + 3;
      for (int i = rowStart; i < regularSheet.maxRows; i++) {
        var row = regularSheet.row(i);
        if (validateLiberalRow(row)) {
          var id = row[0]!.value.toString().replaceAll(' ', '');
          var code = row[0]!.value.toString();
          var title = row[1]!.value.toString();
          var lecturerId = row[2]!.value.toString().replaceAll(' ', '');
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
      }
      return regularCourses;
    } else {
      return [];
    }
  }

  List<LiberalModel> getEveningLib(
      Excel excel, String academicYear, String semester) {
    var eveningSheet = excel.tables['Evening-Liberal']!;
    List<LiberalModel> regularCourses = [];
    var headingRow = eveningSheet.row(liberalInstructions.length + 2);

    if (AppUtils.validateExcel(headingRow, liberalHeader)) {
      var rowStart = liberalInstructions.length + 3;
      for (int i = rowStart; i < eveningSheet.maxRows; i++) {
        var row = eveningSheet.row(i);
        if (validateLiberalRow(row)) {
          var id = 'E${row[0]!.value.toString()}'.replaceAll(' ', '');
          var code = row[0]!.value.toString();
          var title = row[1]!.value.toString();
          var lecturerId = row[2]!.value.toString().replaceAll(' ', '');
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
      }
      return regularCourses;
    } else {
      return [];
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

  @override
  Future<(bool, String)> deleteLiberals(
      {required String academicYear, required String semester}) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      await db
          .collection('liberals')
          .remove({'year': academicYear, 'semester': semester});
      return Future.value((true, 'Liberal Courses deleted successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String, LiberalModel?)> deleteLiberal(String id) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      var data = await db.collection('liberals').findOne({'id': id});
      await db.collection('liberals').remove({'id': id});
      return Future.value((
        true,
        'Liberal Course Deleted Successfully',
        LiberalModel.fromMap(data!),
      ));
    } catch (e) {
      return Future.value((false, e.toString(), null));
    }
  }
}
