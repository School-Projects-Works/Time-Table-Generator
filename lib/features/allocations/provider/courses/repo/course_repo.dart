import '../../../data/courses/courses_model.dart';

abstract class CoursesRepo{
  Future<List<CourseModel>> getCourses(String academicYear, String academicSemester, String targetedStudents);
  Future<bool> addCourses(List<CourseModel> courses);
  //delete all courses
  Future<bool> deleteAllCourses(String academicYear, String academicSemester,String targetedStudents,String department);
  Future<bool> deleteCourse(String id);
}