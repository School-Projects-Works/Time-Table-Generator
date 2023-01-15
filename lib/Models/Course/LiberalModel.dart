// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'LiberalModel.g.dart';

@HiveType(typeId: 9)
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

  LiberalModel(
      {this.code,
      this.title,
      this.lecturerName,
      this.lecturerEmail,
      this.id,
      this.academicYear});

  LiberalModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    lecturerName = json['lecturerName'];
    lecturerEmail = json['lecturerEmail'];
    id = json['id'];
    academicYear = json['academicYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['lecturerName'] = lecturerName;
    data['lecturerEmail'] = lecturerEmail;
    data['id'] = id;
    data['academicYear'] = academicYear;
    return data;
  }
}
