import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';

abstract class AllocationRepo {
  Future<(bool ,(List<CourseModel>,List<ClassModel>,List<LecturerModel>) , String ?)> importAllocation(
          {required String path,
          required String academicYear,
          required String semester,
          required String targetStudents});
  Future<(bool , String ?)> downloadTemplate();
  Future<(bool ,CourseModel?, String ?)> detleteCourse();
  Future<(bool ,ClassModel?, String ?)> detleteClass();
  Future<(bool ,LecturerModel?, String ?)> detleteLecturer();
  
}