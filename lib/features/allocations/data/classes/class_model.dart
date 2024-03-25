import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'class_model.g.dart';

@HiveType(typeId: 1)
class ClassModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String level;
  @HiveField(2)
  String? studyMode;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? size;
  @HiveField(5)
  String? hasDisability;
  @HiveField(6)
  String? department;
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String year;
  @HiveField(9)
  String semester;

  ClassModel({
    this.id,
    required this.level,
    this.studyMode,
    this.name,
    this.size,
    this.hasDisability,
    this.department,
    this.createdAt,
    required this.year,
    required this.semester,
  });

  ClassModel copyWith({
    ValueGetter<String?>? id,
    String? level,
    ValueGetter<String?>? studyMode,
    ValueGetter<String?>? name,
    ValueGetter<String?>? size,
    ValueGetter<String?>? hasDisability,
    ValueGetter<String?>? department,
    ValueGetter<String?>? createdAt,
    String? year,
    String? semester,
  }) {
    return ClassModel(
      id: id != null ? id() : this.id,
      level: level ?? this.level,
      studyMode: studyMode != null ? studyMode() : this.studyMode,
      name: name != null ? name() : this.name,
      size: size != null ? size() : this.size,
      hasDisability: hasDisability != null ? hasDisability() : this.hasDisability,
      department: department != null ? department() : this.department,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
      year: year ?? this.year,
      semester: semester ?? this.semester,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'studyMode': studyMode,
      'name': name,
      'size': size,
      'hasDisability': hasDisability,
      'department': department,
      'createdAt': createdAt,
      'year': year,
      'semester': semester,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'],
      level: map['level'] ?? '',
      studyMode: map['studyMode'],
      name: map['name'],
      size: map['size'],
      hasDisability: map['hasDisability'],
      department: map['department'],
      createdAt: map['createdAt'],
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassModel.fromJson(String source) => ClassModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassModel(id: $id, level: $level, studyMode: $studyMode, name: $name, size: $size, hasDisability: $hasDisability, department: $department, createdAt: $createdAt, year: $year, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ClassModel &&
      other.id == id &&
      other.level == level &&
      other.studyMode == studyMode &&
      other.name == name &&
      other.size == size &&
      other.hasDisability == hasDisability &&
      other.department == department &&
      other.createdAt == createdAt &&
      other.year == year &&
      other.semester == semester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      level.hashCode ^
      studyMode.hashCode ^
      name.hashCode ^
      size.hashCode ^
      hasDisability.hashCode ^
      department.hashCode ^
      createdAt.hashCode ^
      year.hashCode ^
      semester.hashCode;
  }
}