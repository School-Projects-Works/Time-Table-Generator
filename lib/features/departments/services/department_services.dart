import 'package:aamusted_timetable_generator/features/departments/data/department_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DepartmentServices{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;


  static Future<bool>  addDepartment(DepartmentModel department) async {
    try {
      await _db.collection('departments').doc(department.id!).set(department.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
  static Stream<List<DepartmentModel>> getDepartments() {
    return _db.collection('departments').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => DepartmentModel.fromMap(doc.data())).toList());
  }

  static updateDepartment(DepartmentModel departmentModel) async{
    try {
      await _db.collection('departments').doc(departmentModel.id).update(departmentModel.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static Future<void>deleteDepartment(DepartmentModel item) async{
    try {
      await _db.collection('departments').doc(item.id).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}