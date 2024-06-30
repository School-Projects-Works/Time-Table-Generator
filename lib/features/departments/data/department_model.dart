import 'dart:convert';

import 'package:flutter/widgets.dart';

class DepartmentModel {
  String? id;
  String? name;
  String? password;
  int createdAt;
  DepartmentModel({
    this.id,
    this.name,
    this.password,
    required this.createdAt ,
  });

  DepartmentModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? name,
    ValueGetter<String?>? password,
    int? createdAt,
  }) {
    return DepartmentModel(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      password: password != null ? password() : this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'createdAt': createdAt,
    };
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'],
      name: map['name'],
      password: map['password'],
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DepartmentModel.fromJson(String source) =>
      DepartmentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DepartmentModel(id: $id, name: $name, password: $password, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DepartmentModel &&
        other.id == id &&
        other.name == name &&
        other.password == password &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ password.hashCode ^ createdAt.hashCode;
  }
}
