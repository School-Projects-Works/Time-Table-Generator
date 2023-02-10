// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'config_model.g.dart';

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
  String? liberalLevel;
  @HiveField(12)
  String? targetedStudents;
  @HiveField(13)
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
    List<Map<String, String>>? headings,
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
      'liberalLevel': liberalLevel,
      'targetedStudents': targetedStudents,
      'breakTime': breakTime,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      id: map['id'],
      academicName: map['academicName'],
      academicYear: map['academicYear'],
      academicSemester: map['academicSemester'],
      days: map['days'],
      periods: map['periods'],
      liberalCourseDay: map['liberalCourseDay'],
      liberalCoursePeriod: map['liberalCoursePeriod'],
      hasLiberalCourse: map['hasLiberalCourse'],
      hasCourse: map['hasCourse'],
      hasClass: map['hasClass'],
      liberalLevel: map['liberalLevel'],
      targetedStudents: map['targetedStudents'],
      breakTime: map['breakTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConfigModel(id: $id, academicName: $academicName, academicYear: $academicYear, academicSemester: $academicSemester, days: $days, periods: $periods, liberalCourseDay: $liberalCourseDay, liberalCoursePeriod: $liberalCoursePeriod, hasLiberalCourse: $hasLiberalCourse, hasCourse: $hasCourse, hasClass: $hasClass,  liberalLevel: $liberalLevel, targetedStudents: $targetedStudents, breakTime: $breakTime)';
  }

  @override
  bool operator ==(covariant ConfigModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.academicName == academicName &&
        other.academicYear == academicYear &&
        other.academicSemester == academicSemester &&
        listEquals(other.days, days) &&
        listEquals(other.periods, periods) &&
        other.liberalCourseDay == liberalCourseDay &&
        mapEquals(other.liberalCoursePeriod, liberalCoursePeriod) &&
        other.hasLiberalCourse == hasLiberalCourse &&
        other.hasCourse == hasCourse &&
        other.hasClass == hasClass &&
        other.liberalLevel == liberalLevel &&
        other.targetedStudents == targetedStudents &&
        mapEquals(other.breakTime, breakTime);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        academicName.hashCode ^
        academicYear.hashCode ^
        academicSemester.hashCode ^
        days.hashCode ^
        periods.hashCode ^
        liberalCourseDay.hashCode ^
        liberalCoursePeriod.hashCode ^
        hasLiberalCourse.hashCode ^
        hasCourse.hashCode ^
        hasClass.hashCode ^
        liberalLevel.hashCode ^
        targetedStudents.hashCode ^
        breakTime.hashCode;
  }
}
