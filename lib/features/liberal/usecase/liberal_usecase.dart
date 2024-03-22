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
              sheetName: 'Liberal',
              columnCount: liberalHeader.length,
              headings: liberalHeader,
              sheetAt: 0,
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
  Future<List<LiberalModel>> getLiberals() async {
    try {
      final Box<LiberalModel> liberalBox =
          await Hive.openBox<LiberalModel>('liberal');
      //check if box is open
      if (!liberalBox.isOpen) {
        await Hive.openBox('liberal');
      }

      var allLiberals = liberalBox.values.toList();
      return allLiberals;
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<(bool, String, List<LiberalModel>?, List<LecturerModel>?)>
      importLiberal({required String path,
          required String academicYear,
          required String semester}) {
    try {
      var bytes = File(path).readAsBytesSync();
      Excel excel = Excel.decodeBytes(List<int>.from(bytes));
      List<LiberalModel> liberals = [];
      List<LecturerModel> lecturers = [];
      var liberalSheet = excel.tables['Liberal']!;
      List<Data?>? liberalHeaderRow =
          liberalSheet.row(liberalInstructions.length + 1);
      if (AppUtils.validateExcel(liberalHeaderRow, venueHeader)) {
        var rowStart = liberalInstructions.length + 2;
        for (int i = rowStart; i < liberalSheet.maxRows; i++) {
          var row = liberalSheet.row(i);
          if (row[0] == null ||
              row[0]!.value == null ||
              row[1] == null ||
              row[1]!.value == null ||
              row[5] == null ||
              row[5]!.value == null ||
              row[6] == null ||
              row[6]!.value == null) {
            break;
          } else {
             List<String>targetStudents = [];
            if (row[2] != null &&
                row[2]!.value != null &&
                row[2]!
                        .value
                        .toString()
                        .toLowerCase()
                        .trim()
                        .replaceAll(' ', '') ==
                    'yes') {
              targetStudents.add('Regular');
            }
            if (row[3] != null &&
                row[3]!.value != null &&
                row[3]!
                        .value
                        .toString()
                        .toLowerCase()
                        .trim()
                        .replaceAll(' ', '') ==
                    'yes') {
              targetStudents.add('Evening');
            }
            if (row[4] != null &&
                row[4]!.value != null &&
                row[4]!
                        .value
                        .toString()
                        .toLowerCase()
                        .trim()
                        .replaceAll(' ', '') ==
                    'yes') {
              targetStudents.add('Weekend');
            }
            var liberal = LiberalModel(
                id: row[0]!
                    .value
                    .toString()
                    .toLowerCase()
                    .trim()
                    .hashCode
                    .toString(),
                code: row[0]!.value.toString().trim(),
                title: row[1]!.value.toString().trim(),
                studyMode: targetStudents,
                lecturerId: row[6]!.value.toString().trim(),
                lecturerName: row[7]!.value.toString().trim(),
                lecturerEmail: row[8]!.value.toString().trim(),
                academicSemester: semester,
                academicYear: academicYear
                );
            liberals.add(liberal);
            var lecturer = LecturerModel(
                id: row[6]!.value.toString().trim(),
                lecturerName: row[7]!.value.toString().trim(),
                lecturerEmail: row[8]!.value.toString().trim(),
                year: academicYear,
                courses: [row[0]!.value.toString().trim()],
                semester: semester,
                
                );
            lecturers.add(lecturer);
          }
        }
        return Future.value(
            (true, 'Liberal Courses Imported Successfully', liberals, lecturers));
      } else {
        return Future.value((false, 'Invalid Excel file', null, null));
      }
    } catch (e) {
      return Future.value((false, e.toString(), null, null));
    }
  }

  @override
  Future<(bool, String, LiberalModel?)> updateLiberal(LiberalModel venue) {
    // TODO: implement updateLiberal
    throw UnimplementedError();
  }
}
