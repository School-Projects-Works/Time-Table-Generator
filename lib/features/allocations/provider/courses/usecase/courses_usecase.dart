import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../repo/course_repo.dart';

class CoursesUseCase extends CoursesRepo {
  final Db db;

  CoursesUseCase({required this.db});
  @override
  Future<List<CourseModel>> addCourses(List<CourseModel> courses) async {
    try {
      //! saving courses=========================================
      if (db.state != State.open) {
        await db.open();
      }
      //remove all courses where academic year and semester is the same
      await db.collection('courses').remove({
        'year': courses[0].year,
        'semester': courses[0].semester,
        'department': courses[0].department,
      });
      //now add the new courses
      for (var e in courses) {
        await db.collection('courses').insert(e.toMap());
      }
      //get all courses where academic year and semester is the same
      var allCourses = await db.collection('courses').find({
        'year': courses[0].year,
        'semester': courses[0].semester,
      }).toList();
      return allCourses.map((e) => CourseModel.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<CourseModel>> getCourses(String year, String semester) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //get all courses where academic year and semester is the same
      var allCourses = await db.collection('courses').find({
        'year': year,
        'semester': semester,
      }).toList();
      return allCourses.map((e) => CourseModel.fromMap(e)).toList();
      
    } catch (_) {
      return [];
    }
  }

  @override
  Future<(bool, String?, CourseModel?)> updateCourse(CourseModel course) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //update course
      await db.collection('courses').update(
        where.eq('id', course.id),
        course.toMap(),
      );
      return (true, 'Course Updated Successfully', course);
    } catch (error) {
      return (false, error.toString(), null);
    }
  }
}
