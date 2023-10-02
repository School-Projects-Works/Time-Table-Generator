// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:hive/hive.dart';
part 'liberal_corurses_model.g.dart';
@HiveType(typeId: 14)
class LiberalCoursesModel {
  @HiveField(0)
  String? courseCode;
  @HiveField(1)
  String? courseTitle;
  @HiveField(2)
  String? lecturer;
  @HiveField(3)
  String? level;
  @HiveField(4)
  String? academicSemester;
  @HiveField(5)
  String? academicYears;
  @HiveField(6)
  String? targetStudents;
  LiberalCoursesModel({
    this.courseCode,
    this.courseTitle,
    this.lecturer,
    this.level,
    this.academicSemester,
    this.academicYears,
    this.targetStudents,
  });

  LiberalCoursesModel copyWith({
    String? courseCode,
    String? courseTitle,
    String? lecturer,
    String? level,
    String? academicSemester,
    String? academicYears,
    String? targetStudents,
  }) {
    return LiberalCoursesModel(
      courseCode: courseCode ?? this.courseCode,
      courseTitle: courseTitle ?? this.courseTitle,
      lecturer: lecturer ?? this.lecturer,
      level: level ?? this.level,
      academicSemester: academicSemester ?? this.academicSemester,
      academicYears: academicYears ?? this.academicYears,
      targetStudents: targetStudents ?? this.targetStudents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'lecturer': lecturer,
      'level': level,
      'academicSemester': academicSemester,
      'academicYears': academicYears,
      'targetStudents': targetStudents,
    };
  }

  factory LiberalCoursesModel.fromMap(Map<String, dynamic> map) {
    return LiberalCoursesModel(
      courseCode: map['courseCode'] != null ? map['courseCode'] as String : null,
      courseTitle: map['courseTitle'] != null ? map['courseTitle'] as String : null,
      lecturer: map['lecturer'] != null ? map['lecturer'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      academicSemester: map['academicSemester'] != null ? map['academicSemester'] as String : null,
      academicYears: map['academicYears'] != null ? map['academicYears'] as String : null,
      targetStudents: map['targetStudents'] != null ? map['targetStudents'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LiberalCoursesModel.fromJson(String source) => LiberalCoursesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LiberalCoursesModel(courseCode: $courseCode, courseTitle: $courseTitle, lecturer: $lecturer, level: $level, academicSemester: $academicSemester, academicYears: $academicYears, targetStudents: $targetStudents)';
  }

  @override
  bool operator ==(covariant LiberalCoursesModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.courseCode == courseCode &&
      other.courseTitle == courseTitle &&
      other.lecturer == lecturer &&
      other.level == level &&
      other.academicSemester == academicSemester &&
      other.academicYears == academicYears &&
      other.targetStudents == targetStudents;
  }

  @override
  int get hashCode {
    return courseCode.hashCode ^
      courseTitle.hashCode ^
      lecturer.hashCode ^
      level.hashCode ^
      academicSemester.hashCode ^
      academicYears.hashCode ^
      targetStudents.hashCode;
  }
}
