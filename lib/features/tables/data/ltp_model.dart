import 'dart:convert';
import 'package:flutter/widgets.dart';

class LTPModel {
  String? id;
  String? day;
  String? period;
  String? courseCode;
  String? lecturerName;
  String? lecturerId;
  String? courseTitle;
  String? year;
  String? level;
  String? studyMode;
  LTPModel({
    this.id,
    this.day,
    this.period,
    this.courseCode,
    this.lecturerName,
    this.lecturerId,
    this.courseTitle,
    this.year,
    this.level,
    this.studyMode,
  });

  LTPModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? day,
    ValueGetter<String?>? period,
    ValueGetter<String?>? courseCode,
    ValueGetter<String?>? lecturerName,
    ValueGetter<String?>? lecturerId,
    ValueGetter<String?>? courseTitle,
    ValueGetter<String?>? year,
    ValueGetter<String?>? level,
    ValueGetter<String?>? studyMode,
  }) {
    return LTPModel(
      id: id != null ? id() : this.id,
      day: day != null ? day() : this.day,
      period: period != null ? period() : this.period,
      courseCode: courseCode != null ? courseCode() : this.courseCode,
      lecturerName: lecturerName != null ? lecturerName() : this.lecturerName,
      lecturerId: lecturerId != null ? lecturerId() : this.lecturerId,
      courseTitle: courseTitle != null ? courseTitle() : this.courseTitle,
      year: year != null ? year() : this.year,
      level: level != null ? level() : this.level,
      studyMode: studyMode != null ? studyMode() : this.studyMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'period': period,
      'courseCode': courseCode,
      'lecturerName': lecturerName,
      'lecturerId': lecturerId,
      'courseTitle': courseTitle,
      'year': year,
      'level': level,
      'studyMode': studyMode,
    };
  }

  factory LTPModel.fromMap(Map<String, dynamic> map) {
    return LTPModel(
      id: map['id'],
      day: map['day'],
      period: map['period'],
      courseCode: map['courseCode'],
      lecturerName: map['lecturerName'],
      lecturerId: map['lecturerId'],
      courseTitle: map['courseTitle'],
      year: map['year'],
      level: map['level'],
      studyMode: map['studyMode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LTPModel.fromJson(String source) => LTPModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LTPModel(id: $id, day: $day, period: $period, courseCode: $courseCode, lecturerName: $lecturerName, lecturerId: $lecturerId, courseTitle: $courseTitle, year: $year, level: $level, studyMode: $studyMode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LTPModel &&
      other.id == id &&
      other.day == day &&
      other.period == period &&
      other.courseCode == courseCode &&
      other.lecturerName == lecturerName &&
      other.lecturerId == lecturerId &&
      other.courseTitle == courseTitle &&
      other.year == year &&
      other.level == level &&
      other.studyMode == studyMode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      day.hashCode ^
      period.hashCode ^
      courseCode.hashCode ^
      lecturerName.hashCode ^
      lecturerId.hashCode ^
      courseTitle.hashCode ^
      year.hashCode ^
      level.hashCode ^
      studyMode.hashCode;
  }
}
