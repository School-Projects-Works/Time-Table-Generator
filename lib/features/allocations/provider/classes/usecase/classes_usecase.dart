import 'dart:async';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../repo/classes_repo.dart';

class ClassesUsecase extends ClassesRepo {
  final Db db;

  ClassesUsecase({required this.db});
  @override
  Future<List<ClassModel>> addClasses(List<ClassModel> classes) async {
    try {
      //! saving classes=========================================
      if (db.state != State.open) {
        await db.open();
      }
      //remove all classes where academic year, semester and department is the same
      await db.collection('classes').remove({
        'year': classes[0].year,
        'semester': classes[0].semester,
        'department': classes[0].department,
        'program': classes[0].program
      });
      //now add the new classes
      for (var e in classes) {
        await db.collection('classes').insert(e.toMap());
      }

      //get all classes where academic year and semester is the same
      var allClasses = await db.collection('classes').find({
        'year': classes[0].year,
        'semester': classes[0].semester,
      }).toList();
      return allClasses.map((e) => ClassModel.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> deleteClass(String id) {
    try {
      if (db.state != State.open) {
        db.open();
      }
      db.collection('classes').remove({'class_id': id});
      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  }

  @override
  Future<List<ClassModel>> getClasses(String year, String semester) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //get all classes where academic year and semester is the same
      var allClasses = await db.collection('classes').find({
        'year': year,
        'semester': semester,
      }).toList();

      return allClasses.map((e) => ClassModel.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
