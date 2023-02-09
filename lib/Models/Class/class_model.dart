// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'class_model.g.dart';

@HiveType(typeId: 1)
class ClassModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? level;
  @HiveField(2)
  String? targetStudents;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? size;
  @HiveField(5)
  String? hasDisability;
  @HiveField(6)
  String? department;
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String? academicYear;
  @HiveField(9)
  String? academicSemester;

  ClassModel({
    this.id,
    this.level,
    this.name,
    this.size,
    this.hasDisability,
    this.department,
    this.createdAt,
    this.academicYear,
    this.targetStudents,
    this.academicSemester,
  });
}
