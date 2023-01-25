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
  });

  CourseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    creditHours = json['creditHours'];
    specialVenue = json['specialVenue'];
    lecturerName = json['lecturerName'];
    lecturerEmail = json['lecturerEmail'];
    department = json['department'];
    id = json['id'];
    academicYear = json['academicYear'];
    venues = json['venues'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['creditHours'] = creditHours;
    data['specialVenue'] = specialVenue;
    data['lecturerName'] = lecturerName;
    data['lecturerEmail'] = lecturerEmail;
    data['department'] = department;
    data['id'] = id;
    data['academicYear'] = academicYear;
    data['venues'] = venues;
    return data;
  }
}
