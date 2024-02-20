import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../repo/course_repo.dart';

class CoursesUseCase extends CoursesRepo {
  @override
  Future<bool> addCourses(List<CourseModel> courses) async{
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
              element.academicYear == courses[0].academicYear &&
              element.department == courses[0].department &&
              element.academicSemester == courses[0].academicSemester)
          .toList();
      await courseBox.deleteAll(allCoursesToDelete.map((e) => e.id).toList());
      await courseBox.putAll({for (var e in courses) e.id: e});
      return true;
   }catch(_){
      return false;
   }
  }

  @override
  Future<bool> deleteAllCourses(String academicYear, String academicSemester, String targetedStudents, String department) {
    // TODO: implement deleteAllCourses
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteCourse(String id) {
    // TODO: implement deleteCourse
    throw UnimplementedError();
  }

  @override
  Future<List<CourseModel>> getCourses(String academicYear, String academicSemester, String targetedStudents)async {
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
              element.academicYear == academicYear &&
              element.targetStudents==targetedStudents&&
              element.academicSemester == academicSemester)
          .toList();
      return allCourses;
   }catch(_){
      return [];
   }
  }
 
}