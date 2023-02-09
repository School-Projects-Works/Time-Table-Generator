// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'admin_model.g.dart';

@HiveType(typeId: 0)
class AdminModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? password;

  AdminModel({this.id, this.name, this.password});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
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
