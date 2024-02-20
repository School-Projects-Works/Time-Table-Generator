import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/lecturers/lecturer_model.dart';
import '../repo/lecture_repo.dart';

class LecturerUseCase extends LectureRepo {
  @override
  Future<bool> addLectures(List<LecturerModel> lecturers)async {
    try{
      final Box<LecturerModel> lecturerBox =
          await Hive.openBox<LecturerModel>('lecturers');
      if (!lecturerBox.isOpen) {
        await Hive.openBox('lecturers');
      }
      //re,ove all lecturers where academic year and semester is the same
      var allLecturersToDelete = lecturerBox.values
          .where((element) =>
              element.academicYear == lecturers[0].academicYear &&
              element.department == lecturers[0].department &&
              element.academicSemester == lecturers[0].academicSemester)
          .toList();
      await lecturerBox
          .deleteAll(allLecturersToDelete.map((e) => e.id).toList());
      await lecturerBox.putAll({for (var e in lecturers) e.id: e});
      return true;
    }catch(_){
      return Future.value(false);
    }
  }

  @override
  Future<bool> deleteAllLectures(String academicYear, String academicSemester, String targetedStudents, String department) {
    // TODO: implement deleteAllLectures
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteLecture(String id) {
    // TODO: implement deleteLecture
    throw UnimplementedError();
  }

  @override
  Future<List<LecturerModel>> getLectures(String academicYear, String academicSemester, String targetedStudents)async {
    try{
      final Box<LecturerModel> lecturerBox =
          Hive.box<LecturerModel>('lecturers');
      if (!lecturerBox.isOpen) {
        Hive.openBox('lecturers');
      }
      //get all lecturers where academic year and semester is the same
      var allLecturers = lecturerBox.values
          .where((element) =>
              element.academicYear == academicYear &&
              element.targetedStudents==targetedStudents&&
              element.academicSemester == academicSemester)
          .toList();
      return Future.value(allLecturers);
    }catch(_){
      return Future.value([]);
    }
  }
 
}