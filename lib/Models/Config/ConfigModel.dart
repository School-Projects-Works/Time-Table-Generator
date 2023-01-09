// ignore_for_file: file_names

import 'package:hive/hive.dart';

part 'ConfigModel.g.dart';

@HiveType(typeId: 2)
class ConfigModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? academicName;
  @HiveField(2)
  String? academicYear;
  @HiveField(3)
  String? academicSemester;
  @HiveField(4)
  List<Map<String, dynamic>>? days;
  @HiveField(5)
  List<Map<String, dynamic>>? periods;

  ConfigModel({
    this.id,
    this.academicName,
    this.academicYear,
    this.academicSemester,
    this.days,
    this.periods,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      id: json['id'],
      academicName: json['academicName'],
      academicYear: json['academicYear'],
      academicSemester: json['academicSemester'],
      days: json['days'],
      periods: json['periods'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'academicName': academicName,
      'academicYear': academicYear,
      'academicSemester': academicSemester,
      'days': days,
      'periods': periods,
    };
  }
}
