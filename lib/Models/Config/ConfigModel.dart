// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  List<String>? days;
  @HiveField(5)
  List<Map<String, dynamic>>? periods;
  @HiveField(6)
  String? liberalCourseDay;
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
  @HiveField(12)
  String? liberalLevel;
  @HiveField(13)
  String? targetedStudents;
  @HiveField(14)
  Map<String, dynamic>? breakTime;
  @HiveField(15)
  List<Map<String, String>>? headings;

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
    this.liberalLevel,
    this.targetedStudents,
    this.breakTime,
    this.headings,
  });
}
