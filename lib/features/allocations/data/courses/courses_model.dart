import 'dart:convert';
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
  List<Map<String,dynamic>> lecturer;
  @HiveField(5)
  String? department;
  @HiveField(6)
  String? id;
  @HiveField(7)
  String year;
  @HiveField(8)
  List<String>? venues;
  @HiveField(9)
  String? level;
  @HiveField(10)
  String studyMode;
  @HiveField(11)
  String semester;

  CourseModel({
    this.code,
    this.title,
    this.creditHours,
    this.specialVenue,
    required this.lecturer,
    this.department,
    this.id,
    required this.year,
    this.venues,
    this.level,
    required this.studyMode,
    required this.semester,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'creditHours': creditHours,
      'specialVenue': specialVenue,
      'lecturer': lecturer,
      'department': department,
      'id': id,
      'year': year,
      'venues': venues,
      'level': level,
      'studyMode': studyMode,
      'semester': semester,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      code: map['code'],
      title: map['title'],
      creditHours: map['creditHours'],
      specialVenue: map['specialVenue'],
      lecturer: List<Map<String,dynamic>>.from(map['lecturer']?.map((x) => Map<String,dynamic>.from(x))),
      department: map['department'],
      id: map['id'],
      year: map['year'],
      venues: List<String>.from(map['venues']),
      level: map['level'],
      studyMode: map['studyMode'],
      semester: map['semester'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) => CourseModel.fromMap(json.decode(source));
}
