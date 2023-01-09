import 'dart:io';

import 'package:aamusted_timetable_generator/Models/Academic/AcademicModel.dart';
import 'package:hive_flutter/adapters.dart';
import '../Models/Admin/Admin.dart';
import '../Models/Config/ConfigModel.dart';

class HiveCache {
  static Future<void> init() async {
    String path = Directory('${Directory.current.path}/Database').path;

    print("path================: $path");

    await Hive.initFlutter(path);
    Hive.registerAdapter(AdminAdapter());
    Hive.registerAdapter(AcademicModelAdapter());
    Hive.registerAdapter(ConfigModelAdapter());
    await Hive.openBox<Admin>('admins');
    await Hive.openBox<AcademicModel>('academics');
    await Hive.openBox<ConfigModel>('config');
    await Hive.openBox('isLoggedIn');
  }

  static void setAdmin(Admin admin) {
    final box = Hive.box<Admin>('admins');
    box.put('admin', admin);
  }

  static Admin? getAdmin() {
    final box = Hive.box<Admin>('admins');
    return box.get('admin');
  }

  static void createAdmin() async {
    final box = Hive.box<Admin>('admins');
    Admin? admin = box.get('admin');
    if (admin == null) {
      admin = Admin(id: 'admin', name: 'admin', password: '123456');
      box.put('admin', admin);
    }
  }

  static void saveIsLoggedIn(bool isLoggedIn) {
    final box = Hive.box('isLoggedIn');
    box.put('loggedIn', isLoggedIn);
  }

  static bool? getIsLoggedIn() {
    final box = Hive.box('isLoggedIn');
    return box.get('loggedIn', defaultValue: false);
  }

  static getSingleAcademic(String id) {
    final box = Hive.box<AcademicModel>('academics');
    return box.get(id);
  }

  static List<AcademicModel> saveAcademic(AcademicModel academicModel) {
    final box = Hive.box<AcademicModel>('academics');
    box.put(academicModel.id, academicModel);
    return box.values.toList();
  }

  static getAcademics() {
    final box = Hive.box<AcademicModel>('academics');
    return box.values.toList();
  }
}
