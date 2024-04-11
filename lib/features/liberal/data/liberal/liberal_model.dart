import 'dart:convert';

import 'package:flutter/widgets.dart';

class LiberalModel {
  String? id;

  String? code;

  String? title;

  String? lecturerId;

  String? lecturerName;

  String? lecturerEmail;

  String? year;

  String? studyMode;
  String? semester;
  LiberalModel({
    this.id,
    this.code,
    this.title,
    this.lecturerId,
    this.lecturerName,
    this.lecturerEmail,
    this.year,
    this.studyMode,
    this.semester,
  });

  LiberalModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? code,
    ValueGetter<String?>? title,
    ValueGetter<String?>? lecturerId,
    ValueGetter<String?>? lecturerName,
    ValueGetter<String?>? lecturerEmail,
    ValueGetter<String?>? year,
    ValueGetter<String?>? studyMode,
    ValueGetter<String?>? semester,
  }) {
    return LiberalModel(
      id: id != null ? id() : this.id,
      code: code != null ? code() : this.code,
      title: title != null ? title() : this.title,
      lecturerId: lecturerId != null ? lecturerId() : this.lecturerId,
      lecturerName: lecturerName != null ? lecturerName() : this.lecturerName,
      lecturerEmail:
          lecturerEmail != null ? lecturerEmail() : this.lecturerEmail,
      year: year != null ? year() : this.year,
      studyMode: studyMode != null ? studyMode() : this.studyMode,
      semester: semester != null ? semester() : this.semester,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'lecturerEmail': lecturerEmail,
      'year': year,
      'studyMode': studyMode,
      'semester': semester,
    };
  }

  factory LiberalModel.fromMap(Map<String, dynamic> map) {
    return LiberalModel(
      id: map['id'],
      code: map['code'],
      title: map['title'],
      lecturerId: map['lecturerId'],
      lecturerName: map['lecturerName'],
      lecturerEmail: map['lecturerEmail'],
      year: map['year'],
      studyMode: map['studyMode'],
      semester: map['semester'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LiberalModel.fromJson(String source) =>
      LiberalModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LiberalModel(id: $id, code: $code, title: $title, lecturerId: $lecturerId, lecturerName: $lecturerName, lecturerEmail: $lecturerEmail, year: $year, studyMode: $studyMode, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LiberalModel &&
        other.id == id &&
        other.code == code &&
        other.title == title &&
        other.lecturerId == lecturerId &&
        other.lecturerName == lecturerName &&
        other.lecturerEmail == lecturerEmail &&
        other.year == year &&
        other.studyMode == studyMode &&
        other.semester == semester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        title.hashCode ^
        lecturerId.hashCode ^
        lecturerName.hashCode ^
        lecturerEmail.hashCode ^
        year.hashCode ^
        studyMode.hashCode ^
        semester.hashCode;
  }
}
