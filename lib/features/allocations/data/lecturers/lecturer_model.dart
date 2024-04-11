import 'dart:convert';
import 'package:flutter/foundation.dart';


class LecturerModel {

  String? id;
 
  List<String> courses;
  List<Map<String,dynamic>> classes;
  String? lecturerName;
  String? lecturerEmail;
  String? department;
  String year;
  String semester;

  LecturerModel({
    this.id,
    required this.courses,
    required this.classes,
    this.lecturerName,
    this.lecturerEmail,
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
      'lecturerEmail': lecturerEmail,
      'department': department,
      'year': year,
      'semester': semester,
    };
  }

  factory LecturerModel.fromMap(Map<String, dynamic> map) {
    return LecturerModel(
      id: map['id'],
      courses: List<String>.from(map['courses']),
      classes: List<Map<String,dynamic>>.from(map['classes']?.map((x) => Map<String,dynamic>.from(x))),
      lecturerName: map['lecturerName'],
      lecturerEmail: map['lecturerEmail'],
      department: map['department'],
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LecturerModel.fromJson(String source) => LecturerModel.fromMap(json.decode(source));

  LecturerModel copyWith({
    ValueGetter<String?>? id,
    List<String>? courses,
    List<Map<String,dynamic>>? classes,
    ValueGetter<String?>? lecturerName,
    ValueGetter<String?>? lecturerEmail,
    ValueGetter<String?>? department,
    String? year,
    String? semester,
  }) {
    return LecturerModel(
      id: id != null ? id() : this.id,
      courses: courses ?? this.courses,
      classes: classes ?? this.classes,
      lecturerName: lecturerName != null ? lecturerName() : this.lecturerName,
      lecturerEmail: lecturerEmail != null ? lecturerEmail() : this.lecturerEmail,
      department: department != null ? department() : this.department,
      year: year ?? this.year,
      semester: semester ?? this.semester,
    );
  }

  @override
  String toString() {
    return 'LecturerModel(id: $id, courses: $courses, classes: $classes, lecturerName: $lecturerName, lecturerEmail: $lecturerEmail, department: $department, year: $year, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LecturerModel &&
      other.id == id &&
      listEquals(other.courses, courses) &&
      listEquals(other.classes, classes) &&
      other.lecturerName == lecturerName &&
      other.lecturerEmail == lecturerEmail &&
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
      lecturerEmail.hashCode ^
      department.hashCode ^
      year.hashCode ^
      semester.hashCode;
  }
}
