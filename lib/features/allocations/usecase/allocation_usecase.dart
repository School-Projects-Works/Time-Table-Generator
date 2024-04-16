import 'dart:async';
import 'dart:io';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/repo/allocation_repo.dart';
import 'package:aamusted_timetable_generator/features/allocations/usecase/block_funtions.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../core/data/constants/constant_data.dart';
import '../../../core/data/constants/excel_headings.dart';
import '../../../core/data/constants/instructions.dart';
import '../../../core/functions/excel_settings.dart';

class AllocationUseCase extends AllocationRepo {
  @override
  Future<(bool, String?)> downloadTemplate() async {
    try {
      CustomDialog.showLoading(message: 'Downloading template...');
      var workbook = ExcelSettings.generateAllocationTem();

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'AllocationTemplate.xlsx',
      );
      CustomDialog.dismiss();
      CustomDialog.showText(
        text: 'Saving template... Please wait',
      );
      //delay to show the saving text
      await Future.delayed(const Duration(seconds: 1));

      if (outputFile == null) {
        CustomDialog.dismiss();
        return Future.value((false, 'Unable to download template'));
      } else {
        var file = File(outputFile);
        await file.writeAsBytes(workbook.saveAsStream());
        CustomDialog.dismiss();
        if (file.existsSync()) {
          return Future.value((true, file.path));
        } else {
          return Future.value((false, 'Error downloading template'));
        }
      }
    } catch (e) {
      CustomDialog.dismiss();
      return Future.value(
          (false, 'Error downloading template, Check file is already Opened'));
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

      ///check if the excel file contains the required sheets
      ///Regular-Classes, Regular-Allocations, Evening-Classes, Evening-Allocations
      ///if any of the sheets is missing return an error message
      ///else continue with the extraction of data
      var regClassesSheet =
          excel.tables['Regular-Classes'] ?? excel.tables['Sheet1'];
      var regAllocationsSheet = excel.tables['Regular-Allocation'];
      if (regClassesSheet == null || regAllocationsSheet == null) {
        return Future.value((
          false,
          (courses, classes, lecturers),
          'No Regular Classes or Allocation Sheet'
        ));
      }
      var evenClassesSheet = excel.tables['Evening-Classes'];
      var eveAllocationsSheet = excel.tables['Evening-Allocation'];
      if (evenClassesSheet == null || eveAllocationsSheet == null) {
        return Future.value((
          false,
          (courses, classes, lecturers),
          'No Evening Classes or Allocation Sheet'
        ));
      }

      //validate both reg and evening headings
      /// here i extract the headings from the excel various sheet and validate to see if they are correct
      /// if they are not correct i return an error message
      /// else i continue with the extraction of data
      var regClassHeadingRow =
          regClassesSheet.row(classInstructions.length + 3);

      var evenClassHeadingRow =
          evenClassesSheet.row(classInstructions.length + 1);
      var regAllocationsHeadingRow =
          regAllocationsSheet.row(courseInstructions.length + 1);
      var evenAllocationsHeadingRow =
          eveAllocationsSheet.row(courseInstructions.length + 1);

      var regClassIsValid =
          AppUtils.validateExcel(regClassHeadingRow, classHeader);
      var evenClassIsValid =
          AppUtils.validateExcel(evenClassHeadingRow, classHeader);
      var regAlloIsValid = AppUtils.validateExcel(
          regAllocationsHeadingRow, courseAllocationHeader);
      var evenAlloIsValid = AppUtils.validateExcel(
          evenAllocationsHeadingRow, courseAllocationHeader);
      if (!regClassIsValid ||
          !evenClassIsValid ||
          !regAlloIsValid ||
          !evenAlloIsValid) {
        return Future.value(
            (false, (courses, classes, lecturers), 'Invalid Excel Sheet'));
      }

      ///Extract departments from Regular-Classes sheet
      var department = ClassBooks.getDepartmentsFromExcelSheet(
          classesSheet: regClassesSheet);
      if (department == null || department.isEmpty) {
        return Future.value(
            (false, (courses, classes, lecturers), 'No Department Found'));
      }

      ///extract data from Regular-Classes sheet
      var regClasses = ClassBooks.getClassesFromExcelSheet(
          classesSheet: regClassesSheet,
          department: department,
          semester: semester,
          year: year,
          studyMode: 'Regular');
      var evenClasses = ClassBooks.getClassesFromExcelSheet(
          classesSheet: evenClassesSheet,
          department: department,
          semester: semester,
          year: year,
          studyMode: 'Evening');
      classes = [...regClasses, ...evenClasses];

      var (regCourses, regLecturers) =
          AllocationBlocks.getCoursesAndLecturesFromExcelSheet(
              allocationsSheet: regAllocationsSheet,
              department: department,
              semester: semester,
              year: year,
              classes: regClasses,
              studyMode: 'Regular');
      var (evenCourses, evenLecturers) =
          AllocationBlocks.getCoursesAndLecturesFromExcelSheet(
              allocationsSheet: eveAllocationsSheet,
              department: department,
              semester: semester,
              year: year,
              classes: evenClasses,
              studyMode: 'Evening');

      //combine regular and evening courses and remove duplicates
      courses = [...regCourses, ...evenCourses];

      ///loop through the lecturers and add the courses to the lecturer
      ///if lecturer already exist i update the lecturer courses with new course
      ///and classes if not exist already
      ///
      ///Time to loop throgh regulart data
      for (var lecturer in regLecturers) {
        List<CourseModel> lectCourses = [];
        for (var course in courses) {
          var lects =
              course.lecturer.map((e) => LecturerModel.fromMap(e)).toList();
          if (lects.any((element) => element.id == lecturer.id)) {
            if (!lectCourses.any((element) => element.id == course.id)) {
              lectCourses.add(course);
            }
          }
        }
        lecturer.courses = lectCourses.map((e) => e.toMap()).toList();
        var theExistenLecturer =
            lecturers.where((element) => element.id == lecturer.id).firstOrNull;
        if (theExistenLecturer != null) {
          // append classes if not already exist and append courses as well
          var existCourses = lecturer.courses;
          var existClasses = lecturer.classes;
          for (var element in existCourses) {
            if (!theExistenLecturer.courses
                .any((c) => c['id'] == element['id'])) {
              theExistenLecturer.courses.add(element);
            }
          }
          for (var element in existClasses) {
            if (!theExistenLecturer.classes.any((c) => c == element)) {
              theExistenLecturer.classes.add(element);
            }
          }
          lecturers
              .removeWhere((element) => element.id == theExistenLecturer.id);
          lecturers.add(theExistenLecturer);
        } else {
          lecturers.add(lecturer);
        }
      }

      ///Time to loop through evening data
      for (var lecturer in evenLecturers) {
        List<CourseModel> lectCourses = [];
        for (var course in courses) {
          var lects =
              course.lecturer.map((e) => LecturerModel.fromMap(e)).toList();
          if (lects.any((element) => element.id == lecturer.id)) {
            lectCourses.add(course);
          }
        }

        lecturer.courses = lectCourses.map((e) => e.toMap()).toList();

        var theExistenLecturer =
            lecturers.where((element) => element.id == lecturer.id).firstOrNull;
        if (theExistenLecturer != null) {
         
          // append classes if not already exist and append courses as well
          var existCourses = lecturer.courses;
          var existClasses = lecturer.classes;
          for (var element in existCourses) {
            if (!theExistenLecturer.courses
                .any((c) => c['id'] == element['id'])) {
              theExistenLecturer.courses.add(element);
            }
          }
          for (var element in existClasses) {
            if (!theExistenLecturer.classes.any((c) => c == element)) {
              theExistenLecturer.classes.add(element);
            }
          }
          lecturers
              .removeWhere((element) => element.id == theExistenLecturer.id);
          lecturers.add(theExistenLecturer);
        } else {
          lecturers.add(lecturer);
        }
      }

      return Future.value((
        true,
        (courses, classes, lecturers),
        'Allocation Imported Successfully'
      ));
    } catch (e) {
      List<CourseModel> courses = [];
      List<ClassModel> classes = [];
      List<LecturerModel> lecturers = [];
      return Future.value((false, (courses, classes, lecturers), e.toString()));
    }
  }

  @override
  Future<(bool, List<ClassModel>, List<CourseModel>, List<LecturerModel>)>
      deletateAllocation(String academicYear, String academicSemester,
          String department, Db db) async {
    try {
      List<ClassModel> remainingClases = [];
      List<CourseModel> remainingCourses = [];
      List<LecturerModel> remainingLecturer = [];
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
        return Future.value(
            (true, remainingClases, remainingCourses, remainingLecturer));
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
