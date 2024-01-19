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
      List<Data?>? classHeaderRow = classesSheet.row(classInstructions.length+2);
      if (AppUtils.validateExcel(classHeaderRow, classHeader)) {
        
        department =
            classesSheet.row(classInstructions.length + 2)[1]!.value.toString();
        for (int i = rowStart; i <= classesSheet.maxRows; i++) {
          var row = classesSheet.row(i);
          if (row[1]!.value != null &&
              row[0]!.value != null &&
              row[2]!.value != null &&
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
              hasDisability:
                  row[4]!.value != null ? row[4]!.value.toString() : 'No',
              createdAt: DateTime.now().toString(),
            ));
          }
        }
      } else {
        print('invalid classes sheet');
      }
      // get allocations sheet
      var allocationsSheet = excel.tables['Allocations']!;
      List<Data?>? allocationsHeaderRow =
          allocationsSheet.row(courseInstructions.length+2);
      if (AppUtils.validateExcel(
          allocationsHeaderRow, courseAllocationHeader)) {
        department = department.isNotEmpty
            ? department
            : allocationsSheet
                .row(courseInstructions.length + 2)[1]!
                .value
                .toString();
        var rowStart = courseInstructions.length + 4;
        for (int i = rowStart; i <= allocationsSheet.maxRows; i++) {
          var row = allocationsSheet.row(i);
          var lecturer = row[3]!.value.toString();
          if (lecturer.contains(';')) {
            var lecturers = lecturer.split(';');
          }
          if (row[0]!.value != null &&
              row[1]!.value != null &&
              row[2]!.value != null) {
            courses.add(CourseModel(
                id: AppUtils.getId(),
                code: row[0]!.value.toString(),
                title: row[1]!.value.toString(),
                level: row[2]!.value.toString(),
                lecturerName: row[3]!.value.toString(),
                creditHours: row[4]!.value.toString(),
                specialVenue:
                    row[5]!.value != null ? row[5]!.value.toString() : '',
                department: department,
                academicSemester: semester,
                academicYear: academicYear,
                targetStudents: targetStudents));
          }
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
}
