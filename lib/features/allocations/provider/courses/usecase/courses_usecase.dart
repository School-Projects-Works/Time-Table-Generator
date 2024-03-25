import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../repo/course_repo.dart';

class CoursesUseCase extends CoursesRepo {
  @override
  Future<List<CourseModel>> addCourses(List<CourseModel> courses) async{
   try{
      //! saving courses=========================================
      final Box<CourseModel> courseBox =
          await Hive.openBox<CourseModel>('courses');
      //check if box is open
      if (!courseBox.isOpen) {
        await Hive.openBox('courses');
      }
      //remove all courses where academic year and semester is the same
      var allCoursesToDelete = courseBox.values
          .where((element) =>
              element.year == courses[0].year &&
              element.department == courses[0].department &&
              element.semester == courses[0].semester)
          .toList();
      await courseBox.deleteAll(allCoursesToDelete.map((e) => e.id).toList());
      await courseBox.putAll({for (var e in courses) e.id: e});
      var allCourses = courseBox.values
          .where(
              (element) => element.year == courses[0].year && element.semester == courses[0].semester)
          .toList();
      return allCourses;
   }catch(_){
      return [];
   }
  }


  @override
  Future<List<CourseModel>> getCourses(String year, String semester)async {
   try{
      final Box<CourseModel> courseBox =
          await Hive.openBox<CourseModel>('courses');
      //check if box is open
      if (!courseBox.isOpen) {
        await Hive.openBox('courses');
      }
      //get all courses where academic year and semester is the same
      var allCourses = courseBox.values
          .where((element) =>
              element.year == year &&
              element.semester == semester)
          .toList();
      return allCourses;
   }catch(_){
      return [];
   }
  }
  
  @override
  Future<(bool, String?, CourseModel?)> updateCourse(CourseModel course)async {
    try{
       final Box<CourseModel> courseBox =
          await Hive.openBox<CourseModel>('courses');
      //check if box is open
      if (!courseBox.isOpen) {
        await Hive.openBox('courses');
      }
      //update course
      await courseBox.put(course.id, course);
      return (true, 'Course Updated Successfully', course);
    }catch(error){
      return (false, error.toString(), null);
    }
  }
 
}