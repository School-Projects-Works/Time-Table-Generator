import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';

abstract class ClassesRepo {
  Future<List<ClassModel>> getClasses(String academicYear, String academicSemester, String targetedStudents);
  Future<bool> addClasses(List<ClassModel> classes);
  //delete all classes
  Future<bool> deleteAllClasses(String academicYear, String academicSemester,String targetedStudents,String department);
  Future<bool> deleteClass(String id);
}