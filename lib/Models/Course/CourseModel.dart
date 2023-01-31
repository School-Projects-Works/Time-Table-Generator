// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'CourseModel.g.dart';

@HiveType(typeId: 4)
class CourseModel {
  @HiveField(0)
  String? code;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? creditHours;
  @HiveField(3)
  String? specialVenue;
  @HiveField(4)
  String? lecturerName;
  @HiveField(5)
  String? lecturerEmail;
  @HiveField(6)
  String? department;
  @HiveField(7)
  String? id;
  @HiveField(8)
  String? academicYear;
  @HiveField(9)
  List<String>? venues;
  @HiveField(10)
  String? level;
  @HiveField(11)
  String? targetStudents;

  CourseModel({
    this.code,
    this.title,
    this.creditHours,
    this.specialVenue,
    this.lecturerName,
    this.lecturerEmail,
    this.department,
    this.id,
    this.academicYear,
    this.venues,
    this.level,
    this.targetStudents,
  });
}
