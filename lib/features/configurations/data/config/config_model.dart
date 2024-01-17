import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'config_model.g.dart';

@HiveType(typeId: 0)
class ConfigModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? academicYear;
  @HiveField(2)
  String? academicSemester;
  @HiveField(3)
  List<String> days;
  @HiveField(4)
  List<Map<String, dynamic>> periods;
  @HiveField(5)
  String? liberalCourseDay;
  @HiveField(6)
  Map<String, dynamic>? liberalCoursePeriod;
  @HiveField(7)
  bool hasLiberalCourse;
  @HiveField(8)
  bool hasCourse;
  @HiveField(9)
  bool hasClass;
  @HiveField(10)
  String? liberalLevel;
  @HiveField(11)
  String? targetedStudents;
  @HiveField(12)
  List<Map<String, dynamic>>? breakTime;
  ConfigModel({
    this.id,
    this.academicYear,
    this.academicSemester,
    this.days = const [],
    this.periods = const [],
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
    String? academicYear,
    String? academicSemester,
    List<String>? days,
    List<Map<String, dynamic>>? periods,
    String? liberalCourseDay,
    Map<String, dynamic>? liberalCoursePeriod,
    bool? hasLiberalCourse,
    bool? hasCourse,
    bool? hasClass,
    String? liberalLevel,
    String? targetedStudents,
    List<Map<String, dynamic>>? breakTime,
  }) {
    return ConfigModel(
      id: id ?? this.id,
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
      id: map['id'] != null ? map['id'] as String : null,
      academicYear:
          map['academicYear'] != null ? map['academicYear'] as String : null,
      academicSemester: map['academicSemester'] != null
          ? map['academicSemester'] as String
          : null,
      days: map['days'] != null
          ? List<String>.from((map['days'] as List<String>))
          : [],
      periods: map['periods'] != null
          ? List<Map<String, dynamic>>.from(
              (map['periods'] as List<Map<String, dynamic>>)
                  .map<Map<String, dynamic>?>(
                (x) => x,
              ),
            )
          : [],
      liberalCourseDay: map['liberalCourseDay'] != null
          ? map['liberalCourseDay'] as String
          : null,
      liberalCoursePeriod: map['liberalCoursePeriod'] != null
          ? Map<String, dynamic>.from(
              (map['liberalCoursePeriod'] as Map<String, dynamic>))
          : null,
      hasLiberalCourse: map['hasLiberalCourse'] as bool,
      hasCourse: map['hasCourse'] as bool,
      hasClass: map['hasClass'] as bool,
      liberalLevel:
          map['liberalLevel'] != null ? map['liberalLevel'] as String : null,
      targetedStudents: map['targetedStudents'] != null
          ? map['targetedStudents'] as String
          : null,
      breakTime: map['breakTime'] != null
          ? List<Map<String, dynamic>>.from(
              (map['breakTime'] as List<Map<String, dynamic>>)
                  .map<Map<String, dynamic>?>(
                (x) => x,
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConfigurationModel(id: $id, academicYear: $academicYear, academicSemester: $academicSemester, days: $days, periods: $periods, liberalCourseDay: $liberalCourseDay, liberalCoursePeriod: $liberalCoursePeriod, hasLiberalCourse: $hasLiberalCourse, hasCourse: $hasCourse, hasClass: $hasClass, liberalLevel: $liberalLevel, targetedStudents: $targetedStudents, breakTime: $breakTime)';
  }

  @override
  bool operator ==(covariant ConfigModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
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
        listEquals(other.breakTime, breakTime);
  }

  @override
  int get hashCode {
    return id.hashCode ^
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
