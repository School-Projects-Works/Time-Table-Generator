import 'package:hive/hive.dart';

part 'courses_model.g.dart';

@HiveType(typeId: 2)
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
  List<String>? lecturerId;
  @HiveField(5)
  List<String>? lecturerName;
  @HiveField(6)
  String? department;
  @HiveField(7)
  String? id;
  @HiveField(8)
  String? year;
  @HiveField(9)
  List<String>? venues;
  @HiveField(10)
  String? level;
  @HiveField(11)
  String? studyMode;
  @HiveField(12)
  String? semester;

  CourseModel({
    this.code,
    this.title,
    this.creditHours,
    this.specialVenue,
    this.lecturerId,
    this.lecturerName,
    this.department,
    this.id,
    this.year,
    this.venues,
    this.level,
    this.studyMode,
    this.semester,
  });
}
