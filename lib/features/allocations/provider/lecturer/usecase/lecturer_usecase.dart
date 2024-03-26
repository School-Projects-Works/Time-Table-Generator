import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/lecturers/lecturer_model.dart';
import '../repo/lecture_repo.dart';

class LecturerUseCase extends LectureRepo {
  @override
  Future<List<LecturerModel>> addLectures(List<LecturerModel> lecturers) async {
    try {
      final Box<LecturerModel> lecturerBox =
          await Hive.openBox<LecturerModel>('lecturers');
      if (!lecturerBox.isOpen) {
        await Hive.openBox('lecturers');
      }
      //re,ove all lecturers where academic year and semester is the same
      var allLecturersToDelete = lecturerBox.values
          .where((element) =>
              element.year == lecturers[0].year &&
              element.department == lecturers[0].department &&
              element.semester == lecturers[0].semester)
          .toList();
      await lecturerBox
          .deleteAll(allLecturersToDelete.map((e) => e.id).toList());
      await lecturerBox.putAll({for (var e in lecturers) e.id: e});
      var allLecturers = lecturerBox.values
          .where(
              (element) => element.year == lecturers[0].year && element.semester == lecturers[0].semester)
          .toList();
      return allLecturers;
    } catch (_) {
      return [];
    }
  }

 
  @override
  Future<List<LecturerModel>> getLectures(String year, String semester) async {
    try {
      final Box<LecturerModel> lecturerBox =
          await Hive.openBox<LecturerModel>('lecturers');
      if (!lecturerBox.isOpen) {
        await Hive.openBox('lecturers');
      }
      //get all lecturers where academic year and semester is the same
      var allLecturers = lecturerBox.values
          .where(
              (element) => element.year == year && element.semester == semester)
          .toList();
      return allLecturers;
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteAllLecturers(
      String year, String semester, String department) async {
    try {
      final Box<LecturerModel> lecturerBox =
          await Hive.openBox<LecturerModel>('lecturers');
      //check if box is open
      if (!lecturerBox.isOpen) {
        await Hive.openBox('lecturers');
      }
      //get all classes where academic year and semester is the same
      if (department.toLowerCase() == 'All'.toLowerCase()) {
        var allClassesToDelete = lecturerBox.values
            .where((element) =>
                element.year == year && element.semester == semester)
            .toList();
        await lecturerBox
            .deleteAll(allClassesToDelete.map((e) => e.id).toList());
        return true;
      }
      var allLecturersToDelete = lecturerBox.values
          .where((element) =>
              element.year == year &&
              element.department == department &&
              element.semester == semester)
          .toList();
      await lecturerBox
          .deleteAll(allLecturersToDelete.map((e) => e.id).toList());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<(bool, String)> appendLectuers(
      {required List<LecturerModel> list,
      required String year,
      required String semester}) async {
    try {
      final Box<LecturerModel> lecturerBox =
          await Hive.openBox<LecturerModel>('lecturers');
      if (!lecturerBox.isOpen) {
        await Hive.openBox('lecturers');
      }
      //save new lectuere or update lecturer courses
      //get all existing lecturers lecturers
      var allLecturers = lecturerBox.values.toList();
      //get all lecturers where academic year and semester is the same
      var allLecturersToCompare = allLecturers
          .where(
              (element) => element.year == year && element.semester == semester)
          .toList();
      for (var element in list) {
        if (allLecturersToCompare.any((e) => e.id == element.id)) {
          var lecturer =
              allLecturersToCompare.where((e) => e.id == element.id).firstOrNull;
              if(lecturer == null) continue;
          lecturer.courses = [...lecturer.courses, ...element.courses];
          await lecturerBox.put(lecturer.id, lecturer);
        } else {
          element.classes = [];
          await lecturerBox.put(element.id, element);
        }
      }
      return Future.value((true, 'Lecturers added successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }
}
