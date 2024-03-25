import '../../../data/courses/courses_model.dart';

abstract class CoursesRepo {
  Future<List<CourseModel>> getCourses(String year, String semester);
  Future<List<CourseModel>> addCourses(List<CourseModel> courses);
  Future<(bool, String?, CourseModel?)> updateCourse(CourseModel course);
  //delete all courses
}
