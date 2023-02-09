// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'liberal_model.g.dart';

@HiveType(typeId: 4)
class LiberalModel {
  @HiveField(0)
  String? code;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? lecturerName;
  @HiveField(3)
  String? lecturerEmail;
  @HiveField(4)
  String? id;
  @HiveField(5)
  String? academicYear;
  @HiveField(6)
  String? targetStudents;
  @HiveField(7)
  String? academicSemester;

  LiberalModel(
      {this.code,
      this.title,
      this.lecturerName,
      this.lecturerEmail,
      this.id,
      this.academicYear,
      this.targetStudents,
      this.academicSemester});
}
