import 'package:aamusted_timetable_generator/core/data/constants/constant_data.dart';
import 'package:aamusted_timetable_generator/core/data/constants/instructions.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:excel/excel.dart';

class AllocationBlocks {
  /// Retrieves the courses and lecturers from an Excel sheet based on the provided parameters.
  ///
  /// The function takes in the starting row, the allocations sheet, department, semester, year, and a list of classes.
  /// It iterates through the rows of the allocations sheet, validates each row, and extracts the necessary information.
  /// The extracted information is used to create [CourseModel] and [LecturerModel] objects, which are then added to the respective lists.
  /// The function returns a tuple containing the list of courses and the list of lecturers.
  static (List<CourseModel>, List<LecturerModel>)
      getCoursesAndLecturesFromExcelSheet(
          {required Sheet allocationsSheet,
          required String department,
          required String semester,
          required String year,
          required String studyMode,
          required ConfigModel config,
          required List<ClassModel> classes}) {
    List<LecturerModel> lecturers = extractLecturerList(
        allocationsSheet: allocationsSheet,
        year: year,
        semester: semester,
        classes: classes,
              confg: config,
        department: department);
    List<CourseModel> courses = extractCourseList(
        allocationsSheet: allocationsSheet,
        year: year,
        semester: semester,
        department: department,
        studyMode: studyMode,
  
        lecturers: lecturers);
    return (courses, lecturers);
  }

  //Extract only the Lecturers from the Excel sheet
  ///This function will get the list of [LectureModel] from the Excel sheet
  ///It will iterate through the rows of the allocations sheet, validates each row, and extracts the necessary information.
  ///The extracted information is used to create [LecturerModel] objects, which are then added to the list of lecturers.
  ///The function returns a list of lecturers.
  static List<LecturerModel> extractLecturerList(
      {required Sheet allocationsSheet,
      required String year,
      required String semester,
      required List<ClassModel> classes,
      required ConfigModel confg,
      required String department}) {
    var rowStart = courseInstructions.length + 2;
    List<LecturerModel> lecturers = [];
    var days = confg.days;
    
    for (var i = rowStart; i < allocationsSheet.maxRows; i++) {
      var row = allocationsSheet.row(i);
      if (validateAllocationRow(row)) {
        var lecturerId =
            row[5]!.value.toString().trim().replaceAll(' ', '').toLowerCase();
        var lecturerName = row[6]!.value.toString();
        var lecturerFreeDay = row[7]!.value.toString();
        var level = row[2]!.value.toString().trim().replaceAll(' ', '');
        var lecturerClass = row[8] != null && row[8]!.value != null
            ? row[8]!.value.toString()
            : '';
            var dayInit = lecturerFreeDay.length > 3
            ? lecturerFreeDay.toLowerCase().substring(0, 3)
            : lecturerFreeDay.toLowerCase();
        var day = days
            .firstWhere((element) => element.toLowerCase().startsWith(dayInit));
        var lecturer = LecturerModel(
            id: lecturerId,
            courses: [],
            classes: [],
            lecturerName: lecturerName,
            department: department,
            year: year,
            semester: semester,
            freeDay: day);

        /// check if lecturer class is not empty split the classes with comma
        /// after the spliting check if the class is in the list of classes using the class name
        /// then add the class  id to the clecturer to the lecturer
        
        List<String> lecturerClassesList = [];
        if (lecturerClass.isNotEmpty) {
          var lecturerClasses = lecturerClass.split(RegExp(r'[,.]'));
          for (var aClass in lecturerClasses) {
            var theClass = classes
                .where((element) =>
                    element.name!.trim().toLowerCase().replaceAll(' ', '') ==
                    aClass.trim().toLowerCase().replaceAll(' ', ''))
                .firstOrNull;
            if (theClass != null) {
              lecturerClassesList.add(theClass.id!);
            }
          }
        } else {
          /// add all classes with same level and department to lecturer
          lecturerClassesList = classes
              .where((element) =>
                  element.level == level && element.department == department)
              .map((e) => e.id!)
              .toList();
        }
        lecturer.classes = lecturerClassesList;
        lecturers.add(lecturer);
      }
    }
    
    return lecturers;
  }

