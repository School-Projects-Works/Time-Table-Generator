import 'dart:convert';

import 'package:flutter/foundation.dart';

class LTPModel {
  String id;
  String day;
  String period;
  Map<String, dynamic> periodMap;
  String courseCode;
  String lecturerName;
  String lecturerId;
  String courseTitle;
  String courseId;
  String year;
  String level;
  String studyMode;
  String semester;
  LTPModel({
    required this.id,
    required this.day,
    required this.period,
    required this.periodMap,
    required this.courseCode,
    required this.lecturerName,
    required this.lecturerId,
    required this.courseTitle,
    required this.courseId,
    required this.year,
    required this.level,
    required this.studyMode,
    required this.semester,
  });
  
  LTPModel copyWith({
    String? id,
    String? day,
    String? period,
    Map<String, dynamic>? periodMap,
    String? courseCode,
    String? lecturerName,
    String? lecturerId,
    String? courseTitle,
    String? courseId,
    String? year,
    String? level,
    String? studyMode,
    String? semester,
  }) {
    return LTPModel(
      id: id ?? this.id,
      day: day ?? this.day,
      period: period ?? this.period,
      periodMap: periodMap ?? this.periodMap,
      courseCode: courseCode ?? this.courseCode,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerId: lecturerId ?? this.lecturerId,
      courseTitle: courseTitle ?? this.courseTitle,
      courseId: courseId ?? this.courseId,
      year: year ?? this.year,
      level: level ?? this.level,
      studyMode: studyMode ?? this.studyMode,
      semester: semester ?? this.semester,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'period': period,
      'periodMap': periodMap,
      'courseCode': courseCode,
      'lecturerName': lecturerName,
      'lecturerId': lecturerId,
      'courseTitle': courseTitle,
      'courseId': courseId,
      'year': year,
      'level': level,
      'studyMode': studyMode,
      'semester': semester,
    };
  }

  factory LTPModel.fromMap(Map<String, dynamic> map) {
    return LTPModel(
      id: map['id'] ?? '',
      day: map['day'] ?? '',
      period: map['period'] ?? '',
      periodMap: Map<String, dynamic>.from(map['periodMap']),
      courseCode: map['courseCode'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      courseTitle: map['courseTitle'] ?? '',
      courseId: map['courseId'] ?? '',
      year: map['year'] ?? '',
      level: map['level'] ?? '',
      studyMode: map['studyMode'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LTPModel.fromJson(String source) =>
      LTPModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LTPModel(id: $id, day: $day, period: $period, periodMap: $periodMap, courseCode: $courseCode, lecturerName: $lecturerName, lecturerId: $lecturerId, courseTitle: $courseTitle, courseId: $courseId, year: $year, level: $level, studyMode: $studyMode, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LTPModel &&
      other.id == id &&
      other.day == day &&
      other.period == period &&
      mapEquals(other.periodMap, periodMap) &&
      other.courseCode == courseCode &&
      other.lecturerName == lecturerName &&
      other.lecturerId == lecturerId &&
      other.courseTitle == courseTitle &&
      other.courseId == courseId &&
      other.year == year &&
      other.level == level &&
      other.studyMode == studyMode &&
      other.semester == semester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      day.hashCode ^
      period.hashCode ^
      periodMap.hashCode ^
      courseCode.hashCode ^
      lecturerName.hashCode ^
      lecturerId.hashCode ^
      courseTitle.hashCode ^
      courseId.hashCode ^
      year.hashCode ^
      level.hashCode ^
      studyMode.hashCode ^
      semester.hashCode;
  }
}
