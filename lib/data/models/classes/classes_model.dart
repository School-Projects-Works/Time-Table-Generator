// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'classes_model.g.dart';
@HiveType(typeId: 11)
class ClassesModel {
   @HiveField(0)
  String? id;
  @HiveField(1)
  String? level;
  @HiveField(2)
  String? targetStudents;
  @HiveField(3)
  String? code;
  @HiveField(4)
  String? size;
  @HiveField(5)
  String? hasDisabled;
  @HiveField(6)
  String? department;
  @HiveField(7)
  String? academicYear;
  @HiveField(8)
  String? academicSemester;
  ClassesModel({
    this.id,
    this.level,
    this.targetStudents,
    this.code,
    this.size,
    this.hasDisabled,
    this.department,
    this.academicYear,
    this.academicSemester,
  });

  ClassesModel copyWith({
    String? id,
    String? level,
    String? targetStudents,
    String? code,
    String? size,
    String? hasDisabled,
    String? department,
    String? academicYear,
    String? academicSemester,
  }) {
    return ClassesModel(
      id: id ?? this.id,
      level: level ?? this.level,
      targetStudents: targetStudents ?? this.targetStudents,
      code: code ?? this.code,
      size: size ?? this.size,
      hasDisabled: hasDisabled ?? this.hasDisabled,
      department: department ?? this.department,
      academicYear: academicYear ?? this.academicYear,
      academicSemester: academicSemester ?? this.academicSemester,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'level': level,
      'targetStudents': targetStudents,
      'code': code,
      'size': size,
      'hasDisabled': hasDisabled,
      'department': department,
      'academicYear': academicYear,
      'academicSemester': academicSemester,
    };
  }

  factory ClassesModel.fromMap(Map<String, dynamic> map) {
    return ClassesModel(
      id: map['id'] != null ? map['id'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      targetStudents: map['targetStudents'] != null ? map['targetStudents'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
      size: map['size'] != null ? map['size'] as String : null,
      hasDisabled: map['hasDisabled'] != null ? map['hasDisabled'] as String : null,
      department: map['department'] != null ? map['department'] as String : null,
      academicYear: map['academicYear'] != null ? map['academicYear'] as String : null,
      academicSemester: map['academicSemester'] != null ? map['academicSemester'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassesModel.fromJson(String source) => ClassesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassesModel(id: $id, level: $level, targetStudents: $targetStudents, code: $code, size: $size, hasDisabled: $hasDisabled, department: $department, academicYear: $academicYear, academicSemester: $academicSemester)';
  }

  @override
  bool operator ==(covariant ClassesModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.level == level &&
      other.targetStudents == targetStudents &&
      other.code == code &&
      other.size == size &&
      other.hasDisabled == hasDisabled &&
      other.department == department &&
      other.academicYear == academicYear &&
      other.academicSemester == academicSemester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      level.hashCode ^
      targetStudents.hashCode ^
      code.hashCode ^
      size.hashCode ^
      hasDisabled.hashCode ^
      department.hashCode ^
      academicYear.hashCode ^
      academicSemester.hashCode;
  }
}
