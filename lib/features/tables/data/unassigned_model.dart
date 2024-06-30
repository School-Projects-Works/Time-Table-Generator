import 'dart:convert';

import 'package:flutter/widgets.dart';

class UnassignedModel {
  String id;
  String type;
  String code;
  String? className;
  String courseName;
  String courseId;
  String classId;
  String year;
  String semester;
  String department;
  int classSize;
  String lecturer;
  String lecturerId;
  String level;
  String studyMode;
  bool isAssinable;
  bool requireSpecialVenue;
  UnassignedModel({
    required this.id,
    required this.type,
    required this.code,
    this.className,
    required this.courseName,
    required this.courseId,
    required this.classId,
    required this.year,
    required this.semester,
    required this.department,
    required this.classSize,
    required this.lecturer,
    required this.lecturerId,
    required this.level,
    required this.studyMode,
    required this.isAssinable,
    required this.requireSpecialVenue,
  });

  UnassignedModel copyWith({
    String? id,
    String? type,
    String? code,
    ValueGetter<String?>? className,
    String? courseName,
    String? courseId,
    String? classId,
    String? year,
    String? semester,
    String? department,
    int? classSize,
    String? lecturer,
    String? lecturerId,
    String? level,
    String? studyMode,
    bool? isAssinable,
    bool? requireSpecialVenue,
  }) {
    return UnassignedModel(
      id: id ?? this.id,
      type: type ?? this.type,
      code: code ?? this.code,
      className: className != null ? className() : this.className,
      courseName: courseName ?? this.courseName,
      courseId: courseId ?? this.courseId,
      classId: classId ?? this.classId,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      department: department ?? this.department,
      classSize: classSize ?? this.classSize,
      lecturer: lecturer ?? this.lecturer,
      lecturerId: lecturerId ?? this.lecturerId,
      level: level ?? this.level,
      studyMode: studyMode ?? this.studyMode,
      isAssinable: isAssinable ?? this.isAssinable,
      requireSpecialVenue: requireSpecialVenue ?? this.requireSpecialVenue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'code': code,
      'className': className,
      'courseName': courseName,
      'courseId': courseId,
      'classId': classId,
      'year': year,
      'semester': semester,
      'department': department,
      'classSize': classSize,
      'lecturer': lecturer,
      'lecturerId': lecturerId,
      'level': level,
      'studyMode': studyMode,
      'isAssinable': isAssinable,
      'requireSpecialVenue': requireSpecialVenue,
    };
  }

  factory UnassignedModel.fromMap(Map<String, dynamic> map) {
    return UnassignedModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      code: map['code'] ?? '',
      className: map['className'],
      courseName: map['courseName'] ?? '',
      courseId: map['courseId'] ?? '',
      classId: map['classId'] ?? '',
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
      department: map['department'] ?? '',
      classSize: map['classSize']?.toInt() ?? 0,
      lecturer: map['lecturer'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      level: map['level'] ?? '',
      studyMode: map['studyMode'] ?? '',
      isAssinable: map['isAssinable'] ?? false,
      requireSpecialVenue: map['requireSpecialVenue'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UnassignedModel.fromJson(String source) =>
      UnassignedModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UnassignedModel(id: $id, type: $type, code: $code, className: $className, courseName: $courseName, courseId: $courseId, classId: $classId, year: $year, semester: $semester, department: $department, classSize: $classSize, lecturer: $lecturer, lecturerId: $lecturerId, level: $level, studyMode: $studyMode, isAssinable: $isAssinable, requireSpecialVenue: $requireSpecialVenue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UnassignedModel &&
      other.id == id &&
      other.type == type &&
      other.code == code &&
      other.className == className &&
      other.courseName == courseName &&
      other.courseId == courseId &&
      other.classId == classId &&
      other.year == year &&
      other.semester == semester &&
      other.department == department &&
      other.classSize == classSize &&
      other.lecturer == lecturer &&
      other.lecturerId == lecturerId &&
      other.level == level &&
      other.studyMode == studyMode &&
      other.isAssinable == isAssinable &&
      other.requireSpecialVenue == requireSpecialVenue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      code.hashCode ^
      className.hashCode ^
      courseName.hashCode ^
      courseId.hashCode ^
      classId.hashCode ^
      year.hashCode ^
      semester.hashCode ^
      department.hashCode ^
      classSize.hashCode ^
      lecturer.hashCode ^
      lecturerId.hashCode ^
      level.hashCode ^
      studyMode.hashCode ^
      isAssinable.hashCode ^
      requireSpecialVenue.hashCode;
  }
}
