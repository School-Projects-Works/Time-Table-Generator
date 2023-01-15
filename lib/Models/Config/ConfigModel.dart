// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'ConfigModel.g.dart';

@HiveType(typeId: 2)
class ConfigModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? academicName;
  @HiveField(2)
  String? academicYear;
  @HiveField(3)
  String? academicSemester;
  @HiveField(4)
  List<Map<String, dynamic>>? days;
  @HiveField(5)
  List<Map<String, dynamic>>? periods;
  @HiveField(6)
  Map<String, dynamic>? liberalCourseDay;
  @HiveField(7)
  Map<String, dynamic>? liberalCoursePeriod;
  @HiveField(8)
  bool hasLiberalCourse;
  @HiveField(9)
  bool hasCourse;
  @HiveField(10)
  bool hasClass;
  @HiveField(11)
  bool hasVenues;

  ConfigModel({
    this.id,
    this.academicName,
    this.academicYear,
    this.academicSemester,
    this.days,
    this.periods,
    this.liberalCourseDay,
    this.liberalCoursePeriod,
    this.hasLiberalCourse = false,
    this.hasCourse = false,
    this.hasClass = false,
    this.hasVenues = false,
  });
}
