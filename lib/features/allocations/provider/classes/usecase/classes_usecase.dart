import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../repo/classes_repo.dart';

class ClassesUsecase extends ClassesRepo {
  @override
  Future<bool> addClasses(List<ClassModel> classes) async {
    try {
      //! saving classes=========================================
      final Box<ClassModel> classBox =
          await Hive.openBox<ClassModel>('classes');
      //check if box is open
      if (!classBox.isOpen) {
        await Hive.openBox('classes');
      }
      //re,ove all classes where academic year and semester is the same
      var allClassesToDelete = classBox.values
          .where((element) =>
              element.year == classes[0].year &&
              element.department == classes[0].department &&
              element.semester == classes[0].semester)
          .toList();
      await classBox.deleteAll(allClassesToDelete.map((e) => e.id).toList());
      await classBox.putAll({for (var e in classes) e.id: e});
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteAllClasses(
      String year, String semester, String department) async {
    try {
      final Box<ClassModel> classBox =
          await Hive.openBox<ClassModel>('classes');
      //check if box is open
      if (!classBox.isOpen) {
        await Hive.openBox('classes');
      }
      //get all classes where academic year and semester is the same
      if (department.toLowerCase() == 'All'.toLowerCase()) {
        var allClassesToDelete = classBox.values
            .where((element) =>
                element.year == year &&             
                element.semester == semester)
            .toList();
        await classBox.deleteAll(allClassesToDelete.map((e) => e.id).toList());
        return true;
      }
      var allClassesToDelete = classBox.values
          .where((element) =>
              element.year == year &&           
              element.department == department &&
              element.semester == semester)
          .toList();
      await classBox.deleteAll(allClassesToDelete.map((e) => e.id).toList());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteClass(String id) {
    // TODO: implement deleteClass
    throw UnimplementedError();
  }

  @override
  Future<List<ClassModel>> getClasses(
      String year, String semester) async {
    try {
      final Box<ClassModel> classBox =
          await Hive.openBox<ClassModel>('classes');
      //check if box is open
      if (!classBox.isOpen) {
        await Hive.openBox('classes');
      }
      //get all classes where academic year and semester is the same
      var allClasses = classBox.values
          .where((element) =>
              element.year == year &&             
              element.semester == semester)
          .toList();
      return allClasses;
    } catch (_) {
      return [];
    }
  }
}
