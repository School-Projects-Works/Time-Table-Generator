// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'lecturer_model.g.dart';
@HiveType(typeId: 13)
class LecturersModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? department;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? courseCode;
  @HiveField(4)
  String? academicYear;
  @HiveField(5)
  String? academicSemester;
  @HiveField(6)
  List<String> classes;
  @HiveField(7)
  String? level;
  @HiveField(8)
  String? targetStudents;
  LecturersModel({
    this.name,
    this.department,
    this.id,
    this.courseCode,
    this.academicYear,
    this.academicSemester,
     this.classes=const [],
    this.level,
    this.targetStudents,
  });



  LecturersModel copyWith({
    String? name,
    String? department,
    String? id,
    String? courseCode,
    String? academicYear,
    String? academicSemester,
    List<String>? classes,
    String? level,
    String? targetStudents,
  }) {
    return LecturersModel(
      name: name ?? this.name,
      department: department ?? this.department,
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      academicYear: academicYear ?? this.academicYear,
      academicSemester: academicSemester ?? this.academicSemester,
      classes: classes ?? this.classes,
      level: level ?? this.level,
      targetStudents: targetStudents ?? this.targetStudents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'department': department,
      'id': id,
      'courseCode': courseCode,
      'academicYear': academicYear,
      'academicSemester': academicSemester,
      'classes': classes,
      'level': level,
      'targetStudents': targetStudents,
    };
  }

  factory LecturersModel.fromMap(Map<String, dynamic> map) {
    return LecturersModel(
      name: map['name'] != null ? map['name'] as String : null,
      department: map['department'] != null ? map['department'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      courseCode: map['courseCode'] != null ? map['courseCode'] as String : null,
      academicYear: map['academicYear'] != null ? map['academicYear'] as String : null,
      academicSemester: map['academicSemester'] != null ? map['academicSemester'] as String : null,
      classes: List<String>.from((map['classes'] as List<String>)),
      level: map['level'] != null ? map['level'] as String : null,
      targetStudents: map['targetStudents'] != null ? map['targetStudents'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LecturersModel.fromJson(String source) => LecturersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LecturersModel(name: $name, department: $department, id: $id, courseCode: $courseCode, academicYear: $academicYear, academicSemester: $academicSemester, classes: $classes, level: $level, targetStudents: $targetStudents)';
  }

  @override
  bool operator ==(covariant LecturersModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.department == department &&
      other.id == id &&
      other.courseCode == courseCode &&
      other.academicYear == academicYear &&
      other.academicSemester == academicSemester &&
      listEquals(other.classes, classes) &&
      other.level == level &&
      other.targetStudents == targetStudents;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      department.hashCode ^
      id.hashCode ^
      courseCode.hashCode ^
      academicYear.hashCode ^
      academicSemester.hashCode ^
      classes.hashCode ^
      level.hashCode ^
      targetStudents.hashCode;
  }
}
