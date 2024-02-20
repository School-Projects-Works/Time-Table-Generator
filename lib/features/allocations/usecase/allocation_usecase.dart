import 'dart:io';

import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/repo/allocation_repo.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:excel/excel.dart';
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
      // get classes sheet
      var rowStart = classInstructions.length + 3;
      var classesSheet = excel.tables['Classes']!;
      List<Data?>? classHeaderRow =
          classesSheet.row(classInstructions.length + 2);
      if (AppUtils.validateExcel(classHeaderRow, classHeader)) {
        department =
            classesSheet.row(classInstructions.length + 1)[1]!.value.toString();
        for (int i = rowStart; i < classesSheet.maxRows; i++) {
          var row = classesSheet.row(i);
          if (row[1] != null &&
              row[1]!.value != null &&
              row[0] != null &&
              row[0]!.value != null &&
              row[2] != null &&
              row[2]!.value != null &&
              row[3] != null &&
              row[3]!.value != null) {
            classes.add(ClassModel(
              id: AppUtils.getId(),
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
        return Future.value((false, (courses, classes, lecturers), null));
      }
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
        List<CourseModel> dummyCourses = [];
        for (int i = rowStart; i < allocationsSheet.maxRows; i++) {
          var row = allocationsSheet.row(i);
          if (row[0] != null && row[0]!.value != null) {
            if (row[0] != null &&
                row[0]!.value != null &&
                row[1] != null &&
                row[1]!.value != null &&
                row[2] != null &&
                row[2]!.value != null) {
              dummyCourses.add(CourseModel(
                  id: AppUtils.getId(),
                  code: row[0]!.value.toString(),
                  title: row[1]!.value.toString(),
                  level: row[2]!.value.toString(),
                  lecturerName: row[3] != null && row[3]!.value != null
                      ? row[3]!.value.toString()
                      : '',
                  creditHours: row[4] != null && row[4]!.value != null
                      ? row[4]!.value.toString()
                      : '3',
                  specialVenue: row[5] != null && row[5]!.value != null
                      ? row[5]!.value.toString()
                      : '',
                  department: department,
                  academicSemester: semester,
                  academicYear: academicYear,
                  targetStudents: targetStudents));
              //group dummy courses by lecturer
            }
          }
        }
        // var lecturerGroup =
        //     groupBy(dummyCourses, (course) => course.lecturerName);

        // Get all the distinct lecturers from the course
        Map<String, LecturerModel> lecturersList = {};
        // var lecturersList = {};
        for (var course in dummyCourses) {
          if (course.lecturerName != null && course.lecturerName!.isNotEmpty) {
            var lecturerNames = course.lecturerName!.split(';');
            for (var lecturerName in lecturerNames) {
              // Get the classes the lecturer is teaching
              List<String> lectClassList =
                  extractStringWithinBrackets(lecturerName).split(",");
              // Remove the classes from the lecturer name
              lecturerName = extractStringOutsideBrackets(lecturerName).trim();
              if (lectClassList[0].isEmpty) {
                var level = course.level;
                var classList =
                    classes.where((element) => element.level == level).toList();
                lectClassList.clear();
                for (var cls in classList) {
                  lectClassList.add(cls.id!);
                }
              } else {
                //at this point the lecturer has specific classes
                for (var alph in lectClassList) {
                  for (var cls in classes) {
                    if (cls.level == course.level && cls.name!.endsWith(alph)) {
                      lectClassList[lectClassList.indexOf(alph)] = cls.id!;
                    }
                  }
                }
              }

              // Check if the lecturer is already in the list
              // If the lecturer is not in the list, add the lecturer and the course
              // If the lecturer is in the list, add the course to the lecturer
              if (!lecturersList.containsKey(lecturerName)) {
                lecturersList[lecturerName] = LecturerModel(
                  classes: lectClassList.isNotEmpty ? lectClassList : [],
                  courses: [course.code!],
                  lecturerName: lecturerName,
                  lecturerEmail: "",
                  department: department,
                  targetedStudents: targetStudents,
                  academicYear: academicYear,
                  academicSemester: semester,
                  id: AppUtils.getId(),
                  name: lecturerName,
                );
              } else {
                lecturersList[lecturerName]?.courses?.add(course.code!);
              }
            }
          }
        }
        lecturers = lecturersList.values.toList();
        courses = dummyCourses;

        // save to hive
        
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
