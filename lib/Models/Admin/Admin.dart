// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'Admin.g.dart';

@HiveType(typeId: 0)
class Admin {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? password;

  Admin({this.id, this.name, this.password});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }
}
