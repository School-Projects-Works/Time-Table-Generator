import 'dart:convert';

import 'package:flutter/foundation.dart';

class CCPModel {
  //! class-course pair model
  String id;
  String courseId;
  String courseCode;
  String courseName;
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
  CCPModel({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
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
  });
  

  CCPModel copyWith({
    String? id,
    String? courseId,
    String? courseCode,
    String? courseName,
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
  }) {
    return CCPModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'courseCode': courseCode,
      'courseName': courseName,
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
    };
  }

  factory CCPModel.fromMap(Map<String, dynamic> map) {
    return CCPModel(
      id: map['id'] ?? '',
      courseId: map['courseId'] ?? '',
      courseCode: map['courseCode'] ?? '',
      courseName: map['courseName'] ?? '',
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
    );
  }

  String toJson() => json.encode(toMap());

  factory CCPModel.fromJson(String source) => CCPModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CCPModel(id: $id, courseId: $courseId, courseCode: $courseCode, courseName: $courseName, course: $course, classId: $classId, className: $className, classData: $classData, classCapacity: $classCapacity, studyMode: $studyMode, level: $level, year: $year, semester: $semester, department: $department, hasDisability: $hasDisability)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CCPModel &&
      other.id == id &&
      other.courseId == courseId &&
      other.courseCode == courseCode &&
      other.courseName == courseName &&
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
      other.hasDisability == hasDisability;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      courseId.hashCode ^
      courseCode.hashCode ^
      courseName.hashCode ^
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
      hasDisability.hashCode;
  }
}
