import 'dart:convert';
import 'package:flutter/foundation.dart';


class LecturerDataModel {
    String? id;
  List<Map<String, dynamic>> courses;
  List<String> classes;
  String? lecturerName;
  String? department;
  String year;
  String semester;
  String freeDay;
  LecturerDataModel({
    this.id,
    required this.courses,
    required this.classes,
    this.lecturerName,
    this.department,
    required this.year,
    required this.semester,
    required this.freeDay,
  });

  LecturerDataModel copyWith({
    ValueGetter<String?>? id,
    List<Map<String, dynamic>>? courses,
    List<String>? classes,
    ValueGetter<String?>? lecturerName,
    ValueGetter<String?>? department,
    String? year,
    String? semester,
    String? freeDay,
  }) {
    return LecturerDataModel(
      id: id != null ? id() : this.id,
      courses: courses ?? this.courses,
      classes: classes ?? this.classes,
      lecturerName: lecturerName != null ? lecturerName() : this.lecturerName,
      department: department != null ? department() : this.department,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      freeDay: freeDay ?? this.freeDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courses': courses,
      'classes': classes,
      'lecturerName': lecturerName,
      'department': department,
      'year': year,
      'semester': semester,
      'freeDay': freeDay,
    };
  }

  factory LecturerDataModel.fromMap(Map<String, dynamic> map) {
    return LecturerDataModel(
      id: map['id'],
      courses: List<Map<String, dynamic>>.from(map['courses']?.map((x) => Map<String, dynamic>.from(x))),
      classes: List<String>.from(map['classes']),
      lecturerName: map['lecturerName'],
      department: map['department'],
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
      freeDay: map['freeDay'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LecturerDataModel.fromJson(String source) => LecturerDataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LecturerDataModel(id: $id, courses: $courses, classes: $classes, lecturerName: $lecturerName, department: $department, year: $year, semester: $semester, freeDay: $freeDay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LecturerDataModel &&
      other.id == id &&
      listEquals(other.courses, courses) &&
      listEquals(other.classes, classes) &&
      other.lecturerName == lecturerName &&
      other.department == department &&
      other.year == year &&
      other.semester == semester &&
      other.freeDay == freeDay;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      courses.hashCode ^
      classes.hashCode ^
      lecturerName.hashCode ^
      department.hashCode ^
      year.hashCode ^
      semester.hashCode ^
      freeDay.hashCode;
  }
}
