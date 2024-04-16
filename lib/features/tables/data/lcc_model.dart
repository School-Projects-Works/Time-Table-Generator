import 'dart:convert';
import 'package:flutter/foundation.dart';

class LecturerClassCoursePair {
  String id;
  String lecturerId;
  String lecturerName;
  bool isAsigned;
  Map<String, dynamic> lecturer;
  String courseId;
  String courseCode;
  bool requireSpecialVenue;
  List<String> venues;
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
  LecturerClassCoursePair({
    required this.id,
    required this.lecturerId,
    required this.lecturerName,
    required this.isAsigned,
    required this.lecturer,
    required this.courseId,
    required this.courseCode,
    required this.requireSpecialVenue,
    required this.venues,
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

  LecturerClassCoursePair copyWith({
    String? id,
    String? lecturerId,
    String? lecturerName,
    bool? isAsigned,
    Map<String, dynamic>? lecturer,
    String? courseId,
    String? courseCode,
    bool? requireSpecialVenue,
    List<String>? venues,
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
    return LecturerClassCoursePair(
      id: id ?? this.id,
      lecturerId: lecturerId ?? this.lecturerId,
      lecturerName: lecturerName ?? this.lecturerName,
      isAsigned: isAsigned ?? this.isAsigned,
      lecturer: lecturer ?? this.lecturer,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      requireSpecialVenue: requireSpecialVenue ?? this.requireSpecialVenue,
      venues: venues ?? this.venues,
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
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'isAsigned': isAsigned,
      'lecturer': lecturer,
      'courseId': courseId,
      'courseCode': courseCode,
      'requireSpecialVenue': requireSpecialVenue,
      'venues': venues,
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

  factory LecturerClassCoursePair.fromMap(Map<String, dynamic> map) {
    return LecturerClassCoursePair(
      id: map['id'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      isAsigned: map['isAsigned'] ?? false,
      lecturer: Map<String, dynamic>.from(map['lecturer']),
      courseId: map['courseId'] ?? '',
      courseCode: map['courseCode'] ?? '',
      requireSpecialVenue: map['requireSpecialVenue'] ?? false,
      venues: List<String>.from(map['venues']),
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

  factory LecturerClassCoursePair.fromJson(String source) =>
      LecturerClassCoursePair.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LCCPModel(id: $id, lecturerId: $lecturerId, lecturerName: $lecturerName, isAsigned: $isAsigned, lecturer: $lecturer, courseId: $courseId, courseCode: $courseCode, requireSpecialVenue: $requireSpecialVenue, venues: $venues, courseName: $courseName, course: $course, classId: $classId, className: $className, classData: $classData, classCapacity: $classCapacity, studyMode: $studyMode, level: $level, year: $year, semester: $semester, department: $department, hasDisability: $hasDisability)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LecturerClassCoursePair &&
        other.id == id &&
        other.lecturerId == lecturerId &&
        other.lecturerName == lecturerName &&
        other.isAsigned == isAsigned &&
        mapEquals(other.lecturer, lecturer) &&
        other.courseId == courseId &&
        other.courseCode == courseCode &&
        other.requireSpecialVenue == requireSpecialVenue &&
        listEquals(other.venues, venues) &&
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
        lecturerId.hashCode ^
        lecturerName.hashCode ^
        isAsigned.hashCode ^
        lecturer.hashCode ^
        courseId.hashCode ^
        courseCode.hashCode ^
        requireSpecialVenue.hashCode ^
        venues.hashCode ^
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
