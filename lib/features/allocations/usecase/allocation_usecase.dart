import 'dart:io';

import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/repo/allocation_repo.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../core/data/constants/excel_headings.dart';
import '../../../core/data/constants/instructions.dart';
import '../../../core/functions/excel_settings.dart';

class AllocationUseCase extends AllocationRepo {
  @override
  Future<(bool, ClassModel?, String?)> detleteClass() {
    // TODO: implement detleteClass
    throw UnimplementedError();
  }

  @override
  Future<(bool, CourseModel?, String?)> detleteCourse() {
    // TODO: implement detleteCourse
    throw UnimplementedError();
  }

  @override
  Future<(bool, LecturerModel?, String?)> detleteLecturer() {
    // TODO: implement detleteLecturer
    throw UnimplementedError();
  }

  @override
  Future<(bool, String?)> downloadTemplate() async {
    try {
      CustomDialog.showLoading(message: 'Downloading template...');
      final Workbook workbook = Workbook();
      ExcelSettings(
              book: workbook,
              sheetName: 'Classes',
              columnCount: classHeader.length,
              headings: classHeader,
              sheetAt: 0,
              instructions: classInstructions)
          .sheetSettings();
      ExcelSettings(
              book: workbook,
              sheetName: 'Allocations',
              columnCount: courseAllocationHeader.length,
              headings: courseAllocationHeader,
              sheetAt: 1,
              instructions: courseInstructions)
          .sheetSettings();

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
      CustomDialog.dismiss();
      if (file.existsSync()) {
        return Future.value((true, file.path));
      } else {
        return Future.value((false, 'Error downloading template'));
      }
    } catch (e) {
      CustomDialog.dismiss();
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<
          (
            bool,
            (List<CourseModel>, List<ClassModel>, List<LecturerModel>),
            String?
          )>
      importAllocation(
          {required String path,
          required String academicYear,
          required String semester,
          required String targetStudents}) async {
    try {
      List<CourseModel> courses = [];
      List<ClassModel> classes = [];
      List<LecturerModel> lecturers = [];
      var bytes = File(path).readAsBytesSync();
      Excel excel = Excel.decodeBytes(List<int>.from(bytes));
      String department = '';
      // get classes sheet====================================================
      var rowStart = classInstructions.length + 3;
      var classesSheet = excel.tables['Classes']!;
      List<Data?>? classHeaderRow =
          classesSheet.row(classInstructions.length + 2);
      if (AppUtils.validateExcel(classHeaderRow, classHeader)) {
        var departmentRow = classesSheet.row(classInstructions.length + 1)[1];
        department = departmentRow != null && departmentRow.value != null
            ? departmentRow.value.toString()
            : '';
        if (department.isNotEmpty) {
          for (int i = rowStart; i < classesSheet.maxRows; i++) {
            var row = classesSheet.row(i);
            if (validateClassRow(row)) {
              classes.add(ClassModel(
                id: '${row[1]!.value.toString()}$department'
                    .hashCode
                    .toString(),
                level: row[0]!.value.toString(),
                name: row[1]!.value.toString(),
                size: row[2]!.value.toString(),
                targetStudents: targetStudents,
                department: department,
                academicSemester: semester,
                academicYear: academicYear,
                hasDisability: row[4] != null && row[4]!.value != null
                    ? row[4]!.value.toString()
                    : 'No',
                createdAt: DateTime.now().toString(),
              ));
            }
          }
        } else {
          return Future.value((
            false,
            (courses, classes, lecturers),
            'Department was not Specified'
          ));
        }
      } else {
        return Future.value((
          false,
          (courses, classes, lecturers),
          'Excel Sheet can not be validated'
        ));
      }
      //! End of classes sheet====================================================
      // get allocations sheet
      var allocationsSheet = excel.tables['Allocations']!;
      // get allocations headers
      List<Data?>? allocationsHeaderRow =
          allocationsSheet.row(courseInstructions.length + 2);
      // validate allocations headers
      if (AppUtils.validateExcel(
        allocationsHeaderRow,
        courseAllocationHeader,
      )) {
        department = department.isNotEmpty
            ? department
            : allocationsSheet
                .row(courseInstructions.length + 1)[1]!
                .value
                .toString();
        // get allocations
        var rowStart = courseInstructions.length + 3;

        for (int i = rowStart; i < allocationsSheet.maxRows; i++) {
          var row = allocationsSheet.row(i);
          if (validateRow(row)) {
            //? Courses extraction.....................................................
            courses.add(CourseModel(
                id: row[0]!.value.toString(),
                code: row[0]!.value.toString(),
                title: row[1]!.value.toString(),
                level: row[2]!.value.toString(),
                creditHours: row[3] != null && row[3]!.value != null
                    ? row[3]!.value.toString()
                    : '3',
                specialVenue: row[4] != null && row[4]!.value != null
                    ? row[4]!.value.toString()
                    : '',
                lecturerId: row[5]!.value.toString(),
                lecturerName: row[6]!.value.toString(),
                department: department,
                academicSemester: semester,
                academicYear: academicYear,
                targetStudents: targetStudents));
            //! End of courses extraction.....................................................
            //? Lecturers extraction.....................................................
            LecturerModel lecturer = LecturerModel();
            lecturer.classes = [];
            var id = row[5]!
                .value
                .toString()
                .toLowerCase()
                .replaceAll(' ', '')
                .trim();
            var lecturerClass = row[8] != null && row[8]!.value != null
                ? row[8]!.value.toString()
                : '';
            List<String> lecturerClasses = [];
            if (lecturerClass.isNotEmpty) {
              var lecturerClassList = lecturerClass.split(',');
              for (var c in lecturerClassList) {
                //check if class is found in the classes list else cancel all extractions and return error
                if (!classes.any((element) =>
                    element.name!.toLowerCase().trim().replaceAll(' ', '') ==
                    c.toLowerCase().trim().replaceAll(' ', ''))) {
                  return Future.value((
                    false,
                    (courses, classes, lecturers),
                    'A class ($c)in the allocations sheet does not exist in the classes sheet'
                  ));
                } else {
                  lecturerClasses.add(c);
                }
              }
            } else {
              // add all classes with same level to lecturer
              lecturerClasses = classes
                  .where((element) => element.level == row[2]!.value.toString())
                  .map((e) => e.name!)
                  .toList();
            }
            if (lecturers.any((element) =>
                element.id!.toLowerCase().replaceAll(' ', '').trim() == id)) {
              lecturer = lecturers.firstWhere((element) => element.id == id);
              lecturer.courses!.add(row[0]!.value.toString());
              lecturer.classes!.addAll(lecturerClasses);
            } else {
              lecturer = LecturerModel(
                  id: id,
                  lecturerName: row[6]!.value.toString(),
                  department: department,
                  academicSemester: semester,
                  academicYear: academicYear,
                  targetedStudents: targetStudents,
                  courses: [row[0]!.value.toString()],
                  classes: lecturerClasses,
                  lecturerEmail: row[7] != null && row[7]!.value != null
                      ? row[7]!.value.toString()
                      : '');
              lecturers.add(lecturer);
            }
          }
        }

        return Future.value((true, (courses, classes, lecturers), null));
      } else {
        return Future.value((false, (courses, classes, lecturers), null));
      }
    } catch (e) {
      List<CourseModel> courses = [];
      List<ClassModel> classes = [];
      List<LecturerModel> lecturers = [];
      return Future.value((false, (courses, classes, lecturers), e.toString()));
    }
  }

  bool validateRow(List<Data?> row) {
    return row[0] != null &&
        row[0]!.value != null &&
        row[5] != null &&
        row[5]!.value != null &&
        row[6] != null &&
        row[6]!.value != null &&
        row[1] != null &&
        row[1]!.value != null &&
        row[2] != null &&
        row[2]!.value != null;
  }

  bool validateClassRow(List<Data?> row) {
    return row[1] != null &&
        row[1]!.value != null &&
        row[0] != null &&
        row[0]!.value != null &&
        row[2] != null &&
        row[2]!.value != null &&
        row[3] != null &&
        row[3]!.value != null;
  }
}

String extractStringWithinBrackets(String inputString) {
  final pattern = RegExp(r'\((.*?)\)'); // Matches text within square brackets
  final match = pattern.firstMatch(inputString);

  if (match != null) {
    // Extract the captured group (the text within brackets)
    return match.group(1)!;
  } else {
    return ''; // Return an empty string if no match is found
  }
}

String extractStringOutsideBrackets(String inputString) {
  final pattern = RegExp(r'\((.*?)\)'); // Matches text within square brackets
  final match = pattern.firstMatch(inputString);

  if (match != null) {
    return inputString.replaceAll(
        pattern, ''); // Remove the matched bracketed part
  } else {
    return inputString; // Return the original string if no brackets found
  }
}
