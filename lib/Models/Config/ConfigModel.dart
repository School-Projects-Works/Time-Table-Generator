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
  });

  ConfigModel copyWith({
    String? id,
    String? academicName,
    String? academicYear,
    String? academicSemester,
    List<String>? days,
    List<Map<String, dynamic>>? periods,
    String? liberalCourseDay,
    Map<String, dynamic>? liberalCoursePeriod,
    bool? hasLiberalCourse,
    bool? hasCourse,
    bool? hasClass,
    bool? hasVenues,
    String? liberalLevel,
    String? targetedStudents,
    Map<String, dynamic>? breakTime,
  }) {
    return ConfigModel(
      id: id ?? this.id,
      academicName: academicName ?? this.academicName,
      academicYear: academicYear ?? this.academicYear,
      academicSemester: academicSemester ?? this.academicSemester,
      days: days ?? this.days,
      periods: periods ?? this.periods,
      liberalCourseDay: liberalCourseDay ?? this.liberalCourseDay,
      liberalCoursePeriod: liberalCoursePeriod ?? this.liberalCoursePeriod,
      hasLiberalCourse: hasLiberalCourse ?? this.hasLiberalCourse,
      hasCourse: hasCourse ?? this.hasCourse,
      hasClass: hasClass ?? this.hasClass,
      hasVenues: hasVenues ?? this.hasVenues,
      liberalLevel: liberalLevel ?? this.liberalLevel,
      targetedStudents: targetedStudents ?? this.targetedStudents,
      breakTime: breakTime ?? this.breakTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'academicName': academicName,
      'academicYear': academicYear,
      'academicSemester': academicSemester,
      'days': days,
      'periods': periods,
      'liberalCourseDay': liberalCourseDay,
      'liberalCoursePeriod': liberalCoursePeriod,
      'hasLiberalCourse': hasLiberalCourse,
      'hasCourse': hasCourse,
      'hasClass': hasClass,
      'hasVenues': hasVenues,
      'liberalLevel': liberalLevel,
      'targetedStudents': targetedStudents,
      'breakTime': breakTime,
    };
  }
}
