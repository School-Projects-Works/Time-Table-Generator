import 'dart:convert';

import 'package:flutter/foundation.dart';

class LCModel {
  String id;
  String lecturerId;
  String lecturerName;
  Map<String, dynamic> lecturer;
  List<String> classes;
  String courseId;
  String courseCode;
  bool requireSpecialVenue;
  List<String> venues;
  String courseName;
  Map<String, dynamic> course;
  String level;
  String studyMode;
  LCModel({
    required this.id,
    required this.lecturerId,
    required this.lecturerName,
    required this.lecturer,
    required this.classes,
    required this.courseId,
    required this.courseCode,
    required this.requireSpecialVenue,
    required this.venues,
    required this.courseName,
    required this.course,
    required this.level,
    required this.studyMode,
  });

  LCModel copyWith({
    String? id,
    String? lecturerId,
    String? lecturerName,
    Map<String, dynamic>? lecturer,
    List<String>? classes,
    String? courseId,
    String? courseCode,
    bool? requireSpecialVenue,
    List<String>? venues,
    String? courseName,
    Map<String, dynamic>? course,
    String? level,
    String? studyMode,
  }) {
    return LCModel(
      id: id ?? this.id,
      lecturerId: lecturerId ?? this.lecturerId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturer: lecturer ?? this.lecturer,
      classes: classes ?? this.classes,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      requireSpecialVenue: requireSpecialVenue ?? this.requireSpecialVenue,
      venues: venues ?? this.venues,
      courseName: courseName ?? this.courseName,
      course: course ?? this.course,
      level: level ?? this.level,
      studyMode: studyMode ?? this.studyMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'lecturer': lecturer,
      'classes': classes,
      'courseId': courseId,
      'courseCode': courseCode,
      'requireSpecialVenue': requireSpecialVenue,
      'venues': venues,
      'courseName': courseName,
      'course': course,
      'level': level,
      'studyMode': studyMode,
    };
  }

  factory LCModel.fromMap(Map<String, dynamic> map) {
    return LCModel(
      id: map['id'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturer: Map<String, dynamic>.from(map['lecturer']),
      classes: List<String>.from(map['classes']),
      courseId: map['courseId'] ?? '',
      courseCode: map['courseCode'] ?? '',
      requireSpecialVenue: map['requireSpecialVenue'] ?? false,
      venues: List<String>.from(map['venues']),
      courseName: map['courseName'] ?? '',
      course: Map<String, dynamic>.from(map['course']),
      level: map['level'] ?? '',
      studyMode: map['studyMode'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LCModel.fromJson(String source) =>
      LCModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LCModel(id: $id, lecturerId: $lecturerId, lecturerName: $lecturerName, lecturer: $lecturer, classes: $classes, courseId: $courseId, courseCode: $courseCode, requireSpecialVenue: $requireSpecialVenue, venues: $venues, courseName: $courseName, course: $course, level: $level, studyMode: $studyMode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LCModel &&
      other.id == id &&
      other.lecturerId == lecturerId &&
      other.lecturerName == lecturerName &&
      mapEquals(other.lecturer, lecturer) &&
      listEquals(other.classes, classes) &&
      other.courseId == courseId &&
      other.courseCode == courseCode &&
      other.requireSpecialVenue == requireSpecialVenue &&
      listEquals(other.venues, venues) &&
      other.courseName == courseName &&
      mapEquals(other.course, course) &&
      other.level == level &&
      other.studyMode == studyMode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      lecturerId.hashCode ^
      lecturerName.hashCode ^
      lecturer.hashCode ^
      classes.hashCode ^
      courseId.hashCode ^
      courseCode.hashCode ^
      requireSpecialVenue.hashCode ^
      venues.hashCode ^
      courseName.hashCode ^
      course.hashCode ^
      level.hashCode ^
      studyMode.hashCode;
  }
}
