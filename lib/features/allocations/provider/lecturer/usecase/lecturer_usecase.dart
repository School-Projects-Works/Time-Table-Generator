import 'package:mongo_dart/mongo_dart.dart';

import '../../../data/lecturers/lecturer_model.dart';
import '../repo/lecture_repo.dart';

class LecturerUseCase extends LectureRepo {
  final Db db;

  LecturerUseCase({required this.db});
  @override
  Future<List<LecturerModel>> addLectures(List<LecturerModel> lecturers) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //remove all lecturers where academic year, semester and department is the same
      await db.collection('lecturers').remove({
        'year': lecturers[0].year,
        'semester': lecturers[0].semester,
        'department': lecturers[0].department,
      });

      // check if lecturer already exist then append courses and classes
      for (var lecturer in lecturers) {
        var existingLecturer = await db.collection('lecturers').findOne({
          'id': lecturer.id,
          'year': lecturer.year,
          'semester': lecturer.semester,
        });
        if (existingLecturer != null) {
          var courses = existingLecturer['courses'];
          var classes = existingLecturer['classes'];
          courses.addAll(lecturer.courses);
          classes.addAll(lecturer.classes);
          await db.collection('lecturers').update({
            "id": lecturer.id,
            'year': lecturer.year,
            'semester': lecturer.semester,
          }, {
            r'$set': {
              'courses': courses,
              'classes': classes,
            }
          });
        } else {
          await db.collection('lecturers').insert(lecturer.toMap());
        }
      }
      //get all recturers

      var lecturerList = await db.collection('lecturers').find({
        'year': lecturers[0].year,
        'semester': lecturers[0].semester,
      }).toList();
      return lecturerList.map((e) => LecturerModel.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<LecturerModel>> getLectures(String year, String semester) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //get all lecturers where academic year and semester is the same
      var allLecturers = await db.collection('lecturers').find({
        'year': year,
        'semester': semester,
      }).toList();
      return allLecturers.map((e) => LecturerModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteAllLecturers(
      String year, String semester, String department) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }

      if (department.toLowerCase() == 'All'.toLowerCase()) {
        //delete all classes where academic year and semester is the same
        await db.collection('lecturers').remove({
          'year': year,
          'semester': semester,
        });
        return true;
      }
      //delete all classes where academic year, semester and department is the same
      await db.collection('lecturers').remove(
          {'year': year, 'semester': semester, 'department': department});
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<(bool, String)> updateLecturers(LecturerModel libLecturers) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //replace lecturer data with new lecturer
      await db.collection('lecturers').update({
        'id': libLecturers.id,
        'year': libLecturers.year,
        'semester': libLecturers.semester,
      }, libLecturers.toMap());
      return Future.value((true, 'Lecturers updated successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }
}