  /// Extracts the list of courses from the Excel sheet.
  /// This function takes the allocations sheet, year, semester, department, and a list of lecturers as parameters.
  /// It iterates through the rows of the allocations sheet, validates each row, and extracts the necessary information.
  /// The extracted information is used to create [CourseModel] objects, which are then added to the list of courses.
  /// The function returns a list of courses.
  static List<CourseModel> extractCourseList(
      {required Sheet allocationsSheet,
      required String year,
      required String semester,
      required String studyMode,
      required String department,
      required List<LecturerModel> lecturers}) {
    var rowStart = courseInstructions.length + 2;
    List<CourseModel> courses = [];
    for (var i = rowStart; i < allocationsSheet.maxRows; i++) {
      var row = allocationsSheet.row(i);
      if (validateAllocationRow(row)) {
        var courseId = studyMode == 'Regular'
            ? row[0]!.value.toString().toLowerCase().replaceAll(' ', '')
            : 'e-${row[0]!.value.toString()}'.toLowerCase().replaceAll(' ', '');
        var courseCode = row[0]!.value.toString();
        var courseTitle = row[1]!.value.toString();
        var courseLevel = row[2]!.value.toString();
        var courseCreditHours = row[3] != null && row[3]!.value != null
            ? row[3]!.value.toString()
            : '3';
        var courseSpecialVenue = row[4] != null && row[4]!.value != null
            ? row[4]!.value.toString()
            : '';
        var courseLecturerId =
            row[5]!.value.toString().trim().replaceAll(' ', '').toLowerCase();

        var courseLecturer = lecturers
            .where((element) => element.id == courseLecturerId)
            .firstOrNull;
        if (courseLecturer != null) {
          var course = CourseModel(
            id: courseId,
            code: courseCode,
            title: courseTitle,
            level: courseLevel,
            creditHours: courseCreditHours,
            specialVenue: courseSpecialVenue,
            lecturer: [courseLecturer.toMap()],
            department: department,
            studyMode: studyMode,
            semester: semester,
            year: year,
          );

          // Check if the course already exists in the list of courses
          // If it exists and the lectuere not already added, append the lecturer name and id to the course if not already added
          // eles, add the course to the list of courses
          var exist = courses.any((element) => element.id == courseId);
          if (exist) {
            // append lecturer name and id to the course if not already added
            var course =
                courses.firstWhere((element) => element.id == courseId);
            if (!course.lecturer
                .any((element) => element['id'] == courseLecturerId)) {
              course.lecturer.add(courseLecturer.toMap());
              courses.removeWhere((element) => element.id == courseId);
              courses.add(course);
            }
          } else {
            courses.add(course);
          }
        }
      }
    }
    return courses;
  }

  /// Validates a row of data.
  ///
  /// This function takes a list of [Data] objects representing a row of data and
  /// checks if all the required fields are not null. It returns true if all the
  /// required fields are not null, otherwise it returns false.
  static bool validateAllocationRow(List<Data?> row) {
    var ccode = row[0]?.value;
    var ctitle = row[1]?.value;
    var clevel = row[2]?.value;
    var lecID = row[5]?.value;
    var lecName = row[6]?.value;
    var lecFreeDay = row[7]?.value;
    return ccode != null &&
        ctitle != null &&
        clevel != null &&
        lecID != null &&
        lecName != null &&
        lecFreeDay != null;
  }
}

class ClassBooks {
  /// Retrieves a list of [ClassModel] objects from an Excel sheet.
  ///
  /// The [rowStart] parameter specifies the starting row index to read from the [classesSheet].
  /// The [classesSheet] parameter represents the Excel sheet containing the class data.
  /// The [department] parameter specifies the department of the classes.
  /// The [semester] parameter specifies the semester of the classes.
  /// The [year] parameter specifies the year of the classes.
  ///
  /// Returns a list of [ClassModel] objects extracted from the Excel sheet.
  static List<ClassModel> getClassesFromExcelSheet(
      {required Sheet classesSheet,
      required String department,
      required String semester,
      required String year,
      required String studyMode}) {
    List<ClassModel> classes = [];
    var rowStart = studyMode == 'Regular'
        ? classInstructions.length + 4
        : classInstructions.length + 2;
    for (int i = rowStart; i < classesSheet.maxRows; i++) {
      var row = classesSheet.row(i);
      var id = '${row[1]!.value.toString()}$department'
          .toLowerCase()
          .hashCode
          .toString();
      var level = row[0]!.value.toString();
      var name = row[1]!.value.toString();
      var size = row[2] != null && row[2]!.value != null
          ? row[2]!.value.toString()
          : '20';
      var hasDisability = row[3] != null && row[3]!.value != null
          ? row[3]!.value.toString()
          : 'No';
      if (validateClassRow(row)) {
        var classItem = ClassModel(
          id: id,
          level: level,
          name: name,
          size: size,
          hasDisability: hasDisability,
          department: department,
          studyMode: studyMode,
          semester: semester,
          year: year,
        );
        classes.add(classItem);
      }
    }
    return classes;
  }

  /// Validates a class row by checking if the level and class code are not null.
  ///
  /// Returns `true` if both the level and class code are not null, otherwise returns `false`.
  static bool validateClassRow(List<Data?> row) {
    var lev = row[0]?.value;
    var classcode = row[1]?.value;
    return lev != null && classcode != null;
  }

  static String? getDepartmentsFromExcelSheet({required Sheet classesSheet}) {
    var departmentRow = classesSheet.row(classInstructions.length + 1)[1];
    String departmentKey = departmentRow != null && departmentRow.value != null
        ? departmentRow.value.toString()
        : '';
    if (departmentKey.isEmpty) {
      return null;
    }
    var department = departmentList.keys.firstWhere(
        (element) =>
            element.toLowerCase().replaceAll(' ', '') ==
            departmentKey.toLowerCase().replaceAll(' ', ''),
        orElse: () => '');
    if (department.isEmpty) {
      return null;
    }
    return departmentList[department];
  }
}
