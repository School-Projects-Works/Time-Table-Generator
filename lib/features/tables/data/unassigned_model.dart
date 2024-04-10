import 'dart:convert';

import 'package:flutter/widgets.dart';

class UnassignedModel {
  String id;
  String type;
  String code;
  String? className;
  String courseName;
  String lecturer;
  String lecturerId;
  String level;
  String studyMode;
  bool requireSpecialVenue;
  UnassignedModel({
    required this.id,
    required this.type,
    required this.code,
    this.className,
    required this.courseName,
    required this.lecturer,
    required this.lecturerId,
    required this.level,
    required this.studyMode,
    required this.requireSpecialVenue,
  });

  UnassignedModel copyWith({
    String? id,
    String? type,
    String? code,
    ValueGetter<String?>? className,
    String? courseName,
    String? lecturer,
    String? lecturerId,
    String? level,
    String? studyMode,
    bool? requireSpecialVenue,
  }) {
    return UnassignedModel(
      id: id ?? this.id,
      type: type ?? this.type,
      code: code ?? this.code,
      className: className != null ? className() : this.className,
      courseName: courseName ?? this.courseName,
      lecturer: lecturer ?? this.lecturer,
      lecturerId: lecturerId ?? this.lecturerId,
      level: level ?? this.level,
      studyMode: studyMode ?? this.studyMode,
      requireSpecialVenue: requireSpecialVenue ?? this.requireSpecialVenue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'code': code,
      'className': className,
      'courseName': courseName,
      'lecturer': lecturer,
      'lecturerId': lecturerId,
      'level': level,
      'studyMode': studyMode,
      'requireSpecialVenue': requireSpecialVenue,
    };
  }

  factory UnassignedModel.fromMap(Map<String, dynamic> map) {
    return UnassignedModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      code: map['code'] ?? '',
      className: map['className'],
      courseName: map['courseName'] ?? '',
      lecturer: map['lecturer'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      level: map['level'] ?? '',
      studyMode: map['studyMode'] ?? '',
      requireSpecialVenue: map['requireSpecialVenue'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UnassignedModel.fromJson(String source) =>
      UnassignedModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UnassignedModel(id: $id, type: $type, code: $code, className: $className, courseName: $courseName, lecturer: $lecturer, lecturerId: $lecturerId, level: $level, studyMode: $studyMode, requireSpecialVenue: $requireSpecialVenue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UnassignedModel &&
      other.id == id &&
      other.type == type &&
      other.code == code &&
      other.className == className &&
      other.courseName == courseName &&
      other.lecturer == lecturer &&
      other.lecturerId == lecturerId &&
      other.level == level &&
      other.studyMode == studyMode &&
      other.requireSpecialVenue == requireSpecialVenue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      code.hashCode ^
      className.hashCode ^
      courseName.hashCode ^
      lecturer.hashCode ^
      lecturerId.hashCode ^
      level.hashCode ^
      studyMode.hashCode ^
      requireSpecialVenue.hashCode;
  }
}