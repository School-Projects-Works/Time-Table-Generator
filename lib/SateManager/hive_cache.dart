// ignore_for_file: file_names

import 'dart:io';
import 'package:aamusted_timetable_generator/Models/Class/class_model.dart';
import 'package:aamusted_timetable_generator/Models/Course/course_model.dart';
import 'package:aamusted_timetable_generator/Models/Course/liberal_model.dart';
import 'package:aamusted_timetable_generator/Models/Table/table_item_model.dart';
import 'package:aamusted_timetable_generator/Models/Venue/venue_model.dart';
import 'package:hive_flutter/adapters.dart';
import '../Models/Admin/admin_model.dart';
import '../Models/Config/config_model.dart';
import '../Models/Table/table_model.dart';

class HiveCache {
  static Future<void> init() async {
    String path = Directory('${Directory.current.path}/Database').path;
    await Hive.initFlutter(path);
    Hive.registerAdapter(AdminModelAdapter());
    Hive.registerAdapter(ConfigModelAdapter());
    Hive.registerAdapter(CourseModelAdapter());
    Hive.registerAdapter(ClassModelAdapter());
    Hive.registerAdapter(VenueModelAdapter());
    Hive.registerAdapter(LiberalModelAdapter());
    Hive.registerAdapter(TableModelAdapter());

    await Hive.openBox<AdminModel>('admins');
    await Hive.openBox<ConfigModel>('config');
    await Hive.openBox<CourseModel>('courses');
    await Hive.openBox<ClassModel>('classes');
    await Hive.openBox<VenueModel>('venues');
    await Hive.openBox('isLoggedIn');
    await Hive.openBox<LiberalModel>('liberals');
    await Hive.openBox<TableModel>('tables');
  }

  static void setAdmin(AdminModel admin) {
    final box = Hive.box<AdminModel>('admins');
    box.put('admin', admin);
  }

  static AdminModel? getAdmin() {
    final box = Hive.box<AdminModel>('admins');
    return box.get('admin');
  }

  static void createAdmin() async {
    final box = Hive.box<AdminModel>('admins');
    AdminModel? admin = box.get('admin');
    if (admin == null) {
      admin = AdminModel(id: 'admin', name: 'admin', password: '123456');
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

  static void addConfigurations(ConfigModel configurations) {
    final box = Hive.box<ConfigModel>('config');
    box.put(configurations.id, configurations);
  }

  static getConfig(String? id) {
    final box = Hive.box<ConfigModel>('config');
    return box.get(id, defaultValue: ConfigModel());
  }

  static List<ConfigModel> getConfigList() {
    final box = Hive.box<ConfigModel>('config');
    return box.values.toList();
  }

  static void addCourses(CourseModel element) {
    final box = Hive.box<CourseModel>('courses');
    box.put(element.id, element);
  }

  static getCourses() {
    final box = Hive.box<CourseModel>('courses');
    return box.values.toList();
  }

  static getClasses() {
    final box = Hive.box<ClassModel>('classes');
    return box.values.toList();
  }

  static void addClass(ClassModel element) {
    final box = Hive.box<ClassModel>('classes');
    box.put(element.id, element);
  }

  static void updateCourse(CourseModel course) {
    final box = Hive.box<CourseModel>('courses');
    box.put(course.id, course);
  }

  static void addVenue(VenueModel element) {
    final box = Hive.box<VenueModel>('venues');
    box.put(element.id, element);
  }

  static getVenues() {
    final box = Hive.box<VenueModel>('venues');
    return box.values.toList();
  }

  static void deleteCourse(CourseModel course) {
    final box = Hive.box<CourseModel>('courses');
    box.delete(course.id);
  }

  static void deleteClass(ClassModel element) {
    final box = Hive.box<ClassModel>('classes');
    box.delete(element.id);
  }

  static void deleteVenue(VenueModel element) {
    final box = Hive.box<VenueModel>('venues');
    box.delete(element.id);
  }

  static void addLiberal(LiberalModel element) {
    final box = Hive.box<LiberalModel>('liberals');
    box.put(element.id, element);
  }

  static List<LiberalModel> getLiberals() {
    final box = Hive.box<LiberalModel>('liberals');
    return box.values.toList();
  }

  static void deleteLiberal(LiberalModel element) {
    final box = Hive.box<LiberalModel>('liberals');
    box.delete(element.id);
  }

  static void addTables(List<TableItemModel>? tables) {
    final box = Hive.box<TableItemModel>('tables');
    if (tables != null) {
      for (TableItemModel table in tables) {
        box.put(table.id, table);
      }
    }
  }

  static List<TableModel> getTables() {
    final box = Hive.box<TableModel>('tables');
    return box.values.toList();
  }

  static void deleteTable(String id) {
    final box = Hive.box<TableModel>('tables');
    box.delete(id);
  }

  static void saveTable(TableModel table) {
    final box = Hive.box<TableModel>('tables');
    box.put(table.id, table);
  }
}
