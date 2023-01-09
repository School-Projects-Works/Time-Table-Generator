// ignore_for_file: file_names

import 'package:hive_flutter/hive_flutter.dart';
part 'AcademicModel.g.dart';

@HiveType(typeId: 1)
class AcademicModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? year;
  @HiveField(3)
  String? semester;
  @HiveField(4)
  DateTime? createdAt;

  AcademicModel({this.id, this.name, this.semester, this.year, this.createdAt});

  AcademicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    year = json['year'];
    semester = json['semester'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['year'] = year;
    data['semester'] = semester;
    data['createdAt'] = createdAt.toString();
    return data;
  }
}
