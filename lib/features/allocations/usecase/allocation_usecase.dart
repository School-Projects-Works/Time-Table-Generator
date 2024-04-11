import 'dart:async';
import 'dart:io';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/repo/allocation_repo.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:excel/excel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../core/data/constants/excel_headings.dart';
import '../../../core/data/constants/instructions.dart';
import '../../../core/functions/excel_settings.dart';

class AllocationUseCase extends AllocationRepo {
  @override
  Future<(bool, String?)> downloadTemplate() async {
    try {
      CustomDialog.showLoading(message: 'Downloading template...');
      final Workbook workbook = Workbook();
      ExcelSettings(
              book: workbook,
              sheetName: 'Regular-Classes',
              columnCount: classHeader.length,
              headings: classHeader,
              sheetAt: 0,
              instructions: classInstructions)
          .sheetSettings();
      ExcelSettings(
              book: workbook,
              sheetName: 'Regular-Allocations',
              columnCount: courseAllocationHeader.length,
              headings: courseAllocationHeader,
              sheetAt: 1,
              instructions: courseInstructions)
          .sheetSettings();
      ExcelSettings(
              book: workbook,
              sheetName: 'Evening-Classes',
              columnCount: classHeader.length,
              headings: classHeader,
              sheetAt: 2,
              instructions: classInstructions)
          .sheetSettings();
      ExcelSettings(
              book: workbook,
              sheetName: 'Evening-Allocations',
              columnCount: courseAllocationHeader.length,
              headings: courseAllocationHeader,
              sheetAt: 3,
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
      // workbook.dispose();
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
      )> importAllocation({
    required String path,
    required String year,
    required String semester,
  }) async {
    try {
      List<CourseModel> courses = [];
      List<ClassModel> classes = [];
      List<LecturerModel> lecturers = [];
      var bytes = File(path).readAsBytesSync();
      Excel excel = Excel.decodeBytes(List<int>.from(bytes));
      var (regClass, regCourses, regLecturers, regMessage) =
          getRegularData(excel, semester, year);
      if (regClass.isEmpty && regCourses.isEmpty && regLecturers.isEmpty) {
        return Future.value((false, (courses, classes, lecturers), regMessage));
      }
      var (eveClass, eveCourses, eveLecturers, eveMessage) =
          getEveningData(excel, semester, year);
      if (eveClass.isEmpty && eveCourses.isEmpty && eveLecturers.isEmpty) {
        return Future.value((false, (courses, classes, lecturers), eveMessage));
      }
      classes.addAll(regClass);
      classes.addAll(eveClass);
      courses.addAll(regCourses);
      courses.addAll(eveCourses);
      lecturers.addAll(regLecturers);
      //check if lecturer is already in the list then add the courses and classes to the lecturer
      for (var lecturer in eveLecturers) {
        if (lecturers.any((element) => element.id == lecturer.id)) {
          var existenLecturer =
              lecturers.firstWhere((element) => element.id == lecturer.id);
          existenLecturer.classes.addAll(lecturer.classes
              .where((element) => !existenLecturer.classes.contains(element)));
          existenLecturer.courses.addAll(lecturer.courses
              .where((element) => !existenLecturer.courses.contains(element)));
          lecturers.removeWhere((element) => element.id == lecturer.id);
          lecturers.add(existenLecturer);
        } else {
          lecturers.add(lecturer);
        }
      }

      return Future.value(
          (true, (courses, classes, lecturers), eveMessage ?? regMessage));
    } catch (e) {
      List<CourseModel> courses = [];
      List<ClassModel> classes = [];
      List<LecturerModel> lecturers = [];
      return Future.value((false, (courses, classes, lecturers), e.toString()));
    }
  }

  bool validateRow(List<Data?> row) {
    //! do it here
    var ccode = row[0]?.value;
    var ctitle = row[1]?.value;
    var clevel = row[2]?.value;
    var lecID = row[5]?.value;
    var lecName = row[6]?.value;
    var lecEmail = row[7]?.value;
    return ccode != null &&
        ctitle != null &&
        clevel != null &&
        lecID != null &&
        lecName != null &&
        lecEmail != null;
  }

  bool validateClassRow(List<Data?> row) {
    var lev = row[0]?.value;
    var classcode = row[1]?.value;
    return lev != null && classcode != null;
  }

  (List<ClassModel>, List<CourseModel>, List<LecturerModel>, String? message)
      getRegularData(Excel excel, String semester, String year) {
    List<CourseModel> courses = [];
    List<ClassModel> classes = [];
    List<LecturerModel> lecturers = [];
    var classesSheet = excel.tables['Regular-Classes'];
    if (classesSheet == null) {
      return ([], [], [], 'No classes found for Regular Students');
    }
    var allocationsSheet = excel.tables['Regular-Allocations'];
    if (allocationsSheet == null) {
      return ([], [], [], 'No Regular Allocations Sheet');
    }
    var classHeadingRow = classesSheet.row(classInstructions.length + 2);
    var courseHeadingRow = allocationsSheet.row(courseInstructions.length + 2);
    if (AppUtils.validateExcel(classHeadingRow, classHeader) &&
        AppUtils.validateExcel(courseHeadingRow, courseAllocationHeader)) {
      var departmentRow = classesSheet.row(classInstructions.length)[1];
      String department = departmentRow != null && departmentRow.value != null
          ? departmentRow.value.toString()
          : '';
      var rowStart = classInstructions.length + 3;
      if (department.isNotEmpty) {
        for (int i = rowStart; i < classesSheet.maxRows; i++) {
          var row = classesSheet.row(i);
          if (validateClassRow(row)) {
            classes.add(ClassModel(
              id: '${row[1]!.value.toString()}$department'
                  .toLowerCase()
                  .hashCode
                  .toString(),
              level: row[0]!.value.toString(),
              name: row[1]!.value.toString(),
              size: row[2] != null && row[2]!.value != null
                  ? row[2]!.value.toString()
                  : '0',
              department: department,
              studyMode: 'Regular',
              semester: semester,
              year: year,
              hasDisability: row[3] != null && row[3]!.value != null
                  ? row[3]!.value.toString()
                  : 'No',
              createdAt: DateTime.now().toString(),
            ));
          }
        }

        rowStart = courseInstructions.length + 3;
        for (int i = rowStart; i < allocationsSheet.maxRows; i++) {
          var row = allocationsSheet.row(i);
          if (validateRow(row)) {
            var courseId =
                row[0]!.value.toString().toLowerCase().replaceAll(' ', '');
            var lecturerId = row[5]!
                .value
                .toString()
                .trim()
                .replaceAll(' ', '')
                .toLowerCase();
            var lecturerName = row[6]!.value.toString();
            //? Lecturers extraction.....................................................
            LecturerModel lecturer = LecturerModel(
              courses: [courseId],
              classes: [],
              id: lecturerId,
              lecturerName: lecturerName,
              department: department,
              semester: semester,
              year: year,
              lecturerEmail: row[7] != null && row[7]!.value != null
                  ? row[7]!.value.toString()
                  : '',
            );
            var level = row[2]!.value.toString().trim().replaceAll(' ', '');
            var lecturerClass = row[8] != null && row[8]!.value != null
                ? row[8]!.value.toString()
                : '';
            if (lecturerClass.isNotEmpty) {
              var lecturerClasses = lecturerClass.split(',');
              for (var aClass in lecturerClasses) {
                var theClass = classes
                    .where((element) =>
                        element.name!.trim().toLowerCase() ==
                        aClass.trim().toLowerCase())
                    .firstOrNull;
                if (theClass != null) {
                  lecturer.classes.add(theClass.toMap());
                }
              }
            } else {
              // add all classes with same level to lecturer
              lecturer.classes = classes
                  .where((element) =>
                      element.level.trim().replaceAll(' ', '') == level)
                  .map((e) => e.toMap())
                  .toList();
            }

            if (!lecturers.any((element) => element.id == lecturerId)) {
              lecturers.add(lecturer);
            } else {
              var existenLecturer =
                  lecturers.firstWhere((element) => element.id == lecturerId);
              existenLecturer.classes.addAll(lecturer.classes.where(
                  (element) => !existenLecturer.classes.contains(element)));
              existenLecturer.courses.addAll(lecturer.courses.where(
                  (element) => !existenLecturer.courses.contains(element)));
              lecturers.removeWhere((element) => element.id == lecturerId);
              lecturers.add(existenLecturer);
            }
            //? Courses extraction.....................................................
            var exist = courses.any((element) => element.id == courseId);
            if (exist) {
              //append lecturer name and id to the course if not already added
              var course =
                  courses.firstWhere((element) => element.id == courseId);
              if (!course.lecturer
                  .any((element) => element['id'] == lecturerId)) {
                course.lecturer.add(lecturer.toMap());
                courses.removeWhere((element) => element.id == courseId);
                courses.add(course);
              }
            } else {
              courses.add(CourseModel(
                  id: courseId,
                  code: row[0]!.value.toString(),
                  title: row[1]!.value.toString(),
                  level: row[2]!.value.toString(),
                  creditHours: row[3] != null && row[3]!.value != null
                      ? row[3]!.value.toString()
                      : '3',
                  specialVenue: row[4] != null && row[4]!.value != null
                      ? row[4]!.value.toString()
                      : '',
                  lecturer: [lecturer.toMap()],
                  department: department,
                  studyMode: 'Regular',
                  semester: semester,
                  year: year));
            }
            //! End of courses extraction.....................................................
          }
        }
        return (classes, courses, lecturers, null);
      } else {
        return ([], [], [], 'No department found for Regular Students');
      }
    } else {
      return ([], [], [], '');
    }
  }

  (List<ClassModel>, List<CourseModel>, List<LecturerModel>, String? message)
      getEveningData(Excel excel, String semester, String year) {
    List<CourseModel> courses = [];
    List<ClassModel> classes = [];
    List<LecturerModel> lecturers = [];
    var classesSheet = excel.tables['Evening-Classes'];
    if (classesSheet == null) {
      return ([], [], [], 'No classes found for Evening Students');
    }
    var classHeadingRow = classesSheet.row(classInstructions.length + 2);
    if (!AppUtils.validateExcel(classHeadingRow, classHeader)) {
      return ([], [], [], 'Invalid Evening Sheet');
    }

    var departmentRow = classesSheet.row(classInstructions.length)[1];
    String department = departmentRow != null && departmentRow.value != null
        ? departmentRow.value.toString()
        : '';
    var rowStart = classInstructions.length + 3;
    if (department.isNotEmpty) {
      for (int i = rowStart; i < classesSheet.maxRows; i++) {
        var row = classesSheet.row(i);
        if (validateClassRow(row)) {
          classes.add(ClassModel(
            id: '${row[1]!.value.toString()}$department'.hashCode.toString(),
            level: row[0]!.value.toString(),
            name: row[1]!.value.toString(),
            size: row[2] != null && row[2]!.value != null
                ? row[2]!.value.toString()
                : '0',
            department: department,
            studyMode: 'Evening',
            semester: semester,
            year: year,
            hasDisability: row[3] != null && row[3]!.value != null
                ? row[3]!.value.toString()
                : 'No',
            createdAt: DateTime.now().toString(),
          ));
        }
      }

      // get allocations sheet===========================================================
      var allocationsSheet = excel.tables['Evening-Allocations'];
      if (allocationsSheet == null) {
        return ([], [], [], 'No Evening Allocations Sheet');
      }
      var courseHeadingRow =
          allocationsSheet.row(courseInstructions.length + 2);
      if (!AppUtils.validateExcel(courseHeadingRow, courseAllocationHeader)) {
        return ([], [], [], 'Invalid Evening Allocations Sheet');
      }
      rowStart = courseInstructions.length + 3;
      for (int i = rowStart; i < allocationsSheet.maxRows; i++) {
        var row = allocationsSheet.row(i);
        if (validateRow(row)) {
          var courseId = 'E${row[0]!.value.toString().toLowerCase()}';
          var lecturerId =
              row[5]!.value.toString().trim().replaceAll(' ', '').toLowerCase();
          var lecturerName = row[6]!.value.toString();
          //? Lecturers extraction.....................................................
          LecturerModel lecturer = LecturerModel(
            courses: [courseId],
            classes: [],
            id: lecturerId,
            lecturerName: lecturerName,
            department: department,
            semester: semester,
            year: year,
            lecturerEmail: row[7] != null && row[7]!.value != null
                ? row[7]!.value.toString()
                : '',
          );

          var level = row[2]!.value.toString().trim().replaceAll(' ', '');
          var lecturerClass = row[8] != null && row[8]!.value != null
              ? row[8]!.value.toString()
              : '';
          if (lecturerClass.isNotEmpty) {
            var lecturerClasses = lecturerClass.split(',');
            for (var aClass in lecturerClasses) {
              var theClass = classes
                  .where((element) =>
                      element.name!.trim().toLowerCase() ==
                      aClass.trim().toLowerCase())
                  .firstOrNull;
              if (theClass != null) {
                lecturer.classes.add(theClass.toMap());
              }
            }
          } else {
            // add all classes with same level to lecturer
            lecturer.classes = classes
                .where((element) =>
                    element.level.trim().replaceAll(' ', '') == level)
                .map((e) => e.toMap())
                .toList();
          }

          if (!lecturers.any((element) => element.id == lecturerId)) {
            lecturers.add(lecturer);
          } else {
            var existenLecturer =
                lecturers.firstWhere((element) => element.id == lecturerId);
            existenLecturer.classes.addAll(lecturer.classes.where(
                (element) => !existenLecturer.classes.contains(element)));
            existenLecturer.courses.addAll(lecturer.courses.where(
                (element) => !existenLecturer.courses.contains(element)));
            lecturers.removeWhere((element) => element.id == lecturerId);
            lecturers.add(existenLecturer);
          }
          //? Courses extraction.....................................................

          var exist = courses.any((element) => element.id == courseId);
          if (exist) {
            //append lecturer name and id to the course if not already added
            var course =
                courses.firstWhere((element) => element.id == courseId);
            if (!course.lecturer
                .any((element) => element['id'] == lecturerId)) {
              course.lecturer.add(lecturer.toMap());
              courses.removeWhere((element) => element.id == courseId);
              courses.add(course);
            }
          } else {
            courses.add(CourseModel(
                id: courseId,
                code: 'E${row[0]!.value.toString()}',
                title: row[1]!.value.toString(),
                level: row[2]!.value.toString(),
                creditHours: row[3] != null && row[3]!.value != null
                    ? row[3]!.value.toString()
                    : '3',
                specialVenue: row[4] != null && row[4]!.value != null
                    ? row[4]!.value.toString()
                    : '',
                lecturer: [lecturer.toMap()],
                department: department,
                studyMode: 'Evening',
                semester: semester,
                year: year));
          }
          //! End of courses extraction.....................................................
        }
      }
      return (classes, courses, lecturers, null);
    } else {
      return ([], [], [], 'No department found for Evening Students');
    }
  }

  @override
  Future<(bool, List<ClassModel>, List<CourseModel>, List<LecturerModel>)>
      deletateAllocation(String academicYear, String academicSemester,
          String department,Db db) async {
    try { 
      if (db.state != State.open) {
        await db.open();
      }
      if (department == 'All') {
        //delete all classes, courses and lecturers
        await db
            .collection('courses')
            .remove({'semester': academicSemester, 'year': academicYear});
        await db
            .collection('classes')
            .remove({'semester': academicSemester, 'year': academicYear});
        await db
            .collection('lecturers')
            .remove({'semester': academicSemester, 'year': academicYear});
        return Future.value((true, [], [], []) as FutureOr<
            (bool, List<ClassModel>, List<CourseModel>, List<LecturerModel>)>?);
      } else {
        //delete all classes, courses and lecturers for the department
        await db.collection('courses').remove({
          'department': department,
          'semester': academicSemester,
          'year': academicYear
        });
        await db.collection('classes').remove({
          'department': department,
          'semester': academicSemester,
          'year': academicYear
        });
        await db.collection('lecturers').remove({
          'department': department,
          'semester': academicSemester,
          'year': academicYear
        });
        //get remaing classes, courses and lecturers with academic year and semester
        var remainingCourses = await db.collection('courses').find(
            {'semester': academicSemester, 'year': academicYear}).toList();
        var remainingClasses = await db.collection('classes').find(
            {'semester': academicSemester, 'year': academicYear}).toList();
        var remainingLecturers = await db.collection('lecturers').find(
            {'semester': academicSemester, 'year': academicYear}).toList();
        return Future.value((
          true,
          remainingClasses.map((e) => ClassModel.fromMap(e)).toList(),
          remainingCourses.map((e) => CourseModel.fromMap(e)).toList(),
          remainingLecturers.map((e) => LecturerModel.fromMap(e)).toList()
        ));
      }
    } catch (e) {
      List<ClassModel> remainingClasses = [];
      List<CourseModel> remainingCourses = [];
      List<LecturerModel> remainingLecturers = [];
      return Future.value(
          (false, remainingClasses, remainingCourses, remainingLecturers));
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
