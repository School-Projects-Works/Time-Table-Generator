import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';

abstract class AllocationRepo {
  Future<
      (
        bool,
        (List<CourseModel>, List<ClassModel>, List<LecturerModel>),
        String?
      )> importAllocation({
    required String path,
    required String year,
    required String semester,
  });
  Future<(bool, String?)> downloadTemplate();
  Future<(bool, List<ClassModel>, List<CourseModel>, List<LecturerModel>)>
      deletateAllocation(
          String academicYear, String academicSemester, String department);
}
