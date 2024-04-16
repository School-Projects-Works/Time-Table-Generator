import 'dart:convert';

import 'package:flutter/foundation.dart';

class ClassCoursePairModel {
  //! class-course pair model
  String id;
  String courseId;
  String courseCode;
  String courseName;
  bool requiredSpecialVenue;
  List<String> lecturers;
  List<String> venues;
  Map<String, dynamic> course;
  String classId;
  String className;
  Map<String, dynamic> classData;
  int classCapacity;
  String studyMode;
  String level;
  String year;
  String semester;
  String department;
  bool hasDisability;
  bool isPaired;
  ClassCoursePairModel({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.requiredSpecialVenue,
    required this.lecturers,
    required this.venues,
    required this.course,
    required this.classId,
    required this.className,
    required this.classData,
    required this.classCapacity,
    required this.studyMode,
    required this.level,
    required this.year,
    required this.semester,
    required this.department,
    required this.hasDisability,
     this.isPaired=false,
  });

  ClassCoursePairModel copyWith({
    String? id,
    String? courseId,
    String? courseCode,
    String? courseName,
    bool? requiredSpecialVenue,
    List<String>? lecturers,
    List<String>? venues,
    Map<String, dynamic>? course,
    String? classId,
    String? className,
    Map<String, dynamic>? classData,
    int? classCapacity,
    String? studyMode,
    String? level,
    String? year,
    String? semester,
    String? department,
    bool? hasDisability,
    bool? isPaired,
  }) {
    return ClassCoursePairModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      requiredSpecialVenue: requiredSpecialVenue ?? this.requiredSpecialVenue,
      lecturers: lecturers ?? this.lecturers,
      venues: venues ?? this.venues,
      course: course ?? this.course,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      classData: classData ?? this.classData,
      classCapacity: classCapacity ?? this.classCapacity,
      studyMode: studyMode ?? this.studyMode,
      level: level ?? this.level,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      department: department ?? this.department,
      hasDisability: hasDisability ?? this.hasDisability,
      isPaired: isPaired ?? this.isPaired,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'courseCode': courseCode,
      'courseName': courseName,
      'requiredSpecialVenue': requiredSpecialVenue,
      'lecturers': lecturers,
      'venues': venues,
      'course': course,
      'classId': classId,
      'className': className,
      'classData': classData,
      'classCapacity': classCapacity,
      'studyMode': studyMode,
      'level': level,
      'year': year,
      'semester': semester,
      'department': department,
      'hasDisability': hasDisability,
      'isPaired': isPaired,
    };
  }

  factory ClassCoursePairModel.fromMap(Map<String, dynamic> map) {
    return ClassCoursePairModel(
      id: map['id'] ?? '',
      courseId: map['courseId'] ?? '',
      courseCode: map['courseCode'] ?? '',
      courseName: map['courseName'] ?? '',
      requiredSpecialVenue: map['requiredSpecialVenue'] ?? false,
      lecturers: List<String>.from(map['lecturers']),
      venues: List<String>.from(map['venues']),
      course: Map<String, dynamic>.from(map['course']),
      classId: map['classId'] ?? '',
      className: map['className'] ?? '',
      classData: Map<String, dynamic>.from(map['classData']),
      classCapacity: map['classCapacity']?.toInt() ?? 0,
      studyMode: map['studyMode'] ?? '',
      level: map['level'] ?? '',
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
      department: map['department'] ?? '',
      hasDisability: map['hasDisability'] ?? false,
      isPaired: map['isPaired'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassCoursePairModel.fromJson(String source) =>
      ClassCoursePairModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassCoursePairModel(id: $id, courseId: $courseId, courseCode: $courseCode, courseName: $courseName, requiredSpecialVenue: $requiredSpecialVenue, lecturers: $lecturers, venues: $venues, course: $course, classId: $classId, className: $className, classData: $classData, classCapacity: $classCapacity, studyMode: $studyMode, level: $level, year: $year, semester: $semester, department: $department, hasDisability: $hasDisability, isPaired: $isPaired)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ClassCoursePairModel &&
      other.id == id &&
      other.courseId == courseId &&
      other.courseCode == courseCode &&
      other.courseName == courseName &&
      other.requiredSpecialVenue == requiredSpecialVenue &&
      listEquals(other.lecturers, lecturers) &&
      listEquals(other.venues, venues) &&
      mapEquals(other.course, course) &&
      other.classId == classId &&
      other.className == className &&
      mapEquals(other.classData, classData) &&
      other.classCapacity == classCapacity &&
      other.studyMode == studyMode &&
      other.level == level &&
      other.year == year &&
      other.semester == semester &&
      other.department == department &&
      other.hasDisability == hasDisability &&
      other.isPaired == isPaired;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      courseId.hashCode ^
      courseCode.hashCode ^
      courseName.hashCode ^
      requiredSpecialVenue.hashCode ^
      lecturers.hashCode ^
      venues.hashCode ^
      course.hashCode ^
      classId.hashCode ^
      className.hashCode ^
      classData.hashCode ^
      classCapacity.hashCode ^
      studyMode.hashCode ^
      level.hashCode ^
      year.hashCode ^
      semester.hashCode ^
      department.hashCode ^
      hasDisability.hashCode ^
      isPaired.hashCode;
  }
}
