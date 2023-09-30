// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'courses_model.g.dart';
@HiveType(typeId: 12)
class CoursesModel {
   @HiveField(0)
  String? code;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? creditHours;
  @HiveField(3)
  String? specialVenue;
  @HiveField(4)
  List<String> lecturer;
  @HiveField(5)
  String? department;
  @HiveField(6)
  String? id;
  @HiveField(7)
  String? academicYear;
  @HiveField(9)
  List<String> venues;
  @HiveField(10)
  String? level;
  @HiveField(11)
  String? targetStudents;
  @HiveField(12)
  String? academicSemester;
  CoursesModel({
    this.code,
    this.title,
    this.creditHours,
    this.specialVenue,
    this.lecturer=const[],
    this.department,
    this.id,
    this.academicYear,
    this.venues=const [],
    this.level,
    this.targetStudents,
    this.academicSemester,
  });

  CoursesModel copyWith({
    String? code,
    String? title,
    String? creditHours,
    String? specialVenue,
    List<String>? lecturer,
    String? department,
    String? id,
    String? academicYear,
    List<String>? venues,
    String? level,
    String? targetStudents,
    String? academicSemester,
  }) {
    return CoursesModel(
      code: code ?? this.code,
      title: title ?? this.title,
      creditHours: creditHours ?? this.creditHours,
      specialVenue: specialVenue ?? this.specialVenue,
      lecturer: lecturer ?? this.lecturer,
      department: department ?? this.department,
      id: id ?? this.id,
      academicYear: academicYear ?? this.academicYear,
      venues: venues ?? this.venues,
      level: level ?? this.level,
      targetStudents: targetStudents ?? this.targetStudents,
      academicSemester: academicSemester ?? this.academicSemester,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'title': title,
      'creditHours': creditHours,
      'specialVenue': specialVenue,
      'lecturer': lecturer,
      'department': department,
      'id': id,
      'academicYear': academicYear,
      'venues': venues,
      'level': level,
      'targetStudents': targetStudents,
      'academicSemester': academicSemester,
    };
  }

  factory CoursesModel.fromMap(Map<String, dynamic> map) {
    return CoursesModel(
      code: map['code'] != null ? map['code'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      creditHours: map['creditHours'] != null ? map['creditHours'] as String : null,
      specialVenue: map['specialVenue'] != null ? map['specialVenue'] as String : null,
      lecturer: map['lecturer'] != null ? List<String>.from((map['lecturer'] as List<String>)) : [],
      department: map['department'] != null ? map['department'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      academicYear: map['academicYear'] != null ? map['academicYear'] as String : null,
      venues: map['venues'] != null ? List<String>.from((map['venues'] as List<String>)) : [],
      level: map['level'] != null ? map['level'] as String : null,
      targetStudents: map['targetStudents'] != null ? map['targetStudents'] as String : null,
      academicSemester: map['academicSemester'] != null ? map['academicSemester'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CoursesModel.fromJson(String source) => CoursesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoursesModel(code: $code, title: $title, creditHours: $creditHours, specialVenue: $specialVenue, lecturer: $lecturer, department: $department, id: $id, academicYear: $academicYear, venues: $venues, level: $level, targetStudents: $targetStudents, academicSemester: $academicSemester)';
  }

  @override
  bool operator ==(covariant CoursesModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.code == code &&
      other.title == title &&
      other.creditHours == creditHours &&
      other.specialVenue == specialVenue &&
      listEquals(other.lecturer, lecturer) &&
      other.department == department &&
      other.id == id &&
      other.academicYear == academicYear &&
      listEquals(other.venues, venues) &&
      other.level == level &&
      other.targetStudents == targetStudents &&
      other.academicSemester == academicSemester;
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
      academicYear.hashCode ^
      venues.hashCode ^
      level.hashCode ^
      targetStudents.hashCode ^
      academicSemester.hashCode;
  }
}
