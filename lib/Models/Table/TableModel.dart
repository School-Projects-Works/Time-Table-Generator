// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'TableModel.g.dart';

@HiveType(typeId: 12)
class TableModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? academicYear;

  @HiveField(2)
  String? day;
  @HiveField(3)
  String? period;
  @HiveField(4)
  String? targetStudents;
  @HiveField(5)
  Map<String, dynamic>? periodMap;

  @HiveField(6)
  String? courseCode;
  @HiveField(7)
  String? courseId;
  @HiveField(8)
  String? lecturerName;
  @HiveField(9)
  String? lecturerEmail;
  @HiveField(10)
  String? courseTitle;
  @HiveField(11)
  String? creditHours;
  @HiveField(12)
  List<String>? specialVenues;

  @HiveField(13)
  String? venue;
  @HiveField(14)
  String? venueId;
  @HiveField(15)
  String? venueCapacity;
  @HiveField(16)
  String? venueHasDisability;
  @HiveField(17)
  String? isSpecialVenue;

  @HiveField(18)
  String? classLevel;
  @HiveField(19)
  String? className;
  @HiveField(20)
  String? department;
  @HiveField(21)
  String? classSize;
  @HiveField(22)
  String? classHasDisability;
  @HiveField(23)
  String? classId;

  TableModel({
    this.id,
    this.academicYear,
    this.day,
    this.period,
    this.targetStudents,
    this.periodMap,
    this.courseCode,
    this.courseId,
    this.lecturerName,
    this.lecturerEmail,
    this.courseTitle,
    this.creditHours,
    this.specialVenues,
    this.venue,
    this.venueId,
    this.venueCapacity,
    this.venueHasDisability,
    this.isSpecialVenue,
    this.classLevel,
    this.className,
    this.department,
    this.classSize,
    this.classHasDisability,
    this.classId,
  });

  TableModel copyWith({
    String? id,
    String? academicYear,
    String? day,
    String? period,
    String? targetStudents,
    Map<String, dynamic>? periodMap,
    String? courseCode,
    String? courseId,
    String? lecturerName,
    String? lecturerEmail,
    String? courseTitle,
    String? creditHours,
    List<String>? specialVenues,
    String? venue,
    String? venueId,
    String? venueCapacity,
    String? venueHasDisability,
    String? isSpecialVenue,
    String? classLevel,
    String? className,
    String? department,
    String? classSize,
    String? classHasDisability,
    String? classId,
  }) {
    return TableModel(
      id: id ?? this.id,
      academicYear: academicYear ?? this.academicYear,
      day: day ?? this.day,
      period: period ?? this.period,
      targetStudents: targetStudents ?? this.targetStudents,
      periodMap: periodMap ?? this.periodMap,
      courseCode: courseCode ?? this.courseCode,
      courseId: courseId ?? this.courseId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerEmail: lecturerEmail ?? this.lecturerEmail,
      courseTitle: courseTitle ?? this.courseTitle,
      creditHours: creditHours ?? this.creditHours,
      specialVenues: specialVenues ?? this.specialVenues,
      venue: venue ?? this.venue,
      venueId: venueId ?? this.venueId,
      venueCapacity: venueCapacity ?? this.venueCapacity,
      venueHasDisability: venueHasDisability ?? this.venueHasDisability,
      isSpecialVenue: isSpecialVenue ?? this.isSpecialVenue,
      classLevel: classLevel ?? this.classLevel,
      className: className ?? this.className,
      department: department ?? this.department,
      classSize: classSize ?? this.classSize,
      classHasDisability: classHasDisability ?? this.classHasDisability,
      classId: classId ?? this.classId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id ?? '',
      'academicYear': academicYear ?? '',
      'day': day ?? '',
      'period': period ?? '',
      'targetStudents': targetStudents ?? '',
      'periodMap': periodMap ?? '',
      'courseCode': courseCode ?? '',
      'courseId': courseId ?? '',
      'lecturerName': lecturerName ?? '',
      'lecturerEmail': lecturerEmail ?? '',
      'courseTitle': courseTitle ?? '',
      'creditHours': creditHours ?? '',
      'specialVenues': specialVenues ?? '',
      'venue': venue ?? '',
      'venueId': venueId ?? '',
      'venueCapacity': venueCapacity ?? '',
      'venueHasDisability': venueHasDisability ?? '',
      'isSpecialVenue': isSpecialVenue ?? '',
      'classLevel': classLevel ?? '',
      'className': className ?? '',
      'department': department ?? '',
      'classSize': classSize ?? '',
      'classHasDisability': classHasDisability ?? '',
      'classId': classId ?? '',
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'] != null ? map['id'] as String : null,
      academicYear:
          map['academicYear'] != null ? map['academicYear'] as String : null,
      day: map['day'] != null ? map['day'] as String : null,
      period: map['period'] != null ? map['period'] as String : null,
      targetStudents: map['targetStudents'] != null
          ? map['targetStudents'] as String
          : null,
      periodMap: map['periodMap'] != null
          ? Map<String, dynamic>.from(
              (map['periodMap'] as Map<String, dynamic>))
          : null,
      courseCode:
          map['courseCode'] != null ? map['courseCode'] as String : null,
      courseId: map['courseId'] != null ? map['courseId'] as String : null,
      lecturerName:
          map['lecturerName'] != null ? map['lecturerName'] as String : null,
      lecturerEmail:
          map['lecturerEmail'] != null ? map['lecturerEmail'] as String : null,
      courseTitle:
          map['courseTitle'] != null ? map['courseTitle'] as String : null,
      creditHours:
          map['creditHours'] != null ? map['creditHours'] as String : null,
      specialVenues: map['specialVenues'] != null
          ? List<String>.from((map['specialVenues'] as List<String>))
          : null,
      venue: map['venue'] != null ? map['venue'] as String : null,
      venueId: map['venueId'] != null ? map['venueId'] as String : null,
      venueCapacity:
          map['venueCapacity'] != null ? map['venueCapacity'] as String : null,
      venueHasDisability: map['venueHasDisability'] != null
          ? map['venueHasDisability'] as String
          : null,
      isSpecialVenue: map['isSpecialVenue'] != null
          ? map['isSpecialVenue'] as String
          : null,
      classLevel:
          map['classLevel'] != null ? map['classLevel'] as String : null,
      className: map['className'] != null ? map['className'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      classSize: map['classSize'] != null ? map['classSize'] as String : null,
      classHasDisability: map['classHasDisability'] != null
          ? map['classHasDisability'] as String
          : null,
      classId: map['classId'] != null ? map['classId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TableModel.fromJson(String source) =>
      TableModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TableModel(id: $id, academicYear: $academicYear, day: $day, period: $period, targetStudents: $targetStudents, periodMap: $periodMap, courseCode: $courseCode, courseId: $courseId, lecturerName: $lecturerName, lecturerEmail: $lecturerEmail, courseTitle: $courseTitle, creditHours: $creditHours, specialVenues: $specialVenues, venue: $venue, venueId: $venueId, venueCapacity: $venueCapacity, venueHasDisability: $venueHasDisability, isSpecialVenue: $isSpecialVenue, classLevel: $classLevel, className: $className, department: $department, classSize: $classSize, classHasDisability: $classHasDisability, classId: $classId)';
  }

  @override
  bool operator ==(covariant TableModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.academicYear == academicYear &&
        other.day == day &&
        other.period == period &&
        other.targetStudents == targetStudents &&
        mapEquals(other.periodMap, periodMap) &&
        other.courseCode == courseCode &&
        other.courseId == courseId &&
        other.lecturerName == lecturerName &&
        other.lecturerEmail == lecturerEmail &&
        other.courseTitle == courseTitle &&
        other.creditHours == creditHours &&
        listEquals(other.specialVenues, specialVenues) &&
        other.venue == venue &&
        other.venueId == venueId &&
        other.venueCapacity == venueCapacity &&
        other.venueHasDisability == venueHasDisability &&
        other.isSpecialVenue == isSpecialVenue &&
        other.classLevel == classLevel &&
        other.className == className &&
        other.department == department &&
        other.classSize == classSize &&
        other.classHasDisability == classHasDisability &&
        other.classId == classId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        academicYear.hashCode ^
        day.hashCode ^
        period.hashCode ^
        targetStudents.hashCode ^
        periodMap.hashCode ^
        courseCode.hashCode ^
        courseId.hashCode ^
        lecturerName.hashCode ^
        lecturerEmail.hashCode ^
        courseTitle.hashCode ^
        creditHours.hashCode ^
        specialVenues.hashCode ^
        venue.hashCode ^
        venueId.hashCode ^
        venueCapacity.hashCode ^
        venueHasDisability.hashCode ^
        isSpecialVenue.hashCode ^
        classLevel.hashCode ^
        className.hashCode ^
        department.hashCode ^
        classSize.hashCode ^
        classHasDisability.hashCode ^
        classId.hashCode;
  }
}
