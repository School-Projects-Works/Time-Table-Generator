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
      var (regClass, regCourses, regLecturers) =
          getRegularData(excel, semester, year);
      if (regClass.isEmpty && regCourses.isEmpty && regLecturers.isEmpty) {
        return Future.value(
            (false, (courses, classes, lecturers), 'Invalid file selected'));
      }
      var (eveClass, eveCourses, eveLecturers) =
          getEveningData(excel, semester, year);
      if (eveClass.isEmpty && eveCourses.isEmpty && eveLecturers.isEmpty) {
        return Future.value(
            (false, (courses, classes, lecturers), 'Invalid file selected'));
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
          existenLecturer.classes!.addAll(lecturer.classes!
              .where((element) => !existenLecturer.classes!.contains(element)));
          existenLecturer.courses!.addAll(lecturer.courses!
              .where((element) => !existenLecturer.courses!.contains(element)));
          lecturers.removeWhere((element) => element.id == lecturer.id);
          lecturers.add(existenLecturer);
        } else {
          lecturers.add(lecturer);
        }
      }

      return Future.value((true, (courses, classes, lecturers), null));
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

  (List<ClassModel>, List<CourseModel>, List<LecturerModel>) getRegularData(
      Excel excel, String semester, String year) {
    List<CourseModel> courses = [];
    List<ClassModel> classes = [];
    List<LecturerModel> lecturers = [];
    var classesSheet = excel.tables['Regular-Classes'];
    if (classesSheet == null) {
      return ([], [], []);
    }
    var allocationsSheet = excel.tables['Regular-Allocations'];
    if (allocationsSheet == null) {
      return ([], [], []);
    }
    var classHeadingRow = classesSheet.row(classInstructions.length + 2);
    var courseHeadingRow = allocationsSheet.row(courseInstructions.length + 2);
    if (AppUtils.validateExcel(classHeadingRow, classHeader) &&
        AppUtils.validateExcel(courseHeadingRow, courseAllocationHeader)) {
      var departmentRow = classesSheet.row(classInstructions.length + 1)[1];
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
      }

      rowStart = courseInstructions.length + 3;
      for (int i = rowStart; i < allocationsSheet.maxRows; i++) {
        var row = allocationsSheet.row(i);
        if (validateRow(row)) {
          //? Courses extraction.....................................................
          var courseId = row[0]!.value.toString().toLowerCase();
          var exist = courses.any((element) => element.id == courseId);
          var lecturerId =
              row[5]!.value.toString().trim().replaceAll(' ', '').toLowerCase();
          var lecturerName = row[6]!.value.toString();
          if (exist) {
            //append lecturer name and id to the course if not already added

            var course =
                courses.firstWhere((element) => element.id == courseId);
            if (!course.lecturerId!.contains(lecturerId)) {
              course.lecturerId!.add(lecturerId);
              course.lecturerName!.add(lecturerName);
              // replace the course in the courses list
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
                lecturerId: [lecturerId],
                lecturerName: [lecturerName],
                department: department,
                studyMode: 'Regular',
                semester: semester,
                year: year));
          }
          //! End of courses extraction.....................................................
          //? Lecturers extraction.....................................................
          LecturerModel lecturer = LecturerModel()
            ..classes = []
            ..courses = [courseId]
            ..id = lecturerId
            ..lecturerName = lecturerName
            ..department = department
            ..semester = semester
            ..year = year
            ..lecturerEmail = row[7] != null && row[7]!.value != null
                ? row[7]!.value.toString()
                : '';
          var level = row[2]!.value.toString().trim().replaceAll(' ', '');
          var lecturerClass = row[8] != null && row[8]!.value != null
              ? row[8]!.value.toString()
              : '';
          if (lecturerClass.isNotEmpty) {
            var lecturerClasses = lecturerClass.split(',');
            for (var aClass in lecturerClasses) {
              if (classes.any((element) =>
                  element.name!.trim().toLowerCase() ==
                  aClass.trim().toLowerCase())) {
                lecturer.classes!.add(aClass);
              }
            }
          } else {
            // add all classes with same level to lecturer
            lecturer.classes = classes
                .where((element) =>
                    element.level!.trim().replaceAll(' ', '') == level)
                .map((e) => e.name!)
                .toList();
          }

          if (!lecturers.any((element) => element.id == lecturerId)) {
            lecturers.add(lecturer);
          } else {
            var existenLecturer =
                lecturers.firstWhere((element) => element.id == lecturerId);
            existenLecturer.classes!.addAll(lecturer.classes!.where(
                (element) => !existenLecturer.classes!.contains(element)));
            existenLecturer.courses!.addAll(lecturer.courses!.where(
                (element) => !existenLecturer.courses!.contains(element)));
            lecturers.removeWhere((element) => element.id == lecturerId);
            lecturers.add(existenLecturer);
          }
        }
      }
      return (classes, courses, lecturers);
    } else {
      return ([], [], []);
    }
  }

  (List<ClassModel>, List<CourseModel>, List<LecturerModel>) getEveningData(
      Excel excel, String semester, String year) {
    List<CourseModel> courses = [];
    List<ClassModel> classes = [];
    List<LecturerModel> lecturers = [];
    var classesSheet = excel.tables['Evening-Classes'];
    if (classesSheet == null) {
      return ([], [], []);
    }
    var classHeadingRow = classesSheet.row(classInstructions.length + 2);
    if (!AppUtils.validateExcel(classHeadingRow, classHeader)) {
      return ([], [], []);
    }

    var departmentRow = classesSheet.row(classInstructions.length + 1)[1];
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
    }
    // get allocations sheet===========================================================
    var allocationsSheet = excel.tables['Evening-Allocations'];
    if (allocationsSheet == null) {
      return ([], [], []);
    }
    var courseHeadingRow = allocationsSheet.row(courseInstructions.length + 2);
    if (!AppUtils.validateExcel(courseHeadingRow, courseAllocationHeader)) {
      return ([], [], []);
    }
    rowStart = courseInstructions.length + 3;
    for (int i = rowStart; i < allocationsSheet.maxRows; i++) {
      var row = allocationsSheet.row(i);
      if (validateRow(row)) {
        //? Courses extraction.....................................................
        var courseId = 'E${row[0]!.value.toString().toLowerCase()}';
        var exist = courses.any((element) => element.id == courseId);

        var lecturerId =
            row[5]!.value.toString().trim().replaceAll(' ', '').toLowerCase();
        var lecturerName = row[6]!.value.toString();
        if (exist) {
          //append lecturer name and id to the course if not already added
          var course = courses.firstWhere((element) => element.id == courseId);
          if (!course.lecturerId!.contains(lecturerId)) {
            course.lecturerId!.add(lecturerId);
            course.lecturerName!.add(
              lecturerName,
            );
            // replace the course in the courses list
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
              lecturerId: [lecturerId],
              lecturerName: [lecturerName],
              department: department,
              studyMode: 'Evening',
              semester: semester,
              year: year));
        }
        //! End of courses extraction.....................................................
        //? Lecturers extraction.....................................................
        LecturerModel lecturer = LecturerModel()
          ..classes = []
          ..courses = [courseId]
          ..id = lecturerId
          ..lecturerName = lecturerName
          ..department = department
          ..semester = semester
          ..year = year
          ..lecturerEmail = row[7] != null && row[7]!.value != null
              ? row[7]!.value.toString()
              : '';
        var level = row[2]!.value.toString().trim().replaceAll(' ', '');
        var lecturerClass = row[8] != null && row[8]!.value != null
            ? row[8]!.value.toString()
            : '';
        if (lecturerClass.isNotEmpty) {
          var lecturerClasses = lecturerClass.split(',');
          for (var aClass in lecturerClasses) {
            if (classes.any((element) =>
                element.name!.trim().toLowerCase() ==
                aClass.trim().toLowerCase())) {
              lecturer.classes!.add(aClass);
            }
          }
        } else {
          // add all classes with same level to lecturer
          lecturer.classes = classes
              .where((element) =>
                  element.level!.trim().replaceAll(' ', '') == level)
              .map((e) => e.name!)
              .toList();
        }

        if (!lecturers.any((element) => element.id == lecturerId)) {
          lecturers.add(lecturer);
        } else {
          var existenLecturer =
              lecturers.firstWhere((element) => element.id == lecturerId);
          existenLecturer.classes!.addAll(lecturer.classes!
              .where((element) => !existenLecturer.classes!.contains(element)));
          existenLecturer.courses!.addAll(lecturer.courses!
              .where((element) => !existenLecturer.courses!.contains(element)));
          lecturers.removeWhere((element) => element.id == lecturerId);
          lecturers.add(existenLecturer);
        }
      }
    }
    return (classes, courses, lecturers);
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
