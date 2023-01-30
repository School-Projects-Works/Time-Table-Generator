// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'ClassModel.g.dart';

@HiveType(typeId: 5)
class ClassModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? level;
  @HiveField(2)
  String? type;
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

  ClassModel({
    this.id,
    this.level,
    this.type,
    this.name,
    this.size,
    this.hasDisability,
    this.department,
    this.createdAt,
    this.academicYear,
  });
}
