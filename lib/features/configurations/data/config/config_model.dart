import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'config_model.g.dart';

@HiveType(typeId: 0)
class ConfigModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? year;
  @HiveField(2)
  String? semester;
  @HiveField(3)
  Map<String, dynamic> regular;
  @HiveField(4)
  Map<String, dynamic> evening;
  ConfigModel({
    this.id,
    this.year,
    this.semester,
    required this.regular,
    required this.evening,
  });

  ConfigModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? year,
    ValueGetter<String?>? semester,
    Map<String, dynamic>? regular,
    Map<String, dynamic>? evening,
  }) {
    return ConfigModel(
      id: id != null ? id() : this.id,
      year: year != null ? year() : this.year,
      semester: semester != null ? semester() : this.semester,
      regular: regular ?? this.regular,
      evening: evening ?? this.evening,
    );
  }
}

class StudyModeModel {
  List<String> days;
  List<Map<String, dynamic>> periods;
  String? liberalCourseDay;
  Map<String, dynamic>? liberalCoursePeriod;
  bool hasLiberalCourse;
  bool hasCourse;
  bool hasClass;
  String? liberalLevel;
  String? studyMode;
  List<Map<String, dynamic>>? breakTime;
  StudyModeModel({
     this.days=const [],
     this.periods=const [],
    this.liberalCourseDay,
    this.liberalCoursePeriod,
     this.hasLiberalCourse=false,
     this.hasCourse=false,
     this.hasClass=false,
    this.liberalLevel,
    this.studyMode,
    this.breakTime,
  });

  StudyModeModel copyWith({
    List<String>? days,
    List<Map<String, dynamic>>? periods,
    ValueGetter<String?>? liberalCourseDay,
    ValueGetter<Map<String, dynamic>?>? liberalCoursePeriod,
    bool? hasLiberalCourse,
    bool? hasCourse,
    bool? hasClass,
    ValueGetter<String?>? liberalLevel,
    ValueGetter<String?>? studyMode,
    ValueGetter<List<Map<String, dynamic>>?>? breakTime,
  }) {
    return StudyModeModel(
      days: days ?? this.days,
      periods: periods ?? this.periods,
      liberalCourseDay: liberalCourseDay != null ? liberalCourseDay() : this.liberalCourseDay,
      liberalCoursePeriod: liberalCoursePeriod != null ? liberalCoursePeriod() : this.liberalCoursePeriod,
      hasLiberalCourse: hasLiberalCourse ?? this.hasLiberalCourse,
      hasCourse: hasCourse ?? this.hasCourse,
      hasClass: hasClass ?? this.hasClass,
      liberalLevel: liberalLevel != null ? liberalLevel() : this.liberalLevel,
      studyMode: studyMode != null ? studyMode() : this.studyMode,
      breakTime: breakTime != null ? breakTime() : this.breakTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'days': days,
      'periods': periods,
      'liberalCourseDay': liberalCourseDay,
      'liberalCoursePeriod': liberalCoursePeriod,
      'hasLiberalCourse': hasLiberalCourse,
      'hasCourse': hasCourse,
      'hasClass': hasClass,
      'liberalLevel': liberalLevel,
      'studyMode': studyMode,
      'breakTime': breakTime,
    };
  }

  factory StudyModeModel.fromMap(Map<String, dynamic> map) {
    return StudyModeModel(
      days: List<String>.from(map['days']),
      periods: List<Map<String, dynamic>>.from(map['periods']?.map((x) => Map<String, dynamic>.from(x))),
      liberalCourseDay: map['liberalCourseDay'],
      liberalCoursePeriod: Map<String, dynamic>.from(map['liberalCoursePeriod']),
      hasLiberalCourse: map['hasLiberalCourse'] ?? false,
      hasCourse: map['hasCourse'] ?? false,
      hasClass: map['hasClass'] ?? false,
      liberalLevel: map['liberalLevel'],
      studyMode: map['studyMode'],
      breakTime: map['breakTime'] != null ? List<Map<String, dynamic>>.from(map['breakTime']?.map((x) => Map<String, dynamic>.from(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudyModeModel.fromJson(String source) => StudyModeModel.fromMap(json.decode(source));
}
