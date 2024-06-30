import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LecturerModel {
  String? id;

  List<Map<String, dynamic>> courses;
  List<String> classes;
  String? lecturerName;
  String? department;
  String year;
  String semester;
  // String freeDay;

  LecturerModel({
    this.id,
    required this.courses,
    required this.classes,
    this.lecturerName,
    this.department,
    required this.year,
    required this.semester,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courses': courses,
      'classes': classes,
      'lecturerName': lecturerName,
      'department': department,
      'year': year,
      'semester': semester,
    };
  }

  factory LecturerModel.fromMap(Map<String, dynamic> map) {
    return LecturerModel(
      id: map['id'],
      courses: List<Map<String, dynamic>>.from(map['courses']?.map((x) => Map<String, dynamic>.from(x))),
      classes: List<String>.from(map['classes']),
      lecturerName: map['lecturerName'],
      department: map['department'],
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LecturerModel.fromJson(String source) =>
      LecturerModel.fromMap(json.decode(source));

  LecturerModel copyWith({
    ValueGetter<String?>? id,
    List<Map<String, dynamic>>? courses,
    List<String>? classes,
    ValueGetter<String?>? lecturerName,
    ValueGetter<String?>? department,
    String? year,
    String? semester,
  }) {
    return LecturerModel(
      id: id != null ? id() : this.id,
      courses: courses ?? this.courses,
      classes: classes ?? this.classes,
      lecturerName: lecturerName != null ? lecturerName() : this.lecturerName,
      department: department != null ? department() : this.department,
      year: year ?? this.year,
      semester: semester ?? this.semester,
    );
  }

  @override
  String toString() {
    return 'LecturerModel(id: $id, courses: $courses, classes: $classes, lecturerName: $lecturerName, department: $department, year: $year, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LecturerModel &&
      other.id == id &&
      listEquals(other.courses, courses) &&
      listEquals(other.classes, classes) &&
      other.lecturerName == lecturerName &&
      other.department == department &&
      other.year == year &&
      other.semester == semester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      courses.hashCode ^
      classes.hashCode ^
      lecturerName.hashCode ^
      department.hashCode ^
      year.hashCode ^
      semester.hashCode;
  }
}
