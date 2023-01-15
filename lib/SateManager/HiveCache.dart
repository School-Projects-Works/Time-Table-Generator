// ignore_for_file: file_names

import 'dart:io';
import 'package:aamusted_timetable_generator/Models/Academic/AcademicModel.dart';
import 'package:aamusted_timetable_generator/Models/Class/ClassModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/LiberalModel.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:hive_flutter/adapters.dart';
import '../Models/Admin/Admin.dart';
import '../Models/Config/ConfigModel.dart';

class HiveCache {
  static Future<void> init() async {
    String path = Directory('${Directory.current.path}/Database').path;
    await Hive.initFlutter(path);
    Hive.registerAdapter(AdminAdapter());
    Hive.registerAdapter(AcademicModelAdapter());
    Hive.registerAdapter(ConfigModelAdapter());
    Hive.registerAdapter(CourseModelAdapter());
    Hive.registerAdapter(ClassModelAdapter());
    Hive.registerAdapter(VenueModelAdapter());
    Hive.registerAdapter(LiberalModelAdapter());

    await Hive.openBox<Admin>('admins');
    await Hive.openBox<AcademicModel>('academics');
    await Hive.openBox<ConfigModel>('config');
    await Hive.openBox<CourseModel>('courses');
    await Hive.openBox<ClassModel>('classes');
    await Hive.openBox<VenueModel>('venues');
    await Hive.openBox('isLoggedIn');
    await Hive.openBox<LiberalModel>('liberals');
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

  static getCourses(String currentAcademicYear) {
    final box = Hive.box<CourseModel>('courses');
    return box.values
        .where((element) => element.academicYear == currentAcademicYear)
        .toList();
  }

  static getClasses(currentYear) {
    final box = Hive.box<ClassModel>('classes');
    return box.values
        .where((element) => element.academicYear == currentYear)
        .toList();
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

  static getVenues(currentAcademicYear) {
    final box = Hive.box<VenueModel>('venues');
    return box.values
        .where((element) => element.academicYear == currentAcademicYear)
        .toList();
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

  static getLiberals(currentAcademicYear) {
    final box = Hive.box<LiberalModel>('liberals');
    return box.values
        .where((element) => element.academicYear == currentAcademicYear)
        .toList();
  }

  static void deleteLiberal(LiberalModel element) {
    final box = Hive.box<LiberalModel>('liberals');
    box.delete(element.id);
  }
}
