import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';

abstract class ClassesRepo {
  Future<List<ClassModel>> getClasses(String year, String semester);
  Future<List<ClassModel>> addClasses(List<ClassModel> classes);
  //delete all classes
  Future<bool> deleteAllClasses(String year, String semester,String department);
  Future<bool> deleteClass(String id);
}