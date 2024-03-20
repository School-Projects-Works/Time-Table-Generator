import 'package:hive/hive.dart';

part 'lecturer_model.g.dart';

@HiveType(typeId: 3)
class LecturerModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  List<String>? courses;
  @HiveField(2)
  List<String>? classes;
  @HiveField(3)
  String? lecturerName;
  @HiveField(4)
  String? lecturerEmail;
  @HiveField(5)
  String? department;
  @HiveField(6)
  String? academicYear;
  @HiveField(7)
  String? academicSemester;
  @HiveField(8)
  String? targetedStudents;

  LecturerModel({
    this.id,
    this.courses,
    this.classes,
    this.lecturerName,
    this.lecturerEmail,
    this.department,
    this.academicYear,
    this.academicSemester,
    this.targetedStudents,
  });
}
