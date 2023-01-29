import 'package:hive/hive.dart';

part 'TableModel.g.dart';

@HiveType(typeId: 12)
class TableModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? academicYear;

  @HiveField(2)
  String? day;
  @HiveField(3)
  String? period;
  @HiveField(4)
  Map<String, dynamic>? dayMap;
  @HiveField(5)
  Map<String, dynamic>? periodMap;

  @HiveField(6)
  String? courseCode;
  @HiveField(7)
  String? courseId;
  @HiveField(8)
  String? lecturerName;
  @HiveField(9)
  String? lecturerEmail;
  @HiveField(10)
  String? courseTitle;
  @HiveField(11)
  String? creditHours;
  @HiveField(12)
  List<String>? specialVenues;

  @HiveField(13)
  String? venue;
  @HiveField(14)
  String? venueId;
  @HiveField(15)
  String? venueCapacity;
  @HiveField(16)
  String? venueHasDisability;
  @HiveField(17)
  String? isSpecialVenue;

  @HiveField(18)
  String? classLevel;
  @HiveField(19)
  String? className;
  @HiveField(20)
  String? classType;
  @HiveField(21)
  String? department;
  @HiveField(22)
  String? classSize;
  @HiveField(23)
  String? classHasDisability;
  @HiveField(24)
  String? classId;

  TableModel({
    this.id,
    this.academicYear,
    this.day,
    this.period,
    this.dayMap,
    this.periodMap,
    this.courseCode,
    this.courseId,
    this.lecturerName,
    this.lecturerEmail,
    this.courseTitle,
    this.creditHours,
    this.specialVenues,
    this.venue,
    this.venueId,
    this.venueCapacity,
    this.venueHasDisability,
    this.isSpecialVenue,
    this.classLevel,
    this.className,
    this.classType,
    this.department,
    this.classSize,
    this.classHasDisability,
    this.classId,
  });
}
