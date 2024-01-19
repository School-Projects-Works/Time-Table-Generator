import 'package:hive/hive.dart';

part 'lecturer_model.g.dart';

@HiveType(typeId: 2)
class LecturerModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<String>? courses;
  @HiveField(3)
  List<String>? classes;
  @HiveField(4)
  String? lecturerName;
  @HiveField(5)
  String? lecturerEmail;
  @HiveField(6)
  String? department;
  @HiveField(8)
  String? academicYear;

  @HiveField(12)
  String? academicSemester;

  LecturerModel({
    this.id,
    this.name,
    this.courses,
    this.classes,
    this.lecturerName,
    this.lecturerEmail,
    this.department,
    this.academicYear,
    this.academicSemester,
  });
  
}
