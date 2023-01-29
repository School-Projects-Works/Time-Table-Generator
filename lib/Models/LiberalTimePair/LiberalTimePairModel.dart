// ignore_for_file: file_names

import 'package:hive/hive.dart';

part 'LiberalTimePairModel.g.dart';

@HiveType(typeId: 7)
class LiberalTimePairModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? day;
  @HiveField(2)
  String? period;
  @HiveField(3)
  String? courseCode;
  @HiveField(4)
  String? lecturerName;
  @HiveField(5)
  String? lecturerEmail;
  @HiveField(6)
  String? courseTitle;
  @HiveField(7)
  String? academicYear;

  LiberalTimePairModel(
      {this.id,
      this.day,
      this.period,
      this.courseCode,
      this.lecturerName,
      this.lecturerEmail,
      this.courseTitle,
      this.academicYear});
}
