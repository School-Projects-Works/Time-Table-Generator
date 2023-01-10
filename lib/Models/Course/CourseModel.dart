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
  String? lecturerPhone;
  @HiveField(7)
  String? department;
  @HiveField(8)
  String? id;

  CourseModel(
      {this.code,
      this.title,
      this.creditHours,
      this.specialVenue,
      this.lecturerName,
      this.lecturerEmail,
      this.lecturerPhone,
      this.department,
      this.id});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      code: json['code'],
      title: json['title'],
      creditHours: json['creditHours'],
      specialVenue: json['specialVenue'],
      lecturerName: json['lecturerName'],
      lecturerEmail: json['lecturerEmail'],
      lecturerPhone: json['lecturerPhone'],
      department: json['department'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['creditHours'] = creditHours;
    data['specialVenue'] = specialVenue;
    data['lecturerName'] = lecturerName;
    data['lecturerEmail'] = lecturerEmail;
    data['lecturerPhone'] = lecturerPhone;
    data['department'] = department;
    data['id'] = id;
    return data;
  }
}