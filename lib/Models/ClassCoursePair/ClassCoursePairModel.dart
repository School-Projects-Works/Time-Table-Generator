import 'package:hive/hive.dart';

part 'ClassCoursePairModel.g.dart';

@HiveType(typeId: 10)
class ClassCoursePairModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? courseTitle;
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
  String? courseId;
  @HiveField(8)
  String? academicYear;
  @HiveField(9)
  List<String>? venues;
  @HiveField(10)
  String? courseCode;
  @HiveField(11)
  String? classId;
  @HiveField(12)
  String? classLevel;
  @HiveField(13)
  String? classType;
  @HiveField(14)
  String? className;
  @HiveField(15)
  String? classSize;
  @HiveField(16)
  String? classHasDisability;
  @HiveField(17)
  List? classCourses;
  @HiveField(18)
  bool isAssigned;

  ClassCoursePairModel({
    this.id,
    this.courseTitle,
    this.creditHours,
    this.specialVenue,
    this.lecturerName,
    this.lecturerEmail,
    this.department,
    this.courseId,
    this.academicYear,
    this.venues,
    this.courseCode,
    this.classId,
    this.classLevel,
    this.classType,
    this.className,
    this.classSize,
    this.classHasDisability,
    this.classCourses,
    this.isAssigned = false,
  });
}
