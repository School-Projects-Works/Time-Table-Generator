import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class ClassModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? level;
  @HiveField(2)
  String? type;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? size;
  @HiveField(5)
  String? hasDisability;
  @HiveField(6)
  List? courses;
  @HiveField(7)
  String? department;
  @HiveField(8)
  String? createdAt;

  ClassModel(
      {this.id,
      this.level,
      this.type,
      this.name,
      this.size,
      this.hasDisability,
      this.courses,
      this.department,
      this.createdAt});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      level: json['level'],
      type: json['type'],
      name: json['name'],
      size: json['size'],
      hasDisability: json['hasDisability'],
      courses: json['courses'],
      department: json['department'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['type'] = type;
    data['name'] = name;
    data['size'] = size;
    data['hasDisability'] = hasDisability;
    data['courses'] = courses;
    data['department'] = department;
    data['createdAt'] = createdAt;
    return data;
  }
}
