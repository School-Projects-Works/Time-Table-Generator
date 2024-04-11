import 'dart:convert';
import 'package:flutter/foundation.dart';


class TablesModel {
  String? id;
  String? year;
  String day;
  String period;
  String studyMode;
  String startTime;
  String endTime;
  String? courseCode;
  String courseId;
  String lecturerName;
  String? lecturerEmail;
  String courseTitle;
  String? creditHours;
  List<Map<String, dynamic>>? specialVenues;
  String venueName;
  String venueId;
  int venueCapacity;
  bool? disabilityAccess;
  bool? isSpecial;
  String classLevel;
  String className;
  String department;
  String classSize;
  bool? hasDisable;
  String semester;
  String classId;
  String lecturerId;
  int position;
  TablesModel({
    this.id,
    this.year,
    required this.day,
    required this.period,
    required this.studyMode,
    required this.startTime,
    required this.endTime,
    this.courseCode,
    required this.courseId,
    required this.lecturerName,
    this.lecturerEmail,
    required this.courseTitle,
    this.creditHours,
    this.specialVenues,
    required this.venueName,
    required this.venueId,
    required this.venueCapacity,
    this.disabilityAccess,
    this.isSpecial,
    required this.classLevel,
    required this.className,
    required this.department,
    required this.classSize,
    this.hasDisable,
    required this.semester,
    required this.classId,
    required this.lecturerId,
    required this.position,
  });

  TablesModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? year,
    String? day,
    String? period,
    String? studyMode,
    String? startTime,
    String? endTime,
    ValueGetter<String?>? courseCode,
    String? courseId,
    String? lecturerName,
    ValueGetter<String?>? lecturerEmail,
    String? courseTitle,
    ValueGetter<String?>? creditHours,
    ValueGetter<List<Map<String, dynamic>>?>? specialVenues,
    String? venueName,
    String? venueId,
    int? venueCapacity,
    ValueGetter<bool?>? disabilityAccess,
    ValueGetter<bool?>? isSpecial,
    String? classLevel,
    String? className,
    String? department,
    String? classSize,
    ValueGetter<bool?>? hasDisable,
    String? semester,
    String? classId,
    String? lecturerId,
    int? position,
  }) {
    return TablesModel(
      id: id != null ? id() : this.id,
      year: year != null ? year() : this.year,
      day: day ?? this.day,
      period: period ?? this.period,
      studyMode: studyMode ?? this.studyMode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      courseCode: courseCode != null ? courseCode() : this.courseCode,
      courseId: courseId ?? this.courseId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerEmail: lecturerEmail != null ? lecturerEmail() : this.lecturerEmail,
      courseTitle: courseTitle ?? this.courseTitle,
      creditHours: creditHours != null ? creditHours() : this.creditHours,
      specialVenues: specialVenues != null ? specialVenues() : this.specialVenues,
      venueName: venueName ?? this.venueName,
      venueId: venueId ?? this.venueId,
      venueCapacity: venueCapacity ?? this.venueCapacity,
      disabilityAccess: disabilityAccess != null ? disabilityAccess() : this.disabilityAccess,
      isSpecial: isSpecial != null ? isSpecial() : this.isSpecial,
      classLevel: classLevel ?? this.classLevel,
      className: className ?? this.className,
      department: department ?? this.department,
      classSize: classSize ?? this.classSize,
      hasDisable: hasDisable != null ? hasDisable() : this.hasDisable,
      semester: semester ?? this.semester,
      classId: classId ?? this.classId,
      lecturerId: lecturerId ?? this.lecturerId,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'day': day,
      'period': period,
      'studyMode': studyMode,
      'startTime': startTime,
      'endTime': endTime,
      'courseCode': courseCode,
      'courseId': courseId,
      'lecturerName': lecturerName,
      'lecturerEmail': lecturerEmail,
      'courseTitle': courseTitle,
      'creditHours': creditHours,
      'specialVenues': specialVenues,
      'venueName': venueName,
      'venueId': venueId,
      'venueCapacity': venueCapacity,
      'disabilityAccess': disabilityAccess,
      'isSpecial': isSpecial,
      'classLevel': classLevel,
      'className': className,
      'department': department,
      'classSize': classSize,
      'hasDisable': hasDisable,
      'semester': semester,
      'classId': classId,
      'lecturerId': lecturerId,
      'position': position,
    };
  }

  factory TablesModel.fromMap(Map<String, dynamic> map) {
    return TablesModel(
      id: map['id'],
      year: map['year'],
      day: map['day'] ?? '',
      period: map['period'] ?? '',
      studyMode: map['studyMode'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      courseCode: map['courseCode'],
      courseId: map['courseId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerEmail: map['lecturerEmail'],
      courseTitle: map['courseTitle'] ?? '',
      creditHours: map['creditHours'],
      specialVenues: map['specialVenues'] != null ? List<Map<String, dynamic>>.from(map['specialVenues']?.map((x) => x)) : null,
      venueName: map['venueName'] ?? '',
      venueId: map['venueId'] ?? '',
      venueCapacity: map['venueCapacity']?.toInt() ?? 0,
      disabilityAccess: map['disabilityAccess'],
      isSpecial: map['isSpecial'],
      classLevel: map['classLevel'] ?? '',
      className: map['className'] ?? '',
      department: map['department'] ?? '',
      classSize: map['classSize'] ?? '',
      hasDisable: map['hasDisable'],
      semester: map['semester'] ?? '',
      classId: map['classId'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      position: map['position']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TablesModel.fromJson(String source) =>
      TablesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TablesModel(id: $id, year: $year, day: $day, period: $period, studyMode: $studyMode, startTime: $startTime, endTime: $endTime, courseCode: $courseCode, courseId: $courseId, lecturerName: $lecturerName, lecturerEmail: $lecturerEmail, courseTitle: $courseTitle, creditHours: $creditHours, specialVenues: $specialVenues, venueName: $venueName, venueId: $venueId, venueCapacity: $venueCapacity, disabilityAccess: $disabilityAccess, isSpecial: $isSpecial, classLevel: $classLevel, className: $className, department: $department, classSize: $classSize, hasDisable: $hasDisable, semester: $semester, classId: $classId, lecturerId: $lecturerId, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TablesModel &&
      other.id == id &&
      other.year == year &&
      other.day == day &&
      other.period == period &&
      other.studyMode == studyMode &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.courseCode == courseCode &&
      other.courseId == courseId &&
      other.lecturerName == lecturerName &&
      other.lecturerEmail == lecturerEmail &&
      other.courseTitle == courseTitle &&
      other.creditHours == creditHours &&
      listEquals(other.specialVenues, specialVenues) &&
      other.venueName == venueName &&
      other.venueId == venueId &&
      other.venueCapacity == venueCapacity &&
      other.disabilityAccess == disabilityAccess &&
      other.isSpecial == isSpecial &&
      other.classLevel == classLevel &&
      other.className == className &&
      other.department == department &&
      other.classSize == classSize &&
      other.hasDisable == hasDisable &&
      other.semester == semester &&
      other.classId == classId &&
      other.lecturerId == lecturerId &&
      other.position == position;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      year.hashCode ^
      day.hashCode ^
      period.hashCode ^
      studyMode.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      courseCode.hashCode ^
      courseId.hashCode ^
      lecturerName.hashCode ^
      lecturerEmail.hashCode ^
      courseTitle.hashCode ^
      creditHours.hashCode ^
      specialVenues.hashCode ^
      venueName.hashCode ^
      venueId.hashCode ^
      venueCapacity.hashCode ^
      disabilityAccess.hashCode ^
      isSpecial.hashCode ^
      classLevel.hashCode ^
      className.hashCode ^
      department.hashCode ^
      classSize.hashCode ^
      hasDisable.hashCode ^
      semester.hashCode ^
      classId.hashCode ^
      lecturerId.hashCode ^
      position.hashCode;
  }
}
