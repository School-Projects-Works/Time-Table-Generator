import 'dart:convert';
import 'package:flutter/foundation.dart';


class CourseModel {
  String code;
  String title;
  String? creditHours;
  String? specialVenue;
  List<Map<String,dynamic>> lecturer;
  String department;
  String id;
  String year;
  List<String>? venues;
  String level;
  String studyMode;
  String semester;

  CourseModel({
    required this.code,
    required this.title,
    this.creditHours,
    this.specialVenue,
    required this.lecturer,
    required this.department,
    required this.id,
    required this.year,
    this.venues,
    required this.level,
    required this.studyMode,
    required this.semester,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'creditHours': creditHours,
      'specialVenue': specialVenue,
      'lecturer': lecturer,
      'department': department,
      'id': id,
      'year': year,
      'venues': venues,
      'level': level,
      'studyMode': studyMode,
      'semester': semester,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      creditHours: map['creditHours'],
      specialVenue: map['specialVenue'],
      lecturer:map['lecturer']!=null? List<Map<String,dynamic>>.from(map['lecturer']?.map((x) => x)):[],
      department: map['department'] ?? '',
      id: map['id'] ?? '',
      year: map['year'] ?? '',
      venues:map['venues']!=null? List<String>.from(map['venues']):null,
      level: map['level'] ?? '',
      studyMode: map['studyMode'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) => CourseModel.fromMap(json.decode(source));

  CourseModel copyWith({
    String? code,
    String? title,
    ValueGetter<String?>? creditHours,
    ValueGetter<String?>? specialVenue,
    List<Map<String,dynamic>>? lecturer,
    String? department,
    String? id,
    String? year,
    ValueGetter<List<String>?>? venues,
    String? level,
    String? studyMode,
    String? semester,
  }) {
    return CourseModel(
      code: code ?? this.code,
      title: title ?? this.title,
      creditHours: creditHours != null ? creditHours() : this.creditHours,
      specialVenue: specialVenue != null ? specialVenue() : this.specialVenue,
      lecturer: lecturer ?? this.lecturer,
      department: department ?? this.department,
      id: id ?? this.id,
      year: year ?? this.year,
      venues: venues != null ? venues() : this.venues,
      level: level ?? this.level,
      studyMode: studyMode ?? this.studyMode,
      semester: semester ?? this.semester,
    );
  }

  @override
  String toString() {
    return 'CourseModel(code: $code, title: $title, creditHours: $creditHours, specialVenue: $specialVenue, lecturer: $lecturer, department: $department, id: $id, year: $year, venues: $venues, level: $level, studyMode: $studyMode, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CourseModel &&
      other.code == code &&
      other.title == title &&
      other.creditHours == creditHours &&
      other.specialVenue == specialVenue &&
      listEquals(other.lecturer, lecturer) &&
      other.department == department &&
      other.id == id &&
      other.year == year &&
      listEquals(other.venues, venues) &&
      other.level == level &&
      other.studyMode == studyMode &&
      other.semester == semester;
  }

  @override
  int get hashCode {
    return code.hashCode ^
      title.hashCode ^
      creditHours.hashCode ^
      specialVenue.hashCode ^
      lecturer.hashCode ^
      department.hashCode ^
      id.hashCode ^
      year.hashCode ^
      venues.hashCode ^
      level.hashCode ^
      studyMode.hashCode ^
      semester.hashCode;
  }
}
